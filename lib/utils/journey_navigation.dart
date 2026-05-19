import 'package:flutter/material.dart';

/// Pops lesson screens and returns [true] to [JourneymapPage]'s `Navigator.push`.
void finishJourneyNode(BuildContext context, {required int screensAboveMap}) {
  final navigator = Navigator.of(context);
  for (var i = 0; i < screensAboveMap; i++) {
    navigator.pop();
  }
  navigator.pop(true);
}
