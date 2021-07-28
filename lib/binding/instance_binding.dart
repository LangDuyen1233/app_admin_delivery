import 'package:app_delivery/controllers/auth_controller.dart';
import 'package:app_delivery/controllers/category/category_controller.dart';
import 'package:app_delivery/controllers/profile_controller.dart';
import 'package:get/get.dart';

class InstanceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
    Get.lazyPut<ProfileController>(() => ProfileController());
    Get.lazyPut<CategoryController>(() => CategoryController());
  }
}
