import 'package:dio/dio.dart';
    const url = 'https://connect.sumonsheikh.dev/api/auth/login';
class ApiService {
  final Dio _dio = Dio();

  ApiService() {
    _dio.options.headers = {
      'Content-Type': 'application/json',
    };
  }

  Future<Response> login(String number, String fcmToken) async {


    final data = {
      "number": number,
      "fcmToken": fcmToken,
    };

    try {
      return await _dio.post(url, data: data);
    } on DioError catch (e) {
      throw Exception(e.response?.data ?? 'Login request failed');
    }
  }
}
