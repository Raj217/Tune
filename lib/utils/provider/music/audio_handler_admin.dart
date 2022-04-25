/// The base file for handling all music related functions

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:id3tag/id3tag.dart';
import 'dart:io';

import 'package:tune/utils/storage/file_handler.dart';
import 'package:tune/utils/constants/system_constants.dart';
import '../../formatter.dart';

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
  'all songs': <MediaItem>[],
  'favorites': <MediaItem>[]
};
bool _isUpdating = false;

class AudioHandlerAdmin extends ChangeNotifier {
  final AudioHandler _audioHandler;
  final ConcatenatingAudioSource _playlist =
      ConcatenatingAudioSource(children: []);

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
    readPlaylist(playlistName: 'all songs');
  }

  void incrementPlaylistIndex() {
    playlistModeIndex++;
    if (playlistModeIndex >= playlistAllowedModes.length) {
      playlistModeIndex = 0;
    }
  }

  void _listenToPlaybackState() {
    _audioHandler.playbackState.listen((playbackState) {
      if (playbackState.position >= getTotalDuration) {
        _audioHandler.seek(Duration.zero);
        _audioHandler.pause();
      }
      updateMediaItem();
    });
  }

  Future<void> addAudio(
      {required String path,
      String? tag,
      String playlistName = 'all songs'}) async {
    MediaItem mediaItem = await AudioPlayerHandler.getMediaData(path);
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

  Future<List<String>?> readPlaylist({required String playlistName}) async {
    if (_audioData.keys.toList().contains(playlistName)) {
      String? data = await FileHandler.read(fileName: playlistName + '.json');
      if (data != null) {
        List<dynamic> decodedData = json.decode(data);
        for (String link in decodedData) {
          await addAudio(path: link);
        }
      }
    }
    return null;
  }

  Future<void> removeAudio({int? index, MediaItem? mediaItem}) async {
    /// Either index or mediaItem must be provided
    bool removeSuccess = false;
    int? currentIndex = _player.currentIndex;
    Duration currentPos = _player.position;
    bool isPlaying = _player.playing;

    index ??= _audioData['all songs']!.indexOf(mediaItem!);

    MediaItem checkMediaItem = _audioData['all songs']![index];
    if (checkMediaItem == _audioHandler.mediaItem.value) {
      _audioHandler.pause();
      if (_player.hasPrevious) {
        _audioHandler.skipToPrevious();
      } else {
        _audioHandler.skipToNext();
      }
    }
    _audioData['all songs']!.removeAt(index);
    await _playlist.removeAt(index);
    await _player.setAudioSource(_playlist);
    removeSuccess = true;

    if (currentIndex != null && currentIndex < _playlist.length) {
      int? ind;
      if (index > currentIndex) {
        ind = currentIndex;
      } else if (index < currentIndex) {
        ind = currentIndex - 1;
      } else if (_playlist.length != 0) {
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

    if (removeSuccess) {
      savePlaylist(
          playlistLinks: _audioData['all songs']!
              .map<String>((mediaItem) => mediaItem.extras!['path'])
              .toList(),
          playlistName: 'all songs.json');
      notifyListeners();
    }
  }

  // ------------------------------ Getter Methods ------------------------------

  PlayMode get getPlaylistMode => playlistAllowedModes[playlistModeIndex];
  AudioHandler get getAudioHandler => _audioHandler;
  List<int> get getThumbnail =>
      _audioHandler.mediaItem.value?.extras?['thumbnail'] ?? [];

  String get getTitle {
    try {
      return _audioHandler.mediaItem.value?.title ?? kDefaultSongName;
    } catch (e) {
      return kDefaultSongName;
    }
  }

  AudioPlayer get getPlayer => _player;
  Duration get getTotalDuration => _player.duration ?? kDurationNotInitialised;
  Duration get getPosition => _player.position;
  bool get getIsPlaying => _player.playing;
  ConcatenatingAudioSource get getPlaylist => _playlist;
  List<MediaItem> get getAudioData => _audioData['all songs']!;
  int get getNAudioValueNotifier => _audioData['all songs']!.length;
  int get getCurrentlyPlayingAudioIndex => _player.currentIndex ?? -1;
  bool get getIsUpdating => _isUpdating;
  Future<void> updateMediaItem() async {
    if (_player.currentIndex != null &&
        _audioHandler.mediaItem.value != _audioData[_player.currentIndex]) {
      await _audioHandler
          .updateMediaItem(_audioData['all songs']![_player.currentIndex!])
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

  @override
  void dispose() {
    super.dispose();
    _player.dispose();
  }
}

class AudioPlayerHandler extends BaseAudioHandler with SeekHandler {
  AudioPlayerHandler() {
    // So that our clients (the Flutter UI and the system notification) know
    // what states to display, here we set up our audio_related handler to broadcast all
    // playback states changes as they happen via playbackState...
    _player.playbackEventStream.map(_transformEvent).pipe(playbackState);
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
      await rootBundle.load(kDefaultPosterImgPath).then((ByteData bytes) async {
        imgBytes = bytes.buffer.asUint8List();
      });
    }

    String posterPath =
        await FileHandler.save(fileBytes: imgBytes, fileName: 'poster_img.txt');

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
          'thumbnail': imageData
        });
    AudioPlayer tempPlayer = AudioPlayer();
    await tempPlayer.setFilePath(filePath);
    return item.copyWith(duration: tempPlayer.duration);
  }

  Future<void> initSong(String filePath) async {
    await _player.setFilePath(filePath);
    mediaItem.add(await getMediaData(filePath));

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
      _player.seekToPrevious();
      await updateMediaItem(_audioData['all songs']![_player.currentIndex!])
          .then((value) => _isUpdating = false);
    }
  }

  @override
  Future<void> skipToNext() async {
    if (_player.hasNext && !_isUpdating) {
      _isUpdating = true;
      _player.seekToNext();
      await updateMediaItem(_audioData['all songs']![_player.currentIndex!])
          .then((value) => _isUpdating = false);
    }
  }

  @override
  Future<void> skipToQueueItem(int index) async {
    if (!_isUpdating) {
      _isUpdating = true;
      await _player.seek(Duration.zero, index: index);
      updateMediaItem(_audioData['all songs']![index]).then((value) {
        _isUpdating = false;
        play();
      });
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
      androidCompactActionIndices: const [1, 2, 3],
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
