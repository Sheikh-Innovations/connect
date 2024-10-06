import 'package:connect/data/models/user_model.dart';
import 'package:connect/data/providers/api_service.dart';
import 'package:dio/dio.dart';

class AuthRepository {
  final ApiService apiService;

  AuthRepository(this.apiService);

  Future<UserModel> login(String phoneNumber, String fcmToken) async {
    try {
      Response response = await apiService.login(phoneNumber, fcmToken);
      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
      rethrow;
    }
  }
}
