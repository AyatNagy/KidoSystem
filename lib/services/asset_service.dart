import'package:flutter/material.dart';

enum TrainLessonLanguage{english,arabic}
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
  final String basePath='assets/images';
  String get commonBasePath=>'$basePath/common';
  String get trainEnginePath=>'$commonBasePath/train_engine.png';
  String get trainRailwayPath=>'$commonBasePath/train_railway.png';
  String get trainBackgroundPath=>'$commonBasePath/train_background.png';
  String getNumbersPath(TrainLessonLanguage language)=> language==TrainLessonLanguage.arabic
                                                      ?'$basePath/arabicNumbers'
                                                      :'$basePath/englishNumbers';
 
  List<String> carRange(int count,TrainLessonLanguage language){
    return List.generate(count, (index)=>car(language,index+1),);
  }
  String car(TrainLessonLanguage language,int num)=>'${getNumbersPath(language)}/train_car_$num.png';


}