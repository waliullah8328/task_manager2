import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/ui/controllers/sign_in_controller.dart';
import 'package:task_manager/ui/screens/main_bottom_nav_bar_screen.dart';
import 'package:task_manager/ui/screens/signup_screen.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';
import '../utils/app_colors.dart';
import '../widgets/screen_background.dart';
import 'forgot_password_email_screen.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final controller = Get.find<SignInController>();

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
                const SizedBox(height: 82),
                Text(
                  "Get Started With",
                  style: textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 24),
                _buildSignInForm(context),
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

  Widget _buildSignInForm(BuildContext context) {
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
                return "Password should be 6 characters";
              }
              return null;
            },
            obscureText: true,
            decoration: const InputDecoration(hintText: "Password"),
          ),
          const SizedBox(height: 24),
           Visibility(
              visible: !controller.inProgress,
              replacement: const Center(child: CircularProgressIndicator()),
              child: ElevatedButton(
                onPressed: () => _onTapNextButton(context),
                child: const Icon(Icons.arrow_circle_right_outlined),
              ),
            ),

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

  void _onTapNextButton(BuildContext context) {
    if (!_loginFormKey.currentState!.validate()) return;
    _signIn(context);
  }

  void _onTapForgotPasswordButton(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>  ForgotPasswordEmailScreen()),
    );
  }

  void _onTapSignUp(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>  SignUpScreen()),
    );
  }

  Future<void> _signIn(BuildContext context) async {
    final bool result = await controller.signIn(
      _emailTEController.text.trim(),
      _passwordTEController.text,
    );

    if (result) {
      Get.offNamed(MainBottomNavBarScreen.name);
    } else {
      showSnackBarMessage(context, controller.errorMessage ?? "Error", true);
    }
  }
}