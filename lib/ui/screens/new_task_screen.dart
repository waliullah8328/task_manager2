import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/data/model/network_response.dart';
import 'package:task_manager/data/model/task_list_model.dart';
import 'package:task_manager/data/model/task_model.dart';
import 'package:task_manager/data/service/network_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/widgets/center_circular_progress_indicator.dart';
import 'package:task_manager/ui/widgets/snacbar_message.dart';

import '../widgets/list_of_task.dart';
import '../widgets/task_summary_card.dart';
import 'add_new_task_screen.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  List taskItems = [];
  List<TaskModel> _newTaskList = [];
  bool _getNewTaskInProgress = false;
  String status = "New";



  @override
  void initState() {
    super.initState();
   _getNewTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Column(
          children: [
            //_buildSummarySection(taskCountList), // Task summary section
            Visibility(
              visible: !_getNewTaskInProgress,
              replacement: const CenterCircularProgressIndicator(),
            
              child: Expanded(
                child: ListView.separated(
                  itemCount: _newTaskList.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    return  ListOfTask(taskModel:_newTaskList[index],onRefresh: (){
                      _getNewTaskList();
                    },);
                  },
                ),
              ),
            ),
          ],
        ),

      floatingActionButton: FloatingActionButton(
        onPressed: _onTapAddButton, // Handle add new task button
        child: const Icon(Icons.add),
      ),
    );
  }

  // Build the summary section dynamically based on taskCountList
  Widget _buildSummarySection(List taskCountList) {
    // Define the desired order for the task statuses
    final List<String> order = ["New", "Completed", "Progress", "Canceled"];

    // Sort the taskCountList according to the predefined order
    List sortedTaskCountList = taskCountList
        .where((task) => order.contains(task["_id"])) // Filter only relevant tasks
        .toList()
      ..sort((a, b) => order.indexOf(a["_id"]).compareTo(order.indexOf(b["_id"])));

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: sortedTaskCountList.map((task) {
            return TaskSummaryCard(
              title: task["_id"] ?? "Unknown", // Dynamic title
              count: task["sum"] ?? 0, // Dynamic count
            );
          }).toList(),
        ),
      ),
    );
  }



  // Function to handle adding new tasks
  Future<void> _onTapAddButton() async {
    final bool? shouldRefresh = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddNewTaskScreen(),
      ),
    );

    if(shouldRefresh == true){
      _getNewTaskList();

    }


  }

  // Handle task deletion with confirmation dialog
  deleteId(id) {
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
                setState(() {
                  //isLoading = true; // Set loading state
                });
                //await taskDeleteRequest(id); // Delete the task
                //await callData(); // Refresh the data
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

  // Handle status change with modal bottom sheet
  statusChangeId(id) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
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
                    groupValue: status,
                    title: const Text("New"),
                    onChanged: (value) {
                      setModalState(() {
                        status = value.toString(); // Update local status
                      });
                    },
                  ),
                  RadioListTile(
                    value: "Progress",
                    groupValue: status,
                    title: const Text("Progress"),
                    onChanged: (value) {
                      setModalState(() {
                        status = value.toString();
                      });
                    },
                  ),
                  RadioListTile(
                    value: "Completed",
                    groupValue: status,
                    title: const Text("Completed"),
                    onChanged: (value) {
                      setModalState(() {
                        status = value.toString();
                      });
                    },
                  ),
                  RadioListTile(
                    value: "Canceled",
                    groupValue: status,
                    title: const Text("Canceled"),
                    onChanged: (value) {
                      setModalState(() {
                        status = value.toString();
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  // Confirm button
                  SizedBox(
                    width: 200,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context); // Close modal
                        setState(() {
                          //isLoading = true; // Set loading state
                        });
                        //await taskUpdateRequest(id, status); // Update task status
                       // await callData(); // Refresh the data
                        setState(() {
                          status = "New"; // Reset status
                        });
                      },
                      child: const Text("Confirm"),
                      style: ElevatedButton.styleFrom(),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _getNewTaskList()async{
    _newTaskList.clear();
    _getNewTaskInProgress = true;
    setState(() {});
    final NetworkResponse response = await NetworkCaller.getRequest( url: Urls.newTaskList);
    _getNewTaskInProgress = false;
    setState(() {});
    if(response.isSuccess){
      final TaskListModel taskListModel = TaskListModel.fromJson(response.responseData);
      _newTaskList = taskListModel.taskList?? [];



    }else{
      showSnackBarMessage(context, response.errorMessage,true);
    }

  }




}
