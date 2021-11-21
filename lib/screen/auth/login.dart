import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app_delivery/authService.dart';
import 'package:app_delivery/controllers/auth_controller.dart';
import 'package:app_delivery/models/User.dart';
import 'package:app_delivery/screen/auth/forgot_password.dart';
import 'package:app_delivery/screen/auth/widgets/input_field.dart';
import 'package:app_delivery/screen/chat/model/user_chat.dart';
import 'package:app_delivery/screen/widget/loading.dart';

import 'package:app_delivery/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../apis.dart';
import '../index.dart';

class SignIn extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SignIn();
  }
}

class _SignIn extends State<SignIn> {
  TextEditingController email;
  TextEditingController password;
  RxBool passwordvisible = true.obs;

  @override
  void initState() {
    email = TextEditingController();
    password = TextEditingController();
    super.initState();
  }

  void showPassword() {
    passwordvisible.value = passwordvisible.value ? false : true;
    print(passwordvisible);
  }

  Future<void> _saveToken(String token) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.setString('token', token);
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> updateUid(int userId, String uid) async {
    try {
      http.Response response = await http.post(
        Uri.parse(Apis.postUpdateUidUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'user_id': userId,
          'uid': uid,
        }),
      );
      if (response.statusCode == 200) {}
      if (response.statusCode == 500) {
        showToast("Server error, please try again later!");
      }
    } on TimeoutException catch (e) {
      showError(e.toString());
    } on SocketException catch (e) {
      showError(e.toString());
      print(e.toString());
    }
  }

  Future<void> login(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Form.of(context).validate();
    if (email.text.isNotEmpty && password.text.isNotEmpty) {
      try {
        setState(() {
          isLoading = true;
        });
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
        if (response.statusCode == 200) {
          var token = jsonDecode(response.body)["token"];
          var u = UsersJson.fromJson(jsonDecode(response.body)).users;
          UserCredential result;
          try {
            result = await _auth.createUserWithEmailAndPassword(
                email: u.email, password: password.text);
          } catch (e) {
            result = await _auth.signInWithEmailAndPassword(
                email: u.email, password: password.text);
          }

          User user = result.user;
          user.updateDisplayName(u.username);
          user.updatePhotoURL(Apis.baseURL + u.avatar);

          if (user != null) {
            final QuerySnapshot result = await FirebaseFirestore.instance
                .collection('users')
                .where('id', isEqualTo: user.uid)
                .get();
            final List<DocumentSnapshot> documents = result.docs;
            if (documents.length == 0) {
              FirebaseFirestore.instance.collection('users').doc(user.uid).set({
                'nickname': user.displayName,
                'photoUrl': user.photoURL,
                'id': user.uid,
                'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
                'chattingWith': null
              });

              currentUser = user;
              await prefs?.setString('id', currentUser.uid);
              await prefs?.setString('nickname', user.displayName ?? "");
              await prefs?.setString('photoUrl', currentUser.photoURL ?? "");
            } else {
              DocumentSnapshot documentSnapshot = documents[0];
              UserChat userChat = UserChat.fromDocument(documentSnapshot);
              await prefs?.setString('id', userChat.id);
              await prefs?.setString('nickname', userChat.nickname ?? "");
              await prefs?.setString('photoUrl', userChat.photoUrl ?? "");
            }
          }

          if (user.uid == null) {
            await updateUid(u.id, user.uid);
          }

          await _saveToken(token);

          isLoading = false;
          Get.to(MyStatefulWidgetState(
            selectedIndex: 2,
          ));
        }
        if (response.statusCode == 401) {
          setState(() {
            isLoading = false;
          });
          showToast("Đăng nhập thất bại, tài khoản hoặc mật khẩu không đúng");
        }
        if (response.statusCode == 500) {
          showToast("Hệ thống bị lỗi, vui lòng thử lại sau.");
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

  AuthService authService = new AuthService();

  showAlertDialog(BuildContext context) {
    showDialog(
      barrierColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return Container(width: 50.w, height: 50.h, child: const Loading());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        padding: EdgeInsets.only(left: 24.w, right: 24.w),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 50.h,
                  ),
                  Container(
                      width: 414.w,
                      height: 280.h,
                      child: Center(
                        child: Align(
                          alignment: Alignment.center,
                          child: Image(
                              image: ResizeImage(
                            AssetImage('assets/images/logo_kitchen.png'),
                            width: 200,
                            height: 200,
                          )),
                        ),
                      )),
                  Form(
                    child: Builder(
                      builder: (BuildContext ctx) => Column(
                        children: [
                          InputField(
                            controller: email,
                            hintText: 'Email',
                            icon: Icons.person,
                            validator: (val) {
                              if (val.length == 0) {
                                return 'Vui lòng nhập Email hoặc Số điện thoại';
                              } else if (!val.isEmail) {
                                return 'Sai định dạng Email';
                              } else
                                return null;
                            },
                          ),
                          SizedBox(
                            height: 30.h,
                          ),
                          GetBuilder<AuthController>(
                            init: AuthController(),
                            builder: (_) => InputField(
                              controller: password,
                              obscureText: passwordvisible.value,
                              hintText: 'Mật khẩu',
                              icon: Icons.vpn_key,
                              validator: (val) {
                                if (val.length == 0) {
                                  return 'Vui lòng nhập mật khẩu';
                                } else
                                  return null;
                              },
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    showPassword();
                                  });
                                },
                                child: Icon(passwordvisible.isTrue
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                Get.to(ForgotPassword());
                              },
                              child: Text(
                                'Quên mật khẩu ?',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Container(
                            height: 50.h,
                            width: 414.w,
                            padding: EdgeInsets.only(left: 24.w, right: 24.w),
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: TextButton(
                              onPressed: () {
                                print(isLoading);
                                if (isLoading == false) {
                                  login(ctx);
                                }
                              },
                              child: Text(
                                'Đăng nhập'.toUpperCase(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned.fill(
              child: Center(
                child: Container(
                  alignment: Alignment.center,
                  width: 100.w,
                  height: 100.h,
                  child: isLoading ? Loading() : Container(),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  bool isLoading = false;
  bool isLoggedIn = false;
  User currentUser;
  bool isUserSignedIn = false;
}
