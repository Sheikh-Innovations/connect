import 'package:connect/data/providers/hive_service.dart';
import 'package:connect/utils/consts/api_const.dart';
import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio();

  ApiService() {
    _dio.options.headers = {
      'Content-Type': 'application/json',
    };
  }

  Future<Response> login(String number, String fcmToken) async {
    final data = {"number": number, "fcmToken": fcmToken};
    try {
      return await _dio.post(ApiConst.login, data: data);
    } on DioException catch (e) {
      throw Exception(e.response?.data ?? 'Login request failed');
    }
  }

  Future<Response> addInformation(
    String name,
  ) async {
    final data = {"name": name};

    try {
      return await _dio.put(
        ApiConst.addInfo,
        data: data,
        options: Options(
          headers: {
            'Authorization':
                'Bearer ${HiveService.instance.userData?.token}', // Add JWT token in Authorization header
          },
        ),
      );
    } on DioException catch (e) {
      throw Exception(e.response?.data ?? 'Request failed');
    }
  }

  Future<Response> availableContacts(
    List<String> phoneContactNumbers,
  ) async {
    final data = {"phoneNumbers": phoneContactNumbers};

    try {
      return await _dio.post(
        ApiConst.availableContact,
        data: data,
        // options: Options(
        //   headers: {
        //     'Authorization':
        //         'Bearer ${HiveService.instance.userData?.token}', // Add JWT token in Authorization header
        //   },
        // ),
      );
    } on DioException catch (e) {
      throw Exception(e.response?.data ?? 'Request failed');
    }
  }
}
