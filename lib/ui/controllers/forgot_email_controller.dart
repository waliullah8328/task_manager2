import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../data/model/network_response.dart';
import '../../data/service/network_caller.dart';
import '../../data/utils/urls.dart';
import '../utils/utils.dart';

class ForgotEmailController extends GetxController{

  bool isSuccess = false;
  bool _inProgress = false;
  String? _errorMessage;
  final TextEditingController _emailTEController = TextEditingController();


  bool get inProgress => _inProgress;
  String? get errorMessage => _errorMessage;
  TextEditingController get emailTEController => _emailTEController;

  Future<bool> forgotEmail()async{
    _inProgress = true;
    update();
    var email = _emailTEController.text.trim();

    NetworkResponse response = await NetworkCaller.getRequest(url: "${Urls.forgotEmail}/$email",);

    if(response.isSuccess){
      writeEmailVerification(email);
      isSuccess = true;



    }
    else{
      _errorMessage = response.errorMessage;


    }
    _inProgress = false;
    update();

    return isSuccess;

  }
}