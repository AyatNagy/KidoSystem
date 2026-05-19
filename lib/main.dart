import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kido/Widgets/app_lifecycle_watcher.dart';
import 'package:kido/bloc/assessment/assessment_cubit.dart';
import 'package:kido/config/app_locale_controller.dart';
import 'package:kido/config/app_locale_scope.dart';
import 'package:kido/l10n/app_localizations.dart';
import 'package:kido/services/daily_notification_service.dart';
import 'Pages/shared/logo_page.dart';
import 'Widgets/info_widget.dart';
import 'Widgets/responsive_provider.dart';
import 'config/responsive_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  PaintingBinding.instance.imageCache.maximumSize = 200;
  PaintingBinding.instance.imageCache.maximumSizeBytes = 50 * 1024 * 1024;

  final localeController = AppLocaleController();
  await localeController.load();
  await DailyNotificationService.initialize();

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => AppLifecycleWatcher(
        child: MyApp(localeController: localeController),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final AppLocaleController localeController;

  const MyApp({super.key, required this.localeController});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: localeController,
      builder: (context, _) {
        return AppLocaleScope(
          controller: localeController,
          child: MultiBlocProvider(
            providers: [
              BlocProvider<AssessmentCubit>(create: (_) => AssessmentCubit()),
            ],
            child: InfoWidget(
              builder: (context, deviceInfo) {
                return ResponsiveProvider(
                  config: ResponsiveConfig(deviceInfo),
                  child: MaterialApp(
                    debugShowCheckedModeBanner: false,
                    locale: localeController.locale,
                    supportedLocales: AppLocalizations.supportedLocales,
                    localizationsDelegates:
                        AppLocalizations.localizationsDelegates,
                    title: 'Kido',
                    builder: (context, child) {
                      final wrapped = Directionality(
                        textDirection: localeController.textDirection,
                        child: child ?? const SizedBox.shrink(),
                      );
                      return DevicePreview.appBuilder(context, wrapped);
                    },
                    home: const Logo(),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
