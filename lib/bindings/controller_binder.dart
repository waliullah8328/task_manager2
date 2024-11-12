import 'package:get/get.dart';
import 'package:task_manager/ui/controllers/add_new_task_screen.dart';
import 'package:task_manager/ui/controllers/completed_task_controller.dart';
import 'package:task_manager/ui/controllers/forgot_password_otp_controller.dart';
import 'package:task_manager/ui/controllers/new_task_list_controller.dart';
import 'package:task_manager/ui/controllers/reset_password_controller.dart';
import 'package:task_manager/ui/controllers/sign_in_controller.dart';
import 'package:task_manager/ui/controllers/sign_up_controller.dart';
import 'package:task_manager/ui/controllers/splash_controller.dart';

import '../ui/controllers/bottom_navbar_controller.dart';
import '../ui/controllers/cancel_task_controller.dart';
import '../ui/controllers/forgot_email_controller.dart';
import '../ui/controllers/profile_controller.dart';
import '../ui/controllers/progress_task_controller.dart';


class ControllerBinders extends Bindings{
  @override
  void dependencies() {

    Get.put(SplashController());
    Get.put(SignInController());
    Get.put(SignUpController());
    Get.put(ForgotEmailController());
    Get.put(ForgotPasswordOtpController());
    Get.put(ResetPasswordController());
    Get.put(BottomNavBarController());
    Get.put(NewTaskListController());
    Get.put(AddNewTaskController());
    Get.put(CompletedTaskController());
    Get.put(CancelTaskController());
    Get.put(ProgressTaskController());
    Get.put(ProfileController());


  }

}