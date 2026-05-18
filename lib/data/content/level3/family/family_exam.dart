import '../../../../Pages/content/level3/family_members/family_exam.dart';

final List<FamilyMember> familyMembers = [
  FamilyMember(
    name: 'Father',
    nameAr: 'الأب',
    image: 'assets/images/family_members/father-removebg-preview.png',
    sound: 'assets/audio/family/baba.mp3',
  ),
  FamilyMember(
    name: 'Mother',
    nameAr: 'الأم',
    image: 'assets/images/family_members/mother-removebg-preview.png',
    sound: 'assets/audio/family/mama.mp3',
  ),
  FamilyMember(
    name: 'Brother',
    nameAr: 'الأخ',
    image: 'assets/images/family_members/brother-removebg-preview.png',
    sound: 'assets/audio/family/brother_1.mp3',
  ),
  FamilyMember(
    name: 'Sister',
    nameAr: 'الأخت',
    image: 'assets/images/family_members/sister-removebg-preview.png',
    sound: 'assets/audio/family/sister_1.mp3',
  ),
  FamilyMember(
    name: 'GrandFather',
    nameAr: 'الجد',
    image: 'assets/images/family_members/grandfather-removebg-preview.png',
    sound: 'assets/audio/family/grandfather_1.mp3',
  ),
  FamilyMember(
    name: 'GrandMother',
    nameAr: 'الجدة',
    image: 'assets/images/family_members/grandmother-removebg-preview.png',
    sound: 'assets/audio/family/grandmother_1.mp3',
  ),
];
final List<FamilyQuestion> familyQuestions = [
  FamilyQuestion(
    answers: {
      'assets/images/family_members/father-removebg-preview.png': true,
      'assets/images/family_members/mother-removebg-preview.png': false,
    },
  ),
  FamilyQuestion(
    answers: {
      'assets/images/family_members/mother-removebg-preview.png': true,
      'assets/images/family_members/father-removebg-preview.png': false,
    },
  ),
  FamilyQuestion(
    answers: {
      'assets/images/family_members/brother-removebg-preview.png': true,
      'assets/images/family_members/sister-removebg-preview.png': false,
    },
  ),

  FamilyQuestion(
    answers: {
      'assets/images/family_members/sister-removebg-preview.png': true,
      'assets/images/family_members/brother-removebg-preview.png': false,
    },
  ),
];