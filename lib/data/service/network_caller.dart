import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart';
import 'package:task_manager/app.dart';
import 'package:task_manager/ui/controllers/auth_controller.dart';
import 'package:task_manager/ui/screens/sign_in_screen.dart';

import '../model/network_response.dart';

class NetworkCaller {
  static Future<NetworkResponse> getRequest({required String url}) async {
    Uri uri = Uri.parse(url);
    debugPrint(url);
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "token": AuthController.accessToken.toString()
    };

    try {
      final Response response = await get(uri,headers: headers);
      printRequest(url,null, headers);
      printResponse(url, response);

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        return NetworkResponse(
            isSuccess: true,
            statusCode: response.statusCode,
            responseData: decodedData);
      }
      else if (response.statusCode == 401) {
        _moveToLogin();
        return NetworkResponse(
            isSuccess: false,
            statusCode: response.statusCode,
            errorMessage: "UnAuthenticate User!");
      }

      else {
        return NetworkResponse(
            isSuccess: false, statusCode: response.statusCode);
      }
    } catch (e) {
      return NetworkResponse(
          isSuccess: false, statusCode: -1, errorMessage: e.toString());
    }
  }

  static Future<NetworkResponse> postRequest(
      {required String url, Map<String, dynamic>? body}) async {
    Uri uri = Uri.parse(url);
    debugPrint(url);

    Map<String, String> headers = {
      "Content-Type": "application/json",
      "token": AuthController.accessToken.toString()
    };

    try {
      final Response response =
          await post(uri, body: jsonEncode(body), headers: headers);
      printRequest(url, body, headers);
      printResponse(url, response);

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);

        if (decodedData["status"] == "fail") {
          return NetworkResponse(
              isSuccess: false,
              statusCode: response.statusCode,
              errorMessage: decodedData);
        }
        return NetworkResponse(
            isSuccess: true,
            statusCode: response.statusCode,
            responseData: decodedData);
      }
      else if (response.statusCode == 401) {
        _moveToLogin();
        return NetworkResponse(
            isSuccess: false,
            statusCode: response.statusCode,
            errorMessage: "UnAuthenticate User!");
      } else {
        return NetworkResponse(
            isSuccess: false, statusCode: response.statusCode);
      }
    } catch (e) {
      return NetworkResponse(
          isSuccess: false, statusCode: -1, errorMessage: e.toString());
    }
  }

  static void printRequest(
      String url, Map<String, dynamic>? body, Map<String, dynamic>? headers) {
    debugPrint("URL: $url\nBODY: $body\nHEADERS: $headers");
  }

  static void printResponse(String url, Response response) {
    debugPrint(
        "URL: $url\n RESPONSE CODE: ${response.statusCode}\n BODY: ${response.body}");
  }

  static void _moveToLogin() async{
    await AuthController.clearUserData();
    Navigator.pushAndRemoveUntil(
        TaskManagerApp.navigatorKey.currentContext!,
        MaterialPageRoute(
          builder: (context) => SignInScreen(),
        ),
        (route) => false);
  }
}
