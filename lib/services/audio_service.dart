import 'dart:async';
import 'dart:html' as html;
import 'package:flutter/services.dart';

class AudioService {
  static bool _isPlaying = false;

  static bool get isPlaying => _isPlaying; // 👈 ده الحل

  static Future<void> play({required String fileName}) async {
    if (_isPlaying) return;

    _isPlaying = true;

    final completer = Completer<void>();

    final data = await rootBundle.load('assets/audio/$fileName');
    final bytes = data.buffer.asUint8List();

    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);

    final audio =
        html.AudioElement()
          ..src = url
          ..autoplay = true;

    audio.play();

    audio.onEnded.listen((_) {
      html.Url.revokeObjectUrl(url);
      _isPlaying = false;
      completer.complete();
    });

    return completer.future;
  }
}
