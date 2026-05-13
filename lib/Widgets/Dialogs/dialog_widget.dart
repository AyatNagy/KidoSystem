// ignore_for_file: deprecated_member_use

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:kido/Widgets/responsive_provider.dart';
import '../../Models/dailog_model.dart';

void customDialog(
    BuildContext context,
    DailogModel data, {
      required Color titleColor,
      VoidCallback? onNextPressed,
    }) {
  final config = ResponsiveProvider.of(context);

  showDialog<void>(
    context: context,
    barrierDismissible: onNextPressed == null,
    barrierColor: Colors.black.withOpacity(0.4),
    builder: (context) {
      return Center(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Material(
            color: Colors.transparent,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                Container(
                  width: config.localWidth * 0.88,
                  margin: const EdgeInsets.only(top: 50, bottom: 20),
                  padding: const EdgeInsets.fromLTRB(24, 85, 24, 30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(color: titleColor.withOpacity(0.2), width: 4),
                    boxShadow: [
                      BoxShadow(
                        color: titleColor.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                      BoxShadow(
                        color: Colors.grey.shade300,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        data.title.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 26,
                          letterSpacing: 1.2,
                          color: titleColor,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        data.message,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.blueGrey.shade700,
                          height: 1.3,
                        ),
                      ),
                      if (onNextPressed != null) ...[
                        const SizedBox(height: 30),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                            onNextPressed();
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  titleColor.withOpacity(0.9),
                                  titleColor,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.3),
                                  offset: const Offset(0, -4),
                                  blurRadius: 0,
                                ),
                                BoxShadow(
                                  color: titleColor.darken(0.2),
                                  offset: const Offset(0, 6),
                                  blurRadius: 0,
                                ),
                              ],
                            ),
                            child: Text(
                              data.buttonText?.toUpperCase() ?? "LET'S GO!",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 20,
                                letterSpacing: 1.1,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Positioned(
                  top: -20,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 15,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      data.image,
                      width: 150,
                      height: 150,
                      fit: BoxFit.contain,
                    ),
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
      if (context.mounted) {
        if (Navigator.canPop(context)) {
          Navigator.of(context).pop();
        }
      }
    });
  }
}

extension ColorUtils on Color {
  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }
}