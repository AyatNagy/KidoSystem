import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static final AudioPlayer _player = AudioPlayer();

  static Future<void> play({required String fileName}) async {
    try {
      await _player.stop();

      // هنا إحنا بنقول للمكتبة:
      // روحي لـ assets/audio/ وضيفي عليها اسم الملف اللي جاي من الـ Mapper
      await _player.play(AssetSource('audio/$fileName'));
    } catch (e) {
      print("Audio Play Error: $e");
    }
  }

  static void stop() {
    _player.stop();
  }
}
