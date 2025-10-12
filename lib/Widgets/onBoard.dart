import 'package:flutter/material.dart';
import 'package:kido/Models/OnboardModel.dart';

class OnboardPage extends StatelessWidget {
  final OnboardModel data;

  const OnboardPage({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.06,
        vertical: height * 0.04,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset('assets/images/log.png',
                  height: height * 0.06, width: width * 0.12),
              SizedBox(width: width * 0.02),
              Image.asset('assets/images/Kido.png', height: height * 0.05),
            ],
          ),
          SizedBox(height: height * 0.02),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  data.image,
                  height: height * 0.3,
                  width: width * 0.8,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: height * 0.04),

             
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                  child: Text(
                    data.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: width * 0.07, 
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF8869B3),
                    ),
                  ),
                ),
                SizedBox(height: height * 0.02),

                Flexible(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                    child: SingleChildScrollView( 
                      child: Text(
                        data.desc,
                        textAlign: TextAlign.center,
                        style: TextStyle(

                    fontSize: 20,
                    shadows: [
                      Shadow(
                        offset: Offset(3, 3),
                        blurRadius: 3,
                        color: Colors.grey,
                      ),
                    ],
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    height: 1.3,
                  ), 
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis, 
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}