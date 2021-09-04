import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app_delivery/screen/auth/login.dart';
import 'package:app_delivery/screen/index.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'apis.dart';

showError(String s) {
  EasyLoading.dismiss();
  EasyLoading.showError(s, duration: Duration(milliseconds: 750));
}

showToast(String s) {
  EasyLoading.dismiss();
  EasyLoading.showToast(s);
}

Future<String> getToken() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  return _prefs.getString('token');
}

Future<String> getID() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  return _prefs.getString('id');
}

handleAuth() {
  return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          return FutureBuilder(
              future: checkLogin(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return MyStatefulWidgetState();
                } else {
                  return SignIn();
                }
              });
        } else {
          return SignIn();
        }
      });
}

Future<bool> checkLogin() async {
  var token = await getToken();
  return token.isNotEmpty;
}

Future<void> saveToken(String token) async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  await _prefs.setString('token', token);
}

Future<int> uploadImage(File file, String filename) async {
  String token = await getToken();
  print(token);
  try {
    // EasyLoading.show(status: 'Loading...');
    // var bytes = controller.image.readAsBytesSync();
    var request =
        await http.MultipartRequest('POST', Uri.parse(Apis.uploadImage));
    request.files.add(http.MultipartFile.fromBytes(
        'image', file.readAsBytesSync(),
        filename: filename.split('/').last));
    var response = await request.send();
    print(response.statusCode);
    return response.statusCode;
  } on TimeoutException catch (e) {
    showError(e.toString());
  } on SocketException catch (e) {
    showError(e.toString());
  }
}

Future<int> uploadAvatar(File file, String filename) async {
  String token = await getToken();
  print(token);
  try {
    // EasyLoading.show(status: 'Loading...');
    // var bytes = controller.image.readAsBytesSync();
    var request =
        await http.MultipartRequest('POST', Uri.parse(Apis.uploadAvatar));
    request.files.add(http.MultipartFile.fromBytes(
        'image', file.readAsBytesSync(),
        filename: filename.split('/').last));
    var response = await request.send();
    print(response.statusCode);
    return response.statusCode;
  } on TimeoutException catch (e) {
    showError(e.toString());
  } on SocketException catch (e) {
    showError(e.toString());
  }
}

Future<bool> notification(String uid, String title, String body) async {
  try {
    http.Response response = await http.post(
      Uri.parse(Apis.postNotificationUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'uid': uid,
        'title': title,
        'body': body,
      }),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      return true;
    }
  } on TimeoutException catch (e) {
    showError(e.toString());
  } on SocketException catch (e) {
    showError(e.toString());
  }
  return false;
}
