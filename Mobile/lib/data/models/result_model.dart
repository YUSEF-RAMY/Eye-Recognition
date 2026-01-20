class ResultModel {
  final String name;
  final String bestScore;
  final String image;

  ResultModel({required this.name, required this.bestScore, required this.image});

  factory ResultModel.fromjson(Map<String, dynamic> json) {
    return ResultModel(
      name: json['name'],
      bestScore: json['best_score'],
      image: json['image'],
    );
  }
}
