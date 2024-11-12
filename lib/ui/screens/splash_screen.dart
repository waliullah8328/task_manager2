import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:task_manager/ui/controllers/splash_controller.dart';
import '../utils/assets_path.dart';
import '../widgets/screen_background.dart';


class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  final SplashController _authController = Get.find<SplashController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                AssetsPath.logoSvg,
                width: 120,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
