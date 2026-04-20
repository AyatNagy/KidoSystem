import 'dart:async';
import 'dart:html' as html;
import 'package:flutter/services.dart';

class AudioService {
  static html.AudioElement? _currentAudio;

  static Future<void> play({required String fileName}) async {
    // 1. إيقاف أي صوت شغال حالياً فوراً قبل بدء الجديد
    stop();

    final completer = Completer<void>();
    try {
      final data = await rootBundle.load('assets/audio/$fileName');
      final bytes = data.buffer.asUint8List();
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);

      final audio =
          html.AudioElement()
            ..src = url
            ..autoplay = true;

      _currentAudio = audio;

      audio.onEnded.listen((_) {
        html.Url.revokeObjectUrl(url);
        if (_currentAudio == audio) _currentAudio = null;
        completer.complete();
      });

      await audio.play();
    } catch (e) {
      print("Audio Error: $e");
      completer.complete();
    }
    return completer.future;
  }

  static void stop() {
    if (_currentAudio != null) {
      _currentAudio!.pause();
      _currentAudio!.src = ''; // تفريغ المصدر لضمان التوقف
      _currentAudio = null;
    }
  }
}
