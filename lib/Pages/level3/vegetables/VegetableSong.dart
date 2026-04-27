import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:audioplayers/audioplayers.dart'; // مكتبة تشغيل الأصوات
import 'Vegetablemodel.dart';

class VegetableSong extends StatefulWidget {
  const VegetableSong({super.key});

  @override
  State<VegetableSong> createState() => _VegetableSongState();
}

class _VegetableSongState extends State<VegetableSong> {
  final FlutterTts flutterTts = FlutterTts();
  final AudioPlayer audioPlayer = AudioPlayer(); // لتشغيل الملفات المسجلة
  final PageController _controller = PageController(initialPage: 0);

  bool isPressed = false;
  int score = 0;

  // ألوان مبهجة ومريحة للطفل
  final Color primaryColor = const Color(0xFFFF9800); // برتقالي دافئ
  final Color backgroundColor = const Color(0xFFFDFCF0); // كريمي فاتح جداً

  @override
  void dispose() {
    _controller.dispose();
    audioPlayer.dispose();
    super.dispose();
  }

  // دالة تشغيل الصوت المسجل
  void playVoice(String path) async {
    await audioPlayer.play(AssetSource(path));
  }

  @override
  Widget build(BuildContext context) {
    List<Numbermodel> vegetablelist = vegetable1();

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'لعبة الخضروات',
          style: TextStyle(
            color: Colors.black,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: PageView.builder(
        controller: _controller,
        onPageChanged: (page) => setState(() => isPressed = false),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: vegitablesongs2.length,
        itemBuilder: (context, index) {
          var currentQuestion = vegitablesongs2[index];
          var currentVeg = vegetablelist[index];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                // كارت السؤال العلوي
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                    border: Border.all(
                      color: primaryColor.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        currentVeg.textAr,
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      Text(
                        currentVeg.Text,
                        style: const TextStyle(
                          fontSize: 22,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // منطقة الاختيارات (الصور)
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 25,
                    mainAxisSpacing: 25,
                    childAspectRatio: 1,
                  ),
                  itemCount: currentQuestion.answer.length,
                  itemBuilder: (context, i) {
                    String imagePath = currentQuestion.answer.keys.elementAt(i);
                    bool isCorrect = currentQuestion.answer.values.elementAt(i);

                    return InkWell(
                      onTap:
                          isPressed
                              ? null
                              : () {
                                setState(() {
                                  isPressed = true;
                                  if (isCorrect) {
                                    score++;
                                    // تشغيل صوت "صح" (سيتم شرح التركيب بالأسفل)
                                    // playVoice('sounds/correct.mp3');
                                    MotionToast.success(
                                      description: const Text("ممتاز يا بطل!"),
                                    ).show(context);
                                  } else {
                                    // playVoice('sounds/wrong.mp3');
                                    MotionToast.error(
                                      description: const Text("حاول مرة أخرى"),
                                    ).show(context);
                                  }
                                });
                              },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color:
                                isPressed
                                    ? (isCorrect ? Colors.green : Colors.red)
                                    : Colors.grey.withOpacity(0.2),
                            width: 4,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  isPressed
                                      ? (isCorrect
                                          ? Colors.green.withOpacity(0.3)
                                          : Colors.red.withOpacity(0.3))
                                      : Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Image.asset(imagePath, fit: BoxFit.contain),
                        ),
                      ),
                    );
                  },
                ),

                const Spacer(),

                // أزرار التحكم السفلية
                Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildNavButton(
                        icon: Icons.arrow_back_rounded,
                        onTap:
                            index == 0
                                ? null
                                : () => _controller.previousPage(
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                ),
                      ),

                      // زر الصوت الكبير
                      GestureDetector(
                        onTap: () {
                          // هنا تشغلي صوتك المسجل بدلاً من الـ TTS
                          // playVoice(currentVeg.voicePath);
                          flutterTts.speak(currentVeg.Text);
                        },
                        child: Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            color: primaryColor,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: primaryColor.withOpacity(0.4),
                                blurRadius: 15,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.volume_up_rounded,
                            color: Colors.white,
                            size: 45,
                          ),
                        ),
                      ),

                      _buildNavButton(
                        icon: Icons.arrow_forward_rounded,
                        onTap:
                            !isPressed
                                ? null
                                : () {
                                  if (index + 1 < vegitablesongs2.length) {
                                    _controller.nextPage(
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    );
                                  }
                                },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildNavButton({required IconData icon, VoidCallback? onTap}) {
    return CircleAvatar(
      radius: 28,
      backgroundColor: onTap == null ? Colors.grey[300] : Colors.white,
      child: IconButton(
        icon: Icon(
          icon,
          color: onTap == null ? Colors.grey : primaryColor,
          size: 30,
        ),
        onPressed: onTap,
      ),
    );
  }
}
