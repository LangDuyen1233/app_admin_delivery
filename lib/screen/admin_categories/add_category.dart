import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app_delivery/components/item_field.dart';
import 'package:app_delivery/controllers/category/add_category_controller.dart';
import 'package:app_delivery/controllers/category/category_controller.dart';
import 'package:app_delivery/controllers/image_controler.dart';
import 'package:app_delivery/models/Category.dart';
import 'package:app_delivery/widgets/form_add_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../apis.dart';
import '../../utils.dart';

class AddCategory extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddCategory();
  }
}
String validateImage;
class _AddCategory extends State<AddCategory> {
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Builder(
        builder: (BuildContext ctx) => Scaffold(
          appBar: AppBar(
            centerTitle: true,
            elevation: 0,
            title: Text("Thêm danh mục"),
            actions: [
              IconButton(
                icon: Icon(Icons.check_outlined),
                onPressed: () {
                  addCategory(ctx);
                  // controller.dispose();
                },
              ),
            ],
          ),
          body: Container(
            color: Color(0xFFEEEEEE),
            height: 834.h,
            child: Column(
              children: [
                ListImages(),
                SizedBox(
                  height: 15.h,
                ),
                Column(
                  children: [
                    ItemField(
                      validator: (val) {
                        print(val);
                        if (val.length == 0) {
                          return 'Vui lòng nhập tên danh mục';
                        } else
                          return null;
                      },
                      controller: name,
                      hintText: "Tên danh mục",
                    ),
                    ItemField(
                      controller: description,
                      hintText: "Mô tả (không bắt buộc)",
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextEditingController images;
  TextEditingController name;
  TextEditingController description;

  final ImageController controller = Get.put(ImageController());

  @override
  void initState() {
    validateImage = '';
    images = TextEditingController();
    name = TextEditingController();
    description = TextEditingController();
    super.initState();
  }

  Future<void> addCategory(BuildContext context) async {
    String token = await getToken();
    print(token);
    print(name.text);
    print(description.text);
    if (Form.of(context).validate()) {
      print(name.text);
      String nameImage;
      if (controller.imagePath != null) {
        int code = await uploadImage(controller.image, controller.imagePath);
        if (code == 200) {
          nameImage = controller.imagePath.split('/').last;
        }
      }
      if (name.text.isNotEmpty && nameImage.isNotEmpty) {
        try {
          EasyLoading.show(status: 'Loading...');
          print(name.text);
          print(controller.imagePath);
          http.Response response = await http.post(
            Uri.parse(Apis.addCategoryUrl),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': "Bearer $token",
            },
            body: jsonEncode(<String, String>{
              'image': nameImage,
              'name': name.text,
              'description': description.text,
            }),
          );
          print(response.statusCode);
          if (response.statusCode == 200) {
            EasyLoading.dismiss();
            var parsedJson = jsonDecode(response.body);
            print(parsedJson['success']);
            Category category = Category.fromJson(parsedJson['category']);
            Get.back(result: category);
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
          : validateImage = 'Vui lòng chọn hình ảnh cho danh mục';
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
                // img = controller.imagePath;
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
