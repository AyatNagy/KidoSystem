import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class AudioService {
  static final AudioPlayer _player = AudioPlayer();

  static String? _currentFile;
  static Duration _lastPosition = Duration.zero;
  static bool _isPlayingBeforePause = false;

  static Future<void> play({required String fileName}) async {
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

  static Future<void> playSequence(String firstFile, String secondFile) async {
    try {
      _currentFile = firstFile;
      await _player.stop();
      await _player.play(AssetSource('audio/$firstFile'));
      _isPlayingBeforePause = true;

      await _player.onPlayerComplete.first;

      _currentFile = secondFile;
      await _player.play(AssetSource('audio/$secondFile'));
    } catch (e) {
      debugPrint("Audio Sequence Error: $e");
    }
  }

  // تأكدي إن الدالة دي موجودة ومكتوبة كدة بالظبط 👇
  static Future<void> pauseOnLeave() async {
    try {
      if (_player.state == PlayerState.playing) {
        _isPlayingBeforePause = true;
        _lastPosition = await _player.getCurrentPosition() ?? Duration.zero;
        await _player.pause();
      } else {
        _isPlayingBeforePause = false;
      }
    } catch (e) {
      debugPrint("Audio Pause On Leave Error: $e");
    }
  }

  // وتأكدي إن الدالة دي موجودة ومكتوبة كدة بالظبط 👇
  static Future<void> resumeOnReturn() async {
    try {
      if (_isPlayingBeforePause && _currentFile != null) {
        await _player.resume();
        await _player.seek(_lastPosition);
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
