import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/signup_screen.dart';




import '../../data/model/login_model.dart';
import '../../data/model/network_response.dart';
import '../../data/service/network_caller.dart';
import '../../data/utils/urls.dart';
import '../controllers/auth_controller.dart';
import '../utils/app_colors.dart';
import '../widgets/screen_background.dart';
import '../widgets/snacbar_message.dart';
import 'forgot_password_email_screen.dart';
import 'main_bottom_nav_bar_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {


  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
   bool _inProgress = false;
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();



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
                const SizedBox(
                  height: 82,
                ),
                Text(
                  "Get Started With",
                  style: textTheme.displaySmall
                      ?.copyWith(fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 24,
                ),
                _buildSignInForm(),
                const SizedBox(
                  height: 24,
                ),
                Center(
                  child: Column(
                    children: [
                      TextButton(
                          onPressed: _onTapForgotPasswordButton,
                          child: const Text(
                            "Forgot Password?",
                            style: TextStyle(color: Colors.grey),
                          )),
                      _buildSignUpSection(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );


  }
  Widget _buildSignInForm() {
    return Form(
      key:_loginFormKey,
      child: Column(
        children: [
          TextFormField(
           controller: _emailTEController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (String? value){
              if(value?.isEmpty ?? true){
                return "Email is required";

              }
              return null;
            },
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: "Email"),

          ),
          const SizedBox(
            height: 8,
          ),
          TextFormField(
            controller: _passwordTEController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (String? value){
              if(value?.isEmpty ?? true){
                return "Password is required";

              }
              if(value!.length <= 6){
                return "Password should be 6 character";
              }
              return null;
            },

            obscureText: true,

            decoration: const InputDecoration(hintText: "Password"),

          ),
          const SizedBox(
            height: 24,
          ),
          Visibility(
             visible: !_inProgress,
            replacement: const Center(child: CircularProgressIndicator(),),
            child: ElevatedButton(
                onPressed: _onTapNextButton,
                child: const Icon(Icons.arrow_circle_right_outlined)),
          ),
        ],
      ),
    );
  }


  Widget _buildSignUpSection() {
    return RichText(
        text: TextSpan(
            style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 16,
                letterSpacing: 0.5),
            text: "Don't have an account? ",
            children: [
          TextSpan(
              text: "Sign Up",
              style: const TextStyle(color: AppColors.themeColor),
              recognizer: TapGestureRecognizer()..onTap = _onTapSignUp)
        ]));
  }



  void _onTapNextButton() {
    // TODO: implement on tap next screen
    if(!_loginFormKey.currentState!.validate()){
      return;

    }
    _signIn();


   // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const MainBottomNavBarScreen(),), (route) => false);

  }

  Future<void> _signIn()async{
    _inProgress = true;
    setState(() {});
    Map<String, dynamic> requestBody = {
      "email":_emailTEController.text.trim(),
      "password":_passwordTEController.text
    };
    final NetworkResponse response = await NetworkCaller.postRequest(url: Urls.login,body: requestBody);
    _inProgress = false;
    setState(() {});
    if(response.isSuccess){
      LoginModel loginModel = LoginModel.fromJson(response.responseData);
      await AuthController.saveAccessToken(loginModel.token!);
      await AuthController.saveUserData(loginModel.data!);
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const MainBottomNavBarScreen(),), (route) => false);

    }
    else{
      showSnackBarMessage(context, response.errorMessage,true);
    }



  }
  void _onTapForgotPasswordButton() {
    // TODO: implement on tap forgot password
    Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgotPasswordEmailScreen(),));
  }
  void _onTapSignUp() {
    // TODO: implement on tap signup screen
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SignUpScreen(),
        ));
  }
}
