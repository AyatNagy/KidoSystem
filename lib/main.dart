import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:kido/Pages/level3/numbers/numbers_train.dart';
import 'package:kido/Widgets/responsive_provider.dart';
import 'package:kido/config/responsive_config.dart';
import 'Pages/Logo_Page.dart';
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
            home: NumbersTrain(phase:1),
          ),
        );
      },
    );
  }
}
