import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app_delivery/components/item_field.dart';
import 'package:app_delivery/controllers/image_controler.dart';
import 'package:app_delivery/models/Food.dart';
import 'package:app_delivery/models/Topping.dart';
import 'package:app_delivery/screen/products/admin/list_products.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:multi_select_flutter/multi_select_flutter.dart';

import '../../../apis.dart';
import '../../../utils.dart';

class AddProduct extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddProduct();
  }
}

String img;
String validateImage;

class _AddProduct extends State<AddProduct> {
  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidate: true,
      child: Builder(
        builder: (BuildContext ctx) => Scaffold(
          appBar: AppBar(
            centerTitle: true,
            elevation: 0,
            title: Text("Thêm món ăn"),
            actions: [
              IconButton(
                icon: Icon(Icons.check_outlined),
                onPressed: () {
                  addFood(ctx);
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
                  ListImages(),
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
                      SingleChildScrollView(
                        child: Container(
                          color: Colors.white,
                          margin: EdgeInsets.only(
                              top: 5.h, left: 10.w, right: 10.w),
                          child: MultiSelectBottomSheetField<Topping>(
                            key: _multiSelectKey,
                            // initialValue: topping,
                            initialChildSize: .7,
                            maxChildSize: 0.95,
                            title: Text("Danh sách topping"),
                            buttonText: Text("Chọn topping áp dụng"),
                            buttonIcon: Icon(
                              Icons.arrow_drop_down,
                              color: Colors.grey,
                            ),
                            decoration: BoxDecoration(),
                            items: _items,
                            searchable: true,
                            validator: (values) {
                              if (values == null || values.isEmpty) {
                                return null;
                              }
                              return null;
                            },
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
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Topping> _selectedAnimals3 = [];
  static RxList<Topping> topping = new RxList<Topping>();
  final _items = topping.map((f) => MultiSelectItem<Topping>(f, f.name)).toList();

  // var _items = topping.map((f) => MultiSelectItem<Topping>(f, f.name)).toList();

  final _multiSelectKey = GlobalKey<FormFieldState>();
  TextEditingController name;
  TextEditingController size;
  TextEditingController price;
  TextEditingController weight;
  TextEditingController ingredients;

  int category_id;
  final ImageController controller = Get.put(ImageController());

  // TextEditingController topping;
  String toppingId;

  @override
  void initState() {
    // getCategory();
    print(Get.arguments['category_id']);
    category_id = Get.arguments['category_id'];
    print('lo ma mmmmm $category_id');
    name = TextEditingController();
    size = TextEditingController();
    price = TextEditingController();
    weight = TextEditingController();
    ingredients = TextEditingController();
    toppingId = '';
    fetchTopping();
    validateImage = '';
    super.initState();
  }

  Future<void> fetchTopping() async {
    var listTopping = await getTopping();
    if (listTopping != null) {
      printInfo(info: listTopping.length.toString());
      topping.assignAll(listTopping);
      topping.refresh();
    }
  }

  Future<List<Topping>> getTopping() async {
    List<Topping> list;
    String token = (await getToken());
    try {
      print(Apis.getToppingUrl);
      http.Response response = await http.get(
        Uri.parse(Apis.getToppingUrl),
        headers: <String, String>{
          'Accept': 'application/json',
          'Authorization': "Bearer $token",
        },
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        var parsedJson = jsonDecode(response.body);
        print(parsedJson['topping']);
        list = ListTopping.fromJson(parsedJson).topping;
        print(list);
        return list;
      }
      // if (response.statusCode == 401) {
      //   showToast("Loading faild");
      // }
    } on TimeoutException catch (e) {
      showError(e.toString());
    } on SocketException catch (e) {
      showError(e.toString());
      print(e.toString());
    }
    return null;
  }

  void getCategory() async {
    category_id = await Get.arguments['category_id'];
  }

  Future<void> addFood(BuildContext context) async {
    String token = await getToken();
    if (Form.of(context).validate()) {
      String nameImage;

      int code = await uploadImage(controller.image, controller.imagePath);
      if (code == 200) {
        nameImage = controller.imagePath.split('/').last;
      }
      if (name.text.isNotEmpty &&
          nameImage.isNotEmpty &&
          controller.image.path.isNotEmpty &&
          price.text.isNotEmpty) {
        try {
          EasyLoading.show(status: 'Loading...');
          List<Topping> tp = _selectedAnimals3;
          for (int i = 0; i < tp.length; i++) {
            if (i == tp.length - 1) {
              toppingId += tp[i].id.toString();
            } else {
              toppingId += tp[i].id.toString() + ",";
            }
          }
          print(toppingId);

          http.Response response = await http.post(
            Uri.parse(Apis.addFoodUrl),
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
            }),
          );

          print(response.statusCode);
          if (response.statusCode == 200) {
            EasyLoading.dismiss();
            var parsedJson = jsonDecode(response.body);
            print(parsedJson['success']);
            Food food = Food.fromJson(parsedJson['food']);
            // Get.back(result: food);
            Get.off(ListProduct(),
                arguments: {'food': food, 'category_id': category_id});
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
      controller.imagePath == ''
          ? validateImage = ''
          : validateImage = 'Vui lòng chọn hình ảnh cho món ăn';
      showToast('Vui lòng điền đầy đủ các trường');
    }
  }
}

class ListImages extends StatelessWidget {
  final ImageController controller = Get.put(ImageController());

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
                img = controller.imagePath;
              },
              color: Colors.white,
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(5.0)),
              child: GetBuilder<ImageController>(
                builder: (_) {
                  return controller.image == null
                      ? Icon(
                          Icons.add_a_photo,
                          color: Colors.grey,
                          size: 25.0.sp,
                        )
                      : Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.only(top: 5.h, bottom: 5.h),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(maxHeight: 120.h),
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              child: Image.file(
                                controller.image,
                                // width: 90.w,
                                // height: 90.h,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
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

class ChooseTopping extends StatefulWidget {
  @override
  _ChooseTopping createState() => _ChooseTopping();
}

class _ChooseTopping extends State<ChooseTopping> {
  List<Topping> _selectedAnimals3;
  static RxList<Topping> topping = new RxList<Topping>();

  // var _items = topping.map((f) => MultiSelectItem<Topping>(f, f.name)).toList();

  final _multiSelectKey = GlobalKey<FormFieldState>();

  @override
  void initState() {
    fetchTopping();
    _selectedAnimals3 = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Obx(
        () => Container(
          color: Colors.white,
          margin: EdgeInsets.only(top: 5.h, left: 10.w, right: 10.w),
          child: MultiSelectBottomSheetField<Topping>(
            key: _multiSelectKey,
            initialValue: topping,
            initialChildSize: .7,
            maxChildSize: 0.95,
            title: Text("Danh sách topping"),
            buttonText: Text("Chọn topping áp dụng"),
            buttonIcon: Icon(
              Icons.arrow_drop_down,
              color: Colors.grey,
            ),
            decoration: BoxDecoration(),
            items: topping
                .map((f) => MultiSelectItem<Topping>(f, f.name))
                .toList(),
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
                _selectedAnimals3 = values;
                print(values);
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

  Future<void> fetchTopping() async {
    var listTopping = await getTopping();
    if (listTopping != null) {
      printInfo(info: listTopping.length.toString());
      topping.assignAll(listTopping);
      topping.refresh();
    }
  }

  Future<List<Topping>> getTopping() async {
    List<Topping> list;
    String token = (await getToken());
    try {
      print(Apis.getToppingUrl);
      http.Response response = await http.get(
        Uri.parse(Apis.getToppingUrl),
        headers: <String, String>{
          'Accept': 'application/json',
          'Authorization': "Bearer $token",
        },
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        var parsedJson = jsonDecode(response.body);
        print(parsedJson['topping']);
        list = ListTopping.fromJson(parsedJson).topping;
        print(list);
        return list;
      }
      // if (response.statusCode == 401) {
      //   showToast("Loading faild");
      // }
    } on TimeoutException catch (e) {
      showError(e.toString());
    } on SocketException catch (e) {
      showError(e.toString());
      print(e.toString());
    }
    return null;
  }
}
