import 'package:connect/data/models/local/user_data.dart';

class LoginResponse {
  bool flag;
  String msg;
  UserData data;

  LoginResponse({required this.flag, required this.msg, required this.data});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      flag: json['flag'],
      msg: json['msg'],
      data: UserData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'flag': flag,
      'msg': msg,
      'data': data.toJson(),
    };
  }
}

class UserData {
  String id;
  String? name;
  String number;
  String? avater;
  String fcmToken;
  String token;

  UserData({
    required this.id,
    this.name,
    required this.number,
    this.avater,
    required this.fcmToken,
    required this.token,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      name: json['name'],
      number: json['number'],
      avater: json['avater'],
      fcmToken: json['fcmToken'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'number': number,
      'avater': avater,
      'fcmToken': fcmToken,
      'token': token,
    };
  }

  // Conversion method
  UserHiveData toHiveData() {
    return UserHiveData(
      id: id,
      name: name,
      number: number,
      avater: avater,
      fcmToken: fcmToken,
      token: token,
    );
  }

}
