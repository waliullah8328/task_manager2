import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_manager/ui/controllers/forgot_password_otp_controller.dart';
import 'package:task_manager/ui/screens/reset_password_screen.dart';
import 'package:task_manager/ui/screens/sign_in_screen.dart';

import '../utils/app_colors.dart';

import '../widgets/screen_background.dart';


class ForgotPasswordOtpScreen extends StatelessWidget {
   ForgotPasswordOtpScreen({super.key});

  final _forgotOTPFormKey = GlobalKey<FormState>();
   final TextEditingController _pinVerificationTEController = TextEditingController();
  final controller = Get.find<ForgotPasswordOtpController>();

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
                  Text("Pin Verification",style: textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w500),),
                  const SizedBox(height: 8,),
                  Text("A 6 digit verification otp has been sent to your email address",style: textTheme.titleSmall?.copyWith(color: Colors.grey),),
                  const SizedBox(
                    height: 24,
                  ),
                  _buildVerifyEmailForm(context),
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


  Widget _buildVerifyEmailForm(BuildContext context) {
    return Form(
      key: _forgotOTPFormKey,
      child: Column(
        children: [
          PinCodeTextField(
            controller: _pinVerificationTEController,

            autovalidateMode: AutovalidateMode.onUserInteraction,



            length: 6,
            obscureText: false,
            animationType: AnimationType.fade,
            keyboardType: TextInputType.number,
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(5),
              fieldHeight: 50,
              fieldWidth: 40,
              activeFillColor: Colors.white,
              inactiveFillColor: Colors.white,
              selectedFillColor: Colors.white
            ),
            animationDuration: const Duration(milliseconds: 300),
            backgroundColor: Colors.transparent,
            enableActiveFill: true,
             appContext: context,
          ),

          const SizedBox(
            height: 24,
          ),
          Obx(() => Visibility(
            visible: !controller.inProgress,
            replacement: const CircularProgressIndicator(),
            child: ElevatedButton(
                onPressed: _onTapNextButton,
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
                  recognizer: TapGestureRecognizer()..onTap = ()=>_onTapSignIn(context),)
            ]));
  }

  void _onTapNextButton(){
    if(!_forgotOTPFormKey.currentState!.validate()){
      return;
    }
    _forgotEmailAndOtp();

  }

  Future<void> _forgotEmailAndOtp()async{
    final bool result = await controller.forgotEmailAndOtp(otp: _pinVerificationTEController.text);
    if(result){
      Get.to(()=>ResetPasswordScreen());
      Get.showSnackbar(
        const GetSnackBar(
          title: "Success",
          message: "Successfully Submitted",
          duration: Duration(seconds: 3),
        ),
      );

    }
    else{
      Get.showSnackbar(
        GetSnackBar(
          title: "Error",
          message: controller.errorMessage ?? "Unknown error",
          duration: const Duration(seconds: 3),
        ),
      );



    }

  }


  void _onTapSignIn(BuildContext context) {
    // TODO: implement on tap signup screen

    Get.off(()=>SignInScreen());
    //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) =>  SignInScreen(),), (route) => false);
  }
}
