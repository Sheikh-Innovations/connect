import 'package:connect/data/models/user_model.dart';
import 'package:connect/data/repository/auth_repository.dart';
import 'package:get/get.dart';


class AuthController extends GetxController {
  final AuthRepository authRepository;

  AuthController(this.authRepository);

  final Rxn<UserModel> user = Rxn<UserModel>();
  final RxBool isLoading = false.obs;

  Future<void> loginUser(String phoneNumber, String fcmToken) async {
    try {
      isLoading.value = true;
      user.value = await authRepository.login(phoneNumber, fcmToken);
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', e.toString());
    }
  }
}
