import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/ui/controllers/completed_task_controller.dart';
import '../widgets/center_circular_progress_indicator.dart';
import '../widgets/list_of_task.dart';


class CompletedTaskScreen extends StatelessWidget {
   CompletedTaskScreen({super.key});


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


}
