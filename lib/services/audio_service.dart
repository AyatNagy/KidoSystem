import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class AudioService {
  static final AudioPlayer _player = AudioPlayer();

  static String? _currentFile;
  static Duration _lastPosition = Duration.zero;
  static bool _isPlayingBeforePause = false;

  static bool _isAppInForeground = true;

  static Future<void> play({required String fileName}) async {
    if (!_isAppInForeground) {
      _currentFile = fileName;
      _isPlayingBeforePause = true;
      return;
    }

    try {
      _currentFile = fileName;
      _lastPosition = Duration.zero;
      await _player.stop();
      await _player.play(AssetSource('audio/$fileName'));
      _isPlayingBeforePause = true;
    } catch (e) {
      debugPrint("Audio Play Error: $e");
    }
  }

  static Future<void> playAndWait({required String fileName}) async {
    if (!_isAppInForeground) {
      _currentFile = fileName;
      _isPlayingBeforePause = true;
      return;
    }

    try {
      _currentFile = fileName;

      _lastPosition = Duration.zero;

      await _player.stop();

      await _player.play(AssetSource('audio/$fileName'));

      _isPlayingBeforePause = true;

      // 👇 استنى لحد ما الصوت يخلص
      await _player.onPlayerComplete.first;
    } catch (e) {
      debugPrint("Audio playAndWait Error: $e");
    }
  }

  static Future<void> playSequence(String firstFile, String secondFile) async {
    if (!_isAppInForeground) return;

    try {
      _currentFile = firstFile;
      await _player.stop();
      await _player.play(AssetSource('audio/$firstFile'));
      _isPlayingBeforePause = true;

      await _player.onPlayerComplete.first;
      if (_isPlayingBeforePause && _isAppInForeground) {
        _currentFile = secondFile;
        await _player.play(AssetSource('audio/$secondFile'));
      }
    } catch (e) {
      debugPrint("Audio Sequence Error: $e");
    }
  }

  static Future<void> pauseOnLeave() async {
    try {
      _isAppInForeground = false;
      if (_player.state == PlayerState.playing) {
        _isPlayingBeforePause = true;
        _lastPosition = await _player.getCurrentPosition() ?? Duration.zero;
        await _player.pause();
        debugPrint("Audio paused on leave at: $_lastPosition");
      }
    } catch (e) {
      debugPrint("Audio Pause On Leave Error: $e");
    }
  }

  static Future<void> resumeOnReturn() async {
    try {
      _isAppInForeground = true;
      if (_isPlayingBeforePause && _currentFile != null) {
        await _player.seek(_lastPosition);
        await _player.resume();
        debugPrint("Audio resumed and forced to position: $_lastPosition");
      }
    } catch (e) {
      debugPrint("Audio Resume On Return Error: $e");
    }
  }

  static void stop() {
    _currentFile = null;
    _lastPosition = Duration.zero;
    _isPlayingBeforePause = false;
    _player.stop();
  }
}
