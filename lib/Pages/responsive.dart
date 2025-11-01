import 'package:flutter/material.dart';

enum DeviceType { Mobile, Tablet, Desktop }

DeviceType getDeviceType(MediaQueryData mediaQuery) {
  double width = mediaQuery.size.width;

  if (width >= 1100) {
    return DeviceType.Desktop;
  } else if (width >= 650) {
    return DeviceType.Tablet;
  } else {
    return DeviceType.Mobile;
  }
}