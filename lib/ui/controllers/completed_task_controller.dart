import 'package:get/get.dart';

import '../../data/model/network_response.dart';
import '../../data/model/task_list_model.dart';
import '../../data/model/task_model.dart';
import '../../data/service/network_caller.dart';
import '../../data/utils/urls.dart';

class CompletedTaskController extends GetxController{


  List<TaskModel> _completedTaskList = [];
  final RxBool _getCompletedTaskInProgress = false.obs;
  final RxBool _isSuccess = false.obs;
  final RxString _errorMessage = "".obs;


  bool get getCompletedTaskInProgress => _getCompletedTaskInProgress.value;
  bool get isSuccess => _isSuccess.value;
  String get errorMessage => _errorMessage.value;
  List<TaskModel> get completedTaskList => _completedTaskList;


  Future<bool> getCompletedTaskList()async{
    _completedTaskList.clear();
    _getCompletedTaskInProgress.value = true;
    update();
    final NetworkResponse response = await NetworkCaller.getRequest( url: Urls.completedTaskList);

    if(response.isSuccess){
      final TaskListModel taskListModel = TaskListModel.fromJson(response.responseData);
      _completedTaskList = taskListModel.taskList?? [];
      _isSuccess.value = true;



    }else{
      _errorMessage.value = response.errorMessage;
      _isSuccess.value = false;
    }
    _getCompletedTaskInProgress.value = false;
    update();
    return _isSuccess.value;

  }


}