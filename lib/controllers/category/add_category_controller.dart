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
  void dispose() {
    validateImage = '';
    name.clear();
    imagePath = "";
    description.clear();
    super.dispose();
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
