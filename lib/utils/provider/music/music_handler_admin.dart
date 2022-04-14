/// The base file for handling all music related functions

import 'dart:typed_data';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:tune/utils/constant.dart';
import 'package:id3tag/id3tag.dart';
import 'dart:io';

import 'package:tune/utils/storage/file_handler.dart';

final _player = AudioPlayer();
ID3Tag? _metaData;

class MusicHandlerAdmin extends ChangeNotifier {
  late AudioHandler _audioHandler;

  Future<void> initAudioHandler(String filePath) async {
    try {
      await _audioHandler
          .addQueueItem(await AudioPlayerHandler.getMediaData(filePath));
    } catch (e) {
      _audioHandler = await AudioService.init(
          builder: () => AudioPlayerHandler(filePath),
          config: const AudioServiceConfig(
            androidNotificationChannelId: 'com.ryanheise.myapp.channel.audio',
            androidNotificationChannelName: 'Audio playback',
            androidNotificationOngoing: true,
          ),
          cacheManager: DefaultCacheManager());
    }
    return;
  }

  AudioHandler get getAudioHandler {
    return _audioHandler;
  }

  ID3Tag? get getMetaData {
    return _metaData;
  }

  String get getTitle {
    try {
      return _audioHandler.mediaItem.value?.title ?? 'Unnamed Song';
    } catch (e) {
      return 'Unnamed Song';
    }
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
  AudioPlayerHandler(String filePath) {
    // So that our clients (the Flutter UI and the system notification) know
    // what states to display, here we set up our audio handler to broadcast all
    // playback states changes as they happen via playbackState...
    _player.playbackEventStream.map(_transformEvent).pipe(playbackState);
    initSong(filePath);
  }
  static Future<MediaItem> getMediaData(String filePath) async {
    final parser = ID3TagReader(File(filePath));
    _metaData = parser.readTagSync();

    List<String> loc = filePath.split('/');
    String songName = loc[loc.length - 1];

    List<String> dots = songName.split('.');
    List<int>? imgData;

    try {
      imgData = _metaData?.pictures[0].imageData;
    } catch (e) {}

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
          : songName.substring(0, songName.indexOf(dots[dots.length - 1]) - 1),
      artist: _metaData!.artist,
      artUri: Uri.file(posterPath),
    );
    AudioPlayer tempPlayer = AudioPlayer();
    await tempPlayer.setFilePath(filePath);
    return item.copyWith(duration: tempPlayer.duration);
  }

  Future<void> initSong(String filePath) async {
    await _player.setFilePath(filePath);
    mediaItem.add(await getMediaData(filePath));
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
