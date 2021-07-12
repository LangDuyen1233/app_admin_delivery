import 'package:app_delivery/components/item_profile.dart';
import 'package:app_delivery/controllers/image_controler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../constants.dart';

class PersonInformation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Body(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      centerTitle: true,
      elevation: 0,
      title: Text("Thông tin người dùng"),
    );
  }
}

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 5.h),
      color: Color(0xFFEEEEEE),
      height: 834.h,
      width: double.infinity,
      child: Column(
        children: [
          AvatarInf(),
          Container(
            color: defaulColorThem,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(width: 0.2, color: Colors.black12))),
                  child: ItemProfile(
                    title: 'Tên đăng nhập',
                    description: 'MyDuyen',
                  ),
                ),
                ItemProfile(
                  title: 'Số điện thoại',
                  description: '********987',
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 5.h),
            color: defaulColorThem,
            child: Column(
              children: [
                ItemProfile(
                  title: 'Tên',
                  description: 'My Duyen',
                ),
                ItemProfile(
                  title: 'Email',
                  description: 'Nhập email',
                ),
                ItemProfile(
                  title: 'Giới tính',
                  description: 'Nữ',
                ),
                ItemProfile(
                  title: 'Ngày sinh',
                  description: '',
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class AvatarInf extends StatelessWidget {
  final ImageController controller = Get.put(ImageController());

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print('voo ddaay nafo');
        controller.getImage();
      },
      child: Container(
        color: defaulColorThem,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                width: 60.w,
                height: 60.h,
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.black12),
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
                margin: EdgeInsets.all(5),
                child: GetBuilder<ImageController>(
                  builder: (_) {
                    return controller.image == null
                        ? Container(
                            width: 60.w,
                            height: 60.h,
                            padding: EdgeInsets.only(
                                right: 12.w,
                                bottom: 12.h,
                                left: 12.w,
                                top: 12.h),
                            child: Image.asset(
                              'assets/images/person.png',
                              fit: BoxFit.fill,
                              color: Colors.black26,
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            child: Image.file(
                              controller.image,
                              fit: BoxFit.cover,
                            ),
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
                      onPressed: () {
                        print('ưefjwefjwehf');
                        controller.getImage();
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
    );
  }
}
