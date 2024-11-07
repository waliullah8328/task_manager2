import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/signin_screen.dart';
import 'package:task_manager/ui/widgets/center_circular_progress_indicator.dart';
import 'package:task_manager/ui/widgets/snacbar_message.dart';


import '../../data/model/network_response.dart';
import '../../data/service/network_caller.dart';
import '../../data/utils/urls.dart';
import '../utils/app_colors.dart';
import '../utils/utils.dart';
import '../widgets/screen_background.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {

  bool _inProgress = false;


   final TextEditingController _passwordTEController = TextEditingController();
   final TextEditingController _confirmPasswordTEController = TextEditingController();
  final _resetPasswordFormKey = GlobalKey<FormState>();


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
                  _buildResetPasswordForm(),
                  const SizedBox(
                    height: 48,
                  ),
                  Center(
                    child: _buildHaveAccountSection(),
                  ),



                ],),
            ),
          )),
    );
  }


  Widget _buildResetPasswordForm() {
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
              if(value!.length <= 6){
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
              if(value!.length <= 6){
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
          Visibility(
            visible: !_inProgress,
            replacement: const CenterCircularProgressIndicator(),
            child: ElevatedButton(
                onPressed:_onTapNextButton,
                child: const Icon(Icons.arrow_circle_right_outlined)),
          ),
        ],
      ),
    );
  }
  Widget _buildHaveAccountSection() {
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
                  recognizer: TapGestureRecognizer()..onTap = _onTapSignIn)
            ]));
  }
  void _onTapSignIn() {
    // TODO: implement on tap signup screen
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const SignInScreen(),), (route) => false);
  }

  void _onTapNextButton(){
    if(!_resetPasswordFormKey.currentState!.validate()){
      return;
    }
    if(_passwordTEController.text == _confirmPasswordTEController.text){
      _resetPassword();




    }else{
      showSnackBarMessage(context, "Please input same password!",true);
    }




  }

  Future<void> _resetPassword()async{
    _inProgress = true;
    setState(() {});
    final String? email = await readUserData("EmailVerification");
    final String? otp = await readUserData("OTPVerification");
    Map<String, dynamic> requestBody = {
      "email":email,
      "OTP": otp,
      "password":_passwordTEController.text
    };
    final NetworkResponse response = await NetworkCaller.postRequest(url: Urls.recoverResetPassword,body: requestBody);
    _inProgress = false;
    setState(() {});
    if(response.isSuccess){

      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const SignInScreen(),), (route) => false);

    }
    else{
      showSnackBarMessage(context, response.errorMessage,true);
    }



  }

}
