import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/data/model/task_status_model.dart';
import 'package:task_manager/data/routes/route_name.dart';

import '../controller/new_task_list_provider.dart';
import '../widgets/list_of_task.dart';
import '../widgets/task_summary_card.dart';


class NewTaskScreen extends StatelessWidget {
  const NewTaskScreen({super.key});



  @override
  Widget build(BuildContext context) {
    final newTaskProvider = Provider.of<NewTaskListProvider>(context,listen: false);


    return Scaffold(
      body: Column(
        children: [
          Consumer<NewTaskListProvider>(builder: (context, value, child) {
            return _buildSummarySection(value.taskStatusCountList);

          },),
           // Task summary section
          Expanded(
            child:Consumer<NewTaskListProvider>(builder: (context, value, child) {
              return Visibility(
                visible: !value.inProgress,
                replacement: const Center(child: CircularProgressIndicator()),
                child: ListView.separated(
                  itemCount: value.taskList.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    return ListOfTask(
                      taskModel: value.taskList[index],
                      onRefresh: () {
                        value.getNewTaskList();
                        value.getTaskStatusCount();
                      },
                    );
                  },
                ),
              );
            },) ,

          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onTapAddButton(context,newTaskProvider), // Handle add new task button
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

  Future<void> _onTapAddButton(BuildContext context,controller) async {
    /*
    final bool? shouldRefresh = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>  AddNewTaskScreen(),
      ),
    );*/

    final bool shouldRefresh = await Get.toNamed(RouteName.addNewTaskScreen);

    if (shouldRefresh == true) {
      controller.getNewTaskList();
      controller.getTaskStatusCount(); // Refresh task status count as well
    }
  }


}
