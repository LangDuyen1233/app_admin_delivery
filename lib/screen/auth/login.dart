import 'package:app_delivery/controllers/auth_controller.dart';
import 'package:app_delivery/screen/auth/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignIn extends GetView<AuthController> {
  AuthController controller = Get.put(AuthController());

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
                        controller: controller.email,
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
                          controller: controller.password,
                          obscureText: controller.passwordvisible.value,
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
                              controller.showPassword();
                            },
                            // onTap: () {
                            //   controller.hidePassword();
                            // },
                            child: Icon(controller.passwordvisible.isTrue
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
                            controller.login(ctx);
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
      ),
    ));
  }
}
