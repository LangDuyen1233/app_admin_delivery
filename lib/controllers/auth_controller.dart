import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app_delivery/apis.dart';
import 'package:app_delivery/screen/index.dart';
import 'package:app_delivery/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  TextEditingController email;
  TextEditingController password;
  RxBool passwordvisible = true.obs;

  @override
  void onInit() {
    email = TextEditingController();
    password = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    email.clear();
    password.clear();
    super.onClose();
  }

  @override
  void onReady() {
    super.onReady();

    // email = TextEditingController();
    // password = TextEditingController();
  }

  void showPassword() {
    passwordvisible.value = passwordvisible.value ? false : true;
    print(passwordvisible);
    update();
  }

  @override
  void dispose() {
    super.dispose();
    email.dispose();
    password.dispose();
  }

  Future<void> _saveToken(String token) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.setString('token', token);
  }

  static var client = http.Client();

  Future<void> login(BuildContext context) async {
    Form.of(context).validate();
    print(email.text);
    print(password.text);
    if (email.text.isNotEmpty && password.text.isNotEmpty) {
      try {
        EasyLoading.show(status: 'Loading...');
        print(Apis.getSignInUrl);
        http.Response response = await http.post(
          Uri.parse(Apis.getSignInUrl),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'email': email.text,
            'password': password.text,
          }),
        );
        print(response.statusCode);
        if (response.statusCode == 200) {
          var token = jsonDecode(response.body)["token"];
          print('token $token');
          if (token != null) {
            print("TOKEN: " + token);
            await EasyLoading.dismiss();
            await _saveToken(token);
            Get.to(MyStatefulWidgetState());
            // Get.to(() => BottomNavigation());
          }
        }
        if (response.statusCode == 401) {
          showToast("Login failed.");
        }
        if (response.statusCode == 500) {
          showToast("Server error, please try again later!");
        }
      } on TimeoutException catch (e) {
        showError(e.toString());
      } on SocketException catch (e) {
        showError(e.toString());
        print(e.toString());
      }
    } else {
      showToast("Vui lòng điền email và mật khẩu.");
    }
  }
}
