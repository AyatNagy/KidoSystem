import 'package:flutter/material.dart';
import 'package:kido/Models/draganddrop_question.dart';
import 'package:kido/Models/dragable_item.dart';
import 'package:kido/Models/targets_item.dart';
import 'package:kido/config/responsive_config.dart'; // استيراد الـ Config
import '../../../Models/level3/fruits/discovery_fruits.dart';

class FridgeGameLogic {
  static DragDropQuestion generateFruitGame(
    List<FruitsModel> fruits,
    ResponsiveConfig responsive,
  ) {
    return DragDropQuestion(
      questionText: "",
      // ارجعي صورة الثلاجة هنا لتجنب علامة الـ X الحمراء
      backgroundImage: "assets/images/fruits/fridge_open.png",
      items:
          fruits.map((fruit) {
            // تجربة: سنضع الفواكه في إحداثيات ثابتة في منتصف الشاشة للتأكد من ظهورها
            // إذا ظهرت، سنقوم بتعديل توزيعها لاحقاً
            int index = fruits.indexOf(fruit);
            double dx = 0.3 + (index % 2) * 0.3;
            double dy = 0.2 + (index ~/ 2) * 0.15;

            return DragItem(
              id: "fruit_${fruit.fruitPath}",
              image:
                  fruit.fruitPath, // تأكدي أن هذا المسار صح (assets/images/...)
              startPosition: Offset(dx, dy),
              size: Size(
                responsive.localWidth * 0.15,
                responsive.localWidth * 0.15,
              ),
            );
          }).toList(),
      targets: [
        DragTargetZone(
          id: "cart_target",
          acceptedItemIds: fruits.map((f) => "fruit_${f.fruitPath}").toList(),
          position: const Offset(0.35, 0.7),
          size: const Size(0.3, 0.2),
          image: "assets/images/fruits/cart.png",
        ),
      ],
    );
  }
}
