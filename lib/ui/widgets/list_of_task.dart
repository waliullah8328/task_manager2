import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/data/model/task_model.dart';
import '../controllers/task_edit_delete_controller.dart';
import '../utils/app_colors.dart';

class ListOfTask extends StatelessWidget {
  final TaskModel taskModel;
  final VoidCallback onRefresh;

  const ListOfTask({
    super.key,
    required this.taskModel,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final TaskEditDeleteController controller = Get.put(
      TaskEditDeleteController(taskModel.obs),
      tag: taskModel.sId, // Use a unique tag for each task instance
    );

    return Obx(() {
      return Card(
        elevation: 0,
        color: Colors.white,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                controller.taskModel.value.title ?? "",
                style: Theme.of(context).textTheme.titleSmall,
              ),
              Text(controller.taskModel.value.description ?? ""),
              Text("Date: ${_formatDate(controller.taskModel.value.createdDate ?? "")}"),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildTaskStatusChip(controller),
                  Wrap(
                    children: [
                      Obx(() {
                        return Visibility(
                          visible: !controller.changeStatusInProgress,
                          replacement: const Center(child: CircularProgressIndicator()),
                          child: IconButton(
                            onPressed: () => _onTapEditButton(context, controller),
                            icon: const Icon(Icons.edit),
                          ),
                        );
                      }),
                      Obx(() {
                        return Visibility(
                          visible: !controller.deleteTaskInProgress,
                          replacement: const Center(child: CircularProgressIndicator()),
                          child: IconButton(
                            onPressed: controller.deleteTask,
                            icon: const Icon(Icons.delete),
                          ),
                        );
                      }),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  String _formatDate(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  void _onTapEditButton(BuildContext context, TaskEditDeleteController controller) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Status"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: ["New", "Completed", "Canceled", "Progress"].map((e) {
              return ListTile(
                onTap: () {
                  controller.changeStatus(e);

                  Navigator.pop(context);
                },
                title: Text(e),
                selected: controller.taskModel.value.status == e,
                trailing: controller.taskModel.value.status == e
                    ? const Icon(Icons.check_circle)
                    : null,
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTaskStatusChip(TaskEditDeleteController controller) {
    return Obx(() {
      return Chip(
        label: Text(
          controller.taskModel.value.status ?? "",
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        side: const BorderSide(color: AppColors.themeColor),
      );
    });
  }
}
