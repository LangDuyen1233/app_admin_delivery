import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app_delivery/components/item_field.dart';
import 'package:app_delivery/models/Food.dart';
import 'package:app_delivery/models/Topping.dart';
import 'package:app_delivery/screen/products/admin/edit_food.dart';
import 'package:app_delivery/widgets/form_add_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet_field.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:http/http.dart' as http;

import '../../../apis.dart';
import '../../../utils.dart';
import 'list_products.dart';

class EditToppings extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _EditToppings();
  }
}

List<Food> lf;

class _EditToppings extends State<EditToppings> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchTopping(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Form(
            autovalidate: true,
            child: Builder(
              builder: (BuildContext ctx) => Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  elevation: 0,
                  title: Text("Sửa topping"),
                  actions: [
                    IconButton(
                      icon: Icon(Icons.check_outlined),
                      onPressed: () {
                        updateTopping(ctx);
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
                                hintText: "Tên topping",
                                controller: name,
                                type: TextInputType.text,
                                validator: (val) {
                                  print(val);
                                  if (val.length == 0) {
                                    return 'Vui lòng nhập tên topping';
                                  } else
                                    return null;
                                },
                              ),
                              ItemField(
                                hintText: "Giá bán",
                                controller: price,
                                type: TextInputType.number,
                                validator: (val) {
                                  print(val);
                                  if (val.length == 0) {
                                    return 'Vui lòng nhập giá bán';
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
              ),
            ),
          );
        } else
          return Container();
      },
    );
  }

  TextEditingController name;
  TextEditingController price;
  int category_id;
  String foodId;
  int toppingId;

  @override
  void initState() {
    print(Get.arguments['category_id']);
    getCategory();
    // name = TextEditingController();
    // price = TextEditingController();
    foodId = '';
    toppingId = Get.arguments['topping_id'];
    lf = new List<Food>();
  }

  void getCategory() async {
    category_id = await Get.arguments['category_id'];
  }

  Topping tp;

  Future<bool> fetchTopping() async {
    var topping = await editTopping();
    if (topping != null) {
      print(topping);
      tp = topping;
    }
    print('hjghwehgbwegb ${tp.food.length}');
    name = TextEditingController(text: tp.name);
    price = TextEditingController(text: tp.price.toString());

    lf.addAll(tp.food);
    print('leng ${lf.length}');

    var tps = await getFood();
    food.assignAll(tps);
    food.refresh();

    return topping.isBlank;
  }

  Future<Topping> editTopping() async {
    Topping topping;
    String token = (await getToken());
    int categoryId = Get.arguments['category_id'];
    print(categoryId.toString() + " topping nn dduj mas m");
    print(toppingId.toString() + " topppingsefhebfef");

    Map<String, String> queryParams = {
      'category_id': categoryId.toString(),
      'topping_id': toppingId.toString(),
    };
    String queryString = Uri(queryParameters: queryParams).query;
    try {
      print(Apis.editToppingUrl);
      http.Response response = await http.get(
        Uri.parse(Apis.editToppingUrl + '?' + queryString),
        headers: <String, String>{
          'Accept': 'application/json',
          'Authorization': "Bearer $token",
        },
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        var parsedJson = jsonDecode(response.body);
        print(parsedJson['topping']);
        topping = ToppingJson.fromJson(parsedJson).topping;
        print(topping);
        return topping;
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
      if (name.text.isNotEmpty && price.text.isNotEmpty) {
        try {
          EasyLoading.show(status: 'Loading...');
          List<Food> f = selectedAnimals3;
          for (int i = 0; i < f.length; i++) {
            if (i == f.length - 1) {
              foodId += f[i].id.toString();
            } else {
              foodId += f[i].id.toString() + ",";
            }
          }
          print(foodId);

          http.Response response = await http.post(
            Uri.parse(Apis.updateToppingUrl),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': "Bearer $token",
            },
            body: jsonEncode(<String, String>{
              'name': name.text,
              'price': price.text,
              'food': foodId,
              'topping': toppingId.toString(),
            }),
          );
          print(response.statusCode);
          if (response.statusCode == 200) {
            EasyLoading.dismiss();
            var parsedJson = jsonDecode(response.body);
            Topping topping = Topping.fromJson(parsedJson['topping']);
            Get.back(result: topping);
            // Get.off(ListProduct(),
            //     arguments: {'topping': topping, 'category_id': category_id});
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

  Future<List<Food>> getFood() async {
    List<Food> list;
    String token = (await getToken());
    int categoryId = Get.arguments['category_id'];
    print(categoryId.toString() + " dduj mas m");
    Map<String, String> queryParams = {
      'category_id': categoryId.toString(),
    };
    String queryString = Uri(queryParameters: queryParams).query;
    try {
      print(Apis.getFoodUrl);
      http.Response response = await http.get(
        Uri.parse(Apis.getFoodUrl + '?' + queryString),
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
final _multiSelectKey = GlobalKey<FormFieldState>();

class ChooseFood extends StatefulWidget {
  @override
  _ChooseFood createState() => _ChooseFood();
}

class _ChooseFood extends State<ChooseFood> {
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child:
          // Obx(
          //   () =>
          Container(
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
            _multiSelectKey.currentState.validate();
          },
          initialValue: selectedAnimals3,
          chipDisplay: MultiSelectChipDisplay(
            onTap: (item) {
              setState(() {
                selectedAnimals3.remove(item);
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
      // ),
    );
  }

// Future<void> fetchFood() async {
//   var listFood = await getFood();
//   if (listFood != null) {
//     printInfo(info: listFood.length.toString());
//     food.assignAll(listFood);
//     food.refresh();
//   }
// }

}
