import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app_delivery/models/Order.dart';
import 'package:app_delivery/models/Staff.dart';
import 'package:app_delivery/screen/chat/chat.dart';
import 'package:app_delivery/screen/chat/model/user_chat.dart';
import 'package:app_delivery/screen/widget/empty_screen.dart';
import 'package:app_delivery/screen/widget/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../apis.dart';
import '../../../../utils.dart';

class PrepareScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PrepareScreen();
  }
}

RxList<Order> listOrder;
RxList<Staff> staff;

class _PrepareScreen extends State<PrepareScreen> {
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
                            text: "Bạn chưa có đơn hàng nào",
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
                                          top: 2.h,
                                          left: 10.h,
                                        ),
                                        height: 70.h,
                                        width: double.infinity,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        width: 1,
                                                        color: Colors.black12),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                50)),
                                                  ),
                                                  child: Container(
                                                    width: 50.w,
                                                    height: 50.h,
                                                    child: listOrder[index]
                                                                .user
                                                                .avatar ==
                                                            null
                                                        ? Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    right: 10.w,
                                                                    bottom:
                                                                        10.h,
                                                                    left: 10.w,
                                                                    top: 10.h),
                                                            child: ClipRRect(
                                                              child:
                                                                  Image.asset(
                                                                'assets/images/person.png',
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                          )
                                                        : ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            50)),
                                                            child:
                                                                Image.network(
                                                              Apis.baseURL +
                                                                  listOrder[
                                                                          index]
                                                                      .user
                                                                      .avatar,
                                                              width: 100.w,
                                                              height: 100.h,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.only(
                                                      left: 5.w),
                                                  child: Text(listOrder[index]
                                                      .user
                                                      .username),
                                                ),
                                              ],
                                            ),
                                            Container(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  IconButton(
                                                      onPressed: () {
                                                        launch(
                                                            "tel: ${listOrder[index].user.phone}");
                                                      },
                                                      icon: Icon(
                                                        Icons.call,
                                                        size: 20,
                                                        color: Colors.grey,
                                                      )),
                                                  IconButton(
                                                      onPressed: () async {
                                                        SharedPreferences
                                                            prefs =
                                                            await SharedPreferences
                                                                .getInstance();
                                                        User user = FirebaseAuth
                                                            .instance
                                                            .currentUser;
                                                        if (user != null) {
                                                          final querySnapshotresult =
                                                              await FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'users')
                                                                  .where('id',
                                                                      isEqualTo:
                                                                          user.uid)
                                                                  .get();
                                                          if (querySnapshotresult
                                                                  .docs
                                                                  .length ==
                                                              0) {
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'users')
                                                                .doc(user.uid)
                                                                .set({
                                                              'nickname': user
                                                                  .displayName,
                                                              'photoUrl':
                                                                  user.photoURL,
                                                              'id': user.uid,
                                                              'createdAt': DateTime
                                                                      .now()
                                                                  .millisecondsSinceEpoch
                                                                  .toString(),
                                                              'chattingWith':
                                                                  listOrder[
                                                                          index]
                                                                      .user
                                                                      .uid,
                                                            });

                                                            await prefs
                                                                .setString('id',
                                                                    user.uid);
                                                            await prefs.setString(
                                                                'nickname',
                                                                user.displayName ??
                                                                    "");
                                                            await prefs.setString(
                                                                'photoUrl',
                                                                user.photoURL ??
                                                                    "");
                                                          } else {
                                                            DocumentSnapshot
                                                                documentSnapshot =
                                                                querySnapshotresult
                                                                    .docs[0];
                                                            UserChat userChat =
                                                                UserChat.fromDocument(
                                                                    documentSnapshot);
                                                            await prefs
                                                                .setString(
                                                                    'id',
                                                                    userChat
                                                                        .id);
                                                            await prefs.setString(
                                                                'nickname',
                                                                userChat
                                                                    .nickname);
                                                            await prefs.setString(
                                                                'photoUrl',
                                                                userChat.photoUrl ??
                                                                    "");
                                                          }
                                                          String avatar = Apis
                                                                  .baseURL +
                                                              listOrder[index]
                                                                  .user
                                                                  .avatar;
                                                          Get.to(Chat(
                                                            peerId:
                                                                listOrder[index]
                                                                    .user
                                                                    .uid,
                                                            peerNickname:
                                                                listOrder[index]
                                                                    .user
                                                                    .username,
                                                            peerAvatar: avatar,
                                                          ));
                                                        }
                                                      },
                                                      icon: Icon(Icons.message,
                                                          size: 20,
                                                          color: Colors.grey)),
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
                                                      color:
                                                          Colors.grey[300])))),
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
                                                  right: 8.w,
                                                  top: 8.h,
                                                  bottom: 8.w),
                                              child: Column(
                                                children: [
                                                  ListView.builder(
                                                      shrinkWrap: true,
                                                      itemCount:
                                                          listOrder[index]
                                                              .foodOrder
                                                              .length,
                                                      itemBuilder:
                                                          (context, ind) {
                                                        return Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Container(
                                                              width: 24.w,
                                                              child: Text(listOrder[
                                                                          index]
                                                                      .foodOrder[
                                                                          ind]
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
                                                                    listOrder[
                                                                            index]
                                                                        .foodOrder[
                                                                            ind]
                                                                        .food
                                                                        .name,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            18.sp),
                                                                  ),
                                                                  Container(
                                                                    width:
                                                                        230.w,
                                                                    child: ListView.builder(
                                                                        shrinkWrap: true,
                                                                        itemCount: listOrder[index].foodOrder[ind].toppings.length,
                                                                        itemBuilder: (context, i) {
                                                                          return Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text(
                                                                                "+ " + listOrder[index].foodOrder[ind].toppings[i].name,
                                                                                style: TextStyle(fontSize: 15.sp, color: Colors.grey),
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
                                                              child: Text(
                                                                '${NumberFormat.currency(locale: 'vi').format(listOrder[index].foodOrder[ind].price)}',
                                                                textAlign:
                                                                    TextAlign
                                                                        .right,
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      }),
                                                  SizedBox(
                                                    height: 10.h,
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        right: 7.w),
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Text(
                                                        'Tổng: ${NumberFormat.currency(locale: 'vi').format(listOrder[index].price)}'),
                                                  ),
                                                  SizedBox(
                                                    height: 10.h,
                                                  ),
                                                  Container(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    padding:
                                                        EdgeInsets.all(10.sp),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  8.sp)),
                                                      color: Colors.grey[100],
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          width:
                                                              double.infinity,
                                                          child: Text(
                                                            'Ghi chú của khách hàng:',
                                                            style: TextStyle(
                                                                fontSize:
                                                                    16.sp),
                                                          ),
                                                        ),
                                                        Container(
                                                          width:
                                                              double.infinity,
                                                          child: Text(
                                                            listOrder[index]
                                                                        .note ==
                                                                    null
                                                                ? "Chưa có"
                                                                : listOrder[
                                                                        index]
                                                                    .note,
                                                            softWrap: true,
                                                            style: TextStyle(
                                                                fontSize: 15.sp,
                                                                color: Colors
                                                                    .grey),
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
                                      Container(
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                      width: 0.5,
                                                      color:
                                                          Colors.grey[300])))),
                                      Container(
                                        height: 55.h,
                                        child: Column(
                                          children: [
                                            Container(
                                              height: 45.h,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  InkWell(
                                                    onTap: () async {
                                                      showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return AlertDialog(
                                                                title: Text(
                                                                    'Chọn người giao hàng của quán'),
                                                                content:
                                                                    StatefulBuilder(
                                                                  builder: (BuildContext
                                                                          context,
                                                                      StateSetter
                                                                          setState) {
                                                                    return SingleChildScrollView(
                                                                      child: Container(
                                                                          width: double.maxFinite,
                                                                          child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                                                                            ConstrainedBox(
                                                                              constraints: BoxConstraints(
                                                                                maxHeight: MediaQuery.of(context).size.height * 0.4,
                                                                              ),
                                                                              child: ListView.builder(
                                                                                  shrinkWrap: true,
                                                                                  itemCount: staff.length,
                                                                                  itemBuilder: (BuildContext context, int index) {
                                                                                    return RadioListTile(
                                                                                        title: Text(staff[index].name),
                                                                                        value: staff[index].id,
                                                                                        groupValue: selected,
                                                                                        onChanged: (value) {
                                                                                          setState(() {
                                                                                            selected = value;
                                                                                            print(selected);
                                                                                          });
                                                                                        });
                                                                                  }),
                                                                            ),
                                                                          ])),
                                                                    );
                                                                  },
                                                                ),
                                                                actions: <
                                                                    Widget>[
                                                                  TextButton(
                                                                    onPressed:
                                                                        () => Get
                                                                            .back(),
                                                                    child: const Text(
                                                                        'Hủy'),
                                                                  ),
                                                                  TextButton(
                                                                    onPressed:
                                                                        () async {
                                                                      await deliveryByRestaurant(
                                                                          listOrder[index]
                                                                              .id);
                                                                      setState(
                                                                          () async {
                                                                        listOrder
                                                                            .removeAt(index);
                                                                        listOrder
                                                                            .refresh();
                                                                        Get.back();
                                                                        showToast(
                                                                            "Xác nhận đơn hàng thành công");
                                                                        User user = FirebaseAuth
                                                                            .instance
                                                                            .currentUser;
                                                                        await notification(
                                                                            user.uid,
                                                                            'Đơn hàng',
                                                                            'Đơn hàng của bạn được giao bởi nhân viên',
                                                                            3);
                                                                      });
                                                                    },
                                                                    child:
                                                                        const Text(
                                                                      'Xác nhận',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.red),
                                                                    ),
                                                                  ),
                                                                ]);
                                                          });
                                                    },
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      width: 190.w,
                                                      child: Text(
                                                          'Giao bởi quán',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color:
                                                                  Colors.blue)),
                                                    ),
                                                  ),
                                                  Center(
                                                    child: Container(
                                                        decoration: BoxDecoration(
                                                            border: Border(
                                                                right: BorderSide(
                                                                    width: 1,
                                                                    color: Colors
                                                                        .grey)))),
                                                  ),
                                                  InkWell(
                                                    onTap: () async {
                                                      await deliveryByUser(
                                                          listOrder[index].id);
                                                      setState(() {
                                                        listOrder
                                                            .removeAt(index);
                                                        listOrder.refresh();
                                                        Get.back();
                                                        showToast(
                                                            "Báo cho tài xế thành công");
                                                      });
                                                      User user = FirebaseAuth
                                                          .instance.currentUser;
                                                      await notification(
                                                          user.uid,
                                                          'Đơn hàng',
                                                          'Đơn hàng của bạn đang tìm kiếm sinh viên',
                                                          3);
                                                    },
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      width: 190.w,
                                                      child: Text(
                                                        'Tìm kiếm sinh viên',
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color: Colors.blue),
                                                      ),
                                                    ),
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
    staff = new RxList<Staff>();
    fetchStaff();
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
      http.Response response = await http.get(
        Uri.parse(Apis.getPrepareCardUrl),
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

  int selected;

  Future<void> fetchStaff() async {
    var list = await getStaff();
    if (list != null) {
      staff.assignAll(list);
      staff.refresh();
    }
  }

  Future<List<Staff>> getStaff() async {
    List<Staff> list;
    String token = (await getToken());
    try {
      http.Response response = await http.get(
        Uri.parse(Apis.getStaffUrl),
        headers: <String, String>{
          'Accept': 'application/json',
          'Authorization': "Bearer $token",
        },
      );
      if (response.statusCode == 200) {
        var parsedJson = jsonDecode(response.body);
        list = ListStaffJson.fromJson(parsedJson).staff;
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

  Future<Order> deliveryByRestaurant(int id) async {
    String token = await getToken();
    try {
      EasyLoading.show(status: 'Loading...');
      http.Response response = await http.post(
        Uri.parse(Apis.deliveryByRestaurantUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': "Bearer $token",
        },
        body: jsonEncode(
            <String, dynamic>{'orderId': id, 'staffId': selected.toString()}),
      );

      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        var parsedJson = jsonDecode(response.body);
        Order order = Order.fromJson(parsedJson['order']);
        return order;
      }
    } on TimeoutException catch (e) {
      showError(e.toString());
    } on SocketException catch (e) {
      showError(e.toString());
    }
  }

  Future<Order> deliveryByUser(int id) async {
    String token = await getToken();
    try {
      EasyLoading.show(status: 'Loading...');
      http.Response response = await http.post(
        Uri.parse(Apis.deliveryByUserUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': "Bearer $token",
        },
        body: jsonEncode(<String, dynamic>{'orderId': id}),
      );

      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        var parsedJson = jsonDecode(response.body);
        Order order = Order.fromJson(parsedJson['order']);
        return order;
      }
    } on TimeoutException catch (e) {
      showError(e.toString());
    } on SocketException catch (e) {
      showError(e.toString());
    }
  }
}
