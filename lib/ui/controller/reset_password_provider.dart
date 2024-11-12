
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../data/model/network_response.dart';
import '../../data/service/network_caller.dart';
import '../../data/utils/urls.dart';
import '../utils/utils.dart';

class ResetPasswordProvider with ChangeNotifier{

  final RxBool _inProgress = false.obs;
  final RxBool _isSuccess = false.obs;
  final RxString _errorMessage= "".obs;

  bool get inProgress =>_inProgress.value;
  bool get isSuccess =>_isSuccess.value;
  String get errorMessage => _errorMessage.value;

  Future<bool> resetPassword({password})async{
    _inProgress.value = true;
    notifyListeners();
    final String? email = await readUserData("EmailVerification");
    final String? otp = await readUserData("OTPVerification");
    Map<String, dynamic> requestBody = {
      "email":email,
      "OTP": otp,
      "password":password
    };
    final NetworkResponse response = await NetworkCaller.postRequest(url: Urls.recoverResetPassword,body: requestBody);

    if(response.isSuccess){
      _isSuccess.value = true;



    }
    else{
      _isSuccess.value = false;
      _errorMessage.value = response.errorMessage;
    }
    _inProgress.value = false;
    notifyListeners();

    return _isSuccess.value;



  }



}