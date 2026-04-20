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
      backgroundColor: widget.backgroundColor,
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 100),
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
    );
  }
}