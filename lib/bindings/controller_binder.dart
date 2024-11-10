import 'package:get/get.dart';
import 'package:task_manager/ui/controllers/forgot_password_otp_controller.dart';
import 'package:task_manager/ui/controllers/reset_password_controller.dart';
import 'package:task_manager/ui/controllers/sign_in_controller.dart';
import 'package:task_manager/ui/controllers/sign_up_controller.dart';

import '../ui/controllers/forgot_email_controller.dart';

class ControllerBinders extends Bindings{
  @override
  void dependencies() {
    Get.put(SignInController());
    Get.put(SignUpController());
    Get.put(ForgotEmailController());
    Get.put(ForgotPasswordOtpController());
    Get.put(ResetPasswordController());

  }

}