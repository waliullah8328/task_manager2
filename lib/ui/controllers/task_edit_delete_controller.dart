import 'package:get/get.dart';
import 'package:task_manager/data/model/network_response.dart';
import 'package:task_manager/data/model/task_model.dart';
import 'package:task_manager/data/service/network_caller.dart';
import '../../data/utils/urls.dart';

class TaskEditDeleteController extends GetxController {
  final _changeStatusInProgress = false.obs;
  final _deleteTaskInProgress = false.obs;
  final Rx<TaskModel> taskModel;

  bool get changeStatusInProgress => _changeStatusInProgress.value;
  bool get deleteTaskInProgress => _deleteTaskInProgress.value;

  TaskEditDeleteController(this.taskModel);

  Future<void> changeStatus(String newStatus) async {
    _changeStatusInProgress.value = true;
    final NetworkResponse response = await NetworkCaller.getRequest(
      url: Urls.updateTaskStatus(taskModel.value.sId!, newStatus),
    );
    if (response.isSuccess) {
      taskModel.value.status = newStatus;
      taskModel.refresh(); // Refresh the task model for UI updates
      Get.snackbar('Status Update', 'Task status updated successfully.');
    } else {
      Get.snackbar('Error', response.errorMessage);
    }
    _changeStatusInProgress.value = false;
  }

  Future<void> deleteTask() async {
    _deleteTaskInProgress.value = true;
    final NetworkResponse response = await NetworkCaller.getRequest(
      url: Urls.deleteTask(taskModel.value.sId!),
    );
    if (response.isSuccess) {
      Get.back(); // Optionally, close the page or perform another action on success
      Get.snackbar('Delete', 'Task deleted successfully.');
    } else {
      Get.snackbar('Error', response.errorMessage);
    }
    _deleteTaskInProgress.value = false;
  }
}
