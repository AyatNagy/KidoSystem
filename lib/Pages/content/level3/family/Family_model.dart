const String familyGif = 'assets/gif/family.gif';
const String familyGrandfather = 'assets/images/family/Grandfather.png';
const String familyGrandmother = 'assets/images/family/grandmother.png';
const String familyFather = 'assets/images/family/father.png';
const String familyMother = 'assets/images/family/mother.png';
const String familyBrother = 'assets/images/family/brother-Photoroom.png';
const String familySister = 'assets/images/family/sister.png';
const String familySongIcon = 'assets/images/family/song_icon.png';
const String familyTreeIcon = 'assets/images/family/tree_icon.png';

// ─────────────────────────────────────────────────────────────
class FamilyModel {
  final String image;
  final String nameEn;
  final String nameAr;
  final String ttsText;

  const FamilyModel({
    required this.image,
    required this.nameEn,
    required this.nameAr,
    required this.ttsText,
  });
}

class FamilyQuestion {
  final Map<String, bool> answer;
  FamilyQuestion(this.answer);
}

List<FamilyModel> familyList() => [
  const FamilyModel(
    image: familyGrandfather,
    nameEn: 'Grandfather',
    nameAr: 'جد',
    ttsText: 'Grandfather',
  ),
  const FamilyModel(
    image: familyGrandmother,
    nameEn: 'Grandmother',
    nameAr: 'جدة',
    ttsText: 'Grandmother',
  ),
  const FamilyModel(
    image: familyFather,
    nameEn: 'Father',
    nameAr: 'أب',
    ttsText: 'Father',
  ),
  const FamilyModel(
    image: familyMother,
    nameEn: 'Mother',
    nameAr: 'أم',
    ttsText: 'Mother',
  ),
  const FamilyModel(
    image: familyBrother,
    nameEn: 'Brother',
    nameAr: 'أخ',
    ttsText: 'Brother',
  ),
  const FamilyModel(
    image: familySister,
    nameEn: 'Sister',
    nameAr: 'أخت',
    ttsText: 'Sister',
  ),
];

List<FamilyQuestion> familyQuizQuestions = [
  FamilyQuestion({
    familyGrandfather: true,
    familyFather: false,
    familyBrother: false,
    familyGrandmother: false,
  }),
  FamilyQuestion({
    familyMother: false,
    familyGrandmother: true,
    familySister: false,
    familyGrandfather: false,
  }),
  FamilyQuestion({
    familyBrother: false,
    familyGrandfather: false,
    familyFather: true,
    familyMother: false,
  }),
  FamilyQuestion({
    familyMother: true,
    familySister: false,
    familyGrandmother: false,
    familyBrother: false,
  }),
  FamilyQuestion({
    familySister: false,
    familyFather: false,
    familyGrandfather: false,
    familyBrother: true,
  }),
  FamilyQuestion({
    familyMother: false,
    familySister: true,
    familyGrandmother: false,
    familyBrother: false,
  }),
];

List<FamilyQuestion> familySongQuestions = [
  FamilyQuestion({
    familyGrandfather: true,
    familyFather: false,
    familyBrother: false,
    familyGrandmother: false,
  }),
  FamilyQuestion({
    familyMother: false,
    familyGrandmother: true,
    familySister: false,
    familyGrandfather: false,
  }),
  FamilyQuestion({
    familyBrother: false,
    familyGrandfather: false,
    familyFather: true,
    familyMother: false,
  }),
  FamilyQuestion({
    familyMother: true,
    familySister: false,
    familyGrandmother: false,
    familyBrother: false,
  }),
  FamilyQuestion({
    familySister: false,
    familyFather: false,
    familyGrandfather: false,
    familyBrother: true,
  }),
  FamilyQuestion({
    familyMother: false,
    familySister: true,
    familyGrandmother: false,
    familyBrother: false,
  }),
];
