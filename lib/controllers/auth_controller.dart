import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app_delivery/apis.dart';
import 'package:app_delivery/models/User.dart';
import 'package:app_delivery/screen/auth/login.dart';
import 'package:app_delivery/screen/index.dart';
import 'package:app_delivery/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
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

  GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);

  FirebaseAuth _auth = FirebaseAuth.instance;

  Rxn<User> _firebaseUser = Rxn<User>();

  bool isUserSignedIn = false;

  Future<User> google_SignIn() async {
    User user;
    bool isSignedIn = await googleSignIn.isSignedIn();

    print(isSignedIn.toString());

    if (isSignedIn) {
      user = _auth.currentUser;
      print(user.email);
      print(user.toString());
      Get.off(MyStatefulWidgetState());
    } else {
      final GoogleSignInAccount googleUser = (await googleSignIn.signIn());
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        UserCredential result = await _auth.signInWithCredential(credential);
        user = result.user;
        isUserSignedIn = await googleSignIn.isSignedIn();

        print(user.displayName);
        print(user.email);
        if (user != null) {
          String phone = user.phoneNumber;
          if (phone == null) {
            phone = '0';
          }
          print(phone);
          Get.to(MyStatefulWidgetState());
          // postRegisger(user.displayName, user.email, phone, user.photoURL);

          return user;
        } else {
          Get.to(SignIn());
        }
      } else {
        showToast('Đăng nhập thất bại!');
      }
    }
    return null;
  }
}
