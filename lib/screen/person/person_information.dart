import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app_delivery/components/item_field.dart';
import 'package:app_delivery/controllers/discount_controller.dart';
import 'package:app_delivery/controllers/image_controler.dart';
import 'package:app_delivery/models/User.dart';
import 'package:app_delivery/screen/auth/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../apis.dart';
import '../../utils.dart';
import '../constants.dart';

class PersonInformation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PersonInformation();
  }
}

Rx<Users> user;
Users lu;
final DiscountController controllerDate = Get.put(DiscountController());

class _PersonInformation extends State<PersonInformation> {
  List listgender = ["Nam", "Nữ", "Khác"];
  String selected = '';
  String avatar;
  var confirmPass = null;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchUsers(), // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                elevation: 0,
                title: Text("Thông tin người dùng"),
              ),
              body: Container(
                padding: EdgeInsets.only(top: 5.h),
                color: Color(0xFFEEEEEE),
                height: 834.h,
                width: double.infinity,
                child: Column(
                  children: [
                    Container(
                      color: defaulColorThem,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              width: 60.w,
                              height: 60.h,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.black12),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                              ),
                              margin: EdgeInsets.all(5),
                              child: GetBuilder<ImageController>(
                                builder: (_) {
                                  return lu.avatar != null
                                      ? controller.image == null
                                          ? ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(50)),
                                              child: Image.network(
                                                Apis.baseURL + lu.avatar,
                                                width: 100.w,
                                                height: 100.h,
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          : ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(50)),
                                              child: Image.file(
                                                controller.image,
                                                // width: 90.w,
                                                // height: 90.h,
                                                fit: BoxFit.cover,
                                              ),
                                              // ),
                                              // ),
                                            )
                                      : controller.image == null
                                          ? Icon(
                                              Icons.add_a_photo,
                                              color: Colors.grey,
                                              size: 25.0.sp,
                                            )
                                          : ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(50)),
                                              child: Image.file(
                                                controller.image,
                                                // width: 90.w,
                                                // height: 90.h,
                                                fit: BoxFit.cover,
                                              ),
                                              // ),
                                              // ),
                                            );
                                },
                              )),
                          Container(
                            child: Row(
                              children: [
                                Text(
                                  'Thay đổi hình đại diện',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: Colors.blue,
                                  ),
                                ),
                                IconButton(
                                    onPressed: () async {
                                      await controller.getImage();
                                      await changeAvatar();
                                    },
                                    icon: Icon(
                                      Icons.arrow_forward_ios,
                                      size: 14,
                                    ))
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      color: defaulColorThem,
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    top: BorderSide(
                                        width: 0.2, color: Colors.black12))),
                          ),
                          // Obx(
                          //   () =>
                          Container(
                            margin: EdgeInsets.only(top: 0.2.h),
                            color: defaulColorThem,
                            child: Column(
                              children: [
                                Container(
                                  margin:
                                      EdgeInsets.only(left: 15.w, right: 10.w),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              width: 0.3,
                                              color: Colors.black12))),
                                  width: MediaQuery.of(context).size.width,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        child: Text(
                                          'Số điện thoại',
                                          style: TextStyle(fontSize: 17.sp),
                                        ),
                                      ),
                                      Container(
                                        height: 55.h,
                                        margin: EdgeInsets.only(right: 20.w),
                                        child: Center(
                                          child: Text(
                                            user.value.phone,
                                            softWrap: true,
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5.h),
                      color: defaulColorThem,
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 15.w, right: 10.w),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 0.3, color: Colors.black12))),
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: Text(
                                    'Tên',
                                    style: TextStyle(fontSize: 17.sp),
                                  ),
                                ),
                                Container(
                                  child: Row(
                                    children: [
                                      Text(
                                        user.value.username,
                                        softWrap: true,
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          color: Colors.blue,
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                      title: Text('Tên'),
                                                      content:
                                                          SingleChildScrollView(
                                                        child: Column(
                                                          children: [
                                                            ItemField(
                                                              controller:
                                                                  username,
                                                              hintText:
                                                                  "Tên người dùng",
                                                              // controller: quantity,
                                                              type:
                                                                  TextInputType
                                                                      .text,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          onPressed: () =>
                                                              Get.back(),
                                                          child: const Text(
                                                            'Hủy',
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.red),
                                                          ),
                                                        ),
                                                        TextButton(
                                                          onPressed: () async {
                                                            await changeName();
                                                            setState(() {
                                                              user.refresh();
                                                              Get.back();
                                                              showToast(
                                                                  "Cập nhật thành công");
                                                            });
                                                          },
                                                          child: const Text(
                                                            'Lưu lại',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .blue),
                                                          ),
                                                        ),
                                                      ]);
                                                });
                                          },
                                          icon: Icon(
                                            Icons.arrow_forward_ios,
                                            size: 14,
                                          ))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      // margin: EdgeInsets.only(top: 5.h),
                      color: defaulColorThem,
                      child: Column(
                        children: [
                          // Obx(
                          //   () =>
                          Container(
                            margin: EdgeInsets.only(left: 15.w, right: 10.w),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 0.3, color: Colors.black12))),
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // LineDecoration(),
                                Container(
                                  child: Text(
                                    'Email',
                                    style: TextStyle(fontSize: 17.sp),
                                  ),
                                ),
                                Container(
                                  child: Row(
                                    children: [
                                      Text(
                                        user.value.email,
                                        softWrap: true,
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          color: Colors.blue,
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                      title: Text('Email'),
                                                      content:
                                                          SingleChildScrollView(
                                                        child: Column(
                                                          children: [
                                                            ItemField(
                                                              controller: email,
                                                              hintText: "Email",
                                                              // controller: quantity,
                                                              type:
                                                                  TextInputType
                                                                      .text,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          onPressed: () =>
                                                              Get.back(),
                                                          child: const Text(
                                                            'Hủy',
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.red),
                                                          ),
                                                        ),
                                                        TextButton(
                                                          onPressed: () async {
                                                            await changeEmail();
                                                            setState(() {
                                                              user.refresh();
                                                              Get.back();
                                                              showToast(
                                                                  "Cập nhật thành công");
                                                            });
                                                          },
                                                          child: const Text(
                                                            'Lưu lại',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .blue),
                                                          ),
                                                        ),
                                                      ]);
                                                });
                                          },
                                          icon: Icon(
                                            Icons.arrow_forward_ios,
                                            size: 14,
                                          ))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 0.2.h),
                      color: defaulColorThem,
                      child: Column(
                        children: [
                          // Obx(
                          //   () =>
                          Container(
                            margin: EdgeInsets.only(left: 15.w, right: 10.w),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 0.3, color: Colors.black12))),
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // LineDecoration(),
                                Container(
                                  child: Text(
                                    'Giới tính',
                                    style: TextStyle(fontSize: 17.sp),
                                  ),
                                ),
                                Container(
                                  child: Row(
                                    children: [
                                      Text(
                                        user.value.gender,
                                        softWrap: true,
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          color: Colors.blue,
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                      title: Text('Giới tính'),
                                                      content: StatefulBuilder(
                                                        builder: (BuildContext
                                                                context,
                                                            StateSetter
                                                                setState) {
                                                          return SingleChildScrollView(
                                                            child: Container(
                                                                width: double
                                                                    .maxFinite,
                                                                child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: <
                                                                        Widget>[
                                                                      ConstrainedBox(
                                                                        constraints:
                                                                            BoxConstraints(
                                                                          maxHeight:
                                                                              MediaQuery.of(context).size.height * 0.4,
                                                                        ),
                                                                        child: ListView.builder(
                                                                            shrinkWrap: true,
                                                                            itemCount: listgender.length,
                                                                            itemBuilder: (BuildContext context, int index) {
                                                                              return RadioListTile(
                                                                                  title: Text(listgender[index]),
                                                                                  value: listgender[index],
                                                                                  groupValue: selected,
                                                                                  onChanged: (value) {
                                                                                    setState(() {
                                                                                      selected = value;
                                                                                      print(selected);
                                                                                    });
                                                                                  });
                                                                            }),
                                                                      ),
                                                                    ])),
                                                          );
                                                        },
                                                      ),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          onPressed: () =>
                                                              Get.back(),
                                                          child: const Text(
                                                            'Hủy',
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.red),
                                                          ),
                                                        ),
                                                        TextButton(
                                                          onPressed: () async {
                                                            await changeGender();
                                                            setState(() {
                                                              user.refresh();
                                                              Get.back();
                                                              showToast(
                                                                  "Cập nhật thành công");
                                                            });
                                                          },
                                                          child: const Text(
                                                            'Lưu lại',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .blue),
                                                          ),
                                                        ),
                                                      ]);
                                                });
                                          },
                                          icon: Icon(
                                            Icons.arrow_forward_ios,
                                            size: 14,
                                          ))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 0.2.h),
                      color: defaulColorThem,
                      child: Column(
                        children: [
                          // Obx(
                          //   () =>
                          Container(
                            margin: EdgeInsets.only(left: 15.w, right: 10.w),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 0.3, color: Colors.black12))),
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // LineDecoration(),
                                Container(
                                  child: Text(
                                    'Ngày sinh',
                                    style: TextStyle(fontSize: 17.sp),
                                  ),
                                ),
                                Container(
                                  child: Row(
                                    children: [
                                      Text(
                                        user.value.dob.toString(),
                                        softWrap: true,
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          color: Colors.blue,
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            // controller.selectDateDob(context);
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                      // title: Text('Tên'),
                                                      content: Date(),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          onPressed: () =>
                                                              Get.back(),
                                                          child: const Text(
                                                            'Hủy',
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.red),
                                                          ),
                                                        ),
                                                        TextButton(
                                                          onPressed: () async {
                                                            await changeDob();
                                                            setState(() {
                                                              user.refresh();
                                                              Get.back();
                                                              showToast(
                                                                  "Cập nhật thành công");
                                                            });
                                                          },
                                                          child: const Text(
                                                            'Lưu lại',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .blue),
                                                          ),
                                                        ),
                                                      ]);
                                                });
                                          },
                                          icon: Icon(
                                            Icons.arrow_forward_ios,
                                            size: 14,
                                          ))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return Form(
                                autovalidateMode: AutovalidateMode.always,
                                child: Builder(builder: (BuildContext ctx) {
                                  return AlertDialog(
                                      title: Text('Đổi mật khẩu'),
                                      content: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            InputField(
                                              controller: passwordOld,
                                              hintText: "Mật khẩu cũ",
                                              icon: Icons.vpn_key,
                                              obscureText: true,
                                              validator: (val) {
                                                if (val.length == 0) {
                                                  return 'Vui lòng nhập mật khẩu';
                                                } else
                                                  return null;
                                              },
                                            ),
                                            InputField(
                                              controller: passwordNew,
                                              hintText: "Mật khẩu mới",
                                              icon: Icons.vpn_key,
                                              obscureText: true,
                                              validator: (val) {
                                                confirmPass = val;
                                                if (val.length == 0)
                                                  return "Vui lòng nhập mật khẩu";
                                                else if (val.length < 8)
                                                  return "Mật khẩu lớn hơn 8 ký tự";
                                                else
                                                  return null;
                                              },
                                            ),
                                            InputField(
                                              controller: re_passwordNew,
                                              obscureText: true,
                                              icon: Icons.vpn_key,
                                              hintText:
                                                  "Nhập lại mật khẩu mới",
                                              validator: (val) {
                                                if (val.length == 0)
                                                  return "Vui lòng nhập mật khẩu";
                                                else if (val.length < 8)
                                                  return "Mật khẩu lớn hơn 8 ký tự";
                                                else if (confirmPass != val)
                                                  return 'Không khớp mật khẩu';
                                                return null;
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () => Get.back(),
                                          child: const Text(
                                            'Hủy',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            var code = await changePass(ctx);
                                            if (code == 200) {
                                              Get.back();
                                              showToast(
                                                  "Đổi mật khẩu thành công");
                                            }
                                            if (code == 403) {
                                              showToast(
                                                  "Mật khẩu cũ không khớp");
                                            }
                                          },
                                          child: const Text(
                                            'Đổi mật khẩu',
                                            style:
                                                TextStyle(color: Colors.blue),
                                          ),
                                        ),
                                      ]);
                                }),
                              );
                            });
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                            top: 30.h, bottom: 10.h, left: 12.w, right: 12.w),
                        height: 45.h,
                        width: MediaQuery.of(context).size.width / 1.1,
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: Center(
                          child: Text(
                            'Đổi mật khẩu',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Container();
          }
        });
  }

  TextEditingController username;
  TextEditingController email;
  TextEditingController phone;
  TextEditingController gender;
  TextEditingController passwordOld = new TextEditingController();
  TextEditingController passwordNew = new TextEditingController();
  TextEditingController re_passwordNew = new TextEditingController();

  final ImageController controller = Get.put(ImageController());

  // TextEditingController dob;

  @override
  void initState() {
    super.initState();
  }

  Future<int> changePass(BuildContext context) async {
    String token = (await getToken());
    print(passwordOld.text);
    print(passwordNew.text);
    if (Form.of(context).validate()) {
      http.Response response = await http.post(
        Uri.parse(Apis.changePassUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': "Bearer $token",
        },
        body: jsonEncode(<String, String>{
          'passwordOld': passwordOld.text,
          'passwordNew': passwordNew.text,
        }),
      );
      print(response.statusCode);
      return response.statusCode;
    } else {
      showToast('Vui lòng điền đầy đủ thông tin');
    }
  }

  Future<bool> fetchUsers() async {
    var u = await getUser();
    if (u != null) {
      user = u.obs;
      lu = u;
    }
    username = TextEditingController(text: lu.username);
    email = TextEditingController(text: lu.email);
    phone = TextEditingController(text: lu.phone.toString());
    gender = TextEditingController(text: lu.gender);
    // dob = TextEditingController(text: lu.dob.toString());
    return user.isBlank;
  }

  Future<Users> getUser() async {
    Users users;
    String token = (await getToken());
    try {
      print(Apis.getUsersUrl);
      http.Response response = await http.get(
        Uri.parse(Apis.getUsersUrl),
        headers: <String, String>{
          'Accept': 'application/json',
          'Authorization': "Bearer $token",
        },
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        var parsedJson = jsonDecode(response.body);
        print(parsedJson['users']);
        users = UsersJson.fromJson(parsedJson).users;
        print(users);
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

  Future<Users> changeName() async {
    String token = await getToken();
    print(token);
    print(username.text);
    try {
      EasyLoading.show(status: 'Loading...');
      http.Response response = await http.post(
        Uri.parse(Apis.changeNameUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': "Bearer $token",
        },
        body: jsonEncode(<String, dynamic>{
          'username': username.text,
        }),
      );

      print(response.statusCode);
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        var parsedJson = jsonDecode(response.body);
        // print(parsedJson['success']);
        Users users = Users.fromJson(parsedJson['user']);
        return users;
      }
    } on TimeoutException catch (e) {
      showError(e.toString());
    } on SocketException catch (e) {
      showError(e.toString());
    }
  }

  Future<Users> changeEmail() async {
    String token = await getToken();
    print(token);

    try {
      EasyLoading.show(status: 'Loading...');
      http.Response response = await http.post(
        Uri.parse(Apis.changeEmailUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': "Bearer $token",
        },
        body: jsonEncode(<String, dynamic>{
          'email': email.text,
        }),
      );

      print(response.statusCode);
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        var parsedJson = jsonDecode(response.body);
        // print(parsedJson['success']);
        Users users = Users.fromJson(parsedJson['user']);
        return users;
      }
    } on TimeoutException catch (e) {
      showError(e.toString());
    } on SocketException catch (e) {
      showError(e.toString());
    }
  }

  Future<Users> changeDob() async {
    String token = await getToken();
    print(token);
    // print(username.text);
    String dob = controllerDate.dob;
    print(dob);
    try {
      EasyLoading.show(status: 'Loading...');
      http.Response response = await http.post(
        Uri.parse(Apis.changeDobUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': "Bearer $token",
        },
        body: jsonEncode(<String, dynamic>{
          'dob': dob,
        }),
      );

      print(response.statusCode);
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        var parsedJson = jsonDecode(response.body);
        // print(parsedJson['success']);
        Users users = Users.fromJson(parsedJson['user']);
        return users;
      }
    } on TimeoutException catch (e) {
      showError(e.toString());
    } on SocketException catch (e) {
      showError(e.toString());
    }
  }

  Future<Users> changeGender() async {
    String token = await getToken();
    print(token);
    if (selected != null || selected != '') {
      try {
        EasyLoading.show(status: 'Loading...');
        http.Response response = await http.post(
          Uri.parse(Apis.changeGenderUrl),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': "Bearer $token",
          },
          body: jsonEncode(<String, dynamic>{
            'gender': selected,
          }),
        );

        print(response.statusCode);
        if (response.statusCode == 200) {
          EasyLoading.dismiss();
          var parsedJson = jsonDecode(response.body);
          // print(parsedJson['success']);
          Users users = Users.fromJson(parsedJson['user']);
          return users;
        }
      } on TimeoutException catch (e) {
        showError(e.toString());
      } on SocketException catch (e) {
        showError(e.toString());
      }
    } else {
      showToast('Vui lòng chọn giới tính');
    }
  }

  Future<Users> changeAvatar() async {
    String token = await getToken();
    print(token);
    String nameImage;
    print(lu.avatar);
    if (lu.avatar != null) {
      if (controller.imagePath != null) {
        int code = await uploadAvatar(controller.image, controller.imagePath);
        if (code == 200) {
          nameImage = controller.imagePath.split('/').last;
        }
      } else {
        nameImage = lu.avatar.split('/').last;
      }
    } else {
      if (controller.imagePath != null) {
        print(controller.imagePath);
        print('napf dâu k ma');
        int code = await uploadAvatar(controller.image, controller.imagePath);
        if (code == 200) {
          nameImage = controller.imagePath.split('/').last;
        }
      }
      // else {
      //   nameImage = lu.avatar.split('/').last;
      // }
    }
    // if (selected != null || selected != '') {
    try {
      EasyLoading.show(status: 'Loading...');
      http.Response response = await http.post(
        Uri.parse(Apis.changeAvatarUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': "Bearer $token",
        },
        body: jsonEncode(<String, dynamic>{
          'avatar': nameImage,
        }),
      );

      print(response.statusCode);
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        var parsedJson = jsonDecode(response.body);
        // print(parsedJson['success']);
        Users users = Users.fromJson(parsedJson['user']);
        return users;
      }
    } on TimeoutException catch (e) {
      showError(e.toString());
    } on SocketException catch (e) {
      showError(e.toString());
    }
    // } else {
    //   showToast('Vui lòng chọn giới tính');
    // }
  }
}

// class AvatarInf extends StatelessWidget {
//   final ImageController controller = Get.put(ImageController());
//   final String avatar;
//
//   AvatarInf({Key key, this.avatar}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () async {
//         print('voo ddaay nafo');
//         controller.getImage();
//         await changeAvatar();
//       },
//       child: ,
//     );
//   }
//
//
// }

class Date extends StatelessWidget {
  final DiscountController controller = Get.put(DiscountController());

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10.w, right: 10.w),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      height: 60.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              padding: EdgeInsets.only(left: 15.w), child: Text('Ngày sinh')),
          Row(
            children: [
              GetBuilder<DiscountController>(builder: (context) {
                return Text(
                  controller.dob,
                  style: TextStyle(fontSize: 15.sp, color: Colors.grey),
                );
              }),
              IconButton(
                onPressed: () {
                  print('dduj mas m');
                  controller.selectDateDob(context);
                },
                icon: Icon(
                  Icons.calendar_today_rounded,
                  size: 18,
                  color: Colors.grey,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
