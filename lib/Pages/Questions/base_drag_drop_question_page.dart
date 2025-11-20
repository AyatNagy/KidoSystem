import 'package:flutter/material.dart';
import '../../Models/Question/question.dart';
import '../../Models/Question/question_result.dart';
import '../../Controllers/drag_drop_question_controller.dart';
import '../../Widgets/Questions/draggable_question_item.dart';
import '../../Widgets/Questions/drop_target_box.dart';
import '../../Widgets/Questions/question_submit_button.dart';
import '../../Widgets/ResponsiveProvider.dart';

class BaseDragDropQuestionPage extends StatefulWidget {
  final Question question;
  final Function(QuestionResult) onResult;

  const BaseDragDropQuestionPage({
    super.key,
    required this.question,
    required this.onResult,
  });

  @override
  State<BaseDragDropQuestionPage> createState() =>
      _BaseDragDropQuestionPageState();
}

class _BaseDragDropQuestionPageState extends State<BaseDragDropQuestionPage> {
  late DragDropQuestionController _controller;

  @override
  void initState() {
    super.initState();
    _controller = DragDropQuestionController(question: widget.question);
    _controller.addListener(_onControllerChanged);
  }

  void _onControllerChanged() => setState(() {});

  void _handleSubmit() {
    if (!_controller.areAllItemsPlaced) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please place all items in the boxes"),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final result = _controller.calculateResult();
    widget.onResult(result);
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final config = ResponsiveProvider.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.question.title),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: config.pagePadding,
          child: Column(
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children:
                    widget.question.groups.map((group) {
                      return DropTargetBox(
                        group: group,
                        items: _controller.getItemsInGroup(group.id),
                        onItemDropped:
                            (item) =>
                                _controller.moveItemToGroup(item.id, group.id),
                      );
                    }).toList(),
              ),
              const SizedBox(height: 40),
              // العناصر المتاحة
              Expanded(
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    alignment: WrapAlignment.center,
                    children:
                        _controller.availableItems
                            .map((item) => DraggableQuestionItem(item: item))
                            .toList(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              QuestionSubmitButton(
                onPressed: _handleSubmit,
                isEnabled: _controller.areAllItemsPlaced,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
