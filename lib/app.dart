import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/data/routes/route_name.dart';
import 'package:task_manager/ui/controller/add_new_task_provider.dart';
import 'package:task_manager/ui/controller/bottom_navbar_provider.dart';
import 'package:task_manager/ui/controller/cancel_task_provider.dart';
import 'package:task_manager/ui/controller/completed_task_provider.dart';
import 'package:task_manager/ui/controller/forgot_email_provider.dart';
import 'package:task_manager/ui/controller/forgot_password_otp_provider.dart';
import 'package:task_manager/ui/controller/new_task_list_provider.dart';
import 'package:task_manager/ui/controller/progress_task_provider.dart';
import 'package:task_manager/ui/controller/reset_password_provider.dart';
import 'package:task_manager/ui/controller/sign_in_provider.dart';
import 'package:task_manager/ui/controller/sign_up_provider.dart';
import 'package:task_manager/ui/controller/splash_provider.dart';
import 'package:task_manager/ui/controller/task_edit_delete_provider.dart';
import 'package:task_manager/ui/utils/app_colors.dart';
import 'data/model/task_model.dart';
import 'data/routes/route.dart';



class TaskManagerApp extends StatefulWidget {
  const TaskManagerApp({super.key});

  static  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();



  @override
  State<TaskManagerApp> createState() => _TaskManagerAppState();
}

class _TaskManagerAppState extends State<TaskManagerApp> {
  late final TaskModel taskModel;
  void Function()? onRefresh;
  @override
  Widget build(BuildContext context) {
    return  MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => SplashProvider(),),
      ChangeNotifierProvider(create: (context) => CancelTaskProvider(),),
      ChangeNotifierProvider(create: (context) => ProgressTaskProvider(),),
      ChangeNotifierProvider(create: (context) => CompletedTaskProvider(),),
      ChangeNotifierProvider(create: (context) => NewTaskListProvider(),),
      ChangeNotifierProvider(create: (context) => AddNewTaskProvider(),),
      ChangeNotifierProvider(create: (context) => SignInProvider(),),
      ChangeNotifierProvider(create: (context) => SignUpProvider(),),
      ChangeNotifierProvider(create: (context) => ForgotPasswordOtpProvider(),),
      ChangeNotifierProvider(create: (context) => ForgotEmailProvider(),),
      ChangeNotifierProvider(create: (context) => ResetPasswordProvider(),),
      ChangeNotifierProvider(create: (context) => BottomNavBarProvider(),),
      ChangeNotifierProvider(create: (context) => TaskProvider(),),




    ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: TaskManagerApp.navigatorKey,
        theme: ThemeData(
            colorSchemeSeed: AppColors.themeColor,
            textTheme: const TextTheme(

            ),
            inputDecorationTheme:_inputDecorationTheme(),
            elevatedButtonTheme: _elevatedButtonThemeData()
        ),


        initialRoute: RouteName.splashScreen,
        onGenerateRoute: Routes.generateRoute,
      ),
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
