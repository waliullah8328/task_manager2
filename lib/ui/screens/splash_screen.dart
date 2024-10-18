 import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:task_manager/ui/screens/signin_screen.dart';



import '../controllers/auth_controller.dart';
import '../utils/assets_path.dart';

import '../widgets/screen_background.dart';
import 'main_bottom_nav_bar_screen.dart';


class SplashScreen extends StatefulWidget {
   const SplashScreen({super.key});

   @override
   State<SplashScreen> createState() => _SplashScreenState();
 }

 class _SplashScreenState extends State<SplashScreen> {



  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    Timer(const Duration(seconds: 3), () async {
      await AuthController.getAccessToken(); // For get Token

      if(AuthController.isLogin()){
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MainBottomNavBarScreen(),
          ),
        );

      }else{
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const SignInScreen(),
          ),
        );

      }




  });}





  @override
   Widget build(BuildContext context) {
     return Scaffold(
       body: ScreenBackground(
           child: Center(
         child: Column(
           mainAxisAlignment: MainAxisAlignment.center,

           children: [
             SvgPicture.asset(AssetsPath.logoSvg,width: 120,),
           ],
         ),
       ),),

     );
   }
 }


