import 'dart:math';

import 'package:connect/data/models/remote/available_user.dart';
import 'package:connect/data/providers/hive_service.dart';
import 'package:connect/data/repository/auth_repository.dart';
import 'package:connect/modules/auth/views/add_information.dart';
import 'package:connect/screens/home_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

import 'package:get/get.dart';

import '../../../data/models/remote/user_response.dart';

class AuthController extends GetxController implements GetxService {
  final AuthRepository authRepository;

  AuthController(this.authRepository);

  final Rxn<LoginResponse> user = Rxn<LoginResponse>();

  final Rxn<AvailableContacts> contacts = Rxn<AvailableContacts>();
  final RxBool isLoading = false.obs;

  var phoneNumber = ''.obs;
  var name = ''.obs;
  final formKey = GlobalKey<FormState>();
  Future<void> loginUser(String phoneNumber, String fcmToken) async {
    try {
      isLoading.value = true;
      update();
      user.value = await authRepository.login(phoneNumber, fcmToken);
      HiveService.instance.saveUserData(user.value!.data.toHiveData());
      isLoading.value = false;
      if (user.value?.data.name == null && user.value!.flag) {
        Get.to(AddDetailScreen());
      } else {
        Get.offAll(const HomeScreen());
      }
      update();
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> updateProfile(String name) async {
    try {
      isLoading.value = true;
      update();
      user.value = await authRepository.addInformation(name);
      HiveService.instance.saveUserData(user.value!.data.toHiveData());
      isLoading.value = false;
      update();

      if (user.value?.data.name != null) {
        Get.offAll(const HomeScreen());
      }
    } catch (e) {
      isLoading.value = false;
      update();
      Get.snackbar('Error', e.toString());
    }
  }

  // Function to validate the form
  bool validateForm() {
    return formKey.currentState?.validate() ?? false;
  }

  String generateRandomString(int length) {
    const String chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random random = Random();
    return List.generate(length, (index) => chars[random.nextInt(chars.length)])
        .join();
  }

  // Function to handle login button press
  void login() {
    if (validateForm()) {
      loginUser(phoneNumber.value, generateRandomString(20));
    }
  }

  // Function to update the phone number
  void updatePhoneNumber(String number) {
    phoneNumber.value = number;
  }

  void updateName(String value) {
    name.value = value;
  }

  Future<void> availableContacts() async {
    try {
      isLoading.value = true;
      update();
      final phonCont = await fetchPhoneContacts();

      contacts.value = await authRepository.availableContacts(phonCont);

      isLoading.value = false;
      update();
    } catch (e) {
      isLoading.value = false;
      update();
      Get.snackbar('Error', e.toString());
    }
  }

  fetchPhoneContacts() async {
    bool permissionGranted = await FlutterContacts.requestPermission();
    if (!permissionGranted) Get.back();
    Iterable<Contact> contacts =
        await FlutterContacts.getContacts(withProperties: true);

    // Extract phone numbers from contacts
    List<String> numbers = contacts
        .expand((contact) => contact.phones.map((phone) => phone.number))
        .toList();
    print(numbers);
    return numbers;
  }
}
