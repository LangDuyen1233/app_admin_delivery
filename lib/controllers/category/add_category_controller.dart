import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app_delivery/models/Category.dart';
import 'package:app_delivery/screen/admin_categories/category_product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../../apis.dart';
import '../../utils.dart';

class AddCategoryController extends GetxController {
  TextEditingController images;
  TextEditingController name;
  TextEditingController description;
  String validateImage;

  File image;
  String imagePath;
  final _picker = ImagePicker();

  @override
  void onInit() {
    validateImage = '';
    images = TextEditingController();
    name = TextEditingController();
    description = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    validateImage = '';
    name.clear();
    imagePath = "";
    description.clear();
    super.dispose();
  }

  Future<void> addCategory(BuildContext context) async {
    String token = await getToken();
    print(token);
    print(name.text);
    print(description.text);
    print(imagePath);
    if (Form.of(context).validate()) {
      print(name.text);
      print(imagePath);
      if (name.text.isNotEmpty && imagePath.isNotEmpty) {
        try {
          EasyLoading.show(status: 'Loading...');
          print(name.text);
          print(imagePath);
          http.Response response = await http.post(
            Uri.parse(Apis.addCategoryUrl),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': "Bearer $token",
            },
            body: jsonEncode(<String, String>{
              'image': imagePath,
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
      imagePath == ''
          ? validateImage = ''
          : validateImage = 'Vui lòng chọn hình ảnh cho danh mục';
      showToast('Vui lòng điền đầy đủ các trường');
    }
  }

  Future<void> getImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      image = File(pickedFile.path);
      imagePath = pickedFile.path;
      print(imagePath);
      update();
    } else {
      print('No image selected.');
    }
  }
}
