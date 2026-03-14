import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:kido/Pages/content/feelings/emotion_page_view.dart';
import 'Pages/Logo_Page.dart';
import 'Pages/level2/no29/lesson2(29).dart';
import 'Pages/level2/no29/lesson3(29).dart';
import 'Widgets/info_widget.dart';
import 'Widgets/ResponsiveProvider.dart';
import 'config/ResponsiveConfig.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => const MyApp(),
    ),
  );
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
            home:  const BallLesson(),
          ),
        );
      },
    );
  }
}
