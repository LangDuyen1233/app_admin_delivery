import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app_delivery/models/User.dart';
import 'package:app_delivery/screen/auth/login.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../apis.dart';
import '../utils.dart';

class ProfileController extends GetxController {
  Rx<Users> user;

  @override
  void onInit() {
    fetchUsers();
    super.onInit();
  }

  Future<void> fetchUsers() async {
    var u = await getUser();
    if (u != null) {
      user = u.obs;
    }
  }

  Future<Users> getUser() async {
    Users users;
    String token = (await getToken());
    try {
      http.Response response = await http.get(
        Uri.parse(Apis.getUsersUrl),
        headers: <String, String>{
          'Accept': 'application/json',
          'Authorization': "Bearer $token",
        },
      );
      if (response.statusCode == 200) {
        var parsedJson = jsonDecode(response.body);
        users = UsersJson.fromJson(parsedJson).users;
        return users;
      }
      if (response.statusCode == 401) {
        showToast("Loading faild");
      }
    } on TimeoutException catch (e) {
      showError(e.toString());
    } on SocketException catch (e) {
      showError(e.toString());
      print(e.toString());
    }
    return null;
  }

  Future<void> _removeToken() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.remove('token');
  }

  Future<void> logout() async {
    String token = (await getToken());
    try {
      http.Response response = await http.post(
        Uri.parse(Apis.getLogoutUrl),
        headers: <String, String>{
          'Accept': 'application/json',
          'Authorization': "Bearer $token",
        },
      ).timeout(Duration(seconds: 10));
      if (response.statusCode == 200) {
        _removeToken();
        Get.offAll(() => SignIn());
      }
      if (response.statusCode == 401) {
        showToast("Logout failed.");
      }
    } on TimeoutException catch (e) {
      showError(e.toString());
    } on SocketException catch (e) {
      showError(e.toString());
      print(e.toString());
    }
  }
}
