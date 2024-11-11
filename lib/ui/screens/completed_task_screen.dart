import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/ui/controllers/completed_task_controller.dart';
import '../widgets/center_circular_progress_indicator.dart';
import '../widgets/list_of_task.dart';


class CompletedTaskScreen extends StatelessWidget {
   CompletedTaskScreen({super.key});



  String status = "Completed";
  final _controller = Get.find<CompletedTaskController>();





  @override
  Widget build(BuildContext context) {
    _controller.getCompletedTaskList();
    return   Obx(() =>
        Visibility(
      visible: !_controller.getCompletedTaskInProgress,
      replacement: const CenterCircularProgressIndicator(),

      child: ListView.separated(
        itemCount: _controller.completedTaskList.length,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          return  ListOfTask(taskModel:_controller.completedTaskList[index],onRefresh: (){
            _controller.getCompletedTaskList();
          },);
        },
      ),
    ));
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

                ],
              ),
            );
          },
        );
      },
    );
  }
}
