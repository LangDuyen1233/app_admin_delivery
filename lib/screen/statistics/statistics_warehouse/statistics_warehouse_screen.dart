import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app_delivery/controllers/discount_controller.dart';
import 'package:app_delivery/models/Material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:http/http.dart' as http;

import '../../../apis.dart';
import '../../../utils.dart';

class StatisticsWarehouseScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _StatisticsWarehouseScreen();
  }
}

class _StatisticsWarehouseScreen extends State<StatisticsWarehouseScreen> {
  final DiscountController controller = Get.put(DiscountController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text("Báo cáo kho"),
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
                                            var list = await changeWarehouse();
                                            setState(() {
                                              // price = 0.obs;
                                              count = 0.obs;
                                              materials.assignAll(list);
                                              materials.refresh();
                                              for (int i = 0;
                                              i < materials.length;
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
                        Icons.house_siding,
                        size: 35.h,
                        color: Colors.blue,
                      ),
                    ),
                    Text(
                      'Số lượng tồn kho'.toUpperCase(),
                      style: TextStyle(fontSize: 20.sp),
                    ),
                    Obx(
                      () => Text(
                        count.value.toString(),
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 20.sp,
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
                    itemCount: materials.length,
                    itemBuilder: (context, index) {
                      return ListDate(
                        item: materials[index],
                      );
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }

  RxList<Materials> materials;
  RxInt count;

  @override
  void initState() {
    materials = new RxList<Materials>();
    fetch();
    count = 0.obs;
    super.initState();
  }

  Future<void> fetch() async {
    var list = await getWarehouse();
    if (list != null) {
      materials.assignAll(list);
      materials.refresh();
    }
    for (int i = 0; i < materials.length; i++) {
      count += 1;
    }
    print(count);
  }

  Future<List<Materials>> getWarehouse() async {
    List<Materials> list;
    String token = (await getToken());
    try {
      print(Apis.getWarehouseUrl);
      http.Response response = await http.get(
        Uri.parse(Apis.getWarehouseUrl),
        headers: <String, String>{
          'Accept': 'application/json',
          'Authorization': "Bearer $token",
        },
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        var parsedJson = jsonDecode(response.body);
        list = ListMaterialsJson.fromJson(parsedJson).materials;
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

  Future<List<Materials>> changeWarehouse() async {
    List<Materials> list;
    String token = (await getToken());
    Map<String, String> queryParams = {
      'range': controller.range.toString(),
    };
    String queryString = Uri(queryParameters: queryParams).query;
    try {
      print(Apis.changeWarehouseUrl);
      http.Response response = await http.get(
        Uri.parse(Apis.changeWarehouseUrl + '?' + queryString),
        headers: <String, String>{
          'Accept': 'application/json',
          'Authorization': "Bearer $token",
        },
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        var parsedJson = jsonDecode(response.body);
        list = ListMaterialsJson.fromJson(parsedJson).materials;
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
  final Materials item;

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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              margin: EdgeInsets.only(left: 10.w),
              child: Text(DateFormat('yyyy-MM-dd')
                  .format(DateTime.parse(item.updatedAt)))),
          Container(
              margin: EdgeInsets.only(right: 10.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Tên sản phẩm:'),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                    '${item.name}',
                    style: TextStyle(color: Colors.blue,fontSize: 17.sp),
                  ),
                ],
              )),
          Container(
              margin: EdgeInsets.only(right: 10.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Số lượng còn lại:'),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text('${item.quantity}',
                      style: TextStyle(color: Colors.blue)),
                ],
              )),
        ],
      ),
    );
  }
}
