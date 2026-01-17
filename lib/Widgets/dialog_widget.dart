import 'dart:ui';
import 'package:flutter/material.dart';
import '../Models/dailogModel.dart';
import 'ResponsiveProvider.dart';

void CustomDialog(BuildContext context, dialogModel data,
    {required Color titleColor, VoidCallback? onNextPressed}) {
  final config = ResponsiveProvider.of(context);

  showDialog<void>(
    context: context,
    barrierDismissible: onNextPressed == null,
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
                  width: config.localWidth * 0.85,
                  margin: const EdgeInsets.only(top: 60),
                  padding: const EdgeInsets.fromLTRB(20, 70, 20, 25),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        data.title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: titleColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        data.message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black54,
                          height: 1.4,
                        ),
                      ),
                      if (onNextPressed != null) ...[
                        const SizedBox(height: 25),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                            onNextPressed();
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  titleColor,
                                  titleColor.withOpacity(0.7),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: titleColor.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                )
                              ],
                            ),
                            child: const Text(
                              "Start Level Test",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Positioned(
                  top: 0,
                  child: Image.asset(
                    data.image,
                    width: 140,
                    height: 140,
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

  if (onNextPressed == null) {
    Future.delayed(const Duration(seconds: 4), () {
      if (Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }
    });
  }
}