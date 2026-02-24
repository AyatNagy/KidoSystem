class PlacementExamResult{
  final bool skipExam;
  final int? placementExamId;
  final Level level;
  final int? minAge;
  final int? maxAge; 

  PlacementExamResult({
    required this.skipExam,
    this.placementExamId,
    required this.level,
    this.minAge,
    this.maxAge
  });

  factory PlacementExamResult.fromJson(Map<String,dynamic> json){
    return PlacementExamResult(
      skipExam:json['skipExam'],
      placementExamId: json['placementExamId'],
      minAge: json['minAge'],
      maxAge: json['maxAge'],
      level: Level.fromJson(json['level']),
    );
  }
}

class Level{
  final int id;
  final String name;
  final int order;

  Level({
    required this.id,
    required this.name,
    required this.order
  });

  factory Level.fromJson(Map<String,dynamic> json){
    return Level(
      id: json['id'],
      name: json['name'],
      order: json['order'],

    );
  }
}