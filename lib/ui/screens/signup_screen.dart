import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/signin_screen.dart';


import '../../data/model/network_response.dart';
import '../../data/service/network_caller.dart';
import '../../data/utils/urls.dart';
import '../utils/app_colors.dart';
import '../widgets/center_circular_progress_indicator.dart';
import '../widgets/screen_background.dart';
import '../widgets/snacbar_message.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {



  final GlobalKey<FormState> _signUpFormKey = GlobalKey<FormState>();
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
   bool _inProgress = false;


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
                  Text("Join With Us",style: textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w500),),
                  const SizedBox(
                    height: 24,
                  ),
                  _buildSignUpForm(),
                  const SizedBox(
                    height: 24,
                  ),
                  Center(
                    child: _buildHaveAccountSection(),
                  ),



                ],),
            ),
          )),
    );
  }


  Widget _buildSignUpForm() {
    return Form(
      key: _signUpFormKey,
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
            controller: _firstNameTEController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (String? value){
              if(value?.isEmpty ?? true){
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
            controller: _lastNameTEController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (String? value){
              if(value?.isEmpty ?? true){
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
            controller: _mobileTEController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (String?value){
              if(value?.isEmpty ?? true){
                return "Mobile Number is required";
              }
              if(value!.length != 11){
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
            replacement: const CenterCircularProgressIndicator(),
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
  void _onTapSignIn() {
    // TODO: implement on tap signup screen
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SignInScreen(),
        ));
  }

  void _onTapNextButton() {

    if(!_signUpFormKey.currentState!.validate()){
      return;
    }
    _signUp();

  }


  Future<void> _signUp()async{
    _inProgress = true;
    setState(() {});
    Map<String, dynamic>requestBody = {
      "email":_emailTEController.text.trim(),
      "firstName":_firstNameTEController.text.trim(),
      "lastName":_lastNameTEController.text.trim(),
      "mobile":_mobileTEController.text.trim(),
      "password":_passwordTEController.text

    };
    NetworkResponse response = await NetworkCaller.postRequest(url: Urls.registration,body: requestBody);
    _inProgress = false;
    setState(() {});

    if(response.isSuccess){
      clearTextFields();
      showSnackBarMessage(context, "New user is created");

    }
    else{
      _inProgress = false;
      setState(() {});
      showSnackBarMessage(context, response.errorMessage,true);


    }

  }

  void clearTextFields(){
    _emailTEController.clear();
    _firstNameTEController.clear();
    _lastNameTEController.clear();
    _mobileTEController.clear();
    _passwordTEController.clear();
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    _firstNameTEController.dispose();
    _lastNameTEController.dispose();
    _mobileTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }
}
