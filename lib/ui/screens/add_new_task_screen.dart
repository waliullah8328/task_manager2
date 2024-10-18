import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:task_manager/data/model/network_response.dart';
import 'package:task_manager/data/service/network_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/widgets/center_circular_progress_indicator.dart';
import 'package:task_manager/ui/widgets/snacbar_message.dart';

import '../widgets/task_manager_app_bar.dart';


class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {


  bool _addNewTaskInProgress = false;

  final TextEditingController _titleTEController = TextEditingController();
  final TextEditingController _descriptionTEController = TextEditingController();


  final GlobalKey<FormState> _addNewFormKey = GlobalKey<FormState>();






  @override
  Widget build(BuildContext context) {

    return Scaffold(
      //appBar: TaskManagerAppBar(profileData: profileData,),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 42,),

              Text("Add New Task",style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),),
              const SizedBox(height: 24,),
              Form(
                key: _addNewFormKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _titleTEController,
                      //autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (String? value){
                        if(value?.trim().isEmpty ?? true){
                          return "Title is required";

                        }
                        return null;
                      },

                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        hintText: "Title"
                      ),
                    ),
                    const SizedBox(height: 8,),
                    TextFormField(
                      controller: _descriptionTEController,
                      maxLines: 5,
                      //autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (String? value){
                        if(value?.isEmpty ?? true){
                          return "Description is required";

                        }
                        return null;
                      },

                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                          hintText: "Decription"
                      ),
                    ),
                    const SizedBox(height: 16,),
                    Visibility(
                      visible: !_addNewTaskInProgress,
                        replacement: const CenterCircularProgressIndicator(),
                        child: ElevatedButton(onPressed: _addButton, child: const Icon(Icons.arrow_circle_right_outlined))),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }

  void _addButton() {

    if(!_addNewFormKey.currentState!.validate()){
      return;
    }
    _addNewTask();

  }


  Future<void> _addNewTask()async{
    _addNewTaskInProgress = true;
    setState(() {});
    Map<String, dynamic> requestBody = {
      "title":_titleTEController.text.trim(),
      "description": _descriptionTEController.text.trim(),
      "status":"New"
    };
    final NetworkResponse response = await NetworkCaller.postRequest(url: Urls.createTask,body: requestBody);
    _addNewTaskInProgress = false;
    setState(() {});

    if(response.isSuccess){
      _clearTextFields();
      showSnackBarMessage(context, "New task added");

    }
    else{
      showSnackBarMessage(context, response.errorMessage,true);

    }


  }

  void _clearTextFields(){
    _titleTEController.clear();
    _descriptionTEController.clear();
  }





}
