import 'package:get/get.dart';

import '../../data/model/network_response.dart';
import '../../data/model/task_list_model.dart';
import '../../data/model/task_model.dart';
import '../../data/service/network_caller.dart';
import '../../data/utils/urls.dart';

class ProgressTaskController extends GetxController{

  List<TaskModel> _progressTaskList = [];
  final RxBool _getProgressTaskInProgress = false.obs;
  final RxBool _isSuccess = false.obs;
  final RxString _errorMessage = "".obs;

  bool get getProgressTaskInProgress => _getProgressTaskInProgress.value;
  bool get isSuccess => _isSuccess.value;
  String get errorMessage => _errorMessage.value;
  List<TaskModel> get progressTaskList => _progressTaskList;



  Future<bool> getProgressTaskList()async{
    _progressTaskList.clear();
    _getProgressTaskInProgress.value = true;
    update();
    final NetworkResponse response = await NetworkCaller.getRequest( url: Urls.progressTaskList);

    if(response.isSuccess){
      final TaskListModel taskListModel = TaskListModel.fromJson(response.responseData);
      _progressTaskList = taskListModel.taskList?? [];
      _isSuccess.value = true;



    }else{
      _errorMessage.value = response.errorMessage;
      _isSuccess.value = false;

    }
    _getProgressTaskInProgress.value = false;
    update();
    return _isSuccess.value;

  }

}