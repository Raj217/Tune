/// The base file for handling all music related functions

import 'dart:async';
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

  /// Repeat only this audio
  repeatThis,

  /// Shuffle and keep on playing the playlist, on end repeat the current playlist pattern
  shuffleRepeat,

  /// Shuffle and keep on playing the playlist, on end reshuffle the playlist
  shuffleShuffle,

  /// Stop once this audio is over
  endAfterThis,

  /// Stop once this playlist is over
  endAfterPlaylist,
}

final AudioPlayer _player = AudioPlayer();
ID3Tag? _metaData;
List<MediaItem> _audioData = <MediaItem>[];
ValueNotifier<int> _currentlyPlayingAudioIndex = ValueNotifier(-1);
bool _isUpdating = false;

class AudioHandlerAdmin extends ChangeNotifier {
  final AudioHandler _audioHandler;
  final ConcatenatingAudioSource _playlist =
      ConcatenatingAudioSource(children: []);
  final ValueNotifier<int> _nAudioValueNotifier = ValueNotifier(0);

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
    });
  }

  Future<void> addAudio({required String path, String? tag}) async {
    await _playlist.add(AudioSource.uri(Uri.file(path), tag: tag ?? path));
    _audioData.add(await AudioPlayerHandler.getMediaData(path));
    _nAudioValueNotifier.value += 1;
    if (_audioHandler.mediaItem.value?.title == null) {
      _currentlyPlayingAudioIndex.value = 0;
      await _audioHandler.updateMediaItem(_audioData[_player.currentIndex!]);
    }
    return;
  }

  // ------------------------------ Getter Methods ------------------------------

  PlayMode get getPlaylistMode => playlistAllowedModes[playlistModeIndex];
  AudioHandler get getAudioHandler => _audioHandler;
  ID3Tag? get getMetaData => _metaData;

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
  List<MediaItem> get getAudioData => _audioData;
  ValueNotifier<int> get getNAudioValueNotifier => _nAudioValueNotifier;
  ValueNotifier<int> get getCurrentlyPlayingAudioIndex =>
      _currentlyPlayingAudioIndex;
  bool get getIsUpdating => _isUpdating;
  Future<void> updateMediaItem() async {
    if (_audioHandler.mediaItem !=
        _audioData[_currentlyPlayingAudioIndex.value]) {
      await _audioHandler
          .updateMediaItem(_audioData[_player.currentIndex!])
          .then((value) {
        notifyListeners();
      });
    }
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
    // what states to display, here we set up our audio handler to broadcast all
    // playback states changes as they happen via playbackState...
    _player.playbackEventStream.map(_transformEvent).pipe(playbackState);
  }
  static Future<MediaItem> getMediaData(String filePath) async {
    final parser = ID3TagReader(File(filePath));
    _metaData = parser.readTagSync();

    List<int>? imgData;

    try {
      imgData = _metaData?.pictures[0].imageData;
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

    final item = MediaItem(
        id: filePath,
        album: _metaData!.album,
        title: _metaData!.title != null
            ? _metaData!.title!
            : Formatter.extractSongNameFromPath(filePath),
        artist: _metaData!.artist,
        artUri: Uri.file(posterPath),
        extras: {'path': filePath});
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
  Future<void> play() async {
    _player.play();
    _currentlyPlayingAudioIndex.value = _player.currentIndex ?? -1;
  }

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
      await updateMediaItem(_audioData[_player.currentIndex!])
          .then((value) => _isUpdating = false);
      _currentlyPlayingAudioIndex.value = _player.currentIndex ?? -1;
    }
  }

  @override
  Future<void> skipToNext() async {
    if (_player.hasNext && !_isUpdating) {
      _isUpdating = true;
      _player.seekToNext();
      await updateMediaItem(_audioData[_player.currentIndex!])
          .then((value) => _isUpdating = false);
      _currentlyPlayingAudioIndex.value = _player.currentIndex ?? -1;
    }
  }

  @override
  Future<void> skipToQueueItem(int index) async {
    if (!_isUpdating) {
      _isUpdating = true;
      _player.seek(Duration.zero, index: index);
      await updateMediaItem(_audioData[index])
          .then((value) => _isUpdating = false);
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
