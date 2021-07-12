import 'package:app_delivery/components/item_profile.dart';
import 'package:app_delivery/screen/admin_categories/category_product.dart';
import 'package:app_delivery/screen/admin_discounts/discount_screen.dart';
import 'package:app_delivery/screen/admin_materials/materials_screen.dart';
import 'package:app_delivery/screen/admin_order/order_screen.dart';
import 'package:app_delivery/screen/admin_reviews/reviews_screen.dart';
import 'package:app_delivery/screen/admin_staff/staff_screen.dart';
import 'package:app_delivery/screen/home/home_screen.dart';
import 'package:app_delivery/screen/person/person_information.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../constants.dart';

class Person extends StatelessWidget {
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
      automaticallyImplyLeading: false,
      title: Text("Tôi"),
    );
  }
}

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kPrimaryColorThem,
        body: ListView(
          children: [
            // Avatar(
            //   defaultImage: 'assets/images/person.png',
            //   name: 'Mỹ Duyên',
            // ),
            Container(
              color: defaulColorThem,
              padding: EdgeInsets.only(top: 50.h),
              height: 210.h,
              child: InkWell(
                onTap: () {
                  print('voo ddaay nafo');
                  Get.to(PersonInformation());
                },
                child: Column(
                  children: [
                    Container(
                      width: 90.w,
                      height: 90.h,
                      padding: EdgeInsets.only(
                          right: 12.w, bottom: 12.h, left: 12.w, top: 12.h),
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.black12),
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                      child: Image.asset(
                        "assets/images/person.png",
                        fit: BoxFit.cover,
                        color: Colors.black26,
                      ),
                    ),
                    Container(
                      // padding: EdgeInsets.only(top: 20.h),
                      child: Text(
                        "avatar.name",
                        style: TextStyle(
                            fontSize: 22.sp, fontWeight: FontWeight.w600),
                      ),
                    )
                  ],
                ),
              ),
            ),
            // Avatar(icon: Icons.person,name: "Mỹ Duyên",),
            Container(
              margin: EdgeInsets.only(top: 5.h),
              color: defaulColorThem,
              child: Column(
                children: [
                  // ColorLineBottom(),
                  ItemProfile(
                    title: 'Quản lý thực đơn',
                    description: '',
                    page: HomProduct(),
                  ),
                  ItemProfile(
                    title: 'Quản lý hóa đơn',
                    description: '',
                    page: OrderScreen(),
                  ),
                  ItemProfile(
                    title: 'Quản lý nhân viên',
                    description: '',
                    page: StaffScreen(),
                  ),
                  ItemProfile(
                    title: 'Quản lý nguyên vật liệu',
                    description: '',
                    page: MaterialsScreen(),
                  ),
                  ItemProfile(
                    title: 'Quản lý khuyến mãi',
                    description: '',
                    page: DiscountScreen(),
                  ),
                  ItemProfile(
                    title: 'Quản lý đánh giá',
                    description: '',
                    page: ReviewScreen(),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 5),
              color: defaulColorThem,
              child: Column(
                children: [
                  // ColorLineBottom(),
                  ItemProfile(
                    title: 'Trung tâm hỗ trợ',
                    description: '',
                  ),
                  ItemProfile(
                    title: 'Chính sách và quy định',
                    description: '',
                  ),
                  ItemProfile(
                    title: 'Cài đặt',
                    description: '',
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {},
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
                    'Đăng xuất'.toUpperCase(),
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}

class ColorLineBottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(width: 0.5, color: kPrimaryColorThem))),
    );
  }
}
