import 'dart:async';
import 'dart:io';

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
