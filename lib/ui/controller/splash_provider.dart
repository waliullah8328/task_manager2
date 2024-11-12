import 'dart:async';
import 'package:flutter/material.dart';
import 'package:task_manager/app.dart';
import '../../data/routes/route_name.dart';
import 'auth_controller.dart';
class SplashProvider with ChangeNotifier {
  SplashProvider() {
    startTimer();
  }

  void startTimer() {
    Timer(const Duration(seconds: 3), () async {
      await AuthController.getAccessToken(); // For getting Token

      if (AuthController.isLogin()) {
        await AuthController.getUserData();
        _navigateToMainScreen();
      } else {
        _navigateToLoginScreen();
      }
    });
  }

  void _navigateToMainScreen() {
    // Check if the Navigator context is available
    if (TaskManagerApp.navigatorKey.currentContext != null) {
      Navigator.pushReplacementNamed(
        TaskManagerApp.navigatorKey.currentContext!,
        RouteName.mainBottomScreen,
      );
    }
  }

  void _navigateToLoginScreen() {
    if (TaskManagerApp.navigatorKey.currentContext != null) {
      Navigator.pushReplacementNamed(
        TaskManagerApp.navigatorKey.currentContext!,
        RouteName.loginScreen,
      );
    }
  }
}
