import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app_delivery/controllers/image_controler.dart';
import 'package:app_delivery/models/Restaurant.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../apis.dart';
import '../../utils.dart';
import 'address_restaurant.dart';

class RestaurantScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RestaurantScreen();
  }
}

Rx<Restaurants> restaurant;
Restaurants l;


class _RestaurantScreen extends State<RestaurantScreen> {
  final ImageController controller = Get.put(ImageController());
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchRestaurant(),
        // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                elevation: 0,
                title: Text("Thông tin quán"),
              ),
              body: Container(
                color: Color(0xFFEEEEEE),
                height: 834.h,
                child: ListView(
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 20.h),
                      child: Column(
                        children: [
                          SizedBox(
                            width: 120.w,
                            height: 120.h,
                            // child: TextButton(
                            //   onPressed: () async {
                            //     await controller.getImage();
                            //     await changeAvatar();
                            //   },
                            //   child: GetBuilder<ImageController>(
                            //         builder: (_) {
                            //           return l.image != null
                            //               ? controller.image == null
                            //               ? ClipRRect(
                            //             borderRadius: BorderRadius.all(
                            //                 Radius.circular(50)),
                            //             child: Image.network(
                            //               Apis.baseURL + l.image,
                            //               width: 100.w,
                            //               height: 100.h,
                            //               fit: BoxFit.cover,
                            //             ),
                            //           )
                            //               : ClipRRect(
                            //             borderRadius: BorderRadius.all(
                            //                 Radius.circular(50)),
                            //             child: Image.file(
                            //               controller.image,
                            //               // width: 90.w,
                            //               // height: 90.h,
                            //               fit: BoxFit.cover,
                            //             ),
                            //             // ),
                            //             // ),
                            //           )
                            //               : controller.image == null
                            //               ? Icon(
                            //             Icons.add_a_photo,
                            //             color: Colors.grey,
                            //             size: 25.0.sp,
                            //           )
                            //               : ClipRRect(
                            //             borderRadius: BorderRadius.all(
                            //                 Radius.circular(50)),
                            //             child: Image.file(
                            //               controller.image,
                            //               // width: 90.w,
                            //               // height: 90.h,
                            //               fit: BoxFit.cover,
                            //             ),
                            //             // ),
                            //             // ),
                            //           );
                            //         }
                            // ),),
                            child: RaisedButton(
                              onPressed: ()  async {
                                await controller.getImage();
                                await changeImage();
                                // img = controller.imagePath;
                              },
                              color: Colors.white,
                              shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(5.0)),
                              child: GetBuilder<ImageController>(
                                builder: (_) {
                                  return Container(
                                      width: MediaQuery.of(context).size.width,
                                      padding: EdgeInsets.only(
                                          top: 5.h, bottom: 5.h),
                                      child: ConstrainedBox(
                                        constraints:
                                            BoxConstraints(maxHeight: 120.h),
                                        child: ClipRRect(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                            child: l.image != null
                                                ? controller.image == null
                                                    ? ClipRRect(
                                                        child: Image.network(
                                                          Apis.baseURL +
                                                              l.image,
                                                          width: 100.w,
                                                          height: 100.h,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      )
                                                    : ClipRRect(
                                                        child: Image.file(
                                                          controller.image,
                                                          // width: 90.w,
                                                          // height: 90.h,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      )
                                                : controller.image == null
                                                    ? Icon(
                                                        Icons.add_a_photo,
                                                        color: Colors.grey,
                                                        size: 25.0.sp,
                                                      )
                                                    : ClipRRect(
                                                        child: Image.file(
                                                          controller.image,
                                                          // width: 90.w,
                                                          // height: 90.h,
                                                          fit: BoxFit.cover,
                                                        ),
                                                        // ),
                                                        // ),
                                                      )
                                            ),
                                      )
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    AddressRes(
                      address: l.address,
                    ),
                    PhoneRes(
                      phone: l.phone,
                    )
                  ],
                ),
              ),
            );
          } else {
            return Container();
          }
        });
  }

  @override
  void initState() {
    fetchRestaurant();
    super.initState();
  }

  Future<bool> fetchRestaurant() async {
    var u = await getRestaurant();
    print(u.name);
    print(u);
    if (u != null) {
      // user = u.obs;
      l = u;
      print(l.image);
    }
    return l.isBlank;
  }

  Future<Restaurants> getRestaurant() async {
    Restaurants restaurants;
    String token = (await getToken());
    try {
      print(Apis.getRestaurantUrl);
      http.Response response = await http.get(
        Uri.parse(Apis.getRestaurantUrl),
        headers: <String, String>{
          'Accept': 'application/json',
          'Authorization': "Bearer $token",
        },
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        var parsedJson = jsonDecode(response.body);
        print(parsedJson['restaurants']);
        restaurants = RestaurantJson.fromJson(parsedJson).restaurants;
        print(restaurants);
        return restaurants;
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

  Future<Restaurants> changeImage() async {
    String token = await getToken();
    print(token);
    String nameImage;
    print(l.image);
    if (l.image != null) {
      if (controller.imagePath != null) {
        int code = await uploadAvatar(controller.image, controller.imagePath);
        if (code == 200) {
          nameImage = controller.imagePath.split('/').last;
        }
      } else {
        nameImage = l.image.split('/').last;
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
        Uri.parse(Apis.changeImageRestaurantUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': "Bearer $token",
        },
        body: jsonEncode(<String, dynamic>{
          'image': nameImage,
        }),
      );

      print(response.statusCode);
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        var parsedJson = jsonDecode(response.body);
        // print(parsedJson['success']);
        Restaurants restaurants =
            Restaurants.fromJson(parsedJson['restaurants']);
        return restaurants;
      }
    } on TimeoutException catch (e) {
      showError(e.toString());
    } on SocketException catch (e) {
      showError(e.toString());
    }
    return null;
    // } else {
    //   showToast('Vui lòng chọn giới tính');
    // }
  }
}

class AddressRes extends StatelessWidget {
  final String address;

  AddressRes({Key key, this.address}) : super(key: key);

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
              address,
              style: TextStyle(fontSize: 14.sp, color: Colors.grey),
            ),
          )
        ],
      ),
    );
  }
}

class PhoneRes extends StatelessWidget {
  final String phone;

  const PhoneRes({Key key, this.phone}) : super(key: key);

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
              phone,
              style: TextStyle(fontSize: 14.sp, color: Colors.grey),
            ),
          )
        ],
      ),
    );
  }
}
