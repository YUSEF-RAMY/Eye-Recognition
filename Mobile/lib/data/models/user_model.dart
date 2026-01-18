class UserModel {
  final String name;
  final String email;
  final String image;

  UserModel({required this.name, required this.email, required this.image});

  factory UserModel.fromjson(Map<String, dynamic> json) {
    return UserModel(
      name: json['data']['name'],
      email: json['data']['email'],
      image: json['data']['image'],
    );
  }
}
