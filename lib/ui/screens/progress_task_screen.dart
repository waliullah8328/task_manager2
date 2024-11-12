import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../controller/progress_task_provider.dart';
import '../widgets/center_circular_progress_indicator.dart';
import '../widgets/list_of_task.dart';


class ProgressTaskScreen extends StatelessWidget {
   const ProgressTaskScreen({super.key});



  @override
  Widget build(BuildContext context) {

    return Consumer<ProgressTaskProvider>(builder: (context, value, child) {
      return Visibility(
        visible: !value.getProgressTaskInProgress,
        replacement: const CenterCircularProgressIndicator(),

        child: ListView.separated(
          itemCount: value.progressTaskList.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            return  ListOfTask(taskModel:value.progressTaskList[index],onRefresh: (){
              value.getProgressTaskList();
            },);
          },
        ),
      );
    },);
  }


}