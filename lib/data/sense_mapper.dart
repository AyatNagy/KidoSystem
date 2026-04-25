import '../Models/sense_data.dart';
import '../enum/sense_type.dart';

class SenseMapper {
  static SenseData get(SenseType type) {
    switch (type) {
      case SenseType.eyes:
        return const SenseData(
          title: "عيني",
          audio: "senses/eyes.mp3",
          featureImage: "assets/images/senses/eyes.png",
          faceWithoutFeature: "assets/images/senses/face_no_eyes.png",
          topFactor: 0.49,
          leftFactor: 0.25,
          widthFactor: 0.50, // عرض العينين مع بعض
        );
      case SenseType.nose:
        return const SenseData(
          title: "مناخيري",
          audio: "senses/nose.mp3",
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
          featureImage: "assets/images/senses/mouth.png",
          faceWithoutFeature: "assets/images/senses/face_no_mouth.png",
          topFactor: 0.60, // مكانه تحت
          leftFactor: 0.35, // في النص
          widthFactor: 0.30, // البق محتاج عرض أكبر من المناخير
        );
      case SenseType.ears:
        return const SenseData(
          title: "وداني",
          audio: "senses/ears.mp3",
          featureImage: "assets/images/senses/ears.png",
          faceWithoutFeature: "assets/images/senses/face_no_ears.png",
          topFactor: 0.50,
          leftFactor: 0.05,
          widthFactor: 0.90, // الودان محتاجة حجم كبير عشان تركب صح
        );
    }
  }
}
