import 'package:flutter/material.dart';


import '../../data/model/network_response.dart';
import '../../data/model/task_list_model.dart';
import '../../data/model/task_model.dart';
import '../../data/service/network_caller.dart';
import '../../data/utils/urls.dart';
import '../widgets/center_circular_progress_indicator.dart';
import '../widgets/list_of_task.dart';
import '../widgets/snacbar_message.dart';
import '../widgets/task_card.dart';

class ProgressTaskScreen extends StatefulWidget {
  const ProgressTaskScreen({super.key});

  @override
  State<ProgressTaskScreen> createState() => _ProgressTaskScreenState();
}

class _ProgressTaskScreenState extends State<ProgressTaskScreen> {

  List<TaskModel> _progressTaskList = [];
  bool _getProgressTaskInProgress = false;
  bool isLoading = true;
  String status = "New";




  Future<void> _getProgressTaskList()async{
    _progressTaskList.clear();
    _getProgressTaskInProgress = true;
    setState(() {});
    final NetworkResponse response = await NetworkCaller.getRequest( url: Urls.progressTaskList);
    _getProgressTaskInProgress = false;
    setState(() {});
    if(response.isSuccess){
      final TaskListModel taskListModel = TaskListModel.fromJson(response.responseData);
      _progressTaskList = taskListModel.taskList?? [];



    }else{
      showSnackBarMessage(context, response.errorMessage,true);
    }

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getProgressTaskList();
  }


  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !_getProgressTaskInProgress,
      replacement: const CenterCircularProgressIndicator(),
    
      child: ListView.separated(
        itemCount: _progressTaskList.length,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          return  ListOfTask(taskModel:_progressTaskList[index],onRefresh: (){
            _getProgressTaskList();
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
                isLoading= true;
              });
              //await taskDeleteRequest(id);
              //await callData();

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
                    //callData();
                    setState((){
                      status = "Progress";

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