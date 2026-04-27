import 'package:flutter/material.dart';
import 'map.dart';

class JourneymapPage extends StatefulWidget {
  final List<dynamic> journeyData;
  final Color backgroundColor;
  final Color nodeButtonColor;
  final Widget Function(dynamic item) detailFlowBuilder;

  const JourneymapPage({
    super.key,
    required this.journeyData,
    required this.backgroundColor,
    required this.nodeButtonColor,
    required this.detailFlowBuilder,
  });

  @override
  State<JourneymapPage> createState() => _JourneymapPageState();
}

class _JourneymapPageState extends State<JourneymapPage> {
  void _onNodeTap(int index) async {
    final currentStep = widget.journeyData[index];

    final bool? examPassed = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget.detailFlowBuilder(currentStep),
      ),
    );

    if (examPassed == true) {
      setState(() {
        if (index + 1 < widget.journeyData.length) {
          widget.journeyData[index + 1].isLocked = false;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // استخدمنا Stack لوضع الرسومات خلف الخريطة
      body: Stack(
        children: [
          // 1. الخلفية المتدرجة (Gradient Background)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFE8F5E9), // أخضر فاتح جداً (مثل لون النعناع)
                  Color(0xFFC8E6C9), // أخضر أغمق قليلاً
                ],
              ),
            ),
          ),

          // 2. رسومات الديكور (عناصر خلفية لإعطاء روح المزرعة)
          Positioned(
            top: 50,
            left: -30,
            child: Opacity(
              opacity: 0.2,
              child: Icon(
                Icons.bakery_dining_rounded,
                size: 150,
                color: Colors.green[300],
              ),
              // يمكنك استبدال الأيقونات بـ Image.asset لصور خضروات كرتونية باهتة
            ),
          ),
          Positioned(
            bottom: 100,
            right: -20,
            child: Opacity(
              opacity: 0.15,
              child: Icon(
                Icons.eco_rounded,
                size: 200,
                color: Colors.green[400],
              ),
            ),
          ),

          // 3. الخريطة (الـ ListView)
          ListView.builder(
            padding: const EdgeInsets.symmetric(
              vertical: 120,
            ), // مسافة كافية في البداية والنهاية
            itemCount: widget.journeyData.length,
            itemBuilder: (context, index) {
              return MapNode(
                index: index,
                totalItems: widget.journeyData.length,
                lesson: widget.journeyData[index],
                buttonColor: widget.nodeButtonColor,
                onTap: () => _onNodeTap(index),
              );
            },
          ),

          // 4. زر العودة العلوي (اختياري)
          Positioned(
            top: 50,
            left: 20,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.green),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
