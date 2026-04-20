import 'dart:async';
import 'dart:html' as html;
import 'package:flutter/services.dart';

class AudioService {
  static Future<void> play({required String fileName}) async {
    final completer = Completer<void>();

    final data = await rootBundle.load('assets/audio/$fileName');
    final bytes = data.buffer.asUint8List();

    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);

    final audio =
        html.AudioElement()
          ..src = url
          ..autoplay = true;

    try {
      await audio.play();
    } catch (e) {
      print("Audio blocked: $e");
    }

    audio.onEnded.listen((_) {
      html.Url.revokeObjectUrl(url);
      completer.complete();
    });

    return completer.future;
  }
}
