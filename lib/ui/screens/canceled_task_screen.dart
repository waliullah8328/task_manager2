import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/ui/controllers/cancel_task_controller.dart';
import '../widgets/center_circular_progress_indicator.dart';
import '../widgets/list_of_task.dart';



class CanceledTaskScreen extends StatelessWidget {
   CanceledTaskScreen({super.key});
  final _controller = Get.find<CancelTaskController>();
  @override
  Widget build(BuildContext context) {
    _controller.getCanceledTaskList();
    return Obx(() => Visibility(
      visible: !_controller.getCancelTaskInProgress,
      replacement: const CenterCircularProgressIndicator(),

      child: ListView.separated(
        itemCount: _controller.canceledTaskList.length,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          return  ListOfTask(taskModel:_controller.canceledTaskList[index],onRefresh: (){
            _controller.getCanceledTaskList();

          },);
        },
      ),
    ));
  }


}