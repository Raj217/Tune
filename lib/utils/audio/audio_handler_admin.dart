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
Map<String, List<MediaItem>> _audioData = {
  'all': <MediaItem>[],
  'favorites': <MediaItem>[]
};
bool _isUpdating = false;

class AudioHandlerAdmin extends ChangeNotifier {
  // ----------------------------- Attributes -----------------------------
  final AudioHandler _audioHandler;
  final ConcatenatingAudioSource _playlist =
      ConcatenatingAudioSource(children: []);
  final tagger = Audiotagger();

  Map<String, dynamic> data = {'userData': [], 'audios': {}};

  /// How do you want to repeat the song/playlist (allowed modes)
  final List<PlayMode> playlistAllowedModes = [
    PlayMode.repeatAll,
    PlayMode.repeatThis,
    PlayMode.shuffleRepeat
  ];

  /// This keeps track of the current playlist mode for repeat, shuffle, etc
  int playlistModeIndex = 0;

  AudioHandlerAdmin({required AudioHandler audioHandler})
      : _audioHandler = audioHandler {
    _listenToPlaybackState();
    _player.setAudioSource(_playlist);
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

  void incrementPlaylistIndex() {
    playlistModeIndex++;
    if (playlistModeIndex >= playlistAllowedModes.length) {
      playlistModeIndex = 0;
    }
  }

  Future<void> addAudio(
      {required String path, String? tag, String playlistName = 'all'}) async {
    MediaItem mediaItem = await getMediaData(path);
    if (!(_audioData[playlistName]?.contains(mediaItem) ?? true)) {
      await _playlist.add(AudioSource.uri(Uri.file(path), tag: tag ?? path));
      _audioData[playlistName]?.add(mediaItem);
      savePlaylist(
          playlistLinks: _audioData[playlistName]!
              .map<String>((mediaItem) => mediaItem.extras!['path'])
              .toList(),
          playlistName: '$playlistName.json');
      notifyListeners();
      if (_audioHandler.mediaItem.value?.title == null) {
        await _audioHandler
            .updateMediaItem(_audioData[playlistName]![_player.currentIndex!]);
        notifyListeners();
      }
      return;
    }
  }

  Future<void> deletePlaylistStorage({required String playlistName}) async {
    await FileHandler.delete(playlistName + '.json');
  }

  Future<void> savePlaylist(
      {required List<String> playlistLinks,
      required String playlistName}) async {
    await FileHandler.save(
        fileName: playlistName, fileContents: json.encode(playlistLinks));
  }

  Future<void> saveData() async {
    await FileHandler.save(
        fileName: 'cookies.txt', fileContents: json.encode(data));
  }

  Future<void> readPlay1list({String playlistName = 'all'}) async {
    if (_audioData.keys.toList().contains(playlistName)) {
      String? data = await FileHandler.read(fileName: playlistName + '.json');
      if (data != null) {
        List<dynamic> decodedData = json.decode(data);
        for (String link in decodedData) {
          await addAudio(path: link);
        }
      }
    }
    return;
  }

  Future<void> removeAudio({int? index, MediaItem? mediaItem}) async {
    /// Either index or mediaItem must be provided
    bool removeSuccess = false;
    int? currentIndex = _player.currentIndex;
    Duration currentPos = _player.position;
    bool isPlaying = _player.playing;

    index ??= _audioData['all']!.indexOf(mediaItem!);

    MediaItem checkMediaItem = _audioData['all']![index];
    if (checkMediaItem == _audioHandler.mediaItem.value) {
      _audioHandler.pause();
      if (_player.hasPrevious) {
        _audioHandler.skipToPrevious();
      } else if (_player.hasNext) {
        _audioHandler.skipToNext();
      } else {
        _audioHandler.skipToQueueItem(0);
      }
    }
    _audioData['all']!.removeAt(index);
    await _playlist.removeAt(index);
    await _player.setAudioSource(_playlist);
    removeSuccess = true;
    if (currentIndex != null && currentIndex <= _playlist.length) {
      int? ind;
      if (index > currentIndex) {
        ind = currentIndex;
      } else if (index < currentIndex) {
        ind = currentIndex - 1;
      } else if (_playlist.length != 0) {
        ind = currentIndex - 1;
        isPlaying = false;
      }
      print(ind);
      if (ind != null && ind >= 0) {
        await _player.seek(currentPos, index: ind);
        if (isPlaying) {
          await _audioHandler.play();
        }
      }
    }

    if (removeSuccess) {
      savePlaylist(
          playlistLinks: _audioData['all']!
              .map<String>((mediaItem) => mediaItem.extras!['path'])
              .toList(),
          playlistName: 'all.json');
      notifyListeners();
    }
  }

  Future<void> updateMediaItem() async {
    await _audioHandler
        .updateMediaItem(_audioData['all']![_player.currentIndex!])
        .then((value) {
      notifyListeners();
    });
  }

  void setSpeed(double speed) {
    _player.setSpeed(speed);
  }

  void setPitch(double pitch) {
    _player.setPitch(pitch);
  }

  static Future<MediaItem> getMediaData(String filePath) async {
    String playlistName = 'all';
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

    String posterPath = await FileHandler.save(
        fileBytes: imgBytes,
        fileName: 'poster_img${_audioData[playlistName]!.length}');

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
          'playlist': [playlistName] // TODO: Make it dynamic
        });
    AudioPlayer tempPlayer = AudioPlayer();
    await tempPlayer.setFilePath(filePath);
    return item.copyWith(duration: tempPlayer.duration);
  }

  Future<void> setNewMetaDataForAudio(
      {required int index,
      String? audioTitle,
      String? artist,
      String playlistName = 'all'}) async {
    if (_audioData[playlistName] != null) {
      if (index < _audioData[playlistName]!.length) {
        MediaItem mediaItem = _audioData[playlistName]![index];
        String path = mediaItem.extras!['path'];
        _audioData[playlistName]![index] = mediaItem.copyWith(
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

  PlayMode get getPlaylistMode => playlistAllowedModes[playlistModeIndex];
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
  ConcatenatingAudioSource get getPlaylist => _playlist;
  Map<String, List<MediaItem>> get getAllAudioData => _audioData;
  List<MediaItem> get getAudioData => _audioData['all']!;
  int get getNumberOfAudios => _audioData['all']!.length;
  int get getCurrentlyPlayingAudioIndex => _player.currentIndex ?? -1;
  bool get getIsUpdating => _isUpdating;
}

class AudioPlayerHandler extends BaseAudioHandler with SeekHandler {
  AudioPlayerHandler() {
    // So that our clients (the Flutter UI and the system notification) know
    // what states to display, here we set up our audio_related handler to broadcast all
    // playback states changes as they happen via playbackState...
    _player.playbackEventStream.map(_transformEvent).pipe(playbackState);
  }

  Future<void> initSong(String filePath) async {
    await _player.setFilePath(filePath);
    mediaItem.add(await AudioHandlerAdmin.getMediaData(filePath));

    return;
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
      await updateMediaItem(_audioData['all']![_player.currentIndex!]);
      _isUpdating = false;
      play();
    }
  }

  @override
  Future<void> skipToNext() async {
    if (_player.hasNext && !_isUpdating) {
      _isUpdating = true;
      await _player.seekToNext();
      await updateMediaItem(_audioData['all']![_player.currentIndex!]);
      _isUpdating = false;
      play();
    }
  }

  @override
  Future<void> skipToQueueItem(int index) async {
    if (!_isUpdating) {
      _isUpdating = true;
      await _player.seek(Duration.zero, index: index);
      await updateMediaItem(_audioData['all']![index]);
      _isUpdating = false;
      play();
    }
  }

  @override
  Future<void> updateMediaItem(MediaItem mItem) async {
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
