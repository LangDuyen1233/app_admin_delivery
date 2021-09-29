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
import 'choose_discounts.dart';
import 'discount_screen.dart';

class AddDiscountVoucher extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddDiscountVoucher();
  }
}

class _AddDiscountVoucher extends State<AddDiscountVoucher> {
  @override
  Widget build(BuildContext context) {
    return Form(
        autovalidate: true,
        child: Builder(
            builder: (BuildContext ctx) => Scaffold(
                  appBar: AppBar(
                    centerTitle: true,
                    elevation: 0,
                    title: Text("Thêm khuyến mãi"),
                    leading: BackButton(
                      onPressed: () {
                        Get.off(ChooseDiscount());
                      },
                    ),
                    actions: [
                      IconButton(
                        icon: Icon(Icons.check_outlined),
                        onPressed: () {
                          addDiscountVoucher(ctx);
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
                                  // Avatar(icon: Icons.add_a_photo,name: "Image",),
                                  ItemField(
                                    hintText: "Tên",
                                    controller: name,
                                    type: TextInputType.text,
                                    validator: (val) {
                                      print(val);
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
                                      print(val);
                                      if (val.length == 0) {
                                        return 'Vui lòng nhập mã khuyến mãi';
                                      } else
                                        return null;
                                    },
                                  ),
                                  ItemField(
                                    hintText: "Giảm (%)",
                                    controller: percent,
                                    type: TextInputType.number,
                                    validator: (val) {
                                      print(val);
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
                )));
  }

  int typeId;

  @override
  void initState() {
    typeId = Get.arguments['type_discount_id'];
    print("hahahah $typeId");
    name = TextEditingController();
    code = TextEditingController();
    percent = TextEditingController();
    super.initState();
  }

  TextEditingController name;
  TextEditingController code;
  TextEditingController percent;
  final DiscountController date = Get.put(DiscountController());

  Future<void> addDiscountVoucher(BuildContext context) async {
    String token = await getToken();
    print(token);
    if (Form.of(context).validate()) {
      String startDate = date.startDates;
      String endDate = date.endDates;
      if (name.text.isNotEmpty &&
          code.text.isNotEmpty &&
          percent.text.isNotEmpty) {
        try {
          EasyLoading.show(status: 'Loading...');

          http.Response response = await http.post(
            Uri.parse(Apis.addDiscountVoucherUrl),
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
              'type_discount_id': typeId
            }),
          );

          print(response.statusCode);
          if (response.statusCode == 200) {
            EasyLoading.dismiss();
            var parsedJson = jsonDecode(response.body);
            Discount discount = Discount.fromJson(parsedJson['discount']);
            Get.off(DiscountScreen(), arguments: {'discount': discount});
            showToast("Tạo thành công");
          }
          if (response.statusCode == 404) {
            EasyLoading.dismiss();
            var parsedJson = jsonDecode(response.body);
            print(parsedJson['error']);
          }
        } on TimeoutException catch (e) {
          showError(e.toString());
        } on SocketException catch (e) {
          showError(e.toString());
        }
      } else {
        showToast('Vui lòng điền đầy đủ các trường');
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
                return Text(
                  controller.startDates,
                  style: TextStyle(fontSize: 15.sp, color: Colors.grey),
                );
              }),
              IconButton(
                onPressed: () {
                  print('dduj mas m');
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
                return Text(controller.endDates,
                    style: TextStyle(fontSize: 15.sp, color: Colors.grey));
              }),
              IconButton(
                onPressed: () {
                  print('dduj mas m');
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
