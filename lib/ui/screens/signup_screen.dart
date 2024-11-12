import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/ui/screens/sign_in_screen.dart';
import '../controller/sign_up_provider.dart';
import '../utils/app_colors.dart';
import '../widgets/center_circular_progress_indicator.dart';
import '../widgets/screen_background.dart';
import '../widgets/snack_bar_message.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final GlobalKey<FormState> _signUpFormKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    final controller = Provider.of<SignUpProvider>(context);
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
                    "Join With Us",
                    style: textTheme.displaySmall
                        ?.copyWith(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  _buildSignUpForm(context,controller),
                  const SizedBox(
                    height: 24,
                  ),
                  Center(
                    child: _buildHaveAccountSection(context),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Widget _buildSignUpForm(BuildContext context,controller) {
    return Form(
      key: _signUpFormKey,
      child: Column(
        children: [
          TextFormField(
            controller: controller.emailTEController,
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
          const SizedBox(
            height: 8,
          ),
          TextFormField(
            controller: controller.firstNameTEController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (String? value) {
              if (value?.isEmpty ?? true) {
                return "First Name is required";
              }
              return null;
            },
            keyboardType: TextInputType.name,
            decoration: const InputDecoration(hintText: "First Name"),
          ),
          const SizedBox(
            height: 8,
          ),
          TextFormField(
            controller: controller.lastNameTEController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (String? value) {
              if (value?.isEmpty ?? true) {
                return "Last Name is required";
              }
              return null;
            },
            keyboardType: TextInputType.name,
            decoration: const InputDecoration(hintText: "Last Name"),
          ),
          const SizedBox(
            height: 8,
          ),
          TextFormField(
            controller: controller.mobileTEController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (String? value) {
              if (value?.isEmpty ?? true) {
                return "Mobile Number is required";
              }
              if (value!.length != 11) {
                return "Number should be 11 digits (01*********)";
              }
              return null;
            },
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(hintText: "Mobile Number"),
          ),
          const SizedBox(
            height: 8,
          ),
          TextFormField(
            controller: controller.passwordTEController,
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
          const SizedBox(
            height: 24,
          ),
          Consumer<SignUpProvider>(builder: (context, value, child) {
            return Visibility(
              visible: !value.inProgress,
              replacement: const CenterCircularProgressIndicator(),
              child: ElevatedButton(
                onPressed: () => _onTapNextButton(context,controller),
                child: const Icon(Icons.arrow_circle_right_outlined),
              ),
            );
          },),
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
                  recognizer: TapGestureRecognizer()..onTap = _onTapSignIn)
            ]));
  }

  void _onTapSignIn() {
    Get.to(() => SignInScreen());
  }

  void _onTapNextButton(BuildContext context,controller) {
    if (!_signUpFormKey.currentState!.validate()) {
      return;
    }
    _signUp(context,controller);
  }

  Future<void> _signUp(BuildContext context,controller) async {
    final bool result = await controller.signUp(

    );

    if (result) {
      showSnackBarMessage(context, "New user is created");
      Get.to(() => SignInScreen());
    } else {
      showSnackBarMessage(context, controller.errorMessage ?? "Error", true);
    }
  }
}
