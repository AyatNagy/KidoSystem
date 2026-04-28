import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
<<<<<<< HEAD
import 'package:kido/Pages/content/senses/sense_learning_page.dart';
//import 'package:kido/Pages/content/sizes/size_intro_page.dart';
import 'package:kido/Widgets/responsive_provider.dart';
import 'package:kido/config/responsive_config.dart';
import 'package:kido/enum/sense_type.dart';
//import 'package:kido/enum/size_goal.dart';
//import 'Pages/Logo_Page.dart';
=======
import 'package:kido/Pages/level3/level3_home.dart';
import 'package:kido/Widgets/responsive_provider.dart';
import 'package:kido/config/responsive_config.dart';
import 'Pages/Logo_Page.dart';
>>>>>>> origin/main
import 'Widgets/info_widget.dart';


void main() {
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
            home: SenseLearningScreen(type: SenseType.eyes),
=======
            home: Level3Home(childName: "Girl"),
>>>>>>> origin/main
          ),
        );
      },
    );
  }
}
