import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app_delivery/components/item_field.dart';
import 'package:app_delivery/models/Discount.dart';
import 'package:app_delivery/models/Food.dart';
import 'package:app_delivery/widgets/form_add_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet_field.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

import '../../apis.dart';
import '../../utils.dart';
import 'choose_discounts.dart';
import 'discount_screen.dart';

class AddDiscountFood extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddDiscountFood();
  }
}

class _AddDiscountFood extends State<AddDiscountFood> {
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
                          addDiscountFood(ctx);
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
                                    hintText: "Tên khuyễn mãi",
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
                                  ChooseFood()
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),
                )));
  }

  TextEditingController name;
  TextEditingController percent;
  int typeId;
  String foodId;

  @override
  void initState() {
    typeId = Get.arguments['type_discount_id'];
    name = TextEditingController();
    percent = TextEditingController();
    foodId = '';
    super.initState();
  }

  Future<void> addDiscountFood(BuildContext context) async {
    String token = await getToken();
    print(token);
    if (Form.of(context).validate()) {
      if (name.text.isNotEmpty && percent.text.isNotEmpty) {
        try {
          EasyLoading.show(status: 'Loading...');

          List<Food> tp = _selectedAnimals3;
          print(tp);
          for (int i = 0; i < tp.length; i++) {
            if (i == tp.length - 1) {
              foodId += tp[i].id.toString();
            } else {
              foodId += tp[i].id.toString() + ",";
            }
          }
          print(foodId);
          http.Response response = await http.post(
            Uri.parse(Apis.addDiscountFoodUrl),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': "Bearer $token",
            },
            body: jsonEncode(<String, dynamic>{
              'name': name.text,
              'percent': percent.text,
              'type_discount_id': typeId,
              'food': foodId,
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

List<Food> _selectedAnimals3;

class ChooseFood extends StatefulWidget {
  @override
  _ChooseFood createState() => _ChooseFood();
}

class _ChooseFood extends State<ChooseFood> {
  static RxList<Food> food = new RxList<Food>();

  var _items = food.map((f) => MultiSelectItem<Food>(f, f.name)).toList();

  final _multiSelectKey = GlobalKey<FormFieldState>();

  @override
  void initState() {
    fetchFood();
    _selectedAnimals3 = [];
    // print(_items);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Obx(
        () => Container(
          color: Colors.white,
          margin: EdgeInsets.only(top: 5.h, left: 10.w, right: 10.w),
          child: MultiSelectBottomSheetField<Food>(
            key: _multiSelectKey,
            initialChildSize: .7,
            maxChildSize: 0.95,
            title: Text("Danh sách món ăn"),
            buttonText: Text("Chọn món ăn áp dụng"),
            buttonIcon: Icon(
              Icons.arrow_drop_down,
              color: Colors.grey,
            ),
            decoration: BoxDecoration(),
            items: food.map((f) => MultiSelectItem<Food>(f, f.name)).toList(),
            searchable: true,
            onConfirm: (values) {
              setState(() {
                _selectedAnimals3 = values;
              });
              _multiSelectKey.currentState.validate();
            },
            chipDisplay: MultiSelectChipDisplay(
              onTap: (item) {
                setState(() {
                  _selectedAnimals3.remove(item);
                });
                _multiSelectKey.currentState.validate();
              },
              icon: Icon(
                Icons.close,
                color: Colors.red,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> fetchFood() async {
    var listFood = await getFood();
    print(listFood.length);
    if (listFood != null) {
      printInfo(info: listFood.length.toString());
      food.assignAll(listFood);
      print(food);
      food.refresh();
    }
  }

  Future<List<Food>> getFood() async {
    List<Food> list;
    String token = (await getToken());
    try {
      print(Apis.getDiscountFoodUrl);
      http.Response response = await http.get(
        Uri.parse(Apis.getDiscountFoodUrl),
        headers: <String, String>{
          'Accept': 'application/json',
          'Authorization': "Bearer $token",
        },
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        var parsedJson = jsonDecode(response.body);
        print(parsedJson['food']);
        list = ListFoodJson.fromJson(parsedJson).food;
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
