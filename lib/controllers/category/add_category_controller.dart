import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

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
      update();
    } else {}
  }
}
