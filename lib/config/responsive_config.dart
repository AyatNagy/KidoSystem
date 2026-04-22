import 'package:flutter/material.dart';
import '../enum/device_type.dart';
import '../Models/device_info.dart';

class ResponsiveConfig {
  final DeviceInfo deviceInfo;

  ResponsiveConfig(this.deviceInfo);

  // Device type
  bool get isMobile => deviceInfo.deviceType == DeviceType.mobile;
  bool get isTablet => deviceInfo.deviceType == DeviceType.tablet;
  bool get isDesktop => deviceInfo.deviceType == DeviceType.desktop;

  //font sizes
  double get headline =>
      isDesktop
          ? 36
          : isTablet
          ? 32
          : 28;
  double get title =>
      isDesktop
          ? 30
          : isTablet
          ? 26
          : 22;
  double get body =>
      isDesktop
          ? 20
          : isTablet
          ? 18
          : 16;

  // Standardized button sizes
  double get buttonHeight =>
      isDesktop
          ? 70
          : isTablet
          ? 64
          : 56;
  double get buttonFont =>
      isDesktop
          ? 32
          : isTablet
          ? 28
          : 24;

  // Standardized image sizes based on a factor
  double imageWidth(double factor) => deviceInfo.localWidth * factor;
  double imageHeight(double factor) => deviceInfo.localHeight * factor;

  // Standard paddings
  EdgeInsets get pagePadding => EdgeInsets.symmetric(
    horizontal: deviceInfo.localWidth * 0.05,
    vertical: deviceInfo.localHeight * 0.02,
  );

  // Expose localWidth and localHeight
  double get localWidth => deviceInfo.localWidth;
  double get localHeight => deviceInfo.localHeight;
}
