import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/signin_screen.dart';


import '../utils/app_colors.dart';
import '../widgets/screen_background.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {

  bool isLoading = false;



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
          ElevatedButton(
              onPressed:_onTapNextButton,
              child: const Icon(Icons.arrow_circle_right_outlined)),
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


    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const SignInScreen(),), (route) => false);

  }
}
