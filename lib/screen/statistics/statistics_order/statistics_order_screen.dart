import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app_delivery/controllers/discount_controller.dart';
import 'package:app_delivery/models/Order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:http/http.dart' as http;

import '../../../apis.dart';
import '../../../utils.dart';

class StatisticsOrderScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _StatisticsOrderScreen();
  }
}

class _StatisticsOrderScreen extends State<StatisticsOrderScreen> {
  final DiscountController controller = Get.put(DiscountController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text("Báo cáo đơn hàng"),
      ),
      body: Container(
        color: Color(0xFFEEEEEE),
        height: 834.h,
        width: double.infinity,
        child: Column(
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: 400.w,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            showDialog<Widget>(
                                context: context,
                                builder: (BuildContext context) {
                                  return Center(
                                    child: Container(
                                      width: 414.w,
                                      height: 400.h,
                                      child: Card(
                                        margin: EdgeInsets.only(
                                            left: 12.w, right: 12.w),
                                        child: SfDateRangePicker(
                                          backgroundColor: Colors.white,
                                          showActionButtons: true,
                                          onSubmit: (Object value) async {
                                            print('object' +
                                                controller.range.value);
                                            Navigator.pop(context);
                                            var list = await changeOrder();
                                            setState(() {
                                              count = 0.obs;
                                              order.assignAll(list);
                                              order.refresh();

                                              for (int i = 0;
                                                  i < order.length;
                                                  i++) {
                                                count += 1;
                                              }
                                              print(count);
                                            });
                                          },
                                          onCancel: () {
                                            Navigator.pop(context);
                                          },
                                          onSelectionChanged:
                                              controller.onSelectionChanged,
                                          selectionMode:
                                              DateRangePickerSelectionMode
                                                  .range,
                                        ),
                                      ),
                                    ),
                                  );
                                });
                          },
                          icon: Icon(Icons.calendar_today),
                        ),
                        Obx(() => Text(controller.range.value)),
                      ],
                    ),
                  ),
                  Container(
                      height: 50.h,
                      decoration: BoxDecoration(
                          color: Colors.black87,
                          border: Border(
                              right: BorderSide(
                                  width: 1, color: Colors.blue[100])))),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 220.h,
              child: Card(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: 10.h,
                    ),
                    Container(
                      width: 55.w,
                      height: 55.h,
                      decoration: BoxDecoration(
                        color: Color(0xFFDAECFF),
                        borderRadius: BorderRadius.circular(5.sp),
                      ),
                      child: Icon(
                        Icons.confirmation_number,
                        size: 35.h,
                        color: Colors.blue,
                      ),
                    ),
                    Text(
                      'Số Đơn hàng'.toUpperCase(),
                      style: TextStyle(fontSize: 20.sp),
                    ),
                    Obx(
                      () => Text(
                        '${count.value} đơn',
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    )
                  ],
                ),
              ),
            ),
            Container(
              width: 414.w,
              height: 520.h,
              child: Obx(
                () => ListView.builder(
                    shrinkWrap: true,
                    itemCount: order.length,
                    itemBuilder: (context, index) {
                      return ListDate(
                        item: order[index],
                      );
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }

  RxList<Order> order;
  RxInt count;

  @override
  void initState() {
    order = new RxList<Order>();
    fetch();
    count = 0.obs;
    super.initState();
  }

  Future<void> fetch() async {
    var list = await getOrder();
    if (list != null) {
      order.assignAll(list);
      order.refresh();
    }
    for (int i = 0; i < order.length; i++) {
      count += 1;
    }
  }

  Future<List<Order>> getOrder() async {
    List<Order> list;
    String token = (await getToken());
    try {
      print(Apis.getOrderUrl);
      http.Response response = await http.get(
        Uri.parse(Apis.getOrderUrl),
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

  Future<List<Order>> changeOrder() async {
    List<Order> list;
    String token = (await getToken());
    Map<String, String> queryParams = {
      'range': controller.range.toString(),
    };
    String queryString = Uri(queryParameters: queryParams).query;
    try {
      print(Apis.changeOrderUrl);
      http.Response response = await http.get(
        Uri.parse(Apis.changeOrderUrl + '?' + queryString),
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

class ListDate extends StatelessWidget {
  final Order item;

  const ListDate({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              bottom: BorderSide(
            width: 0.8,
            color: Color(0xFFEEEEEE),
          ))),
      height: 80.h,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  margin: EdgeInsets.only(left: 10.w),
                  child: Text(DateFormat('yyyy-MM-dd')
                      .format(DateTime.parse(item.updatedAt)))),
              Container(
                child: Text('Đơn hàng: #${item.id}'),
              ),
              Container(
                margin: EdgeInsets.only(right: 10.w),
                child: Text('Trạng thái: ${item.statusOrder.status}'),
              )
            ],
          ),
          SizedBox(
            height: 12.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  margin: EdgeInsets.only(left: 10.w),
                  child: Text('Khách hàng: ${item.user.username}')),
              Container(
                margin: EdgeInsets.only(right: 10.w),
                child: Text(
                    'Tồng tiền: ${NumberFormat.currency(locale: 'vi').format(item.price)}'),
              )
            ],
          )
        ],
      ),
    );
  }
}
