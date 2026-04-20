import 'dart:html' as html;
import 'package:flutter/services.dart';

class AudioSessionManager {
  static html.AudioElement? _currentAudio;
  static String? _currentUrl;

  static Future<void> play(String fileName) async {
    await stop();

    final data = await rootBundle.load('assets/audio/$fileName');
    final bytes = data.buffer.asUint8List();

    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);

    final audio =
        html.AudioElement()
          ..src = url
          ..autoplay = true;

    _currentAudio = audio;
    _currentUrl = url;

    try {
      await audio.play();
    } catch (_) {}

    audio.onEnded.listen((_) {
      _clear();
    });
  }

  static Future<void> stop() async {
    try {
      _currentAudio?.pause();
    } catch (_) {}
    _clear();
  }

  static void _clear() {
    if (_currentUrl != null) {
      html.Url.revokeObjectUrl(_currentUrl!);
    }
    _currentAudio = null;
    _currentUrl = null;
  }
}
