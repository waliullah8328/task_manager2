import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart'; // Importing intl for date formatting
import 'package:task_manager/data/model/network_response.dart';
import 'package:task_manager/data/model/task_model.dart';
import 'package:task_manager/data/service/network_caller.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';

import '../../data/utils/urls.dart';
import '../utils/app_colors.dart';

class ListOfTask extends StatefulWidget {
   ListOfTask({
    super.key,
      this.deleteItems,  this.statusChange, required this.taskModel, required this.onRefresh,
  });

  final TaskModel taskModel;
  final Function(String)?  deleteItems,statusChange;
  final VoidCallback onRefresh;
  bool _changeStatusInProgress = false;
  bool _deleteTaskInProgress = false;


  @override
  State<ListOfTask> createState() => _ListOfTaskState();
}

class _ListOfTaskState extends State<ListOfTask> {
  String _selectedStatus = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedStatus = widget.taskModel.status!;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.taskModel.title??"",
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Text(widget.taskModel.description??""),
            Text("Date: ${widget.taskModel.createdDate ?? ""}" ), // Display formatted date
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildTaskStatusChip(),
                Wrap(
                  children: [
                    Visibility(
                      visible: widget._changeStatusInProgress == false,
                      replacement: Center(child: CircularProgressIndicator(),),
                      child: IconButton(
                        onPressed: _onTapEditButton/*(){
                          // widget.statusChange(taskItem["_id"]);
                        }*/,
                        icon: const Icon(Icons.edit),
                      ),
                    ),
                    Visibility(
                      visible: widget._deleteTaskInProgress == false,
                      replacement: Center(child: CircularProgressIndicator(),),
                      child: IconButton(
                        onPressed: (){
                          deleteTask();
                        },
                        icon: const Icon(Icons.delete),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );;
  }

  // Helper method to format the date
  String _formatDate(String dateString) {
    DateTime dateTime = DateTime.parse(dateString); // Parse the date string
    return DateFormat('yyyy-MM-dd').format(dateTime); // Format to 'yyyy-MM-dd'
  }

  void _onTapEditButton() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Status"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: ["New", "Completed", "Canceled", "Progress"].map((e) {
              return ListTile(
                onTap: () {
                  changeStatus(e);
                  Navigator.pop(context);
                },
                title: Text(e),
                selected: _selectedStatus == e,
                trailing: _selectedStatus == e? const Icon(Icons.check_circle):null,
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),

          ],
        );
      },
    );
  }

  void _onTapDeleteButton() {
    // Handle delete button tap


  }

  Widget _buildTaskStatusChip() {
    return Chip(
      label: Text(
       widget.taskModel.status??"",
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      side: const BorderSide(color: AppColors.themeColor),
    );
  }

  Future<void> changeStatus(String newStatus)async{
    widget._changeStatusInProgress = true;
    setState(() {});
    final NetworkResponse response = await NetworkCaller.getRequest(url: Urls.updateTaskStatus(widget.taskModel.sId!, newStatus));
    if(response.isSuccess){
      widget.onRefresh();

    }else{
      widget._changeStatusInProgress = false;
      setState(() {

      });
      showSnackBarMessage(context, response.errorMessage);
    }

  }

  Future<void> deleteTask()async{
    widget._deleteTaskInProgress = true;
    setState(() {});
    final NetworkResponse response = await NetworkCaller.getRequest(url: Urls.deleteTask(widget.taskModel.sId!,));
    if(response.isSuccess){
      widget.onRefresh();

    }else{
      widget._deleteTaskInProgress = false;
      setState(() {

      });
      showSnackBarMessage(context, response.errorMessage);
    }

  }

}
