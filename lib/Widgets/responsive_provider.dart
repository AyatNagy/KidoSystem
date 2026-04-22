import 'package:flutter/material.dart';
import '../config/responsive_config.dart';

class ResponsiveProvider extends InheritedWidget {
  final ResponsiveConfig config;

  const ResponsiveProvider({
    super.key,
    required this.config,
    required super.child,
  });

  static ResponsiveConfig of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<ResponsiveProvider>();
    assert(provider != null, 'No ResponsiveProvider found in context');
    return provider!.config;
  }

  @override
  bool updateShouldNotify(covariant ResponsiveProvider oldWidget) =>
      config != oldWidget.config;
}
