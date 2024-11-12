import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/ui/controllers/reset_password_controller.dart';
import 'package:task_manager/ui/widgets/center_circular_progress_indicator.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';
import '../../data/routes/route_name.dart';
import '../utils/app_colors.dart';
import '../widgets/screen_background.dart';

class ResetPasswordScreen extends StatelessWidget {
   ResetPasswordScreen({super.key});




  final _resetPasswordFormKey = GlobalKey<FormState>();
   final TextEditingController _passwordTEController = TextEditingController();
   final TextEditingController _confirmPasswordTEController = TextEditingController();
  final controller = Get.find<ResetPasswordController>();


  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ScreenBackground(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 82,),
                  Text("Set Password",style: textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w500),),
                  const SizedBox(height: 8,),
                  Text("Minimum number of password should be 8 character",style: textTheme.titleSmall?.copyWith(color: Colors.grey),),
                  const SizedBox(
                    height: 24,
                  ),
                  _buildResetPasswordForm(context),
                  const SizedBox(
                    height: 48,
                  ),
                  Center(
                    child: _buildHaveAccountSection(context),
                  ),



                ],),
            ),
          )),
    );
  }


  Widget _buildResetPasswordForm(BuildContext context) {
    return Form(
      key: _resetPasswordFormKey,
      child: Column(
        children: [
          TextFormField(
            controller: _passwordTEController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value){
              if(value!.isEmpty){
                return "Password is required";

              }
              if(value.length <= 6){
                return "Password should be 6 character";
              }
              return null;
            },




            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: "Password"),
          ),
          const SizedBox(
            height: 8,
          ),
          TextFormField(
            controller: _confirmPasswordTEController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value){
              if(value!.isEmpty){
                return "Password is required";

              }
              if(value.length <= 6){
                return "Password should be 6 character";
              }
              return null;
            },




            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: "Confirm Password"),
          ),

          const SizedBox(
            height: 24,
          ),
          Obx(() => Visibility(
            visible: !controller.inProgress,
            replacement: const CenterCircularProgressIndicator(),
            child: ElevatedButton(
                onPressed:()=>_onTapNextButton(context),
                child: const Icon(Icons.arrow_circle_right_outlined)),
          )),
        ],
      ),
    );
  }
  Widget _buildHaveAccountSection(BuildContext context) {
    return RichText(
        text: TextSpan(
            style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 16,
                letterSpacing: 0.5),
            text: "Have account? ",
            children: [
              TextSpan(
                  text: "Sign In",
                  style: const TextStyle(color: AppColors.themeColor),
                  recognizer: TapGestureRecognizer()..onTap = ()=>_onTapSignIn(context))
            ]));
  }
  void _onTapSignIn(BuildContext context) {
    // TODO: implement on tap signup screen
    //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) =>  SignInScreen(),), (route) => false);
    Get.offAll(RouteName.loginScreen);
  }

  void _onTapNextButton(BuildContext context){
    if(!_resetPasswordFormKey.currentState!.validate()){
      return;
    }
    if(_passwordTEController.text == _confirmPasswordTEController.text){
      _resetPassword(context);




    }else{
      showSnackBarMessage(context, "Please input same password!",true);
    }




  }

  Future<void> _resetPassword(BuildContext context)async{
    final bool result = await controller.resetPassword(password: _passwordTEController.text);
    if(result){
      //Get.offAll(()=> SignInScreen());
      Get.offAllNamed(RouteName.loginScreen);
      Get.showSnackbar(
        const GetSnackBar(
          title: "Success",
          message: "Reset Password Successfully",
          duration: Duration(seconds: 3),
        ),
      );


      //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) =>  SignInScreen(),), (route) => false);

    }
    else{
      Get.showSnackbar(
        GetSnackBar(
          title: "Error",
          message: controller.errorMessage,
          duration: const Duration(seconds: 3),
        ),
      );
     // showSnackBarMessage(context, controller.errorMessage.toString(),true);
    }



  }

}
