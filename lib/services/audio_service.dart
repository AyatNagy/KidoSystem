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

  static void stop() {
    _player.stop();
  }
}
