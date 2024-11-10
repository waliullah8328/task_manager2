
import 'package:get/get.dart';
import '../../data/model/network_response.dart';
import '../../data/service/network_caller.dart';
import '../../data/utils/urls.dart';
import '../utils/utils.dart';

class ForgotPasswordOtpController extends GetxController{


  final RxBool _inProgress = false.obs;
  final RxBool _isSuccess = false.obs;
  final RxString _errorMessage = "".obs;


  bool get inProgress => _inProgress.value;
  bool get isSuccess => _isSuccess.value;
  String? get errorMessage => _errorMessage.value;



  Future<bool> forgotEmailAndOtp({otp})async{
    _inProgress.value = true;
    final String? email = await readUserData("EmailVerification");


    NetworkResponse response = await NetworkCaller.getRequest(url: "${Urls.forgotOTP}/$email/$otp",);

    if(response.isSuccess){
      writeOTPVerification(otp);
      _isSuccess.value = true;




    }
    else{
      _errorMessage.value = response.errorMessage;
      _isSuccess.value = false;
    }
    _inProgress.value = false;

    return _isSuccess.value;

  }
}