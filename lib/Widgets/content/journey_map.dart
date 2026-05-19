// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:kido/utils/lesson_completion.dart';
import 'map.dart';

class JourneymapPage extends StatefulWidget {
  final List<dynamic> journeyData;
  final Color backgroundColor;
  final Color nodeButtonColor;
  final Widget Function(dynamic item) detailFlowBuilder;
  final int childId;
  final int? Function(dynamic item, int index)? resolveLessonId;

  const JourneymapPage({
    super.key,
    required this.journeyData,
    required this.backgroundColor,
    required this.nodeButtonColor,
    required this.detailFlowBuilder,
    this.childId = 0,
    this.resolveLessonId,
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
      if (widget.childId > 0 && widget.resolveLessonId != null) {
        final lessonId = widget.resolveLessonId!(currentStep, index);
        if (lessonId != null) {
          await completeLessonForChild(
            childId: widget.childId,
            lessonId: lessonId,
          );
        }
      }
      if (!mounted) return;
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
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  widget.backgroundColor,
                  widget.backgroundColor.withOpacity(0.3),
                ],
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: -30,
            child: Opacity(
              opacity: 0.1,
              child: Icon(
                Icons.bakery_dining_rounded,
                size: 150,
                color: Colors.black,
              ),
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
                color: Colors.black,
              ),
            ),
          ),
          ListView.builder(
            padding: const EdgeInsets.only(top: 240, bottom: 120),
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
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/Characters/study-boy.gif',
              height: 150,
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            top: 50,
            left: 20,
            child: SafeArea(
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black87),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}