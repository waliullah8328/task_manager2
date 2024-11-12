import 'dart:async';
import 'package:get/get.dart';
import '../../data/routes/route_name.dart';
import 'auth_controller.dart';

class SplashController extends GetxController {


  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  void startTimer() {
    Timer(const Duration(seconds: 30), () async {
      await AuthController.getAccessToken(); // For get Token

      if (AuthController.isLogin()) {
        await AuthController.getUserData();
        Get.offAllNamed(RouteName.mainBottomScreen);
      } else {
        Get.offAllNamed(RouteName.loginScreen);
      }
    });
  }


}
