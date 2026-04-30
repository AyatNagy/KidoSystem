import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:kido/Pages/Logo_Page.dart';
//import 'package:kido/Pages/content/senses/sense_drag_practice_page.dart';
import 'package:kido/Pages/content/senses/sense_tap_practice_page.dart';
import 'package:kido/Pages/level3/family/Family_map_screen.dart';
//import 'package:kido/Pages/content/senses/sense_learning_page.dart';
//import 'package:kido/Pages/level1/level1_home.dart';
import 'package:kido/Pages/level3/level3_home.dart';
import 'package:kido/Pages/level3/vegetables/vegetable_map_screen.dart';
import 'package:kido/Widgets/responsive_provider.dart';
import 'package:kido/config/responsive_config.dart';
import 'package:kido/enum/sense_type.dart';
//import 'Pages/Logo_Page.dart';

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
            home: Level3Home(childName: "habiba"),
            //SenseTapPracticeScreen(type: SenseType.ears),
          ),
        );
      },
    );
  }
}
