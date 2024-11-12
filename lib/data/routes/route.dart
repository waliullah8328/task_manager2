
import 'package:flutter/material.dart';
import 'package:task_manager/data/routes/route_name.dart';
import 'package:task_manager/ui/screens/add_new_task_screen.dart';
import 'package:task_manager/ui/screens/forgot_password_email_screen.dart';
import 'package:task_manager/ui/screens/main_bottom_nav_bar_screen.dart';
import 'package:task_manager/ui/screens/profile_screen.dart';
import 'package:task_manager/ui/screens/sign_in_screen.dart';
import 'package:task_manager/ui/screens/splash_screen.dart';

import '../../ui/screens/forgot_password_otp_screen.dart';
import '../../ui/screens/reset_password_screen.dart';
import '../../ui/screens/signup_screen.dart';


class Routes{


  static Route<dynamic> generateRoute(RouteSettings settings){

    switch(settings.name){
      case RouteName.splashScreen:
        return MaterialPageRoute(builder: (context) => SplashScreen(),);
      case RouteName.loginScreen:
        return MaterialPageRoute(builder: (context) => SignInScreen(),);
      case RouteName.signUpScreen:
        return MaterialPageRoute(builder: (context) => SignUpScreen(),);
      case RouteName.forgotPasswordEmailScreen:
        return MaterialPageRoute(builder: (context) => ForgotPasswordEmailScreen(),);
      case RouteName.forgotPasswordOtpScreen:
        return MaterialPageRoute(builder: (context) => ForgotPasswordOtpScreen(),);
      case RouteName.resetPasswordScreen:
        return MaterialPageRoute(builder: (context) => ResetPasswordScreen(),);
      case RouteName.mainBottomScreen:
        return MaterialPageRoute(builder: (context) => MainBottomNavBarScreen(),);
      case RouteName.addNewTaskScreen:
        return MaterialPageRoute(builder: (context) => AddNewTaskScreen(),);
      case RouteName.profileScreen:
        return MaterialPageRoute(builder: (context) => ProfileScreen(),);
      default:
        return MaterialPageRoute(builder: (context) => SignInScreen(),);
    }

  }
}