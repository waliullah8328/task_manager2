import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/ui/controllers/progress_task_controller.dart';
import '../widgets/center_circular_progress_indicator.dart';
import '../widgets/list_of_task.dart';


class ProgressTaskScreen extends StatelessWidget {
   ProgressTaskScreen({super.key});

  final _controller = Get.find<ProgressTaskController>();




  @override
  Widget build(BuildContext context) {
    _controller.getProgressTaskList();
    return Obx(() => Visibility(
      visible: !_controller.getProgressTaskInProgress,
      replacement: const CenterCircularProgressIndicator(),
    
      child: ListView.separated(
        itemCount: _controller.progressTaskList.length,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          return  ListOfTask(taskModel:_controller.progressTaskList[index],onRefresh: (){
            _controller.getProgressTaskList();
          },);
        },
      ),
    ));
  }


}