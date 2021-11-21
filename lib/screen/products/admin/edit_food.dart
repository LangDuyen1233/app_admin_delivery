import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app_delivery/components/item_field.dart';
import 'package:app_delivery/controllers/image_controler.dart';
import 'package:app_delivery/models/Food.dart';
import 'package:app_delivery/models/Topping.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet_field.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:http/http.dart' as http;

import '../../../apis.dart';
import '../../../utils.dart';

class EditFood extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _EditFood();
  }
}

List<Topping> ltp;

class _EditFood extends State<EditFood> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchFood(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Form(
            autovalidate: true,
            child: Builder(
              builder: (BuildContext ctx) => Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  elevation: 0,
                  title: Text("Sửa món ăn"),
                  actions: [
                    IconButton(
                      icon: Icon(Icons.check_outlined),
                      onPressed: () {
                        updateFood(ctx);
                      },
                    ),
                  ],
                ),
                body: Container(
                  color: Color(0xFFEEEEEE),
                  height: 834.h,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ListImages(
                          url: f.image[0].url,
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        Column(
                          children: [
                            ItemField(
                              hintText: "Tên món ăn",
                              controller: name,
                              type: TextInputType.text,
                              validator: (val) {
                                print(val);
                                if (val.length == 0) {
                                  return 'Vui lòng nhập tên món ăn';
                                } else
                                  return null;
                              },
                            ),
                            ItemField(
                              hintText: "Size",
                              controller: size,
                              type: TextInputType.text,
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
                            ItemField(
                              hintText: "Khối lượng",
                              controller: weight,
                              type: TextInputType.number,
                            ),
                            ItemField(
                              hintText: "Thành phần",
                              controller: ingredients,
                              type: TextInputType.text,
                            ),
                            new ChooseTopping()
                          ],
                        ),
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
  TextEditingController size;
  TextEditingController price;
  TextEditingController weight;
  TextEditingController ingredients;
  int category_id;
  int food_id;
  String toppingId;
  final ImageController controller = Get.put(ImageController());

  Food f;
  Topping tp;

  @override
  void initState() {
    print(Get.arguments['category_id']);
    category_id = Get.arguments['category_id'];
    food_id = Get.arguments['food_id'];
    fetchFood();
    toppingId = '';

    validateImage = '';
    super.initState();
  }

  Future<bool> fetchFood() async {
    var food = await editFood();
    if (food != null) {
      f = food;
    }
    name = TextEditingController(text: f.name);
    size = TextEditingController(text: f.size);
    price = TextEditingController(text: f.price.toString());
    weight = TextEditingController(text: f.weight.toString());
    ingredients = TextEditingController(text: f.ingredients);

    ltp = f.topping;

    var tp = await getTopping();
    topping.assignAll(tp);
    topping.refresh();

    return food.isBlank;
  }

  Future<Food> editFood() async {
    Food food;
    String token = (await getToken());
    int categoryId = Get.arguments['category_id'];
    Map<String, String> queryParams = {
      'category_id': categoryId.toString(),
      'food_id': food_id.toString(),
    };
    String queryString = Uri(queryParameters: queryParams).query;
    try {
      print(Apis.editFoodUrl);
      http.Response response = await http.get(
        Uri.parse(Apis.editFoodUrl + '?' + queryString),
        headers: <String, String>{
          'Accept': 'application/json',
          'Authorization': "Bearer $token",
        },
      );
      if (response.statusCode == 200) {
        var parsedJson = jsonDecode(response.body);
        food = FoodJson.fromJson(parsedJson).food;
        return food;
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

  Future<void> updateFood(BuildContext context) async {
    String token = await getToken();
    if (Form.of(context).validate()) {
      String nameImage;
      if (f.image[0] != null) {
        if (controller.imagePath != null) {
          int code = await uploadImage(controller.image, controller.imagePath);
          if (code == 200) {
            nameImage = controller.imagePath.split('/').last;
          }
        } else {
          nameImage = f.image[0].url.split('/').last;
        }
      }
      if (name.text.isNotEmpty &&
          nameImage.isNotEmpty &&
          price.text.isNotEmpty) {
        try {
          EasyLoading.show(status: 'Loading...');
          List<Topping> tp = selectedAnimals3;
          for (int i = 0; i < tp.length; i++) {
            if (i == tp.length - 1) {
              toppingId += tp[i].id.toString();
            } else {
              toppingId += tp[i].id.toString() + ",";
            }
          }

          http.Response response = await http.post(
            Uri.parse(Apis.updateFoodUrl),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': "Bearer $token",
            },
            body: jsonEncode(<String, dynamic>{
              'name': name.text,
              'size': size.text,
              'price': price.text,
              'weight': weight.text,
              'ingredients': ingredients.text,
              'image': nameImage,
              'category_id': category_id.toString(),
              'topping': toppingId,
              'food_id': food_id,
            }),
          );

          if (response.statusCode == 200) {
            EasyLoading.dismiss();
            var parsedJson = jsonDecode(response.body);
            Food food = Food.fromJson(parsedJson['food']);
            Get.back(result: food);
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
    } else {
      controller.imagePath == ''
          ? validateImage = ''
          : validateImage = 'Vui lòng chọn hình ảnh cho món ăn';
      showToast('Vui lòng điền đầy đủ các trường');
    }
  }

  Future<List<Topping>> getTopping() async {
    List<Topping> list;
    String token = (await getToken());
    try {
      http.Response response = await http.get(
        Uri.parse(Apis.getToppingUrl),
        headers: <String, String>{
          'Accept': 'application/json',
          'Authorization': "Bearer $token",
        },
      );
      if (response.statusCode == 200) {
        var parsedJson = jsonDecode(response.body);
        list = ListTopping.fromJson(parsedJson).topping;
        return list;
      }
    } on TimeoutException catch (e) {
      showError(e.toString());
    } on SocketException catch (e) {
      showError(e.toString());
    }
    return null;
  }
}

String img;
String image;
String validateImage;
List<Topping> selectedAnimals3;

class ListImages extends StatelessWidget {
  final ImageController controller = Get.put(ImageController());
  final String url;

  ListImages({Key key, this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20.h),
      child: Column(
        children: [
          SizedBox(
            width: 120.w,
            height: 120.h,
            child: RaisedButton(
              onPressed: () {
                controller.getImage();
              },
              color: Colors.white,
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(5.0)),
              child: GetBuilder<ImageController>(
                builder: (_) {
                  return Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(top: 5.h, bottom: 5.h),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: 120.h),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          child: controller.image == null
                              ? Image.network(
                                  Apis.baseURL + url,
                                  width: 100.w,
                                  height: 100.h,
                                  fit: BoxFit.cover,
                                )
                              : Image.file(
                                  controller.image,
                                  width: 100.w,
                                  height: 100.h,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ));
                },
              ),
            ),
          ),
          GetBuilder<ImageController>(
            init: ImageController(),
            builder: (_) => Text(
              controller.imagePath == null ? validateImage : '',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

RxList<Topping> topping = new RxList<Topping>();

class ChooseTopping extends StatefulWidget {
  @override
  _ChooseTopping createState() => _ChooseTopping();
}

class _ChooseTopping extends State<ChooseTopping> {
  final _multiSelectKey = GlobalKey<FormFieldState>();

  @override
  void initState() {
    selectedAnimals3 = [];
    for (int i = 0; i < ltp.length; i++) {
      selectedAnimals3.add(ltp[i]);
      for (int j = 0; j < topping.length; j++) {
        if (ltp[i].name == topping[j].name) {
          topping.remove(topping[j]);
        }
      }
      topping.add(ltp[i]);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        margin: EdgeInsets.only(top: 5.h, left: 10.w, right: 10.w),
        child: MultiSelectBottomSheetField<Topping>(
          key: _multiSelectKey,
          initialChildSize: .7,
          maxChildSize: 0.95,
          title: Text("Danh sách topping"),
          buttonText: Text("Chọn topping áp dụng"),
          buttonIcon: Icon(
            Icons.arrow_drop_down,
            color: Colors.grey,
          ),
          decoration: BoxDecoration(),
          items:
              topping.map((f) => MultiSelectItem<Topping>(f, f.name)).toList(),
          searchable: true,
          validator: (values) {
            if (values == null || values.isEmpty) {
              return null;
            }
            List<String> names = values.map((e) => e.name).toList();
            if (names.contains("Frog")) {
              return "Frogs are weird!";
            }
            return null;
          },
          onConfirm: (values) {
            setState(() {
              selectedAnimals3 = values;
            });
          },
          initialValue: selectedAnimals3,
          chipDisplay: MultiSelectChipDisplay(
            onTap: (item) {
              setState(() {
                selectedAnimals3.remove(item);
              });
            },
            icon: Icon(
              Icons.close,
              color: Colors.red,
            ),
          ),
        ),
      ),
    );
  }
}
