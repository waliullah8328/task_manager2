import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_manager/ui/screens/reset_password_screen.dart';
import 'package:task_manager/ui/screens/sign_in_screen.dart';


import '../../data/model/network_response.dart';
import '../../data/service/network_caller.dart';
import '../../data/utils/urls.dart';
import '../utils/app_colors.dart';
import '../utils/utils.dart';
import '../widgets/screen_background.dart';
import '../widgets/snack_bar_message.dart';

class ForgotPasswordOtpScreen extends StatefulWidget {
  const ForgotPasswordOtpScreen({super.key});

  @override
  State<ForgotPasswordOtpScreen> createState() => _ForgotPasswordOtpScreenState();
}

class _ForgotPasswordOtpScreenState extends State<ForgotPasswordOtpScreen> {


  bool _inProgress = false;
  final TextEditingController _pinVerificationTEController = TextEditingController();


  final _forgotOTPFormKey = GlobalKey<FormState>();

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
                  _buildVerifyEmailForm(),
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


  Widget _buildVerifyEmailForm() {
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
          Visibility(
            visible: !_inProgress,
            replacement: const CircularProgressIndicator(),
            child: ElevatedButton(
                onPressed: _onTapNextButton,
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

  void _onTapNextButton(){
    if(!_forgotOTPFormKey.currentState!.validate()){
      return;
    }
    _forgotEmailAndOtp();






  }

  Future<void> _forgotEmailAndOtp()async{
    _inProgress = true;
    setState(() {});
    final String? email = await readUserData("EmailVerification");
    var otp = _pinVerificationTEController.text.trim();

    NetworkResponse response = await NetworkCaller.getRequest(url: "${Urls.forgotOTP}/$email/$otp",);
    _inProgress = false;
    setState(() {});

    if(response.isSuccess){
      writeOTPVerification(otp);
      Navigator.push(context, MaterialPageRoute(builder: (context) => const ResetPasswordScreen(),));

      showSnackBarMessage(context, "Successfully Submitted");

    }
    else{
      _inProgress = false;
      setState(() {});
      showSnackBarMessage(context, response.errorMessage,true);


    }

  }


  void _onTapSignIn() {
    // TODO: implement on tap signup screen
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) =>  SignInScreen(),), (route) => false);
  }
}
