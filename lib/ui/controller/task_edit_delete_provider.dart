import 'package:flutter/material.dart';
import 'package:task_manager/data/model/network_response.dart';
import 'package:task_manager/data/model/task_model.dart';
import 'package:task_manager/data/service/network_caller.dart';
import 'package:task_manager/data/utils/urls.dart';

class TaskProvider extends ChangeNotifier {
  bool _changeStatusInProgress = false;
  bool _deleteTaskInProgress = false;
  bool get changeStatusInProgress => _changeStatusInProgress;
  bool get deleteTaskInProgress => _deleteTaskInProgress;

  Future<void> changeStatus(TaskModel task, String newStatus, VoidCallback onSuccess) async {
    _changeStatusInProgress = true;
    notifyListeners();

    final NetworkResponse response = await NetworkCaller.getRequest(
      url: Urls.updateTaskStatus(task.sId!, newStatus),
    );

    if (response.isSuccess) {
      onSuccess();
    } else {
      // handle failure (you could add error handling here)
    }

    _changeStatusInProgress = false;
    notifyListeners();
  }

  Future<void> deleteTask(TaskModel task, VoidCallback onSuccess) async {
    _deleteTaskInProgress = true;
    notifyListeners();

    final NetworkResponse response = await NetworkCaller.getRequest(
      url: Urls.deleteTask(task.sId!),
    );

    if (response.isSuccess) {
      onSuccess();
    } else {
      // handle failure (you could add error handling here)
    }

    _deleteTaskInProgress = false;
    notifyListeners();
  }
}
