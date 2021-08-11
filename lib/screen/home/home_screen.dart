import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app_delivery/components/choose_item.dart';
import 'package:app_delivery/models/Order.dart';
import 'package:app_delivery/screen/restaurant/restaurant_screen.dart';
import 'package:app_delivery/screen/statistics/chartss.dart';
import 'package:app_delivery/screen/statistics/statistics_order/statistics_order_screen.dart';
import 'package:app_delivery/screen/statistics/statistics_revenue/statistics_revenue_screen.dart';
import 'package:app_delivery/screen/statistics/statistics_screen.dart';
import 'package:app_delivery/screen/statistics/statistics_warehouse/statistics_warehouse_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../apis.dart';
import '../../utils.dart';
import 'notify.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(270.h),
        child: AppBar(
          automaticallyImplyLeading: false,
          title: Container(
            padding: EdgeInsets.only(top: 12.h),
            height: 70.h,
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        "Xin chao Com so 1",
                        style: TextStyle(fontSize: 22.sp, color: Colors.white),
                      ),
                    ),
                    Container(
                      width: 140.w,
                      child: Text(
                        "Kiot Nong Lam, duong 8, Linh Trung, Thu Duc",
                        softWrap: true,
                        style: TextStyle(fontSize: 14.sp, color: Colors.white),
                      ),
                    )
                  ],
                ),
                Container(
                  width: 40.w,
                  child: IconButton(
                      onPressed: () {
                        Get.to(RestaurantScreen());
                      },
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        size: 16.sp,
                      )),
                )
              ],
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications),
              color: Colors.white,
              tooltip: 'Notifications',
              onPressed: () {
                Get.to(NotifyScreen());
              },
            )
          ],
          elevation: 0,
          backgroundColor: Colors.white,
          flexibleSpace: Stack(
            children: [
              Container(
                child: ClipPath(
                  clipper: CustomShape(),
                  // this is my own class which extendsCustomClipper
                  child: Container(
                    color: Color(0xff0D93E8),
                  ),
                ),
              ),
              Positioned(
                child: UserCard(),
                top: ((270 - 70) / 2).h,
                left: 5.w,
              )
            ],
          ),
        ),
      ),
      body: Container(
        color: Color(0xFFEEEEEE),
        height: 634.h,
        width: double.infinity,
        child: ListView(
          children: [
            BarChartPage2(),
            ChooseItem(
              icon: Icons.monetization_on,
              name: 'Báo cáo doanh thu',
              content: 'Hiện thị doanh thu của cửa hàng trong kỳ',
              page: StatisticsRevenueScreen(),
            ),
            ChooseItem(
              icon: Icons.food_bank,
              name: 'Báo cáo đơn hàng',
              content: 'Thống kê các dữ liệu tổng hợp về đơn hàng',
              page: StatisticsOrderScreen(),
            ),
            ChooseItem(
              icon: Icons.house_siding,
              name: 'Báo cáo kho',
              content: 'Tổng giá trị và số lượng sản phẩm tồn kho',
              page: StatisticsWarehouseScreen(),
            ),
            SizedBox(height: 10.h)
          ],
        ),
      ),
    );
  }
}

class UserCard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UserCard();
  }
}

class _UserCard extends State<UserCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400.w,
      height: 188.h,
      child: Card(
        margin: EdgeInsets.only(left: 10.w, right: 10.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: Colors.white,
        child: Container(
          padding: EdgeInsets.all(20.w),
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(width: 0.5, color: Colors.black12)),
                ),
                padding: EdgeInsets.only(bottom: 15.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Text(
                          "DOANH THU HÔM NAY",
                          style: TextStyle(fontSize: 18.sp, color: Colors.grey),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10.h),
                          child: Obx(
                            () => Text(
                              NumberFormat.currency(locale: 'vi')
                                  .format(price.value),
                              style: TextStyle(
                                  fontSize: 20.sp,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(() => StatisticsScreen());
                      },
                      child: Row(
                        children: [
                          Text(
                            "Xem chi tiết",
                            style: TextStyle(color: Colors.blueAccent),
                          ),
                          Icon(Icons.arrow_forward_ios,
                              size: 15.sp, color: Colors.blueAccent)
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 20.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          "Đơn hàng mới",
                          style: TextStyle(color: Colors.grey),
                        ),
                        Container(
                            margin: EdgeInsets.only(top: 5.h),
                            child: Obx(
                              () => Text(
                                countNew.value != null
                                    ? countNew.value.toString()
                                    : '0',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ))
                      ],
                    ),
                    Column(
                      children: [
                        Text("Đơn hủy", style: TextStyle(color: Colors.grey)),
                        Container(
                            margin: EdgeInsets.only(top: 5.h),
                            child: Obx(
                              () => Text(
                                countCancel.value != null
                                    ? countCancel.value.toString()
                                    : '0',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ))
                      ],
                    ),
                    Column(
                      children: [
                        Text("Tổng số đơn",
                            style: TextStyle(color: Colors.grey)),
                        Container(
                            margin: EdgeInsets.only(top: 5.h),
                            child: Obx(
                              () => Text(
                                countSum.value != null
                                    ? countSum.value.toString()
                                    : '0',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ))
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  RxList<Order> order;
  RxList<Order> orderNew;
  RxList<Order> orderCancel;
  RxList<Order> orderSum;
  RxInt price;
  RxInt countNew;
  RxInt countCancel;
  RxInt countSum;
  Timer timer;

  @override
  void initState() {
    price = 0.obs;
    countNew = 0.obs;
    countCancel = 0.obs;
    countSum = 0.obs;
    order = new RxList<Order>();
    orderNew = new RxList<Order>();
    orderCancel = new RxList<Order>();
    orderSum = new RxList<Order>();
    fetch();
    super.initState();
  }

  Future<void> fetch() async {
    var list = await getOder();
    var listNew = await getNewOrder();
    var listCancel = await getCancelOrder();
    var listSum = await getSumOrder();
    if (list != null) {
      order.assignAll(list);
      order.refresh();

      orderNew.assignAll(listNew);
      orderNew.refresh();

      orderCancel.assignAll(listCancel);
      orderCancel.refresh();

      orderSum.assignAll(listSum);
      orderSum.refresh();
    }
    for (int i = 0; i < order.length; i++) {
      price = price + (order[i].price);
    }
    print(price);

    for (int i = 0; i < orderNew.length; i++) {
      countNew += 1;
    }
    print(countNew);

    for (int i = 0; i < orderCancel.length; i++) {
      countCancel += 1;
    }
    print(countCancel);

    for (int i = 0; i < orderSum.length; i++) {
      countSum += 1;
    }
    print(countSum);
  }

  Future<List<Order>> getOder() async {
    List<Order> list;
    String token = (await getToken());
    try {
      print(Apis.getSalesUrl);
      http.Response response = await http.get(
        Uri.parse(Apis.getSalesUrl),
        headers: <String, String>{
          'Accept': 'application/json',
          'Authorization': "Bearer $token",
        },
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        var parsedJson = jsonDecode(response.body);
        // print(parsedJson['food']);
        list = ListOrderJson.fromJson(parsedJson).order;
        print(list);
        return list;
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

  Future<List<Order>> getNewOrder() async {
    List<Order> list;
    String token = (await getToken());
    try {
      print(Apis.getNewCardUrl);
      http.Response response = await http.get(
        Uri.parse(Apis.getNewCardUrl),
        headers: <String, String>{
          'Accept': 'application/json',
          'Authorization': "Bearer $token",
        },
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        var parsedJson = jsonDecode(response.body);
        list = ListOrderJson.fromJson(parsedJson).order;
        print(list);
        return list;
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

  Future<List<Order>> getCancelOrder() async {
    List<Order> list;
    String token = (await getToken());
    try {
      print(Apis.getCancelUrl);
      http.Response response = await http.get(
        Uri.parse(Apis.getCancelUrl),
        headers: <String, String>{
          'Accept': 'application/json',
          'Authorization': "Bearer $token",
        },
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        var parsedJson = jsonDecode(response.body);
        list = ListOrderJson.fromJson(parsedJson).order;
        print(list);
        return list;
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

  Future<List<Order>> getSumOrder() async {
    List<Order> list;
    String token = (await getToken());
    try {
      print(Apis.getSumUrl);
      http.Response response = await http.get(
        Uri.parse(Apis.getSumUrl),
        headers: <String, String>{
          'Accept': 'application/json',
          'Authorization': "Bearer $token",
        },
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        var parsedJson = jsonDecode(response.body);
        list = ListOrderJson.fromJson(parsedJson).order;
        print(list);
        return list;
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

class CustomShape extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    double height = size.height;
    double width = size.width;
    var path = Path();
    path.lineTo(0, height - 100);
    path.quadraticBezierTo(width / 2, height, width, height - 100);
    path.lineTo(width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}
