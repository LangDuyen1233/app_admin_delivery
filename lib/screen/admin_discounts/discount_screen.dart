import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app_delivery/models/Discount.dart';
import 'package:app_delivery/screen/admin_discounts/edit_discount_food.dart';
import 'package:app_delivery/screen/admin_discounts/edit_discount_voucher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../apis.dart';
import '../../utils.dart';
import 'choose_discounts.dart';

class DiscountScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DiscountScreen();
  }
}

RxList<Discount> discount;
// RxList<Discount> topping = new RxList<Discount>();

class _DiscountScreen extends State<DiscountScreen> {
  int type_discount_id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text("Danh sách khuyến mãi"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              print("mày có vô đây không???");
              Get.to(ChooseDiscount());
            },
          ),
        ],
      ),
      body: Container(
          color: Color(0xFFEEEEEE),
          height: 834.h,
          width: double.infinity,
          child: Column(
            children: [
              Expanded(
                  child: Obx(
                () => ListView.builder(
                  shrinkWrap: true,
                  itemCount: discount.length,
                  itemBuilder: (context, index) {
                    return Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      actionExtentRatio: 0.12,
                      child: DiscountItem(
                        item: discount[index],
                      ),
                      secondaryActions: <Widget>[
                        Container(
                          child: IconSlideAction(
                            caption: 'Edit',
                            color: Color(0xFFEEEEEE),
                            icon: Icons.edit,
                            foregroundColor: Colors.blue,
                            onTap: () async {
                              var result = await Get.to(
                                  () => discount[index].typeDiscountId != 1
                                      ? EditDiscountVoucher()
                                      : EditDiscountFood(),
                                  arguments: {
                                    'discount_id': discount.value[index].id
                                  });
                              setState(() {
                                if (result != null) {
                                  fetchDiscount();
                                }
                              });
                            },
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5),
                          child: IconSlideAction(
                            caption: 'Delete',
                            color: Color(0xFFEEEEEE),
                            icon: Icons.delete,
                            foregroundColor: Colors.red,
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                        title: Text('Xóa khuyến mãi'),
                                        content: const Text(
                                            'Bạn có chắc chắn muốn xóa không?'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () => Get.back(),
                                            child: const Text('Hủy'),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                               discount[index].typeDiscountId != 1? await deleteDiscountVoucher(
                                                  discount[index].id): await deleteDiscountFood(discount[index].id);

                                              setState(() {
                                                discount.removeAt(index);
                                                discount.refresh();
                                                Get.back();
                                                showToast("Xóa thành công");
                                              });

                                              // Get.to(ListProduct());

                                              // food.refresh();
                                            },
                                            child: const Text(
                                              'Xóa',
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          ),
                                        ]);
                                  });
                            },
                          ),
                        )
                      ],
                    );
                  },
                ),
              )),
              SizedBox(
                height: 5.h,
              )
            ],
          )),
    );
  }

  @override
  void initState() {
    discount = new RxList<Discount>();
    fetchDiscount();
    super.initState();
  }

  Future<void> fetchDiscount() async {
    var list = await getDiscount();
    if (list != null) {
      // printInfo(info: listFood.length.toString());
      print(list.length);
      discount.assignAll(list);
      discount.refresh();
      // print(food.length);
    }
  }

  Future<List<Discount>> getDiscount() async {
    List<Discount> list;
    String token = (await getToken());
    try {
      print(Apis.getDiscountUrl);
      http.Response response = await http.get(
        Uri.parse(Apis.getDiscountUrl),
        headers: <String, String>{
          'Accept': 'application/json',
          'Authorization': "Bearer $token",
        },
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        var parsedJson = jsonDecode(response.body);
        // print(parsedJson['discount']);
        list = ListDiscountJson.fromJson(parsedJson).discount;
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

  Future<Discount> deleteDiscountVoucher(int discount_id) async {
    String token = await getToken();
    print(token);

    try {
      EasyLoading.show(status: 'Loading...');
      http.Response response = await http.post(
        Uri.parse(Apis.deleteDiscountVoucherUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': "Bearer $token",
        },
        body: jsonEncode(<String, dynamic>{
          'discount_id': discount_id,
        }),
      );

      print(response.statusCode);
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        var parsedJson = jsonDecode(response.body);
        // print(parsedJson['success']);
        Discount discount = Discount.fromJson(parsedJson['discount']);
        return discount;
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
  }

  Future<Discount> deleteDiscountFood(int discount_id) async {
    String token = await getToken();
    print(token);

    try {
      EasyLoading.show(status: 'Loading...');
      http.Response response = await http.post(
        Uri.parse(Apis.deleteDiscountFoodUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': "Bearer $token",
        },
        body: jsonEncode(<String, dynamic>{
          'discount_id': discount_id,
        }),
      );

      print(response.statusCode);
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        var parsedJson = jsonDecode(response.body);
        // print(parsedJson['success']);
        Discount discount = Discount.fromJson(parsedJson['discount']);
        return discount;
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
  }
}

class DiscountItem extends StatelessWidget {
  final Discount item;

  const DiscountItem({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.only(top: 10.h, left: 15, right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.sp)),
          color: Colors.white,
        ),
        height: 130.h,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 10.w),
                  child: item.typeDiscountId != 1
                      ? Icon(
                          Icons.local_offer,
                          size: 35.h,
                          color: Colors.amber,
                        )
                      : Icon(
                          Icons.food_bank,
                          size: 35.h,
                          color: Colors.blue,
                        ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 15.w, right: 10.w),
                  // height: 92.h,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        height: 5.h,
                      ),
                      Text(
                        item.name,
                        style: TextStyle(
                            fontSize: 20.sp, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Text(
                        "Giảm (%):" + item.percent + " %",
                        style: TextStyle(
                            fontSize: 16.sp, fontWeight: FontWeight.w400),
                      ),
                      item.typeDiscountId != 1
                          ? Text(
                              "Mã giảm: " + item.code,
                              style: TextStyle(
                                  fontSize: 16.sp, fontWeight: FontWeight.w400),
                            )
                          : Text(''),
                      Container(
                        width: 300.w,
                        child: Text(
                          item.typeDiscount == null
                              ? ""
                              : item.typeDiscount.content,
                          softWrap: true,
                          style: TextStyle(fontSize: 15.sp, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
