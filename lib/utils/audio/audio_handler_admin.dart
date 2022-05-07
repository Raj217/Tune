/// The base file for handling all audio related functions

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:audio_service/audio_service.dart';
import 'package:audiotagger/models/tag.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:id3tag/id3tag.dart';
import 'dart:io';
import 'package:audiotagger/audiotagger.dart';

import 'package:tune/utils/storage/file_handler.dart';
import 'package:tune/utils/app_constants.dart';
import 'package:tune/utils/formatter.dart';

enum PlayMode {
  /// Repeat all the audios in the playlist
  repeatAll,

  /// Repeat only this audio_related
  repeatThis,

  /// Shuffle and keep on playing the playlist, on end repeat the current playlist pattern
  shuffleRepeat,

  /// Shuffle and keep on playing the playlist, on end reshuffle the playlist
  shuffleShuffle,

  /// Stop once this audio_related is over
  endAfterThis,

  /// Stop once this playlist is over
  endAfterPlaylist,
}

final AudioPlayer _player = AudioPlayer();

/// List of mediaItem of the currentPlaylist
List<MediaItem> _currentPlaylistMediaItems = [];
bool _isUpdating = false;
String fileStorageName = 'cookies.txt';

class AudioHandlerAdmin extends ChangeNotifier {
  /// [_data] is responsible for storing all sorts of data for the app audio purpose
  ///
  /// userData includes:
  ///   ⚫ currently playing playlist
  ///   ⚫ current index
  ///   ⚫ avatar
  ///   ⚫ playlist mode
  ///
  /// TODO: Add current position also maybe?
  ///
  /// audios includes the song path with some additional information which are:
  ///    ⚫ playlists
  ///
  /// in the form of 'path': {'playlists': []}.
  ///
  /// NOTE: Favorites are stored as playlist here
  final Map<String, dynamic> _data = {'userData': [], 'audios': {}};

  /// [_currentPlaylist] stores the playlist name and there corresponding song index.
  /// It is made after initialising [_data] since it's data is derived from it.
  ///
  /// Storing format:  'playlistName': []
  ///
  /// NOTE: Not storing as [ConcatenatingAudioSource] since the number of audios
  /// might increase with time which will take a lot of space to store them all at once.
  /// Better to initialise them whenever necessary with [initPlaylist] method
  final Map<String, List<String>> _playlists = {};

  /// The main brain of Tune which is responsible for handling all the playing,
  /// pausing, etc. thanks to audio_service
  final AudioHandler _audioHandler;

  String _currentPlaylistName =
      'all'; // TODO: Add by default its value to the stored/current playlist

  /// The currently playing playlist
  final ConcatenatingAudioSource _currentPlaylist =
      ConcatenatingAudioSource(children: []);

  /// Helps in editing the audio tags:
  ///   ⚫ Audio Title
  ///   ⚫ Artist Name
  ///
  /// TODO: Store the audio image(/thumbnail) with it
  final tagger = Audiotagger();

  /// How do you want to repeat the song/playlist (allowed modes)
  final List<PlayMode> _playlistAllowedModes = [
    PlayMode.repeatAll,
    PlayMode.repeatThis,
    PlayMode.shuffleRepeat
  ];

  /// This keeps track of the current playlist mode. It can be set to
  /// any value from [_playlistAllowedModes]
  int playlistModeIndex = 0;

  /// The heart of Tune which handles all the things related to audio
  /// with the help of [AudioPlayerHandler]
  AudioHandlerAdmin({required AudioHandler audioHandler})
      : _audioHandler = audioHandler {
    _listenToPlaybackState();
    _player.setAudioSource(_currentPlaylist);
  }

  void _listenToPlaybackState() {
    _audioHandler.playbackState.listen((playbackState) async {
      if (playbackState.position >= getTotalDuration) {
        _audioHandler.pause();
        _audioHandler.seek(Duration.zero);
      }
      await updateMediaItem();
    });
  }

  Future<void> initPlaylist({String playlistName = 'all'}) async {
    if (_playlists.containsKey(playlistName)) {
      await _currentPlaylist.clear();
      _currentPlaylistName = playlistName;
      String path;
      for (int i = 0; i < _playlists[playlistName]!.length; i++) {
        path = _data['audios'].keys[i];
        await _currentPlaylist.add(AudioSource.uri(Uri.file(path), tag: path));
        _currentPlaylistMediaItems.add(await getMediaData(path));
      }
    }
    return;
  }

  void incrementPlaylistIndex() {
    playlistModeIndex++;
    if (playlistModeIndex >= _playlistAllowedModes.length) {
      playlistModeIndex = 0;
    }
  }

  Future<void> addAudio(
      {required String path, String playlistName = 'all'}) async {
    if (playlistName == _currentPlaylistName) {
      if ((_currentPlaylistMediaItems.indexWhere(
              (MediaItem mediaItem) => mediaItem.extras?['path'] == path)) !=
          -1) {
        // the song is already in the current playlist
        return;
      } else {
        await _currentPlaylist.add(AudioSource.uri(Uri.file(path), tag: path));
        _currentPlaylistMediaItems.add(await getMediaData(path));
        _updateData(path: path, playlistName: playlistName);
        await saveData();
        notifyListeners();
        return;
      }
    } else {
      // Store in a different playlist
      _updateData(path: path, playlistName: playlistName);
      await saveData();
      notifyListeners();
      return;
    }
    /*
    MediaItem mediaItem = await getMediaData(path);
    if (!(_audioData[playlistName]?.contains(mediaItem) ?? true)) {
      await _currentPlaylist
          .add(AudioSource.uri(Uri.file(path), tag: tag ?? path));
      _audioData[playlistName]?.add(mediaItem);
      savePlaylist(
          playlistLinks: _audioData[playlistName]!
              .map<String>((mediaItem) => mediaItem.extras!['path'])
              .toList(),
          playlistName: '$playlistName.json');
      notifyListeners();
      if (_audioHandler.mediaItem.value?.title == null) { TODO: What is this?
        await _audioHandler
            .updateMediaItem(_audioData[playlistName]![_player.currentIndex!]);
        notifyListeners();
      }
      return;
    }*/
  }

  void _updateData({required String path, required String playlistName}) {
    if (_data['audios'].containsKey(path)) {
      if (_data['audios'][path]['playlists'].indexOf(playlistName) != -1) {
        // Audio is already in that playlist
        return;
      } else {
        _data['audios'][path]['playlists'].add(playlistName);
        _updatePlaylists(path: path, playlistName: playlistName);
        return;
      }
    } else {
      _data['audios'][path] = {
        'playlists': [playlistName]
      };
      _updatePlaylists(path: path, playlistName: playlistName);
      return;
    }
  }

  void _updatePlaylists({required String path, required String playlistName}) {
    if (_playlists.containsKey(playlistName)) {
      if (_playlists[playlistName]!.contains(path)) {
        // Audio already in that playlist
        return;
      } else {
        _playlists[playlistName]!.add(path);
        return;
      }
    } else {
      _playlists[playlistName] = [path];
      return;
    }
  }

  void addNewPlaylist({required String playlistName, List<String>? paths}) {
    _playlists[playlistName] = paths ?? [];
  }

  Future<void> deletePlaylistStorage({required String playlistName}) async {
    await FileHandler.delete(playlistName + '.json');
  }

  Future<void> readData() async {
    String data = await FileHandler.read(fileName: fileStorageName);
    dynamic decodedData = await json.decode(data);

    _data['userData'] = decodedData['userData'];
    for (String path in decodedData['audios'].keys) {
      for (String pName in decodedData['audios'][path]['playlists']) {
        await addAudio(path: path, playlistName: pName);
      }
    }
    return;
  }

  void _cleanData() {
    if (_data['audios'].isNotEmpty) {
      for (String path in _data['audios'].keys) {
        if (_data['audios'][path]['playlists'].length == 0) {
          _data['audios'].remove(path);
        }
      }
    }
  }

  Future<void> saveData() async {
    _cleanData();
    await FileHandler.save(
        fileName: fileStorageName, fileContents: json.encode(_data));
  }

  Future<void> removeAudio(
      {required MediaItem mediaItem, String playlistName = 'all'}) async {
    /// Either index or mediaItem must be provided
    bool removeSuccess = false;
    int? currentIndex = _player.currentIndex;
    Duration currentPos = _player.position;
    bool isPlaying = _player.playing;

    if (playlistName == _currentPlaylistName) {
      if (mediaItem == _audioHandler.mediaItem.value) {
        // TODO: Check
        _audioHandler.pause();
        if (_player.hasPrevious) {
          _audioHandler.skipToPrevious();
        } else if (_player.hasNext) {
          _audioHandler.skipToNext();
        } else {
          _audioHandler.skipToQueueItem(0);
        }
      }
      int i = _currentPlaylistMediaItems.indexOf(mediaItem);

      _currentPlaylistMediaItems.removeAt(i);
      _currentPlaylist.removeAt(i);

      await _player.setAudioSource(_currentPlaylist); // TODO: Really necessary?
      removeSuccess = true;
      if (currentIndex != null && currentIndex <= _currentPlaylist.length) {
        int? ind;
        if (i >= currentIndex) {
          ind = currentIndex;
        } else if (i <= currentIndex) {
          ind = currentIndex - 1;
        } else if (_currentPlaylist.length != 0) {
          ind = currentIndex - 1;
          isPlaying = false;
        }
        if (ind != null && ind >= 0) {
          await _player.seek(currentPos, index: ind);
          if (isPlaying) {
            await _audioHandler.play();
          }
        }
      }
    }
    _playlists[playlistName]!.remove(mediaItem.extras!['path']);
    _data['audios'][mediaItem.extras!['path']]['playlists']
        .remove(playlistName);

    if (removeSuccess) {
      saveData();
      notifyListeners();
      return;
    }
  }

  void removeFromPlaylist(
      {required String path, required String playlistName}) {
    _playlists[playlistName]?.remove(path);
    _data['audios'][path]['playlists'].remove(playlistName);
    if (playlistName == _currentPlaylistName) {
      int ind = _currentPlaylistMediaItems.indexWhere(
          (MediaItem mediaItem) => mediaItem.extras!['path'] == path);
      //TODO: should ind = -1 appear?
      _currentPlaylist.removeAt(ind);
      _currentPlaylistMediaItems.removeAt(ind);
    }
    notifyListeners();
    saveData();
  }

  Future<void> addToPlaylist(
      {required String path, required String playlistName}) async {
    await addAudio(path: path, playlistName: playlistName);
    notifyListeners();
    saveData();
  }

  Future<void> updateMediaItem() async {
    if (_currentPlaylistMediaItems.isNotEmpty) {
      await _audioHandler
          .updateMediaItem(_currentPlaylistMediaItems[_player.currentIndex!])
          .then((value) {
        notifyListeners();
      });
    }
  }

  void setSpeed(double speed) {
    _player.setSpeed(speed);
  }

  void setPitch(double pitch) {
    _player.setPitch(pitch);
  }

  bool isFavorite(String path) {
    print(_data['audios'][path]);
    if (_data['audios'][path]['playlists'].contains('favorite')) {
      return true;
    }
    return false;
  }

  static Future<MediaItem> getMediaData(String filePath) async {
    final parser = ID3TagReader(File(filePath));
    ID3Tag _metaData = parser.readTagSync();

    List<int>? imgData;

    try {
      imgData = _metaData.pictures[0].imageData;
    } catch (e) {} // To avoid an error which occurred when I changed the song from one which had a poster to the one which didn't had one

    Uint8List? imgBytes;
    if (imgData != null) {
      imgBytes = Uint8List.fromList(imgData);
    } else {
      await rootBundle
          .load(AppConstants.paths.kDefaultPosterImgPath)
          .then((ByteData bytes) {
        imgBytes = bytes.buffer.asUint8List();
      });
    }
    int posterImgIndex = _currentPlaylistMediaItems.length;
    while (await FileHandler.fileExists('posterImage$posterImgIndex')) {
      posterImgIndex++;
    }
    String posterPath = await FileHandler.save(
        fileBytes: imgBytes, fileName: 'posterImage$posterImgIndex');

    List<int> imageData = [];
    if (_metaData.pictures.isNotEmpty) {
      imageData = _metaData.pictures[0].imageData;
    }

    final item = MediaItem(
        id: filePath,
        album: _metaData.album,
        title: _metaData.title ?? Formatter.extractSongNameFromPath(filePath),
        artist: _metaData.artist,
        artUri: Uri.file(posterPath),
        extras: {
          'path': filePath,
          'size': await FileHandler.getFileSize(filePath: filePath),
          'thumbnail': imageData,
        });

    AudioPlayer tempPlayer = AudioPlayer();
    await tempPlayer.setFilePath(filePath);
    return item.copyWith(duration: tempPlayer.duration);
  }

  Future<void> setNewMetaDataForAudio(
      {required int index, String? audioTitle, String? artist}) async {
    if (_currentPlaylistMediaItems.isNotEmpty) {
      if (index < _currentPlaylistMediaItems.length) {
        MediaItem mediaItem = _currentPlaylistMediaItems[index];
        String path = mediaItem.extras!['path'];
        _currentPlaylistMediaItems[index] = mediaItem.copyWith(
            title: audioTitle ?? mediaItem.title,
            artist: artist ?? mediaItem.artist);
        if (index == _player.currentIndex) {
          updateMediaItem();
        }
        await tagger.writeTags(
            path: path, tag: Tag(title: audioTitle, artist: artist));
        notifyListeners();
      }
    }
    return;
  }

  @override
  void dispose() {
    // saveData();
    _player.dispose();
    super.dispose();
  }

  // ------------------------------ Getter Methods ------------------------------

  PlayMode get getPlaylistMode => _playlistAllowedModes[playlistModeIndex];
  AudioHandler get getAudioHandler => _audioHandler;
  List<int> get getThumbnail =>
      _audioHandler.mediaItem.value?.extras?['thumbnail'] ?? [];

  String get getTitle {
    try {
      return _audioHandler.mediaItem.value?.title ??
          AppConstants.names.kDefaultSongName;
    } catch (e) {
      return AppConstants.names.kDefaultSongName;
    }
  }

  AudioPlayer get getPlayer => _player;
  Duration get getTotalDuration =>
      _player.duration ?? AppConstants.durations.kDurationNotInitialised;
  Duration get getPosition => _player.position;
  bool get getIsPlaying => _player.playing;
  ConcatenatingAudioSource get getPlaylist => _currentPlaylist;
  List<MediaItem> get getCurrentAudioData => _currentPlaylistMediaItems;
  int get getNumberOfAudios => _currentPlaylistMediaItems.length;
  int get getCurrentlyPlayingAudioIndex => _player.currentIndex ?? -1;
  bool get getIsUpdating => _isUpdating;
  Map<String, List<String>> get getAllPlaylists => _playlists;
}

class AudioPlayerHandler extends BaseAudioHandler with SeekHandler {
  AudioPlayerHandler() {
    // So that our clients (the Flutter UI and the system notification) know
    // what states to display, here we set up our audio_related handler to broadcast all
    // playback states changes as they happen via playbackState...
    _player.playbackEventStream.map(_transformEvent).pipe(playbackState);
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> stop() => _player.stop();

  @override
  Future<void> skipToPrevious() async {
    if (_player.hasPrevious && !_isUpdating) {
      _isUpdating = true;
      await _player.seekToPrevious();
      await updateMediaItem(_currentPlaylistMediaItems[_player.currentIndex!]);
      _isUpdating = false;
      play();
    }
  }

  @override
  Future<void> skipToNext() async {
    if (_player.hasNext && !_isUpdating) {
      _isUpdating = true;
      await _player.seekToNext();
      await updateMediaItem(_currentPlaylistMediaItems[_player.currentIndex!]);
      _isUpdating = false;
      play();
    }
  }

  @override
  Future<void> skipToQueueItem(int index) async {
    if (!_isUpdating) {
      _isUpdating = true;
      await _player.seek(Duration.zero, index: index);
      await updateMediaItem(_currentPlaylistMediaItems[index]);
      _isUpdating = false;
      play();
    }
  }

  @override
  Future<void> updateMediaItem(MediaItem mItem) async {
    print(mItem.artUri);
    mediaItem.add(mItem);
  }

  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: [
        MediaControl.skipToPrevious,
        MediaControl.rewind,
        if (_player.playing) MediaControl.pause else MediaControl.play,
        MediaControl.fastForward,
        MediaControl.skipToNext
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [0, 2, 4],
      processingState: const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[_player.processingState]!,
      playing: _player.playing,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
      queueIndex: event.currentIndex,
    );
  }
}
