import '../../../../Models/level1/sense_model.dart';
import '../../../../enum/sense_type.dart';

class SenseMapper {
  static SenseData get(SenseType type) {
    switch (type) {
      case SenseType.eyes:
        return const SenseData(
          title: "عيني",
          audio: "senses/eyes.mp3",
          questionAudio: "senses/where_is_eyes.mp3",
          featureImage: "assets/images/senses/eyes.png",
          faceWithoutFeature: "assets/images/senses/face_no_eyes.png",
          topFactor: 0.49,
          leftFactor: 0.25,
          widthFactor: 0.50,
        );

      case SenseType.nose:
        return const SenseData(
          title: "مناخيري",
          audio: "senses/nose.mp3",
          questionAudio: "senses/where_is_nose.mp3",
          featureImage: "assets/images/senses/nose.png",
          faceWithoutFeature: "assets/images/senses/face_no_nose.png",
          topFactor: 0.45,
          leftFactor: 0.29,
          widthFactor: 0.45,
        );

      case SenseType.mouth:
        return const SenseData(
          title: "بوقي",
          audio: "senses/mouth.mp3",
          questionAudio: "senses/where_is_mouth.mp3",
          featureImage: "assets/images/senses/mouth.png",
          faceWithoutFeature: "assets/images/senses/face_no_mouth.png",
          topFactor: 0.60,
          leftFactor: 0.35,
          widthFactor: 0.30,
        );

      case SenseType.ears:
        return const SenseData(
          title: "وداني",
          audio: "senses/ears.mp3",
          questionAudio: "senses/where_is_ears.mp3",
          featureImage: "assets/images/senses/ears.png",
          faceWithoutFeature: "assets/images/senses/face_no_ears.png",
          topFactor: 0.50,
          leftFactor: 0.05,
          widthFactor: 0.90,
        );
    }
  }
}
