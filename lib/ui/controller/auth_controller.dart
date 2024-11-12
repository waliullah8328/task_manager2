import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/data/model/user_model.dart';

class AuthController{

 static const String _accessToken = "accessToken";
 static const String _userDataKey = "userData";

  static String? accessToken;
  static UserModel? userData;

  static Future<void> saveAccessToken(String token)async{
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  await sharedPreferences.setString(_accessToken, token);
  accessToken = token;
  }

 static Future<void> saveUserData(UserModel userModel)async{
   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
   await sharedPreferences.setString(_userDataKey,jsonEncode(userModel.toJson()));
   userData =userModel;
 }

 static Future<String?> getAccessToken()async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString(_accessToken);
    accessToken = token;
    return token;
  }



 static Future<UserModel?> getUserData()async{
   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
   String? userEncodedData = sharedPreferences.getString(_userDataKey);
   if(userEncodedData == null){
     return null;
   }
   UserModel userModel= UserModel.fromJson(jsonDecode(userEncodedData!));
   userData = userModel;
   return userModel;
 }
  static bool isLogin(){
    return accessToken != null;
  }

  static Future<void> clearUserData()async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
     await sharedPreferences.clear();
     accessToken == null;
  }
}