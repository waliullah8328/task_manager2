import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:provider/provider.dart';

import '../controller/splash_provider.dart';
import '../utils/assets_path.dart';
import '../widgets/screen_background.dart';


class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});



  @override
  Widget build(BuildContext context) {
    final splash_Provider = Provider.of<SplashProvider>(context);
    //splash_Provider.
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
