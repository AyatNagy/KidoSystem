import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:device_preview/device_preview.dart';
<<<<<<< HEAD
import 'package:kido/Pages/content/sizes/size_intro_page.dart';
import 'package:kido/Pages/level1/matching_practice_page.dart';
=======
import 'package:audioplayers/audioplayers.dart';
import 'package:kido/Pages/level3/family_members/FamilyBackGround.dart';
>>>>>>> main
import 'package:kido/Pages/level3/level3_home.dart';
import 'package:kido/Widgets/responsive_provider.dart';
import 'package:kido/config/responsive_config.dart';
import 'package:kido/Widgets/info_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(DevicePreview(enabled: true, builder: (context) => const MyApp()));
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
<<<<<<< HEAD
            home: const MatchingPracticePage(),

            //SenseTapPracticeScreen(type: SenseType.ears),
=======
            home: const FamilyBackGround(),
>>>>>>> main
          ),
        );
      },
    );
  }
}
