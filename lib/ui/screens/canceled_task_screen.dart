import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../controller/cancel_task_provider.dart';
import '../widgets/center_circular_progress_indicator.dart';
import '../widgets/list_of_task.dart';



class CanceledTaskScreen extends StatelessWidget {
   const CanceledTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {

    //final cancelTaskProvider = Provider.of<CancelTaskProvider>(context,listen: false);
    //cancelTaskProvider.getCanceledTaskList();
    return  Consumer<CancelTaskProvider>(builder: (context, value, child) {
      return Visibility(
        visible: !value.getCancelTaskInProgress,
        replacement: const CenterCircularProgressIndicator(),

        child: ListView.separated(
          itemCount: value.canceledTaskList.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            return  ListOfTask(taskModel:value.canceledTaskList[index],onRefresh: (){
              value.getCanceledTaskList();

            },);
          },
        ),
      );
    },);
  }


}