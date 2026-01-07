import 'dart:ui';

class DragTargetZone {
  final String id;
  final List<String> acceptedItemIds;
  final Offset position;
  final Size size;
  final String image;

  DragTargetZone({
    required this.id,
    required this.acceptedItemIds,
    required this.position,
    required this.size,
    required this.image,
  });
}
