import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/model/network_response.dart';
import '../../data/service/network_caller.dart';
import '../../data/utils/urls.dart';

class SignUpProvider with ChangeNotifier{

  // Text Editing Variables
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();


  bool _inProgress = false;
  bool isSuccess= false;
  String? _errorMessage;


  bool get inProgress => _inProgress;
  String? get errorMessage => _errorMessage;
  TextEditingController get emailTEController =>_emailTEController;
  TextEditingController get firstNameTEController =>_firstNameTEController;
  TextEditingController get lastNameTEController =>_lastNameTEController;
  TextEditingController get mobileTEController =>_mobileTEController;
  TextEditingController get passwordTEController =>_passwordTEController;


  void clearTextFields() {
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





  Future<bool> signUp() async {
    _inProgress = true;
    notifyListeners();
    Map<String, dynamic> requestBody = {
      "email": _emailTEController.text.trim(),
      "firstName": _firstNameTEController.text,
      "lastName": _lastNameTEController.text,
      "mobile": _lastNameTEController.text,
      "password": _passwordTEController.text
    };
    NetworkResponse response = await NetworkCaller.postRequest(
        url: Urls.registration, body: requestBody);


    if (response.isSuccess) {
      clearTextFields();
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }
    _inProgress = false;
    notifyListeners();

    return isSuccess;
  }


}