import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app_delivery/components/item_field.dart';
import 'package:app_delivery/controllers/discount_controller.dart';
import 'package:app_delivery/models/Discount.dart';
import 'package:app_delivery/widgets/form_add_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../apis.dart';
import '../../utils.dart';
import 'discount_screen.dart';

class EditDiscountVoucher extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _EditDiscountVoucher();
  }
}

class _EditDiscountVoucher extends State<EditDiscountVoucher> {
  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidate: true,
      child: Builder(
        builder: (BuildContext ctx) => FutureBuilder(
          future: fetchDiscount(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  elevation: 0,
                  title: Text("Sửa khuyến mãi"),
                  actions: [
                    IconButton(
                      icon: Icon(Icons.check_outlined),
                      onPressed: () {
                        updateDiscountVoucher(context);
                      },
                    ),
                  ],
                ),
                body: Container(
                    color: Color(0xFFEEEEEE),
                    height: 834.h,
                    width: double.infinity,
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          FormAddWidget(
                            widget: Column(
                              children: [
                                ItemField(
                                  hintText: "Tên",
                                  controller: name,
                                  type: TextInputType.text,
                                  validator: (val) {
                                    if (val.length == 0) {
                                      return 'Vui lòng nhập tên khuyến mãi';
                                    } else
                                      return null;
                                  },
                                ),
                                ItemField(
                                  hintText: "Mã",
                                  controller: code,
                                  type: TextInputType.text,
                                  validator: (val) {
                                    if (val.length == 0) {
                                      return 'Vui lòng nhập mã khuyến mãi';
                                    } else
                                      return null;
                                  },
                                ),
                                ItemField(
                                  hintText: "Giảm (%)",
                                  controller: percent,
                                  type: TextInputType.text,
                                  validator: (val) {
                                    if (val.length == 0) {
                                      return 'Vui lòng nhập giảm giá theo %';
                                    } else
                                      return null;
                                  },
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                StartDate(),
                                SizedBox(
                                  height: 5.h,
                                ),
                                EndDate(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
              );
            } else
              return Container();
          },
        ),
      ),
    );
  }

  TextEditingController name;
  TextEditingController code;
  TextEditingController percent;
  final DiscountController date = Get.put(DiscountController());
  int discountId;
  Discount d;

  @override
  void initState() {
    discountId = Get.arguments['discount_id'];
    super.initState();
  }

  Future<bool> fetchDiscount() async {
    var discount = await editDiscountVoucher();
    if (discount != null) {
      d = discount;
    }
    name = TextEditingController(text: d.name);
    code = TextEditingController(text: d.code);
    percent = TextEditingController(text: d.percent.toString());
    date.startDates = d.startDate;
    date.endDates = d.endDate;

    return discount.isBlank;
  }

  Future<Discount> editDiscountVoucher() async {
    Discount discount;
    String token = (await getToken());
    discountId = Get.arguments['discount_id'];
    Map<String, String> queryParams = {
      'discountId': discountId.toString(),
    };
    String queryString = Uri(queryParameters: queryParams).query;
    try {
      http.Response response = await http.get(
        Uri.parse(Apis.editDiscountVoucherUrl + '?' + queryString),
        headers: <String, String>{
          'Accept': 'application/json',
          'Authorization': "Bearer $token",
        },
      );
      if (response.statusCode == 200) {
        var parsedJson = jsonDecode(response.body);
        discount = DiscountJson.fromJson(parsedJson).discount;
        print(discount);
        return discount;
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

  Future<void> updateDiscountVoucher(BuildContext context) async {
    String token = await getToken();
    String startDate = date.startDates;
    String endDate = date.endDates;

    if (name.text.isNotEmpty &&
        code.text.isNotEmpty &&
        percent.text.isNotEmpty) {
      try {
        http.Response response = await http.post(
          Uri.parse(Apis.updateDiscountVoucherUrl),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': "Bearer $token",
          },
          body: jsonEncode(<String, dynamic>{
            'name': name.text,
            'code': code.text,
            'percent': percent.text,
            'start_date': startDate,
            'end_date': endDate,
            'type_discount_id': 1,
            'discountId':discountId
          }),
        );

        if (response.statusCode == 200) {
          EasyLoading.dismiss();
          var parsedJson = jsonDecode(response.body);
          Discount discount = Discount.fromJson(parsedJson['discount']);
          Get.off(DiscountScreen(), arguments: {'discount': discount});
          showToast("Sửa thành công");
        }
      } on TimeoutException catch (e) {
        showError(e.toString());
      } on SocketException catch (e) {
        showError(e.toString());
      }
    } else {
      showToast('Vui lòng điền đầy đủ các trường');
    }
  }
}

class StartDate extends StatelessWidget {
  final DiscountController controller = Get.put(DiscountController());

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10.w, right: 10.w),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      height: 60.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              padding: EdgeInsets.only(left: 15.w),
              child: Text('Ngày bắt đầu')),
          Row(
            children: [
              GetBuilder<DiscountController>(builder: (context) {
                return controller.startDates != null
                    ? Text(
                        controller.startDates,
                        style: TextStyle(fontSize: 15.sp, color: Colors.grey),
                      )
                    : Text('Chọn ngày bắt đầu');
              }),
              IconButton(
                onPressed: () {
                  controller.selectStartDate(context);
                },
                icon: Icon(
                  Icons.calendar_today_rounded,
                  size: 18,
                  color: Colors.grey,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class EndDate extends StatelessWidget {
  final DiscountController controller = Get.put(DiscountController());

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10.w, right: 10.w),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      height: 60.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              padding: EdgeInsets.only(left: 15.w),
              child: Text('Ngày kết thúc')),
          Row(
            children: [
              GetBuilder<DiscountController>(builder: (context) {
                return controller.endDates != null
                    ? Text(controller.endDates,
                        style: TextStyle(fontSize: 15.sp, color: Colors.grey))
                    : Text('Chọn ngày kết thúc');
              }),
              IconButton(
                onPressed: () {
                  controller.selectEndDate(context);
                },
                icon: Icon(
                  Icons.calendar_today_rounded,
                  size: 18,
                  color: Colors.grey,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
