import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import '../errors/exceptions.dart';

/// Singleton audio engine wrapper.
///
/// Exposes typed streams and transport controls for the BLoC layer.
/// All I/O exceptions are re-thrown with typed domain exceptions.
class AudioService {
  AudioService._() {
    _player.onLog.listen((message) {
      developer.log(message, name: 'AudioService');
    });
  }

  static final AudioService _instance = AudioService._();
  factory AudioService() => _instance;

  final AudioPlayer _player = AudioPlayer();
  String? _currentUrl;

  Stream<Duration> get positionStream => _player.onPositionChanged;
  Stream<Duration> get durationStream => _player.onDurationChanged;
  Stream<PlayerState> get playerStateStream => _player.onPlayerStateChanged;

  Future<void> play(String streamUrl) async {
    _currentUrl = streamUrl;
    try {
      await _player.play(
        UrlSource(streamUrl),
        mode: PlayerMode.mediaPlayer,
      );
    } on TimeoutException catch (err) {
      throw NetworkException(
        message: 'Network timeout: could not connect to stream (${err.message}).',
      );
    } on SocketException catch (err) {
      throw NetworkException(
        message: 'Network error: check internet connection (${err.message}).',
      );
    } on PlatformException catch (err) {
      developer.log('Audio engine error: ${err.message}', name: 'AudioService');
      throw const PlaybackException(message: 'Audio stream unavailable.');
    } catch (err) {
      throw PlaybackException(message: 'Playback failed: $err');
    }
  }


  Future<void> pause() async {
    try {
      await _player.pause();
    } catch (err) {
      developer.log('Pause error: $err', name: 'AudioService');
    }
  }

  Future<void> resume() async {
    try {
      final isIdle =
          _player.state == PlayerState.completed ||
          _player.state == PlayerState.stopped;
      final cachedUrl = _currentUrl;
      if (isIdle && cachedUrl != null) {
        await _player.play(UrlSource(cachedUrl));
        return;
      }
      await _player.resume();
    } catch (err) {
      developer.log('Resume error: $err', name: 'AudioService');
    }
  }

  Future<Duration?> getDuration() => _player.getDuration();

  Future<void> setRepeatMode(bool isLooping) =>
      _player.setReleaseMode(isLooping ? ReleaseMode.loop : ReleaseMode.release);

  Future<void> seek(Duration targetPosition) async {
    try {
      await _player.seek(targetPosition);
    } catch (err) {
      developer.log('Seek error: $err', name: 'AudioService');
    }
  }

  Future<void> stop() async {
    try {
      await _player.stop();
    } catch (err) {
      developer.log('Stop error: $err', name: 'AudioService');
    }
  }

  Future<void> dispose() => _player.dispose();
}
