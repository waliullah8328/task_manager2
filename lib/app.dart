import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:task_manager/bindings/controller_binder.dart';
import 'package:task_manager/data/routes/route_name.dart';
import 'package:task_manager/ui/screens/main_bottom_nav_bar_screen.dart';
import 'package:task_manager/ui/screens/splash_screen.dart';
import 'package:task_manager/ui/utils/app_colors.dart';

import 'data/routes/route.dart';



class TaskManagerApp extends StatefulWidget {
  const TaskManagerApp({super.key});

  static  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


  @override
  State<TaskManagerApp> createState() => _TaskManagerAppState();
}

class _TaskManagerAppState extends State<TaskManagerApp> {
  @override
  Widget build(BuildContext context) {
    return  GetMaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: TaskManagerApp.navigatorKey,
      theme: ThemeData(
        colorSchemeSeed: AppColors.themeColor,
        textTheme: const TextTheme(

        ),
        inputDecorationTheme:_inputDecorationTheme(),
        elevatedButtonTheme: _elevatedButtonThemeData()
      ),
      initialBinding: ControllerBinders(),
      initialRoute: RouteName.splashScreen,
      onGenerateRoute: Routes.generateRoute,
    );
  }

  ElevatedButtonThemeData _elevatedButtonThemeData (){
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.themeColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 11),
          fixedSize: const Size.fromWidth(double.maxFinite),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8)
          )
      ),
    );
  }

  InputDecorationTheme _inputDecorationTheme (){
    return InputDecorationTheme(
        fillColor: Colors.white,
        filled: true,
        hintStyle: const TextStyle(
          fontWeight: FontWeight.w300
        ),
        border: _inputBorder(),
        enabledBorder: _inputBorder(),
        focusedBorder: _inputBorder(),
        errorBorder: _inputBorder(),
        disabledBorder: _inputBorder(),

    );
  }

  OutlineInputBorder _inputBorder (){
    return OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(8),
    );
  }
}
