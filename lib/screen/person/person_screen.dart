import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app_delivery/apis.dart';
import 'package:app_delivery/authService.dart';
import 'package:app_delivery/components/item_profile.dart';
import 'package:app_delivery/controllers/profile_controller.dart';
import 'package:app_delivery/models/User.dart';
import 'package:app_delivery/screen/admin_categories/category_product.dart';
import 'package:app_delivery/screen/admin_discounts/discount_screen.dart';
import 'package:app_delivery/screen/admin_materials/materials_screen.dart';
import 'package:app_delivery/screen/admin_order/order_screen.dart';
import 'package:app_delivery/screen/admin_reviews/reviews_screen.dart';
import 'package:app_delivery/screen/admin_staff/staff_screen.dart';
import 'package:app_delivery/screen/person/person_information.dart';
import 'package:app_delivery/screen/person/policy.dart';
import 'package:app_delivery/screen/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../utils.dart';
import '../constants.dart';

class PersonProfile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Person();
  }
}

Rx<Users> user;
Users lu;

class _Person extends State<PersonProfile> {
  ProfileController controller = Get.put(ProfileController());

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
                automaticallyImplyLeading: false,
                title: Text("Tôi"),
              ),
              body: FutureBuilder(
                  future: fetchUsers(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Loading();
                    } else {
                      return RefreshIndicator(
                        onRefresh: () => fetchUsers(),
                        child: ListView(
                          children: [
                            Container(
                              color: defaulColorThem,
                              padding: EdgeInsets.only(top: 50.h),
                              height: 210.h,
                              child: InkWell(
                                onTap: () async {
                                  await Get.to(PersonInformation());
                                  setState(() {
                                    fetchUsers();
                                  });
                                },
                                child: Column(children: [
                                  Container(
                                    width: 90.w,
                                    height: 90.h,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1, color: Colors.black12),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(50)),
                                    ),
                                    child: lu.avatar == null
                                        ? Image.asset(
                                            "assets/images/person.png",
                                            fit: BoxFit.cover,
                                            color: Colors.black26,
                                          )
                                        : ClipRRect(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(50)),
                                            child: Image.network(
                                              Apis.baseURL + lu.avatar,
                                              height: 200.h,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  Container(
                                    child: Text(
                                      lu.username,
                                      style: TextStyle(
                                          fontSize: 22.sp,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ]),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 5.h),
                              color: defaulColorThem,
                              child: Column(
                                children: [
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
                                  ItemProfile(
                                    title: 'Chính sách và quy định',
                                    description: '',
                                    page: Policy(),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                await controller.logout();
                                await AuthService().signOut();
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                    top: 30.h,
                                    bottom: 10.h,
                                    left: 12.w,
                                    right: 12.w),
                                height: 45.h,
                                width: MediaQuery.of(context).size.width / 1.1,
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                                child: Center(
                                  child: Text(
                                    'Đăng xuất'.toUpperCase(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  }),
            );
          } else {
            return Container();
          }
        });
  }

  @override
  void initState() {
    fetchUsers();
    super.initState();
  }

  Future<bool> fetchUsers() async {
    var u = await getUser();
    if (u != null) {
      lu = u;
    }
    return lu.isBlank;
  }

  Future<Users> getUser() async {
    Users users;
    String token = (await getToken());
    try {
      http.Response response = await http.get(
        Uri.parse(Apis.getUsersUrl),
        headers: <String, String>{
          'Accept': 'application/json',
          'Authorization': "Bearer $token",
        },
      );
      if (response.statusCode == 200) {
        var parsedJson = jsonDecode(response.body);
        users = UsersJson.fromJson(parsedJson).users;
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
}
