import 'package:flutter/material.dart';
import '../config/ResponsiveConfig.dart';

class ResponsiveProvider extends InheritedWidget {
  final ResponsiveConfig config;

  const ResponsiveProvider({
    Key? key,
    required this.config,
    required Widget child,
  }) : super(key: key, child: child);

  static ResponsiveConfig of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<ResponsiveProvider>();
    assert(provider != null, 'No ResponsiveProvider found in context');
    return provider!.config;
  }

  @override
  bool updateShouldNotify(covariant ResponsiveProvider oldWidget) => config != oldWidget.config;
}
