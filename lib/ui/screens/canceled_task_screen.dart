import 'package:flutter/material.dart';

import '../../data/model/network_response.dart';
import '../../data/model/task_list_model.dart';
import '../../data/model/task_model.dart';
import '../../data/service/network_caller.dart';
import '../../data/utils/urls.dart';
import '../widgets/center_circular_progress_indicator.dart';
import '../widgets/list_of_task.dart';
import '../widgets/snack_bar_message.dart';


class CanceledTaskScreen extends StatefulWidget {
  const CanceledTaskScreen({super.key});

  @override
  State<CanceledTaskScreen> createState() => _CanceledTaskScreenState();
}

class _CanceledTaskScreenState extends State<CanceledTaskScreen> {

  List taskItems = [];
  List<TaskModel> _canceledTaskList = [];
  bool _getCanceledTaskInProgress = false;
  bool isLoading = true;
  String status = "Canceled";



  callData() async {
    //var data = await taskListRequest("Canceled");
    setState(() {
      isLoading = false;
      //taskItems = data;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    callData();
    _getCanceledTaskList();
    super.initState();
  }

  Future<void> _getCanceledTaskList()async{
    _canceledTaskList.clear();
    _getCanceledTaskInProgress = true;
    setState(() {});
    final NetworkResponse response = await NetworkCaller.getRequest( url: Urls.canceledTaskList);
    _getCanceledTaskInProgress = false;
    setState(() {});
    if(response.isSuccess){
      final TaskListModel taskListModel = TaskListModel.fromJson(response.responseData);
      _canceledTaskList = taskListModel.taskList?? [];



    }else{
      showSnackBarMessage(context, response.errorMessage,true);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !_getCanceledTaskInProgress,
      replacement: const CenterCircularProgressIndicator(),

      child: ListView.separated(
        itemCount: _canceledTaskList.length,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          return  ListOfTask(taskModel:_canceledTaskList[index],onRefresh: (){
            _getCanceledTaskList();

          },);
        },
      ),
    );
  }

  deleteId(id){
    showDialog(
      context: context,
      builder: (context) {
        return  AlertDialog(
          title: Text("Delete!"),
          content: Text("Once you delete it, you can't get back!"),
          actions: [
            OutlinedButton(onPressed: ()async{
              Navigator.pop(context);
              setState(() {
                isLoading = true;
              });
              //await taskDeleteRequest(id);
              await callData();

            }, child: Text("Yes")),
            OutlinedButton(onPressed: ()async{
              Navigator.pop(context);


            }, child: Text("No")),
          ],
        );
      },);
  }
  statusChangeId(id){
    showModalBottomSheet(context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return Container(
            padding: const EdgeInsets.all(30),
            height: 370,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                RadioListTile(value: "New", groupValue: status, title: Text("New"),onChanged:(value){
                  setState((){
                    status = value.toString();

                  });


                }),
                RadioListTile(value: "Progress", groupValue: status, title: const Text("Progress"),onChanged:(value){
                  setState((){
                    status = value.toString();

                  });


                }),
                RadioListTile(value: "Completed", groupValue: status, title: const Text("Completed"),onChanged:(value){
                  setState((){
                    status = value.toString();

                  });


                }),

                RadioListTile(value: "Canceled", groupValue: status, title: const Text("Canceled"),onChanged:(value){
                  setState((){
                    status = value.toString();

                  });


                }),
                const SizedBox(height: 20,),

                Container(child: SizedBox(
                  width: 200, // Set the desired width
                  height: 45,
                  child: ElevatedButton(onPressed: (){
                    Navigator.pop(context);
                    setState(() {
                      isLoading = true;
                    });

                    //taskUpdateRequest(id,status);
                    callData();
                    setState((){
                      status = "Canceled";

                    });

                  }, child: Text("Confirm"),
                    style: ElevatedButton.styleFrom(


                    ),
                  ),
                ),)

              ],
            ),
          );
        },);
      },);
  }
}