import 'package:get/get.dart';
import '../../data/model/login_model.dart';
import '../../data/model/network_response.dart';
import '../../data/service/network_caller.dart';
import '../../data/utils/urls.dart';
import 'auth_controller.dart';

class SignInController extends GetxController {
  bool _inProgress = false;
  bool isSuccess = false;
  String? _errorMessage;

  String? get errorMessage => _errorMessage;
  bool get inProgress => _inProgress;

  Future<bool> signIn(String email, String password) async {
    _inProgress = true;
    update();
    Map<String, dynamic> requestBody = {"email": email, "password": password};
    final NetworkResponse response =
        await NetworkCaller.postRequest(url: Urls.login, body: requestBody);

    if (response.isSuccess) {
      LoginModel loginModel = LoginModel.fromJson(response.responseData);
      await AuthController.saveAccessToken(loginModel.token!);
      await AuthController.saveUserData(loginModel.data!);
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }
    _inProgress = false;
    update();
    return isSuccess;
  }
}
