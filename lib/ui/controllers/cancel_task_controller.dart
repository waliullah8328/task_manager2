import 'package:get/get.dart';

import '../../data/model/network_response.dart';
import '../../data/model/task_list_model.dart';
import '../../data/model/task_model.dart';
import '../../data/service/network_caller.dart';
import '../../data/utils/urls.dart';

class CancelTaskController extends GetxController{

  List<TaskModel> _canceledTaskList = [];
  final RxBool _getCanceledTaskInProgress = false.obs;
  final RxBool _isSuccess = false.obs;
  final RxString _errorMessage = "".obs;


  bool get getCancelTaskInProgress => _getCanceledTaskInProgress.value;
  bool get isSuccess => _isSuccess.value;
  String get errorMessage => _errorMessage.value;
  List<TaskModel> get canceledTaskList => _canceledTaskList;



  Future<bool> getCanceledTaskList()async{
    _canceledTaskList.clear();
    _getCanceledTaskInProgress.value = true;
   update();
    final NetworkResponse response = await NetworkCaller.getRequest( url: Urls.canceledTaskList);

    if(response.isSuccess){
      final TaskListModel taskListModel = TaskListModel.fromJson(response.responseData);
      _canceledTaskList = taskListModel.taskList?? [];
      _isSuccess.value = true;



    }else{
      _errorMessage.value = response.errorMessage;
      _isSuccess.value = false;
    }
    _getCanceledTaskInProgress.value = false;
    update();
    return _isSuccess.value;

  }

}