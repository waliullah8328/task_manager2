import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/ui/controllers/add_new_task_screen.dart';
import 'package:task_manager/ui/widgets/center_circular_progress_indicator.dart';
import '../widgets/task_manager_app_bar.dart';


class AddNewTaskScreen extends StatelessWidget {
   AddNewTaskScreen({super.key});

  final TextEditingController _titleTEController = TextEditingController();
  final TextEditingController _descriptionTEController = TextEditingController();
  final GlobalKey<FormState> _addNewFormKey = GlobalKey<FormState>();
  final _controller = Get.find<AddNewTaskController>();






  @override
  Widget build(BuildContext context) {

    return PopScope(
      canPop: false,
      onPopInvoked: (result){
       if(result){
         return;
       }
        Navigator.pop(context,_controller.shouldRefreshPreviousPage);

      },
      child: Scaffold(
        appBar: TaskManagerAppBar(),
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

                        validator: (String? value){
                          if(value?.isEmpty ?? true){
                            return "Description is required";
      
                          }
                          return null;
                        },
      
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                            hintText: "Description"
                        ),
                      ),
                      const SizedBox(height: 16,),
                       Obx(() => Visibility(
                            visible: !_controller.addNewTaskInProgress,
                              replacement: const CenterCircularProgressIndicator(),
                              child: ElevatedButton(onPressed: ()=>_addButton(context), child: const Icon(Icons.arrow_circle_right_outlined)))),


                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      
      ),
    );
  }

  void _addButton(BuildContext context) {

    if(!_addNewFormKey.currentState!.validate()){
      return;
    }
    _addNewTask(context);

  }




  Future<void> _addNewTask(BuildContext context)async{
    final result = await _controller.addNewTask(title: _titleTEController.text.trim(),description: _descriptionTEController.text.trim(),status: "New");

    if(result){

      _clearTextFields();

      //showSnackBarMessage(context, "New task added");
      Get.showSnackbar(const GetSnackBar(title: "Success",message: "New task added",duration: Duration(seconds: 3),));

    }
    else{
      //showSnackBarMessage(context, _controller.errorMessage,true);
      Get.showSnackbar(GetSnackBar(title: "Error",message: _controller.errorMessage,duration: const Duration(seconds: 3),));

    }


  }

  void _clearTextFields(){
    _titleTEController.clear();
    _descriptionTEController.clear();
  }





}
