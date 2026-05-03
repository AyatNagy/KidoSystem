import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:device_preview/device_preview.dart';
<<<<<<< Updated upstream
import 'package:kido/Pages/content/sizes/size_intro_page.dart';
import 'package:kido/Pages/level3/level3_home.dart';
import 'package:kido/Widgets/responsive_provider.dart';
import 'package:kido/config/responsive_config.dart';
import 'package:kido/enum/sense_type.dart';
import 'package:kido/enum/size_goal.dart';
//import 'Pages/Logo_Page.dart';
=======
import 'package:audioplayers/audioplayers.dart';
import 'package:kido/Pages/level3/family_members/BackgroundPage.dart';
import 'package:kido/Pages/level3/level3_home.dart';
import 'package:kido/Widgets/responsive_provider.dart';
import 'package:kido/config/responsive_config.dart';
import 'package:kido/Widgets/info_widget.dart';
>>>>>>> Stashed changes

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

<<<<<<< Updated upstream
void main() {
  runApp(DevicePreview(enabled: true, builder: (context) => const MyApp()));
=======
  runApp(
    DevicePreview(
      enabled: true, // ✅ كانت false
      builder: (context) => const MyApp(),
    ),
  );
>>>>>>> Stashed changes
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return InfoWidget(
      builder: (context, deviceInfo) {
        return ResponsiveProvider(
          config: ResponsiveConfig(deviceInfo),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            builder: DevicePreview.appBuilder,
            locale: DevicePreview.locale(context),
<<<<<<< Updated upstream
            home: const SizeIntroPage(goal: SizeGoal.longShort),

            //SenseTapPracticeScreen(type: SenseType.ears),
=======
            home: const Level3Home(childName: "Ayat"),
>>>>>>> Stashed changes
          ),
        );
      },
    );
  }
}
