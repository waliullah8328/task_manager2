import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/data/routes/route_name.dart';
import '../controller/sign_in_provider.dart';
import '../utils/app_colors.dart';
import '../widgets/screen_background.dart';


class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  // Private form key
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    final controler = Provider.of<SignInProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 82),
                Text(
                  "Get Started With",
                  style: textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 24),
                _buildSignInForm(context,controler),
                const SizedBox(height: 24),
                Center(
                  child: Column(
                    children: [
                      TextButton(
                        onPressed: () => _onTapForgotPasswordButton(context),
                        child: const Text("Forgot Password?", style: TextStyle(color: Colors.grey)),
                      ),
                      _buildSignUpSection(context),
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

  Widget _buildSignInForm(BuildContext context,controler) {
    return Form(
      key: _loginFormKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailTEController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (String? value) {
              if (value?.isEmpty ?? true) {
                return "Email is required";
              }
              return null;
            },
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: "Email"),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _passwordTEController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (String? value) {
              if (value?.isEmpty ?? true) {
                return "Password is required";
              }
              if (value!.length <= 6) {
                return "Password should be at least 6 characters";
              }
              return null;
            },
            obscureText: true,
            decoration: const InputDecoration(hintText: "Password"),
          ),
          const SizedBox(height: 24),
          Consumer<SignInProvider>(builder: (context, value, child) {
            return Visibility(
              visible: !value.inProgress,
              replacement: const Center(child: CircularProgressIndicator()),
              child: ElevatedButton(
                onPressed: () => _onTapNextButton(context,controler),
                child: const Icon(Icons.arrow_circle_right_outlined),
              ),
            );
          },),
        ],
      ),
    );
  }

  Widget _buildSignUpSection(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
          fontSize: 16,
          letterSpacing: 0.5,
        ),
        text: "Don't have an account? ",
        children: [
          TextSpan(
            text: "Sign Up",
            style: const TextStyle(color: AppColors.themeColor),
            recognizer: TapGestureRecognizer()..onTap = () => _onTapSignUp(context),
          ),
        ],
      ),
    );
  }

  void _onTapNextButton(BuildContext context,controler) {
    if (!_loginFormKey.currentState!.validate()) return;
    _signIn(context,controler);
  }

  void _onTapForgotPasswordButton(BuildContext context) {
    /*
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ForgotPasswordEmailScreen()),
    );*/
    Get.toNamed(RouteName.forgotPasswordEmailScreen);
  }

  void _onTapSignUp(BuildContext context) {

    Get.toNamed(RouteName.signUpScreen);

    /*
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignUpScreen()),
    );*/
  }

  Future<void> _signIn(BuildContext context,controller) async {
    final bool result = await controller.signIn(
      _emailTEController.text.trim(),
      _passwordTEController.text,
    );
      if (result) {
        Get.offAllNamed(RouteName.mainBottomScreen);
      } else {

        //showSnackBarMessage(context, _controller.errorMessage, true);
        Get.showSnackbar(GetSnackBar(title:"Error",message: controller.errorMessage,duration: const Duration(seconds: 3),));
      }

  }
}
