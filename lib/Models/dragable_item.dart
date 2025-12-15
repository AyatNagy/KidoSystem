import 'dart:ui';

class DragItem {
  final String id;
  final String image;
  final Offset startPosition;
  final Size size;

  DragItem({
    required this.id,
    required this.image,
    required this.startPosition,
    required this.size,
  });
}
