import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/model/network_response.dart';
import '../../data/model/user_model.dart';
import '../../data/service/network_caller.dart';
import '../../data/utils/urls.dart';
import 'auth_controller.dart';

class ProfileController extends GetxController{

  final _emailTEController = TextEditingController();
  final _firstNameTEController = TextEditingController();
  final _lastNameTEController = TextEditingController();
  final _phoneTEController = TextEditingController();
  final _passwordTEController = TextEditingController();

  XFile? _selectedImage;
  final RxBool _updateProfileInProgress = false.obs;

  TextEditingController get emailTEController => _emailTEController;
  TextEditingController get firstNameTEController => _firstNameTEController;
  TextEditingController get lastNameTEController => _lastNameTEController;
  TextEditingController get phoneTEController => _phoneTEController;
  TextEditingController get passwordTEController=> _passwordTEController;

  XFile? get selectedImage => _selectedImage;
  bool get updateProfileInProgress => _updateProfileInProgress.value;

  void setUserData() {
    if (AuthController.userData != null) {
      _emailTEController.text = AuthController.userData!.email ?? "";
      _firstNameTEController.text = AuthController.userData!.firstName ?? "";
      _lastNameTEController.text = AuthController.userData!.lastName ?? "";
      _phoneTEController.text = AuthController.userData!.mobile ?? "";
    } else {
      // Handle the case when userData is null, e.g., setting default values or showing an error message
      _emailTEController.text = "";
      _firstNameTEController.text = "";
      _lastNameTEController.text = "";
      _phoneTEController.text = "";
      print("Warning: User data is null. Ensure that user data is loaded before accessing it.");
    }
  }


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    setUserData();
    updateProfile();
  }



  Future<void> updateProfile()async{
    _updateProfileInProgress.value = true;
    update();
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
    _updateProfileInProgress.value =false;
    update();
    if(response.isSuccess){
      UserModel userModel = UserModel.fromJson(requestBody);
      AuthController.saveUserData(userModel);
      Get.showSnackbar(const GetSnackBar(title: "Success",message: "Profile has been updated",duration: Duration(seconds: 2),));

      //showSnackBarMessage(context, "Profile has been updated");


    }else{
      Get.showSnackbar(GetSnackBar(title: "Error",message: response.errorMessage,duration: const Duration(seconds: 2),));

      //showSnackBarMessage(context, response.errorMessage);

    }


  }

  String getSelectedPhotoTile(){
    if(_selectedImage!= null){
      return _selectedImage!.name;
    }
    return "Selected Photo";
  }

  Future<void> selectImage()async{
    ImagePicker _imagePicker = ImagePicker();
    XFile? pickedImage = await _imagePicker.pickImage(source: ImageSource.gallery);

    if(pickedImage != null){
      _selectedImage = pickedImage;
     update();

    }
  }




}