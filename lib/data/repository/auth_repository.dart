import 'package:connect/data/models/remote/available_user.dart';
import 'package:connect/data/models/remote/user_response.dart';
import 'package:connect/data/providers/api_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class AuthRepository {
  final ApiService apiService;

  AuthRepository(this.apiService);

  Future<LoginResponse> login(String phoneNumber, String fcmToken) async {
    try {
      Response response = await apiService.login(phoneNumber, fcmToken);
      if (response.statusCode == 200) {
        print(response.data);
        return LoginResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<LoginResponse> addInformation(String name) async {
    try {
      Response response = await apiService.addInformation(name);
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print(response.data);
        }
        return LoginResponse.fromJson(response.data);
      } else {
        throw Exception('Request Failed');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<AvailableContacts> availableContacts(
      List<String> phoneContactNumbers) async {
    try {
      Response response =
          await apiService.availableContacts(phoneContactNumbers);
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print(response.data);
        }
        return AvailableContacts.fromJson(response.data);
      } else {
        throw Exception('Request Failed');
      }
    } catch (e) {
      rethrow;
    }
  }
}
