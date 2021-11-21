import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app_delivery/models/Order.dart';
import 'package:app_delivery/screen/widget/empty_screen.dart';
import 'package:app_delivery/screen/widget/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../apis.dart';
import '../../../utils.dart';

class HistoryScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HistoryScreen();
  }
}

RxList<Order> listOrder;
DateFormat formatter = DateFormat('yyyy-MM-dd');

class _HistoryScreen extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
          future: fetch(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Loading();
            } else {
              if (snapshot.hasError) {
                return EmptyScreen(text: 'Bạn chưa có đơn hàng nào.');
              } else {
                return RefreshIndicator(
                  onRefresh: () => fetch(),
                  child: Obx(
                    () => listOrder.length == 0
                        ? EmptyScreen(
                            text: "Bạn chưa có đơn hàng nào.",
                          )
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
                                            left: 15.w, right: 15.w),
                                        height: 50.h,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(DateFormat('yyyy-MM-dd')
                                                .format(DateTime.parse(
                                                    listOrder[index]
                                                        .updatedAt))),
                                            listOrder[index].orderStatusId == 5
                                                ? Text('Đã hủy')
                                                : Text('Đã giao')
                                          ],
                                        ),
                                      ),
                                      Container(
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                      width: 0.5,
                                                      color:
                                                          Colors.grey[300])))),
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: 15, right: 18),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              height: 70.h,
                                              child: Row(
                                                children: [
                                                  Container(
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            width: 1,
                                                            color:
                                                                Colors.black12),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    50)),
                                                      ),
                                                      child: Container(
                                                          width: 50.w,
                                                          height: 50.h,
                                                          child: listOrder[
                                                                          index]
                                                                      .user
                                                                      .avatar ==
                                                                  null
                                                              ? Container(
                                                                  padding: EdgeInsets.only(
                                                                      right:
                                                                          10.w,
                                                                      bottom:
                                                                          10.h,
                                                                      left:
                                                                          10.w,
                                                                      top:
                                                                          10.h),
                                                                  child:
                                                                      ClipRRect(
                                                                    child: Image
                                                                        .asset(
                                                                      'assets/images/person.png',
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                  ),
                                                                )
                                                              : ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius.all(Radius
                                                                          .circular(
                                                                              50)),
                                                                  child: Image
                                                                      .network(
                                                                    Apis.baseURL +
                                                                        listOrder[index]
                                                                            .user
                                                                            .avatar,
                                                                    width:
                                                                        100.w,
                                                                    height:
                                                                        100.h,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  )))),
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        left: 5.w),
                                                    child: Text(listOrder[index]
                                                        .user
                                                        .username),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                                decoration: BoxDecoration(
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            width: 0.2,
                                                            color: Colors
                                                                .grey[300])))),
                                            listOrder[index].userDeliveryId !=
                                                    null
                                                ? Container(
                                                    height: 50.h,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          children: [
                                                            Icon(
                                                              Icons.motorcycle,
                                                              color:
                                                                  Colors.blue,
                                                              size: 25.sp,
                                                            ),
                                                            SizedBox(
                                                              width: 5.w,
                                                            ),
                                                            Text(
                                                              'Giao hàng bởi sinh viên',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .blue),
                                                            ),
                                                          ],
                                                        ),
                                                        IconButton(
                                                          icon: Icon(Icons
                                                              .navigate_next),
                                                          onPressed: () {
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return AlertDialog(
                                                                      title: Text(
                                                                          'Thông tin người giao hàng'),
                                                                      content:
                                                                          SingleChildScrollView(
                                                                        child:
                                                                            Column(
                                                                          children: [
                                                                            Text("Tên người giao: " +
                                                                                listOrder[index].user.username),
                                                                            SizedBox(
                                                                              height: 10.h,
                                                                            ),
                                                                            Text("Số điện thoại: " +
                                                                                listOrder[index].user.phone),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      actions: <
                                                                          Widget>[
                                                                        TextButton(
                                                                          onPressed: () =>
                                                                              Get.back(),
                                                                          child:
                                                                              const Text('Ok'),
                                                                        ),
                                                                      ]);
                                                                });
                                                          },
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                : listOrder[index].staffId !=
                                                        null
                                                    ? Container(
                                                        height: 50.h,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .motorcycle,
                                                                  color: Colors
                                                                      .blue,
                                                                  size: 25.sp,
                                                                ),
                                                                SizedBox(
                                                                  width: 5.w,
                                                                ),
                                                                Text(
                                                                  'Giao hàng bởi quán',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .blue),
                                                                )
                                                              ],
                                                            ),
                                                            IconButton(
                                                              icon: Icon(Icons
                                                                  .navigate_next),
                                                              onPressed: () {
                                                                showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return AlertDialog(
                                                                          title: Text(
                                                                              'Thông tin người giao hàng'),
                                                                          content:
                                                                              SingleChildScrollView(
                                                                            child:
                                                                                Column(
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              children: [
                                                                                Text("Tên người giao: " + listOrder[index].staff.name),
                                                                                SizedBox(
                                                                                  height: 10.h,
                                                                                ),
                                                                                Text("Số điện thoại: " + listOrder[index].staff.phone),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          actions: <
                                                                              Widget>[
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
                                                      )
                                                    : Container(),
                                            Container(
                                                decoration: BoxDecoration(
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            width: 0.2,
                                                            color: Colors
                                                                .grey[300])))),
                                            Container(
                                              height: 60.h,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        Text(
                                                          'Đã giao',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                        Text(DateFormat('HH:mm')
                                                            .format(DateTime.parse(
                                                                    listOrder[
                                                                            index]
                                                                        .updatedAt)
                                                                .toLocal())),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        Text(
                                                          'Món',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                        Text(
                                                            "${listOrder[index].foodOrder.length}")
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        Text(
                                                          'Khoảng cách',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                        FutureBuilder(
                                                          future: distanceRestaurant(
                                                              double.parse(
                                                                  listOrder[
                                                                          index]
                                                                      .latitude),
                                                              double.parse(
                                                                  listOrder[
                                                                          index]
                                                                      .longitude),
                                                              double.parse(
                                                                  listOrder[
                                                                          index]
                                                                      .foodOrder[
                                                                          0]
                                                                      .food
                                                                      .restaurant
                                                                      .lattitude),
                                                              double.parse(listOrder[
                                                                      index]
                                                                  .foodOrder[0]
                                                                  .food
                                                                  .restaurant
                                                                  .longtitude)),
                                                          builder: (context,
                                                              AsyncSnapshot<
                                                                      double>
                                                                  snapshot) {
                                                            if (snapshot
                                                                .hasError)
                                                              return Text(
                                                                  '0.0km');
                                                            if (snapshot
                                                                .hasData)
                                                              return Text(
                                                                  '${snapshot.data}km');
                                                            else {
                                                              return Text(
                                                                  '0.0km');
                                                            }
                                                          },
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                          height: 40.h,
                                          padding: EdgeInsets.only(right: 15.w),
                                          alignment: Alignment.centerRight,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Icon(
                                                Icons.summarize,
                                                size: 20.sp,
                                                color: Colors.grey[700],
                                              ),
                                              SizedBox(
                                                width: 6.w,
                                              ),
                                              Text(
                                                  '${NumberFormat.currency(locale: 'vi').format(listOrder[index].price)}'),
                                            ],
                                          )),
                                    ],
                                  ),
                                ),
                              );
                            }),
                  ),
                );
              }
            }
          }),
    );
  }

  @override
  void initState() {
    listOrder = new RxList<Order>();
    fetch();
    super.initState();
  }

  Future<void> fetch() async {
    var list = await getHistoryCard();
    if (list != null) {
      listOrder.assignAll(list);
      listOrder.refresh();
    }
  }

  Future<List<Order>> getHistoryCard() async {
    List<Order> list;
    String token = (await getToken());
    try {
      http.Response response = await http.get(
        Uri.parse(Apis.getHistoryCardUrl),
        headers: <String, String>{
          'Accept': 'application/json',
          'Authorization': "Bearer $token",
        },
      );
      if (response.statusCode == 200) {
        var parsedJson = jsonDecode(response.body);
        list = ListOrderJson.fromJson(parsedJson).order;
        return list;
      }
      if (response.statusCode == 401) {
        showToast("Loading faild");
      }
    } on TimeoutException catch (e) {
      showError(e.toString());
    } on SocketException catch (e) {
      showError(e.toString());
    }
    return null;
  }
}
