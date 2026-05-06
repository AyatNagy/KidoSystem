import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:kido/Pages/Logo_Page.dart';
import 'package:kido/Pages/content/sizes/size_intro_page.dart';
import 'package:kido/Pages/level2/puzzel/puzzel-practice_page.dart';
import 'package:kido/Widgets/responsive_provider.dart';
import 'package:kido/config/responsive_config.dart';
import 'package:kido/Widgets/info_widget.dart';
import 'package:kido/data/level2/puzzel_data.dart';
import 'package:kido/enum/size_goal.dart';

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
            home: PuzzlePracticeScreen(
              puzzleData: puzzleLevel1, // 👈 جربي أول ليفل
            ),
          ),
        );
      },
    );
  }
}
