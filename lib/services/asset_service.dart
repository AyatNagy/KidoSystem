import'package:flutter/material.dart';

class AssetService{
  static const Images images=Images();
  static Future<void> warmupAssets(BuildContext context,List<String> paths) async {
  for (String path in paths) {
    await precacheImage(AssetImage(path), context);
  }
  }
}

class Images{
   const Images();
  final String basePath='images';
  String get englishNumbersPath=>'$basePath/englishNumbers';
  String get trainEnginePath=>'$englishNumbersPath/train_engine.png';
  String get trainRailwayPath=>'$englishNumbersPath/train_railway.png';
  String get trainBackgroundPath=>'$englishNumbersPath/train_background.png';
  String car(int num)=>'$englishNumbersPath/train_car_$num.png';
  List<String> carRange(int count)=>
  List.generate(count,(i)=>car(i+1));


}