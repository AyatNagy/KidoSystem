import 'dart:ui';
import 'package:flutter/material.dart';
import '../Models/dailogModel.dart';
import 'ResponsiveProvider.dart';

void CustomDialog(BuildContext context, dialogModel data,
    {required Color titleColor}) {
  final config = ResponsiveProvider.of(context);

  showDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.3),
    builder: (context) {
      return Center(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Material(
            color: Colors.transparent,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                Container(
                  width: config.localWidth * 0.8,
                  margin: const EdgeInsets.only(top: 60),
                  padding: const EdgeInsets.fromLTRB(20, 70, 20, 25),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        data.title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: titleColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        data.message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 0,
                  child: Image.asset(
                    data.image,
                    width: config.imageWidth(0.9),
                    height: 130,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );

  Future.delayed(const Duration(seconds: 4), () {
    if (Navigator.canPop(context)) {
      Navigator.of(context).pop();
    }
  });
}