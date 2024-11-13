import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Importing intl for date formatting
import 'package:provider/provider.dart';
import 'package:task_manager/data/model/task_model.dart';

import '../controller/task_edit_delete_provider.dart';
import '../utils/app_colors.dart';

class ListOfTask extends StatelessWidget {
  final TaskModel taskModel;
  final VoidCallback onRefresh;

  ListOfTask({super.key, required this.taskModel, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

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
              taskModel.title ?? "",
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Text(taskModel.description ?? ""),
            Text("Date: ${taskModel.createdDate ?? ""}"),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildTaskStatusChip(),
                Wrap(
                  children: [
                    Visibility(
                      visible: !taskProvider.changeStatusInProgress,
                      replacement: Center(child: CircularProgressIndicator()),
                      child: IconButton(
                        onPressed: () => _onTapEditButton(context),
                        icon: const Icon(Icons.edit),
                      ),
                    ),
                    Visibility(
                      visible: !taskProvider.deleteTaskInProgress,
                      replacement: Center(child: CircularProgressIndicator()),
                      child: IconButton(
                        onPressed: () => _onTapDeleteButton(context),
                        icon: const Icon(Icons.delete),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onTapEditButton(BuildContext context) {
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
                  Provider.of<TaskProvider>(context, listen: false).changeStatus(
                    taskModel,
                    e,
                    onRefresh,
                  );
                  Navigator.pop(context);
                },
                title: Text(e),
                selected: taskModel.status == e,
                trailing: taskModel.status == e ? const Icon(Icons.check_circle) : null,
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

  void _onTapDeleteButton(BuildContext context) {
    Provider.of<TaskProvider>(context, listen: false).deleteTask(taskModel, onRefresh);
  }

  Widget _buildTaskStatusChip() {
    return Chip(
      label: Text(
        taskModel.status ?? "",
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      side: const BorderSide(color: AppColors.themeColor),
    );
  }
}
