import 'package:app_delivery/screen/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ForgotPassSuccess extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 896.h,
        width: 414.w,
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              color: Colors.green,
              size: 60,
            ),
            SizedBox(
              height: 20.h,
            ),
            Text(
              'Đổi mật khẩu thành công',
              style: TextStyle(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.green),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Vui lòng kiểm tra Email để hoàn tất',
              style: TextStyle(fontSize: 18.sp),
            ),
            SizedBox(
              height: 40.h,
            ),
            Container(
              height: 45.h,
              width: 200.w,
              padding: EdgeInsets.only(left: 24.w, right: 24.w),
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: TextButton(
                onPressed: () async {
                  Get.offAll(SignIn());
                },
                child: Text(
                  'Về đăng nhập'.toUpperCase(),
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
