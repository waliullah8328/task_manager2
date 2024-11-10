import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/ui/controllers/forgot_email_controller.dart';
import 'package:task_manager/ui/screens/forgot_password_otp_screen.dart';
import 'package:task_manager/ui/widgets/center_circular_progress_indicator.dart';
import '../utils/app_colors.dart';
import '../widgets/screen_background.dart';
import '../widgets/snack_bar_message.dart';

class ForgotPasswordEmailScreen extends StatelessWidget {
  ForgotPasswordEmailScreen({super.key});

  final _forgotEmailFormKey = GlobalKey<FormState>();
  final controller = Get.find<ForgotEmailController>();

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
                  "Your Email Address",
                  style: textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                Text(
                  "A 6 digit verification OTP will be sent to your email address",
                  style: textTheme.titleSmall?.copyWith(color: Colors.grey),
                ),
                const SizedBox(height: 24),
                _buildVerifyEmailForm(context),
                const SizedBox(height: 48),
                Center(
                  child: _buildHaveAccountSection(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVerifyEmailForm(BuildContext context) {
    return Form(
      key: _forgotEmailFormKey,
      child: Column(
        children: [
          TextFormField(
            controller: controller.emailTEController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value!.isEmpty) {
                return "Email is required";
              }
              return null;
            },
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: "Email"),
          ),
          const SizedBox(height: 24),
          Visibility(
            visible: !controller.inProgress,
            replacement: const CenterCircularProgressIndicator(),
            child: ElevatedButton(
              onPressed: () => _onTapNextButton(context),
              child: const Icon(Icons.arrow_circle_right_outlined),
            ),
          ),
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
          letterSpacing: 0.5,
        ),
        text: "Have an account? ",
        children: [
          TextSpan(
            text: "Sign In",
            style: const TextStyle(color: AppColors.themeColor),
            recognizer: TapGestureRecognizer()..onTap = () => _onTapSignIn(context),
          ),
        ],
      ),
    );
  }

  void _onTapSignIn(BuildContext context) {
    Navigator.pop(context);
  }

  void _onTapNextButton(BuildContext context) {
    if (!_forgotEmailFormKey.currentState!.validate()) {
      return;
    }
    _forgotEmail(context);
  }

  Future<void> _forgotEmail(BuildContext context) async {
    final bool result = await controller.forgotEmail();

    if (result) {
      Get.to(() => const ForgotPasswordOtpScreen());
      showSnackBarMessage(context, "Successfully Submitted");
    } else {
      showSnackBarMessage(context, controller.errorMessage ?? "Error", true);
    }
  }
}
