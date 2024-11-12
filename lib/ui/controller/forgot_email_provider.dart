import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../data/model/network_response.dart';
import '../../data/service/network_caller.dart';
import '../../data/utils/urls.dart';
import '../utils/utils.dart';

class ForgotEmailProvider with ChangeNotifier{

  final RxBool _isSuccess = false.obs;
  final RxBool _inProgress = false.obs;
  final RxString _errorMessage = "".obs;



  bool get inProgress => _inProgress.value;
  bool get isSuccess => _isSuccess.value;
  String? get errorMessage => _errorMessage.value;

  Future<bool> forgotEmail({email})async{
    _inProgress.value = true;
    notifyListeners();
    NetworkResponse response = await NetworkCaller.getRequest(url: "${Urls.forgotEmail}/$email",);

    if(response.isSuccess){
      writeEmailVerification(email);
      _isSuccess.value = true;



    }
    else{
      _errorMessage?.value = response.errorMessage?? 'Unknown error';
      _isSuccess.value = false;


    }
    _inProgress.value = false;
    notifyListeners();

    return _isSuccess.value;

  }
}