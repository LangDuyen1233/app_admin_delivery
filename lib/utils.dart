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
import 'networking.dart';

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
                  return MyStatefulWidgetState(selectedIndex: 2,);
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

Future<bool> notification(
    String uid, String title, String body, int notification_type_id) async {
  try {
    http.Response response = await http.post(
      Uri.parse(Apis.postNotificationUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'uid': uid,
        'title': title,
        'body': body,
        'notification_type_id': notification_type_id,
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

Future<void> saveNotification(
    String title, String body, String user_id, int notification_type_id) async {
  var token = await getToken();
  try {
    print(title);
    print(body);
    http.Response response = await http.post(
      Uri.parse(Apis.saveNotificationUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer $token",
      },
      body: jsonEncode(<String, dynamic>{
        'user_id': user_id,
        'title': title,
        'body': body,
        'notification_type_id': notification_type_id,
      }),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {}
  } on TimeoutException catch (e) {
    showError(e.toString());
  } on SocketException catch (e) {
    showError(e.toString());
  }
}

Future<double> distanceRestaurant(
    double startLat, double startLng, double endLat, double endLng) async {
  Distance distance = new Distance(
    startLat: startLat,
    startLng: startLng,
    endLat: endLat,
    endLng: endLng,
  );
  var data = await distance.postData();
  // print(data);

  if (data != 404) {
    var arrarDistance = data['distances'][0];
    print(arrarDistance);
    return arrarDistance[1];
  }
  return 0.0;
}
