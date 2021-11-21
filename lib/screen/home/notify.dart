import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app_delivery/models/Notify.dart';
import 'package:app_delivery/screen/widget/empty_screen.dart';
import 'package:app_delivery/screen/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../apis.dart';
import '../../utils.dart';

class NotifyScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Notify();
  }
}

class _Notify extends State<NotifyScreen> {
  RxList<Notify> notify;

  @override
  void initState() {
    notify = new RxList<Notify>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: Text("Thông báo"),
        ),
        body: FutureBuilder(
          future: fetch(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Loading();
            } else {
              if (snapshot.hasData) {
                return Container(
                    padding: EdgeInsets.only(top: 5.h),
                    color: Color(0xFFEEEEEE),
                    height: 834.h,
                    child: RefreshIndicator(
                      onRefresh: () => fetch(),
                      child: ListView.builder(
                        reverse: true,
                        shrinkWrap: true,
                        itemCount: notify.length,
                        itemBuilder: (context, index) {
                          return Container(
                            child: NotifyCard(
                              item: notify[index],
                            ),
                          );
                        },
                      ),
                    ));
              } else {
                return EmptyScreen(
                  text: 'Bạn chưa có thông báo',
                );
              }
            }
          },
        ));
  }

  Future<bool> fetch() async {
    var list = await getNotify();
    if (list != null) {
      notify.assignAll(list);
      notify.refresh();
    }
    return notify.isNotEmpty;
  }

  Future<List<Notify>> getNotify() async {
    String token = (await getToken());
    try {
      http.Response response = await http.get(
        Uri.parse(Apis.getNotifyUrl),
        headers: <String, String>{
          'Accept': 'application/json',
          'Authorization': "Bearer $token",
        },
      );
      if (response.statusCode == 200) {
        var parsedJson = jsonDecode(response.body);
        var list = ListNotifyJson.fromJson(parsedJson).notify;
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

class NotifyCard extends StatelessWidget {
  final Notify item;

  const NotifyCard({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 3.h,
        left: 8.h,
      ),
      margin: EdgeInsets.only(top: 10.h, left: 12.h, right: 10.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8.sp)),
        color: Colors.white,
      ),
      height: 100.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: 15.w, right: 10.w),
            height: 92.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.notifications,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          width: 4.w,
                        ),
                        Text(
                          item.title,
                          style: TextStyle(
                              fontSize: 18.sp, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    Text(DateFormat('yyyy-MM-dd hh:mm').format(
                        DateTime.parse(
                            item.updatedAt)),style: TextStyle(color: Colors.black54),)
                  ],
                ),
                Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                width: 0.5, color: Colors.grey[300])))),
                Container(
                  width: 400.w,
                  padding: EdgeInsets.only(bottom: 20.h, top: 5.h),
                  child: Text(
                    item.body,
                    softWrap: true,
                    style: TextStyle(fontSize: 16.sp),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
