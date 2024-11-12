import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../controller/completed_task_provider.dart';
import '../widgets/center_circular_progress_indicator.dart';
import '../widgets/list_of_task.dart';


class CompletedTaskScreen extends StatelessWidget {
   const CompletedTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Consumer<CompletedTaskProvider>(builder: (context, value, child) {
      return Visibility(
        visible: !value.getCompletedTaskInProgress,
        replacement: const CenterCircularProgressIndicator(),

        child: ListView.separated(
          itemCount: value.completedTaskList.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            return  ListOfTask(taskModel:value.completedTaskList[index],onRefresh: (){
              value.getCompletedTaskList();
            },);
          },
        ),
      );
    },);
  }


}
