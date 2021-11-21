import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app_delivery/apis.dart';
import 'package:app_delivery/screen/auth/fogot_pass_success.dart';
import 'package:app_delivery/screen/auth/widgets/input_field.dart';
import 'package:app_delivery/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

class ForgotPassword extends StatelessWidget {
  TextEditingController email = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        leading: BackButton(
          color: Colors.black,
        ),
        centerTitle: true,
        title: Text(
          'Quên mật khẩu',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Form(
        child: Builder(
          builder: (BuildContext ctx){
            return Container(
              padding: EdgeInsets.only(left: 24.w, right: 24.w),
              color: Colors.white,
              child: SingleChildScrollView(
                child:  Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 4,
                      child: Center(
                        child: Align(
                          alignment: Alignment.center,
                          child: Image(
                            image: ResizeImage(
                              AssetImage('assets/images/logo_kitchen.png'),
                              width: 150,
                              height: 150,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 366.w,
                      child: Text(
                          'Nhập địa chỉ email của bạn vào bên dưới và chúng tôi sẽ gửi cho bạn một email kèm theo hướng dẫn về cách thay đổi mật khẩu của bạn'),
                    ),
                    SizedBox(
                      height: 50.h,
                    ),
                    Container(
                      width: 414.w,
                      child: Column(
                        children: <Widget>[
                          InputField(
                            controller: email,
                            hintText: 'Email',
                            icon: Icons.email,
                            validator: (val) {
                              if (val.length == 0) {
                                return 'Vui lòng nhập Email';
                              } else if (!val.isEmail) {
                                return 'Sai định dạng Email';
                              } else
                                return null;
                            },
                          ),
                          SizedBox(
                            height: 40.h,
                          ),
                          Container(
                            height: 60.h,
                            width: 414.w,
                            padding: EdgeInsets.only(left: 24.w, right: 24.w),
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                            child: TextButton(
                              onPressed: () async {
                               var code= await forgotPass(ctx);
                               if(code== 200){
                                    Get.off(ForgotPassSuccess());
                               }else if(code == 400){
                                 showToast('Email không tồn tại!');
                               }
                              },
                              child: Text(
                                'Quên mật khẩu'.toUpperCase(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        )
      ),
    );
  }

  Future<int> forgotPass(BuildContext context) async {
    String token = await getToken();
    if (Form.of(context).validate()) {
      try {
        http.Response response = await http.post(
          Uri.parse(Apis.forgotPassUrl),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': "Bearer $token",
          },
          body: jsonEncode(<String, dynamic>{
            'email': email.text,
          }),
        );
        return response.statusCode;
      } on TimeoutException catch (e) {
        showError(e.toString());
      } on SocketException catch (e) {
        showError(e.toString());
      }
    } else {
      showToast('Vui lòng điền đầy đủ các trường');
    }
  }
}
