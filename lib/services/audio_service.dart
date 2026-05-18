import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class AudioService {
  static final AudioPlayer _player = AudioPlayer();

  // ➕ إضافة جديدة: لاعب منفصل تماماً للمؤثرات الصوتية (علشان يشتغلوا فوق بعض)
  static final AudioPlayer _effectsPlayer = AudioPlayer();

  static String? _currentFile;
  static Duration _lastPosition = Duration.zero;
  static bool _isPlayingBeforePause = false;
  static bool _isAppInForeground = true;

  // ➕ دالة جديدة تماماً: خاصة بالفرقعة، مش بتأثر على الـ _player القديم نهائي
  static Future<void> playEffect({required String fileName}) async {
    if (!_isAppInForeground) return;
    try {
      await _effectsPlayer.stop();
      await _effectsPlayer.play(AssetSource('audio/$fileName'));
    } catch (e) {
      debugPrint("Audio Play Effect Error: $e");
    }
  }

  // -------------------------------------------------------------
  // ⚠️ الدوال القديمة كما هي تماماً دون أي تغيير في اللوجيك الخاص بها:
  // -------------------------------------------------------------

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
      // زيادة أمان: بنوقف صوت المؤثرات لو خرجنا من التطبيق
      await _effectsPlayer.pause();
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
    _effectsPlayer
        .stop(); // بنوقف الـ effects كمان هنا عند الاستدعاء العام للـ stop
  }
}
