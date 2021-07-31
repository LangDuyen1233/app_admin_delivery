import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app_delivery/models/Order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../apis.dart';
import '../../../../utils.dart';
import 'empty_card.dart';

class DeliveredScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DeliveredScreen();
  }
}

RxList<Order> listOrder;

class _DeliveredScreen extends State<DeliveredScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: RefreshIndicator(
      onRefresh: () => fetch(),
      child: Obx(
        () => listOrder.length == 0
            ? EmptyCard()
            : ListView.builder(
                shrinkWrap: true,
                itemCount: listOrder.length,
                itemBuilder: (context, index) {
                  return Container(
                    alignment: FractionalOffset.topCenter,
                    margin: new EdgeInsets.only(top: 1.h),
                    child: Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                              top: 2.h,
                              left: 10.h,
                            ),
                            height: 70.h,
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    //img user
                                    Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1, color: Colors.black12),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50)),
                                        ),
                                        //image
                                        child: Container(
                                            width: 50.w,
                                            height: 50.h,
                                            child: listOrder[index]
                                                        .user
                                                        .avatar ==
                                                    null
                                                ? Container(
                                                    padding: EdgeInsets.only(
                                                        right: 10.w,
                                                        bottom: 10.h,
                                                        left: 10.w,
                                                        top: 10.h),
                                                    child: ClipRRect(
                                                      child: Image.asset(
                                                        'assets/images/person.png',
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  )
                                                : ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                50)),
                                                    child: Image.network(
                                                      Apis.baseURL +
                                                          listOrder[index]
                                                              .user
                                                              .avatar,
                                                      width: 100.w,
                                                      height: 100.h,
                                                      fit: BoxFit.cover,
                                                    )))),
                                    //user name
                                    Container(
                                      padding: EdgeInsets.only(left: 5.w),
                                      child:
                                          Text(listOrder[index].user.username),
                                    ),
                                  ],
                                ),
                                Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            Icons.call,
                                            size: 20,
                                            color: Colors.grey,
                                          )),
                                      IconButton(
                                          onPressed: () {},
                                          icon: Icon(Icons.message,
                                              size: 20, color: Colors.grey)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          width: 0.5,
                                          color: Colors.grey[300])))),
                          Container(
                            height: 50.h,
                            margin: EdgeInsets.only(left: 15.h, right: 15.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Icon(
                                      Icons.motorcycle,
                                      color: Colors.blue,
                                      size: 25.sp,
                                    ),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    listOrder[index].userDeliveryId == null
                                        ? Text(
                                            'Giao hàng bởi quán',
                                            style:
                                                TextStyle(color: Colors.blue),
                                          )
                                        : Text(
                                            'Giao hàng bởi sinh viên',
                                            style:
                                                TextStyle(color: Colors.blue),
                                          ),
                                  ],
                                ),
                                IconButton(
                                  icon: Icon(Icons.navigate_next),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                              title: Text(
                                                  'Thông tin người giao hàng'),
                                              content: listOrder[index]
                                                          .userDeliveryId ==
                                                      null
                                                  ? SingleChildScrollView(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                              "Tên người giao: " +
                                                                  listOrder[
                                                                          index]
                                                                      .staff
                                                                      .name),
                                                          SizedBox(
                                                            height: 10.h,
                                                          ),
                                                          Text(
                                                              "Số điện thoại: " +
                                                                  listOrder[
                                                                          index]
                                                                      .staff
                                                                      .phone),
                                                        ],
                                                      ),
                                                    )
                                                  : SingleChildScrollView(
                                                      child: Column(
                                                        children: [
                                                          Text("Tên người giao: " +
                                                              listOrder[index]
                                                                  .user
                                                                  .username),
                                                          SizedBox(
                                                            height: 10.h,
                                                          ),
                                                          Text(
                                                              "Số điện thoại: " +
                                                                  listOrder[
                                                                          index]
                                                                      .user
                                                                      .phone),
                                                        ],
                                                      ),
                                                    ),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () => Get.back(),
                                                  child: const Text('Ok'),
                                                ),
                                              ]);
                                        });
                                  },
                                )
                              ],
                            ),
                          ),
                          Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          width: 0.5,
                                          color: Colors.grey[300])))),
                          Container(
                            padding: EdgeInsets.only(
                                left: 10.w,
                                right: 10.w,
                                bottom: 1.w,
                                top: 10.h),
                            width: double.infinity,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(
                                      right: 8.w, top: 8.h, bottom: 8.w),
                                  child: Column(
                                    children: [
                                      ListView.builder(
                                          shrinkWrap: true,
                                          itemCount:
                                              listOrder[index].foodOrder.length,
                                          itemBuilder: (context, ind) {
                                            return Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: 24.w,
                                                  child: Text(listOrder[index]
                                                          .foodOrder[ind]
                                                          .quantity
                                                          .toString() +
                                                      ' x'),
                                                ),
                                                Container(
                                                  width: 230.w,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        listOrder[index]
                                                            .foodOrder[ind]
                                                            .food
                                                            .name,
                                                        style: TextStyle(
                                                            fontSize: 18.sp),
                                                      ),
                                                      Container(
                                                        width: 230.w,
                                                        child: ListView.builder(
                                                            shrinkWrap: true,
                                                            itemCount:
                                                                listOrder[index]
                                                                    .foodOrder[
                                                                        ind]
                                                                    .toppings
                                                                    .length,
                                                            itemBuilder:
                                                                (context, i) {
                                                              return Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    "+ " +
                                                                        listOrder[index]
                                                                            .foodOrder[ind]
                                                                            .toppings[i]
                                                                            .name,
                                                                    style: TextStyle(
                                                                        fontSize: 15
                                                                            .sp,
                                                                        color: Colors
                                                                            .grey),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 1.h,
                                                                  )
                                                                ],
                                                              );
                                                            }),
                                                      ),
                                                      SizedBox(
                                                        height: 5.h,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  width: 70.w,
                                                  child: Text(
                                                    listOrder[index]
                                                        .foodOrder[ind]
                                                        .price
                                                        .toString(),
                                                    textAlign: TextAlign.right,
                                                  ),
                                                ),
                                              ],
                                            );
                                          }),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(right: 7.w),
                                        alignment: Alignment.centerRight,
                                        child: Text('Tổng: ' +
                                            listOrder[index].price.toString()),
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      Container(
                                        alignment: Alignment.topLeft,
                                        padding: EdgeInsets.all(10.sp),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8.sp)),
                                          color: Colors.grey[100],
                                        ),
                                        child: Column(
                                          children: [
                                            Container(
                                              width: double.infinity,
                                              child: Text(
                                                'Ghi chú của khách hàng:',
                                                style:
                                                    TextStyle(fontSize: 16.sp),
                                              ),
                                            ),
                                            Container(
                                              width: double.infinity,
                                              child: Text(
                                                listOrder[index].note == null
                                                    ? "Chưa có"
                                                    : listOrder[index].note,
                                                softWrap: true,
                                                style: TextStyle(
                                                    fontSize: 15.sp,
                                                    color: Colors.grey),
                                              ),
                                            )
                                          ],
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
                  );
                }),
      ),
    ));
  }

  @override
  void initState() {
    listOrder = new RxList<Order>();
    fetch();
    super.initState();
  }

  Future<void> fetch() async {
    var list = await getOrder();
    if (list != null) {
      listOrder.assignAll(list);
      listOrder.refresh();
    }
  }

  Future<List<Order>> getOrder() async {
    List<Order> list;
    String token = (await getToken());
    try {
      print(Apis.getDeliveredCardUrl);
      http.Response response = await http.get(
        Uri.parse(Apis.getDeliveredCardUrl),
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
}
