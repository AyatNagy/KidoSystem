const String vBroccoli = "assets/gif/broccli.gif";
const String vCarrot = "assets/gif/carrot.gif";
const String vChili = "assets/gif/chili_pepper.gif";
const String vOnion = "assets/gif/onion.gif";
const String vTomato = "assets/gif/tomato.gif";

class Numbermodel {
  String image;
  String text;
  String textAr;
  Numbermodel({required this.image, required this.text, required this.textAr});
}

class QuestionModel {
  Map<String, bool> answer;
  QuestionModel(this.answer);
}

List<Numbermodel> vegetable1() {
  return [
    Numbermodel(image: vBroccoli, text: "Broccoli", textAr: "بروكلي"),
    Numbermodel(image: vCarrot, text: "Carrot", textAr: "جزر"),
    Numbermodel(image: vChili, text: "Chili pepper", textAr: "فلفل حار"),
    Numbermodel(image: vOnion, text: "Onion", textAr: "بصل"),
    Numbermodel(image: vTomato, text: "Tomato", textAr: "طماطم"),
  ];
}

List<QuestionModel> vegitablesongs2 = [
  // Broccoli
  QuestionModel({vBroccoli: true, vCarrot: false}),

  // Carrot
  QuestionModel({vCarrot: true, vTomato: false}),

  // Chili
  QuestionModel({vChili: true, vOnion: false}),

  // Onion
  QuestionModel({vOnion: true, vBroccoli: false}),

  // Tomato
  QuestionModel({vTomato: true, vCarrot: false}),
];
