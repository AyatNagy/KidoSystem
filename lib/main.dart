import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'Pages/Logo_Page.dart';
import 'Widgets/info_widget.dart';
import 'Widgets/ResponsiveProvider.dart';
import 'config/ResponsiveConfig.dart';

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
            home: Logo(),
          ),
        );
      },
    );
  }
}
