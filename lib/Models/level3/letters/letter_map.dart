class LetterJourney {
  final String image;
  bool isLocked;
  final dynamic letterData;
  final dynamic dragData;
  final String? charName;

  LetterJourney({
    required this.image,
    required this.isLocked,
    this.letterData,
    this.dragData,
    this.charName = '',
  });
}
