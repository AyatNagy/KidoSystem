import 'package:flutter/material.dart';
import '../services/audio_service.dart';

class AppLifecycleWatcher extends StatefulWidget {
  final Widget child;
  const AppLifecycleWatcher({super.key, required this.child});

  @override
  State<AppLifecycleWatcher> createState() => _AppLifecycleWatcherState();
}

class _AppLifecycleWatcherState extends State<AppLifecycleWatcher>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      AudioService.pauseOnLeave();
    } else if (state == AppLifecycleState.resumed) {
      Future.delayed(const Duration(milliseconds: 150), () {
        AudioService.resumeOnReturn();
      });
    } else if (state == AppLifecycleState.detached) {
      AudioService.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
