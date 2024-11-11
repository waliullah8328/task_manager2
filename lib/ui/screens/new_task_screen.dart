import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/data/model/task_status_model.dart';
import 'package:task_manager/ui/controllers/new_task_list_controller.dart';

import '../widgets/list_of_task.dart';
import '../widgets/task_summary_card.dart';
import 'add_new_task_screen.dart';

class NewTaskScreen extends StatelessWidget {
  NewTaskScreen({super.key});

  final NewTaskListController _controller = Get.find<NewTaskListController>();
  final String status = "New";

  @override
  Widget build(BuildContext context) {
    _controller.getNewTaskList();
    _controller.getTaskStatusCount();

    return Scaffold(
      body: Column(
        children: [
          GetBuilder<NewTaskListController>(
            builder: (controller) {
              return _buildSummarySection(controller.taskStatusCountList);
            },
          ), // Task summary section
          Expanded(
            child: GetBuilder<NewTaskListController>(
              builder: (controller) {
                return Visibility(
                  visible: !controller.inProgress,
                  replacement: const Center(child: CircularProgressIndicator()),
                  child: ListView.separated(
                    itemCount: controller.taskList.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      return ListOfTask(
                        taskModel: controller.taskList[index],
                        onRefresh: () {
                          _controller.getNewTaskList();
                          _controller.getTaskStatusCount();
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onTapAddButton(context), // Handle add new task button
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSummarySection(List<TaskStatusModel> taskStatusCountList) {
    final List<String> order = ["New", "Completed", "Progress", "Canceled"];

    List<TaskStatusModel> sortedTaskStatusCountList = taskStatusCountList
        .where((task) => order.contains(task.sId)) // Filter only relevant tasks
        .toList()
      ..sort((a, b) => order.indexOf(a.sId!).compareTo(order.indexOf(b.sId!)));

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: sortedTaskStatusCountList.map((task) {
            return TaskSummaryCard(
              title: task.sId ?? "Unknown", // Display the task status (sId)
              count: task.sum ?? 0,          // Display the count (sum)
            );
          }).toList(),
        ),
      ),
    );
  }

  Future<void> _onTapAddButton(BuildContext context) async {
    final bool? shouldRefresh = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>  AddNewTaskScreen(),
      ),
    );

    if (shouldRefresh == true) {
      _controller.getNewTaskList();
      _controller.getTaskStatusCount(); // Refresh task status count as well
    }
  }

  void deleteId(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete!"),
          content: const Text("Once you delete it, you can't get it back!"),
          actions: [
            OutlinedButton(
              onPressed: () async {
                Navigator.pop(context); // Close dialog
                // Add your delete functionality here
              },
              child: const Text("Yes"),
            ),
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
              },
              child: const Text("No"),
            ),
          ],
        );
      },
    );
  }

  void statusChangeId(BuildContext context, String id) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        String localStatus = status; // Define a local status variable

        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(30),
              height: 370,
              child: Column(
                children: [
                  // Radio buttons for status selection
                  RadioListTile(
                    value: "New",
                    groupValue: localStatus,
                    title: const Text("New"),
                    onChanged: (value) {
                      setModalState(() {
                        localStatus = value.toString();
                      });
                    },
                  ),
                  RadioListTile(
                    value: "Progress",
                    groupValue: localStatus,
                    title: const Text("Progress"),
                    onChanged: (value) {
                      setModalState(() {
                        localStatus = value.toString();
                      });
                    },
                  ),
                  RadioListTile(
                    value: "Completed",
                    groupValue: localStatus,
                    title: const Text("Completed"),
                    onChanged: (value) {
                      setModalState(() {
                        localStatus = value.toString();
                      });
                    },
                  ),
                  RadioListTile(
                    value: "Canceled",
                    groupValue: localStatus,
                    title: const Text("Canceled"),
                    onChanged: (value) {
                      setModalState(() {
                        localStatus = value.toString();
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  // Confirm button
                  SizedBox(
                    width: 200,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context); // Close modal
                        _controller.getTaskStatusCount(); // Refresh the task status count
                        // Add your status update functionality here
                      },
                      child: const Text("Confirm"),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
