import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'package:task_manager/data/model/task_status_count_model.dart';

import '../../data/model/network_response.dart';
import '../../data/model/task_list_model.dart';

import '../../data/model/task_model.dart';
import '../../data/model/task_status_model.dart';
import '../../data/service/network_caller.dart';
import '../../data/utils/urls.dart';

class NewTaskListProvider with ChangeNotifier{

  NewTaskListProvider(){
    getNewTaskList();
    getTaskStatusCount();
  }


  final RxBool _inProgress = false.obs;
  final RxBool _isSuccess = false.obs;
  final RxString _errorMessage = "".obs;
  final RxBool _getTaskStatusCountInProgress = false.obs;
  final RxBool _isSuccessCount = false.obs;
  final RxString _countErrorMessage = "".obs;
  List<TaskModel> _taskList = [];
  List<TaskStatusModel> _taskStatusCountList = [];





  bool get inProgress => _inProgress.value;
  bool get isSuccess => _isSuccess.value;
  bool get isSuccessCount => _isSuccessCount.value;
  String get errorMessage => _errorMessage.value;
  String get countErrorMessage => _countErrorMessage.value;
  bool get getTaskStatusCountInProgress => _getTaskStatusCountInProgress.value;
  List<TaskModel> get taskList => _taskList;
  List<TaskStatusModel> get taskStatusCountList => _taskStatusCountList;







  Future<bool> getNewTaskList()async{

    _taskList.clear();
    _inProgress.value = true;
    notifyListeners();
    final NetworkResponse response = await NetworkCaller.getRequest(url: Urls.newTaskList);

    if (response.isSuccess) {
      final TaskListModel taskListModel = TaskListModel.fromJson(response.responseData);
      _taskList = taskListModel.taskList ?? [];
      _isSuccess.value = true;
    } else {
     _errorMessage.value = response.errorMessage;
     _isSuccess.value = false;
    }
    _inProgress.value= false;
    notifyListeners();
    return _isSuccess.value;

  }

  Future<bool> getTaskStatusCount()async{
    taskStatusCountList.clear();
    _getTaskStatusCountInProgress.value = true;
    notifyListeners();
    final NetworkResponse response = await NetworkCaller.getRequest(url: Urls.taskStatusCount);
    _getTaskStatusCountInProgress.value = false;
    notifyListeners();
    if (response.isSuccess) {
      final TaskStatusCountModel taskStatusCountModel = TaskStatusCountModel.fromJson(response.responseData);
      _taskStatusCountList = taskStatusCountModel.taskStatusCountList ?? [];
      _isSuccessCount.value = true;
    } else {
      _countErrorMessage.value = response.errorMessage;
      _isSuccessCount.value = false;
    }

    return _isSuccessCount.value;
  }


}