import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager/data/model/network_response.dart';
import 'package:task_manager/data/model/user_model.dart';
import 'package:task_manager/data/service/network_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/controllers/auth_controller.dart';
import 'package:task_manager/ui/widgets/snacbar_message.dart';

import '../widgets/task_manager_app_bar.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  final _emailTEController = TextEditingController();
  final _firstNameTEController = TextEditingController();
  final _lastNameTEController = TextEditingController();
  final _phoneTEController = TextEditingController();
  final _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  XFile? _selectedImage;
  bool _updateProfileInProgress = false;

  void setUserData(){
    _emailTEController.text = AuthController.userData!.email??"";
    _firstNameTEController.text = AuthController.userData!.firstName??"";
    _lastNameTEController.text = AuthController.userData!.lastName??"";
    _phoneTEController.text = AuthController.userData!.mobile??"";

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setUserData();
  }
  @override
  Widget build(BuildContext context) {




    return  Scaffold(
      appBar: TaskManagerAppBar(isProfileOpen: true,),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 48,),
                Text(
                  "Update Profile",
                  style:Theme.of(context).textTheme.displaySmall
                      ?.copyWith(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 32,),
                _buildPhotoPicker(),
                const SizedBox(height: 16,),
                TextFormField(
                  enabled: false,
                  controller: _emailTEController,
                  decoration: InputDecoration(
                    hintText: "Email",
                  ),
                  validator: (String? value){
                    if(value?.trim().isEmpty?? true){
                      return "Enter your email";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8,),
                TextFormField(
                  controller: _firstNameTEController,
                  decoration: InputDecoration(
                    hintText: "First Name",
                  ),
                  validator: (String? value){
                    if(value?.trim().isEmpty?? true){
                      return "Enter your first name";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8,),
                TextFormField(
                  controller: _lastNameTEController,
                  decoration: InputDecoration(
                    hintText: "Last Name",
                  ),
                  validator: (String? value){
                    if(value?.trim().isEmpty?? true){
                      return "Enter your last name";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8,),
                TextFormField(
                  controller: _phoneTEController,
                  decoration: InputDecoration(
                    hintText: "Phone Number",
            
                  ),
                  validator: (String? value){
                    if(value?.trim().isEmpty?? true){
                      return "Enter your phone number";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8,),
                TextFormField(
                  controller: _passwordTEController,
                  decoration: InputDecoration(
                    hintText: "Password",
            
                  ),

                ),
                const SizedBox(height: 16,),
                Visibility(
                  visible: _updateProfileInProgress == false,
                  replacement: const Center(child: CircularProgressIndicator(),),
                  child: ElevatedButton(onPressed: (){
                    if(_formKey.currentState!.validate()){
                      updateProfile();
                      setUserData();

                    }
                  }, child: Icon(Icons.arrow_circle_right_outlined)),
                ),
                const SizedBox(height: 16,),
            
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoPicker() => Container(
    height: 50,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: Colors.white

    ),
    child: Row(
      children: [
        GestureDetector(
          onTap: (){
            _selectImage();
          },
          child: Container(
            width: 100,
            height: 50,
            decoration: const BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8)
              ),
            ),
            alignment: Alignment.center,
            child: const Text("Photos",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 16),),
          ),
        ),
        const SizedBox(width: 8,),
        Text(_getSelectedPhotoTile()),
      ],
    ),
  );

  String _getSelectedPhotoTile(){
    if(_selectedImage!= null){
      return _selectedImage!.name;
    }
    return "Selected Photo";
  }

  Future<void> _selectImage()async{
    ImagePicker _imagePicker = ImagePicker();
    XFile? pickedImage = await _imagePicker.pickImage(source: ImageSource.gallery);

    if(pickedImage != null){
      _selectedImage = pickedImage;
      setState(() {});

    }
  }

  Future<void> updateProfile()async{
    _updateProfileInProgress = true;
    setState(() {});
    Map<String,dynamic> requestBody = {
      "email":_emailTEController.text.trim(),
      "firstName":_firstNameTEController.text,
      "lastName":_lastNameTEController.text,
      "mobile":_phoneTEController.text,


    };
    if(_passwordTEController.text.isNotEmpty){
      requestBody["password"] = _passwordTEController.text;
    }
    if(_selectedImage != null){
      List<int> imageBytes = await _selectedImage!.readAsBytes();
      String convertedImage = base64Encode(imageBytes);
      requestBody["photo"]= convertedImage;
    }
    final NetworkResponse response = await NetworkCaller.postRequest(url: Urls.profileUpdate,body: requestBody);
    _updateProfileInProgress =false;
    setState(() {});
    if(response.isSuccess){
      UserModel userModel = UserModel.fromJson(requestBody);
      AuthController.saveUserData(userModel);
      showSnackBarMessage(context, "Profile has been updated");


    }else{

      showSnackBarMessage(context, response.errorMessage);

    }


  }
}
