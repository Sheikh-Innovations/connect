import 'package:connect/data/providers/api_service.dart';
import 'package:connect/data/repository/auth_repository.dart';
import 'package:connect/modules/auth/controllers/auth_controller.dart';
import 'package:connect/modules/auth/controllers/home_controller.dart';
import 'package:get/get.dart';


class DependencyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ApiService());
    Get.lazyPut(() => AuthRepository(Get.find<ApiService>()));
    Get.lazyPut(() => AuthController(Get.find<AuthRepository>()));
    Get.lazyPut(() => HomeController());
  }
}
