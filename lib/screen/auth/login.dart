import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app_delivery/authService.dart';
import 'package:app_delivery/controllers/auth_controller.dart';
import 'package:app_delivery/models/User.dart';
import 'package:app_delivery/screen/auth/widgets/input_field.dart';
import 'package:app_delivery/screen/chat/chat.dart';
import 'package:app_delivery/screen/chat/home.dart';
import 'package:app_delivery/screen/chat/model/user_chat.dart';

import 'package:app_delivery/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  // AuthController controller = Get.put(AuthController());

  TextEditingController email;
  TextEditingController password;
  RxBool passwordvisible = true.obs;

  @override
  void initState() {
    email = TextEditingController();
    password = TextEditingController();
    super.initState();
    // isSignedIn();
  }

  void showPassword() {
    passwordvisible.value = passwordvisible.value ? false : true;
    print(passwordvisible);
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   email.dispose();
  //   password.dispose();
  // }

  Future<void> _saveToken(String token) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.setString('token', token);
  }

  static var client = http.Client();
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
      print(response.statusCode);
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
    print(email.text);
    print(password.text);
    if (email.text.isNotEmpty && password.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });

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
          print(user);

          if (user != null) {
            // Check is already sign up
            final QuerySnapshot result = await FirebaseFirestore.instance
                .collection('users')
                .where('id', isEqualTo: user.uid)
                .get();
            final List<DocumentSnapshot> documents = result.docs;
            if (documents.length == 0) {
              // Update data to server if new user
              FirebaseFirestore.instance.collection('users').doc(user.uid).set({
                'nickname': user.displayName,
                'photoUrl': user.photoURL,
                'id': user.uid,
                'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
                'chattingWith': null
              });

              // Write data to local
              currentUser = user;
              print(currentUser.uid);
              await prefs?.setString('id', currentUser.uid);
              await prefs?.setString('nickname', user.displayName ?? "");
              await prefs?.setString('photoUrl', currentUser.photoURL ?? "");
            } else {
              DocumentSnapshot documentSnapshot = documents[0];
              UserChat userChat = UserChat.fromDocument(documentSnapshot);
              // Write data to local
              print(userChat.id);
              await prefs?.setString('id', userChat.id);
              await prefs?.setString('nickname', userChat.nickname);
              await prefs?.setString('photoUrl', userChat.photoUrl ?? "");
            }
            // Fluttertoast.showToast(msg: "Sign in success");
            this.setState(() {
              isLoading = false;
            });
          }

          if (user.uid == null) {
            await updateUid(u.id, user.uid);
          }

          print('token $token');
          await EasyLoading.dismiss();
          await _saveToken(token);
          Get.to(MyStatefulWidgetState());
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

  AuthService authService = new AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        padding: EdgeInsets.only(left: 24.w, right: 24.w),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                  width: 414.w,
                  height: 280.h,
                  child: Center(
                    child: Align(
                      alignment: Alignment.center,
                      child: Image(
                          image: ResizeImage(
                        AssetImage('assets/images/fork.png'),
                        width: 100,
                        height: 100,
                      )),
                    ),
                  )),
              Form(
                // key: controller.formKeySignIn,
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
                        // onChanged: (val) {
                        //   controller.email = val;
                        // },
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      GetBuilder<AuthController>(
                        init: AuthController(),
                        // INIT IT ONLY THE FIRST TIME
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
                            // onTap: () {
                            //   controller.hidePassword();
                            // },
                            child: Icon(passwordvisible.isTrue
                                ? Icons.visibility
                                : Icons.visibility_off),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            // Get.to(ForgotPassword());
                          },
                          child: Text(
                            'Quên mật khẩu ?',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
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
                            // googleSignIn.signOut();
                            login(ctx);
                          },
                          child: Text(
                            'Đăng nhập'.toUpperCase(),
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      // Align(
                      //   alignment: Alignment.centerRight,
                      //   child: TextButton(
                      //     onPressed: () {
                      //       handleSignIn().catchError((err) {
                      //         Fluttertoast.showToast(msg: err.toString());
                      //         this.setState(() {
                      //           isLoading = false;
                      //         });
                      //       });
                      //       // google_SignIn();
                      //       saveToken(
                      //           'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiMGUzOTIyNTRlNGIyZTIwZmQwYjdiNTQ2NDQ0MjBmNmFlOTdmYTk5MzViYTNiNmI5NmJiNWZkOTUxMzgyYTQwNTc4OWI2ZmI5OGNmZjdhZGUiLCJpYXQiOjE2Mjc4MDAwNjMuNzc2MzY0LCJuYmYiOjE2Mjc4MDAwNjMuNzc2MzcsImV4cCI6MTY1OTMzNjA2My43MDQwOSwic3ViIjoiMSIsInNjb3BlcyI6W119.H5QTT4HgxGCGNIXbZPjC5QZ3NJzjVzg80n64TI6XpZgdqzWM6pfm-5BqNRw11MpwLjeDcFZQNZjz4ahMLHXQtWOJsPs9Swfiq_HtgLTTOO6f60CbURxMPV9-pm-Qi8dOcvLc6I7wGc1d1H-Yw9GvvX62gmgcVHNQzPnB4MMqaxci85cpMmoPb_VB-lTBWw3lCfy2pk_xLvAHWRfOsxDwVHcLQ0zHVW1PQq39449L8ie92x38QtIcOCRmS69pCdAYwA69AJgLl_brEqJzAjBcSYjnhxotR4ZqOhSR4-kk4qqiwl7I6vKp04z8lsQJy6mmb8MBgX8hsjFHrXzLjscikqUfujBfPdlW6_JmykECFEyBGwg1IJRxq8RHWE1pp1D6AxScXjxMLo_CgnfjCtr-DHxJLkouC0YeGoXa3G0v5vnDLDiAleaRqC825hk41gUqrX4idoTclz4-Sv7drEN5WbPDzwzH8nCl_iCvVglC2RkMM48qMSz9w6Sy0Av85c9pQzrmjB_y6HjfMRitXFEak3XP9Wc7U6MJMmcuAdnvxSREenjSLzottcP9Zae7N94YWP76Xp3TJNIa_xalQIrjmA_-J_7RTF-bN837N565t23JMaP5RsM0W088JDUnsJgyEsgFK9mpowSGuoiTxwDRuM-J4QJKUAQ0DpFzXc6OOzM');
                      //     },
                      //     child: Text(
                      //       'Signin Google',
                      //       style: TextStyle(color: Colors.grey),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
///////////////////
//               Center(
//                 child: TextButton(
//                   onPressed: () {
//                     handleSignIn().catchError((err) {
//                       Fluttertoast.showToast(msg: err.toString());
//                       this.setState(() {
//                         isLoading = false;
//                       });
//                     });
//                   },
//                   child: Text(
//                     'SIGN IN WITH GOOGLE',
//                     style: TextStyle(fontSize: 16.0, color: Colors.white),
//                   ),
//                   style: ButtonStyle(
//                       backgroundColor:
//                           MaterialStateProperty.all<Color>(Color(0xffdd4b39)),
//                       padding: MaterialStateProperty.all<EdgeInsets>(
//                           EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0))),
//                 ),
//               ),
//               // Loading
//               Positioned(
//                 child: isLoading ? const Loading() : Container(),
//               ),
            ],
          ),
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

// Future<Null> handleSignIn() async {
//   prefs = await SharedPreferences.getInstance();
//
//   this.setState(() {
//     isLoading = true;
//   });
//
//   GoogleSignInAccount googleUser = await googleSignIn.signIn();
//   if (googleUser != null) {
//     GoogleSignInAuthentication googleAuth = await googleUser.authentication;
//     final AuthCredential credential = GoogleAuthProvider.credential(
//       accessToken: googleAuth.accessToken,
//       idToken: googleAuth.idToken,
//     );
//
//     User firebaseUser =
//         (await firebaseAuth.signInWithCredential(credential)).user;
//
//     if (firebaseUser != null) {
//       // Check is already sign up
//       final QuerySnapshot result = await FirebaseFirestore.instance
//           .collection('users')
//           .where('id', isEqualTo: firebaseUser.uid)
//           .get();
//       final List<DocumentSnapshot> documents = result.docs;
//       if (documents.length == 0) {
//         // Update data to server if new user
//         FirebaseFirestore.instance
//             .collection('users')
//             .doc(firebaseUser.uid)
//             .set({
//           'nickname': firebaseUser.displayName,
//           'photoUrl': firebaseUser.photoURL,
//           'id': firebaseUser.uid,
//           'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
//           'chattingWith': null
//         });
//
//         // Write data to local
//         currentUser = firebaseUser;
//         await prefs?.setString('id', currentUser.uid);
//         await prefs?.setString('nickname', currentUser.displayName ?? "");
//         await prefs?.setString('photoUrl', currentUser.photoURL ?? "");
//       } else {
//         DocumentSnapshot documentSnapshot = documents[0];
//         UserChat userChat = UserChat.fromDocument(documentSnapshot);
//         // Write data to local
//         await prefs?.setString('id', userChat.id);
//         await prefs?.setString('nickname', userChat.nickname);
//         await prefs?.setString('photoUrl', userChat.photoUrl);
//         await prefs?.setString('aboutMe', userChat.aboutMe);
//       }
//       Fluttertoast.showToast(msg: "Sign in success");
//       this.setState(() {
//         isLoading = false;
//       });
//       Get.to(MyStatefulWidgetState());
//       // Navigator.push(
//       //     context,
//       //     MaterialPageRoute(
//       //         builder: (context) =>
//       //             HomeScreen(currentUserId: firebaseUser.uid)));
//     } else {
//       Fluttertoast.showToast(msg: "Sign in fail");
//       this.setState(() {
//         isLoading = false;
//       });
//     }
//   } else {
//     Fluttertoast.showToast(msg: "Can not init google sign in");
//     this.setState(() {
//       isLoading = false;
//     });
//   }
// }

// Future<User> google_SignIn() async {
//   User user;
//   bool isSignedIn = await googleSignIn.isSignedIn();
//
//   print(isSignedIn.toString());
//
//   if (isSignedIn) {
//     user = firebaseAuth.currentUser;
//     print(user.email);
//     print(user.toString());
//     Get.off(MyStatefulWidgetState());
//   } else {
//     final GoogleSignInAccount googleUser = (await googleSignIn.signIn());
//     if (googleUser != null) {
//       final GoogleSignInAuthentication googleAuth =
//       await googleUser.authentication;
//       final AuthCredential credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );
//       // UserCredential result = await firebaseAuth.signInWithCredential(credential);
//       // user = result.user;
//       // isUserSignedIn = await googleSignIn.isSignedIn();
//
//       User firebaseUser = (await firebaseAuth.signInWithCredential(credential)).user;
//
//       print(firebaseUser.displayName);
//       print(firebaseUser.email);
//       if (firebaseUser != null) {
//
//         String phone = user.phoneNumber;
//         if (phone == null) {
//           phone = '0';
//         }
//         final QuerySnapshot result =
//         await FirebaseFirestore.instance.collection('users').where('id', isEqualTo: firebaseUser.uid).get();
//         final List<DocumentSnapshot> documents = result.docs;
//         if (documents.length == 0) {
//           // Update data to server if new user
//           FirebaseFirestore.instance
//               .collection('users')
//               .doc(user.uid)
//               .set({
//             'nickname': user.displayName,
//             'photoUrl': user.photoURL,
//             'id': user.uid,
//             'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
//             'chattingWith': null
//           });
//
//           // Write data to local
//           currentUser = user;
//           await prefs?.setString('id', currentUser.uid);
//           await prefs?.setString('nickname', currentUser.displayName ?? "");
//           await prefs?.setString('photoUrl', currentUser.photoURL ?? "");
//         } else {
//           DocumentSnapshot documentSnapshot = documents[0];
//           UserChat userChat = UserChat.fromDocument(documentSnapshot);
//           // Write data to local
//           await prefs?.setString('id', userChat.id);
//           await prefs?.setString('nickname', userChat.nickname);
//           await prefs?.setString('photoUrl', userChat.photoUrl);
//           await prefs?.setString('aboutMe', userChat.aboutMe);
//         }
//         print(phone);
//         Get.to(MyStatefulWidgetState());
//         // postRegisger(user.displayName, user.email, phone, user.photoURL);
//
//         return user;
//       } else {
//         Get.to(SignIn());
//       }
//     } else {
//       showToast('Đăng nhập thất bại!');
//     }
//   }
//   return null;
// }

// void isSignedIn() async {
//   this.setState(() {
//     isLoading = true;
//   });
//
//   prefs = await SharedPreferences.getInstance();
//
//   isLoggedIn = await googleSignIn.isSignedIn();
//   if (isLoggedIn && prefs?.getString('id') != null) {
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//           builder: (context) =>
//               ChatsScreen(currentUserId: prefs.getString('id') ?? "")),
//     );
//   }
//
//   this.setState(() {
//     isLoading = false;
//   });
// }
//
// Future<Null> handleSignIn() async {
//   prefs = await SharedPreferences.getInstance();
//
//   this.setState(() {
//     isLoading = true;
//   });
//
//   GoogleSignInAccount googleUser = await googleSignIn.signIn();
//   if (googleUser != null) {
//     GoogleSignInAuthentication googleAuth = await googleUser.authentication;
//     final AuthCredential credential = GoogleAuthProvider.credential(
//       accessToken: googleAuth.accessToken,
//       idToken: googleAuth.idToken,
//     );
//
//     User firebaseUser =
//         (await firebaseAuth.signInWithCredential(credential)).user;
//
//     if (firebaseUser != null) {
//       // Check is already sign up
//       final QuerySnapshot result = await FirebaseFirestore.instance
//           .collection('users')
//           .where('id', isEqualTo: firebaseUser.uid)
//           .get();
//       final List<DocumentSnapshot> documents = result.docs;
//       if (documents.length == 0) {
//         // Update data to server if new user
//         FirebaseFirestore.instance
//             .collection('users')
//             .doc(firebaseUser.uid)
//             .set({
//           'nickname': firebaseUser.displayName,
//           'photoUrl': firebaseUser.photoURL,
//           'id': firebaseUser.uid,
//           'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
//           'chattingWith': null
//         });
//
//         // Write data to local
//         currentUser = firebaseUser;
//         await prefs?.setString('id', currentUser.uid);
//         await prefs?.setString('nickname', currentUser.displayName ?? "");
//         await prefs?.setString('photoUrl', currentUser.photoURL ?? "");
//       } else {
//         DocumentSnapshot documentSnapshot = documents[0];
//         UserChat userChat = UserChat.fromDocument(documentSnapshot);
//         // Write data to local
//         await prefs?.setString('id', userChat.id);
//         await prefs?.setString('nickname', userChat.nickname);
//         await prefs?.setString('photoUrl', userChat.photoUrl);
//         await prefs?.setString('aboutMe', userChat.aboutMe);
//       }
//       Fluttertoast.showToast(msg: "Sign in success");
//       this.setState(() {
//         isLoading = false;
//       });
//
//       Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (context) =>
//                   ChatsScreen(currentUserId: firebaseUser.uid)));
//     } else {
//       Fluttertoast.showToast(msg: "Sign in fail");
//       this.setState(() {
//         isLoading = false;
//       });
//     }
//   } else {
//     Fluttertoast.showToast(msg: "Can not init google sign in");
//     this.setState(() {
//       isLoading = false;
//     });
//   }
// }
}
