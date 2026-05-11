import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
<<<<<<< HEAD
=======
import 'package:kido/Pages/Auth/parent_login_screen.dart';
import 'package:kido/Pages/content/level1/level1_home.dart';
import 'package:kido/Pages/content/level2/level2home.dart';
import 'package:kido/Pages/content/level3/level3_home.dart';
import 'package:kido/Pages/kid/exam_screen.dart';
>>>>>>> homelevels
import 'Pages/shared/logo_page.dart';
import 'Widgets/info_widget.dart';
import 'Widgets/responsive_provider.dart';
import 'config/responsive_config.dart';

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
            home: const Logo(),
=======
            home: const ExamSkeletonScreen(examId: "exam2", childName: "sara"),
>>>>>>> homelevels
          ),
        );
      },
    );
  }
}
