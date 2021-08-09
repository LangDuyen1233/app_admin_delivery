import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app_delivery/components/item_field.dart';
import 'package:app_delivery/models/Discount.dart';
import 'package:app_delivery/models/Food.dart';
import 'package:app_delivery/screen/chat/widget/loading.dart';
import 'package:app_delivery/widgets/form_add_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet_field.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

import '../../../apis.dart';
import '../../../utils.dart';

class EditDiscountFood extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _EditDiscountFood();
  }
}

List<Food> lf;

class _EditDiscountFood extends State<EditDiscountFood> {
  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidate: true,
      child: FutureBuilder(
        future: fetch(),
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
                      updateTopping(context);
                    },
                  ),
                ],
              ),
              body: Container(
                color: Color(0xFFEEEEEE),
                height: 834.h,
                child: Container(
                  child: Column(
                    children: [
                      FormAddWidget(
                        widget: Column(
                          children: [
                            // Avatar(icon: Icons.add_a_photo,name: "Image",),
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
                      )
                    ],
                  ),
                ),
              ),
            );
          } else
            return Container();
        },
      ),
    );
  }

  TextEditingController name;
  TextEditingController percent;
  String foodId;
  int discountId;

  @override
  void initState() {
    foodId = '';
    discountId = Get.arguments['discount_id'];
    print('twefwgef j3fhw3 $discountId');
    lf = new List<Food>();
    fetch();
  }

  Discount d;

  Future<bool> fetch() async {
    var discount = await editDiscount();
    // print(discount);
    if (discount != null) {
      d = discount;
    }
    print(d.name);
    // // print('hjghwehgbwegb ${tp.food.length}');
    name = TextEditingController(text: d.name);
    percent = TextEditingController(text: d.percent.toString());

    lf.addAll(d.food);
    print('leng ${lf.length}');
    print(d.food);

    var tps = await getFood();
    print(tps.length);
    food.assignAll(tps);
    food.refresh();
   return d.isBlank;
  }

  Future<Discount> editDiscount() async {
    Discount discount;
    String token = (await getToken());
    print(discountId.toString() + " topppingsefhebfef");

    Map<String, String> queryParams = {
      'discount_id': discountId.toString(),
    };
    String queryString = Uri(queryParameters: queryParams).query;
    try {
      print(Apis.editDiscountFoodUrl);
      http.Response response = await http.get(
        Uri.parse(Apis.editDiscountFoodUrl + '?' + queryString),
        headers: <String, String>{
          'Accept': 'application/json',
          'Authorization': "Bearer $token",
        },
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        var parsedJson = jsonDecode(response.body);
        discount = Discount.fromJson(parsedJson['discount']);
        return discount;
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

  Future<void> updateTopping(BuildContext context) async {
    String token = await getToken();
    print(token);
    if (Form.of(context).validate()) {
      if (name.text.isNotEmpty && percent.text.isNotEmpty) {
        try {
          // EasyLoading.show(status: 'Loading...');
          List<Food> f = selectedAnimals3;
          for (int i = 0; i < f.length; i++) {
            if (i == f.length - 1) {
              foodId += f[i].id.toString();
            } else {
              foodId += f[i].id.toString() + ",";
            }
          }
          print(foodId);
          print('twefwgef j3fhw3 $discountId');

          http.Response response = await http.post(
            Uri.parse(Apis.updateDiscountFoodUrl),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': "Bearer $token",
            },
            body: jsonEncode(<String, String>{
              'name': name.text,
              'percent': percent.text,
              'food': foodId,
              'discountId': discountId.toString(),
            }),
          );
          print(response.statusCode);
          if (response.statusCode == 200) {
            // EasyLoading.dismiss();
            var parsedJson = jsonDecode(response.body);
            print(parsedJson['success']);
            Discount discount = Discount.fromJson(parsedJson['discount']);
            Get.back(result: discount);
            // Get.off(ListProduct(),
            //     arguments: {'topping': topping, 'category_id': category_id});
            showToast("Chỉnh sửa thành công");
          }
          if (response.statusCode == 404) {
            // EasyLoading.dismiss();
            var parsedJson = jsonDecode(response.body);
            print(parsedJson['error']);
          }
          if (response.statusCode == 500) {
            // EasyLoading.dismiss();
            // var parsedJson = jsonDecode(response.body);
            // print(parsedJson['error']);
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

List<Food> selectedAnimals3;
RxList<Food> food = new RxList<Food>();

class ChooseFood extends StatefulWidget {
  @override
  _ChooseFood createState() => _ChooseFood();
}

class _ChooseFood extends State<ChooseFood> {
  final _multiSelectKey = GlobalKey<FormFieldState>();

  @override
  void initState() {
    selectedAnimals3 = [];
    for (int i = 0; i < lf.length; i++) {
      selectedAnimals3.add(lf[i]);
      for (int j = 0; j < food.length; j++) {
        if (lf[i].name == food[j].name) {
          print('vao day');
          food.remove(food[j]);
        }
      }
      food.add(lf[i]);
      print(food);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
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
              selectedAnimals3 = values;
            });
            // _multiSelectKey.currentState.validate();
          },
          initialValue: selectedAnimals3,
          chipDisplay: MultiSelectChipDisplay(
            onTap: (item) {
              setState(() {
                selectedAnimals3.remove(item);
              });
              // _multiSelectKey.currentState.validate();
            },
            icon: Icon(
              Icons.close,
              color: Colors.red,
            ),
          ),
        ),
      ),
      // ),
    );
  }
}
