/// The base file for handling all music related functions

import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tune/utils/constant.dart';
import 'package:id3tag/id3tag.dart';
import 'dart:io';

final _player = AudioPlayer();
ID3Tag? _metaData;

class MusicHandlerAdmin extends ChangeNotifier {
  late AudioHandler _audioHandler;
  MusicHandlerAdmin({required AudioHandler audioHandler}) {
    _audioHandler = audioHandler;
  }

  AudioHandler get getAudioHandler {
    return _audioHandler;
  }

  ID3Tag? get getMetaData {
    return _metaData;
  }

  AudioPlayer get getPlayer {
    return _player;
  }

  @override
  void dispose() {
    super.dispose();
    _player.dispose();
  }

  Duration get getTotalDuration {
    return _player.duration ?? kDurationNotInitialised;
  }

  Duration get getPosition {
    if (_player.position >= getTotalDuration) {
      _player.seek(Duration.zero);
      _player.pause();
    }
    return _player.position;
  }

  bool get getIsPlaying {
    return _player.playing;
  }
}

/// Handles the current audio
///

class AudioPlayerHandler extends BaseAudioHandler with SeekHandler {
  AudioPlayerHandler() {
    // So that our clients (the Flutter UI and the system notification) know
    // what state to display, here we set up our audio handler to broadcast all
    // playback state changes as they happen via playbackState...
    _player.playbackEventStream.map(_transformEvent).pipe(playbackState);
    init();
  }

  Future<void> init() async {
    final ByteData fileData = await rootBundle.load(kDefaultSongPath);
    final filePath = '${(await getTemporaryDirectory()).path}/test';
    File(filePath).writeAsBytesSync(fileData.buffer
        .asUint8List(fileData.offsetInBytes, fileData.lengthInBytes));

    final parser = ID3TagReader(File(filePath));
    _metaData = parser.readTagSync();

    final item = MediaItem(
      id: kDefaultSongPath,
      album: _metaData!.album,
      title: _metaData!.title ?? '',
      artist: _metaData!.artist,
    );

    await _player.setAsset(kDefaultSongPath);

    mediaItem.add(item.copyWith(duration: _player.duration));
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> stop() => _player.stop();

  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: [
        MediaControl.rewind,
        if (_player.playing) MediaControl.pause else MediaControl.play,
        MediaControl.stop,
        MediaControl.fastForward,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [0, 1, 3],
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
