import 'package:flutter/material.dart';
import '../functions/get_device_type.dart';
import '../Models/device_info.dart';

class InfoWidget extends StatelessWidget {
  final Widget Function(BuildContext context, DeviceInfo deviceInfo) builder;

  const InfoWidget({Key? key, required this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {

        var mediaQueryData = MediaQuery.of(context);

        var deviceInfo = DeviceInfo(
          orientation: mediaQueryData.orientation,
          deviceType: getDeviceType(mediaQueryData),
          screenWidth: mediaQueryData.size.width,
          screenHeight: mediaQueryData.size.height,
          localHeight: constraints.maxHeight,
          localWidth: constraints.maxWidth,
        );

        return builder(context, deviceInfo);
      },
    );
  }
}
