import 'package:flutter/material.dart';
import 'package:kido/Models/OnboardModel.dart';
import '../Widgets/ResponsiveProvider.dart';
import 'appBar.dart';

class OnboardPage extends StatelessWidget {
  final OnboardModel data;

  const OnboardPage({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveProvider.of(context);

    return Scaffold(
      appBar: const KidoAppBar(),
      backgroundColor: Colors.white,

      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: responsive.localWidth * 0.06,
          vertical: responsive.localHeight * 0.04,
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    data.image,
                    height: responsive.localHeight * 0.30,
                    width: responsive.localWidth * 0.80,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: responsive.localHeight * 0.04),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: responsive.localWidth * 0.05,
                    ),
                    child: Text(
                      data.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: responsive.localWidth * 0.07,
                        fontWeight: FontWeight.bold,
                        color: data.color,
                      ),
                    ),
                  ),
                  SizedBox(height: responsive.localHeight * 0.02),
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: responsive.localWidth * 0.05,
                      ),
                      child: SingleChildScrollView(
                        child: Text(
                          data.desc,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: responsive.body * 1.2,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            height: 1.3,
                            shadows: const [
                              Shadow(
                                offset: Offset(3, 3),
                                blurRadius: 3,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
