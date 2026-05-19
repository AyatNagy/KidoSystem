import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kido/Widgets/app_lifecycle_watcher.dart';
import 'package:kido/bloc/assessment/assessment_cubit.dart';
import 'Pages/shared/logo_page.dart';
import 'Widgets/info_widget.dart';
import 'Widgets/responsive_provider.dart';
import 'config/responsive_config.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  PaintingBinding.instance.imageCache.maximumSize = 200;
  PaintingBinding.instance.imageCache.maximumSizeBytes = 50 * 1024 * 1024;

  runApp(const AppLifecycleWatcher(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DevicePreview(
      enabled: true,
      builder:
          (context) => MultiBlocProvider(
            providers: [
              BlocProvider<AssessmentCubit>(create: (_) => AssessmentCubit()),
            ],
            child: InfoWidget(
              builder: (context, deviceInfo) {
                return ResponsiveProvider(
                  config: ResponsiveConfig(deviceInfo),
                  child: MaterialApp(
                    debugShowCheckedModeBanner: false,
                    builder: DevicePreview.appBuilder,
                    locale: DevicePreview.locale(context),
                    home: const Logo(),
                  ),
                );
              },
            ),
          ),
    );
  }
}
