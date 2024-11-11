import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';

import '../../data/model/network_response.dart';
import '../../data/service/network_caller.dart';
import '../../data/utils/urls.dart';
import '../widgets/snack_bar_message.dart';

class AddNewTaskController extends GetxController{


  final RxBool _addNewTaskInProgress = false.obs;
  final RxBool _shouldRefreshPreviousPage = false.obs;
  final RxBool _isSuccess = false.obs;
  RxString _errorMessage = "".obs;


  bool get addNewTaskInProgress => _addNewTaskInProgress.value;
  bool get shouldRefreshPreviousPage => _shouldRefreshPreviousPage.value;
  bool get isSuccess => _isSuccess.value;
  String get errorMessage => _errorMessage.value;



  Future<bool> addNewTask({title,description,status})async{
    _addNewTaskInProgress.value = true;
    update();
    Map<String, dynamic> requestBody = {
      "title":title,
      "description": description,
      "status":status
    };
    final NetworkResponse response = await NetworkCaller.postRequest(url: Urls.createTask,body: requestBody);


    if(response.isSuccess){
      _shouldRefreshPreviousPage.value = true;
      _isSuccess.value = true;


    }
    else{
      _errorMessage.value = response.errorMessage;
      _isSuccess.value = false;


    }
    _addNewTaskInProgress.value = false;
    update();
    return _isSuccess.value;


  }
}