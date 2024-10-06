class UserModel {
  final String id;
  final String phoneNumber;
  final String token;

  UserModel({
    required this.id,
    required this.phoneNumber,
    required this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      phoneNumber: json['number'],
      token: json['token'],
    );
  }
}
