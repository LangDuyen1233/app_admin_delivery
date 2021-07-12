import 'package:app_delivery/controllers/image_controler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'address_restaurant.dart';

class RestaurantScreen extends StatelessWidget {
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
      title: Text("Thông tin quán"),
    );
  }
}

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFEEEEEE),
      height: 834.h,
      child: ListView(
        children: [AvatarRes(), AddressRes(), PhoneRes()],
      ),
    );
  }
}

class AvatarRes extends StatelessWidget {
  final ImageController controller = Get.put(ImageController());

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10.w, right: 5.w, top: 15.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100.w,
            height: 100.h,
            child: RaisedButton(
              onPressed: () {
                controller.getImage();
              },
              color: Colors.white,
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(5.0)),
              child: GetBuilder<ImageController>(
                builder: (_) {
                  return controller.image == null
                      ? Icon(
                          Icons.add_a_photo,
                          color: Colors.grey,
                          size: 25.0.sp,
                        )
                      : Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.only(top: 5.h, bottom: 5.h),
                          child: FittedBox(
                            fit: BoxFit.fill,
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              child: Image.file(
                                controller.image,
                                // width: 90.w,
                                // height: 90.h,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AddressRes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 10.h),
      padding: EdgeInsets.only(left: 15.w),
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // LineDecoration(),
              Container(
                child: Text(
                  'Địa chỉ quán',
                  style: TextStyle(fontSize: 17.sp),
                ),
              ),
              Container(
                  child: IconButton(
                      onPressed: () {
                        Get.to(AddressRestaurant());
                      },
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                      )))
            ],
          ),
          Container(
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(width: 0.3, color: Colors.black12))),
          ),
          Container(
            height: 50.h,
            alignment: Alignment.centerLeft,
            child: Text(
              'Đường 8, linh xuân, thủ đức',
              style: TextStyle(fontSize: 14.sp, color: Colors.grey),
            ),
          )
        ],
      ),
    );
  }
}

class PhoneRes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 10.h),
      padding: EdgeInsets.only(left: 15.w),
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // LineDecoration(),
              Container(
                child: Text(
                  'Số điện thoại quán',
                  style: TextStyle(fontSize: 17.sp),
                ),
              ),
              Container(
                  child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                      )))
            ],
          ),
          Container(
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(width: 0.3, color: Colors.black12))),
          ),
          Container(
            height: 50.h,
            alignment: Alignment.centerLeft,
            child: Text(
              '098764347',
              style: TextStyle(fontSize: 14.sp, color: Colors.grey),
            ),
          )
        ],
      ),
    );
  }
}
