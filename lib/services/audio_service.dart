import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class AudioService {
  static final AudioPlayer _player = AudioPlayer();

  static Future<void> play({required String fileName}) async {
    try {
      await _player.stop();
      await _player.play(AssetSource('audio/$fileName'));
    } catch (e) {
      debugPrint("Audio Play Error: $e");
    }
  }

  static Future<void> playSequence(String firstFile, String secondFile) async {
    try {
      await _player.stop();
      await _player.play(AssetSource('audio/$firstFile'));

      await _player.onPlayerComplete.first;

      await _player.play(AssetSource('audio/$secondFile'));
    } catch (e) {
      debugPrint("Audio Sequence Error: $e");
    }
  }

  static void stop() {
    _player.stop();
  }
}
