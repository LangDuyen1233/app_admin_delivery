import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app_delivery/models/Category.dart';
import 'package:app_delivery/screen/admin_categories/add_category.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../apis.dart';
import '../../utils.dart';

class CategoryController extends GetxController {
  final RxList<Category> _category = new RxList<Category>();

  List<Category> get category => _category.toList();

  set category(List<Category> value) {
    _category.assignAll(value);
  } // TextEditingController images;

  @override
  void onReady() {
    fetchCategory();
    super.onReady();
  }

  @override
  void onInit() {
    fetchCategory();
    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> fetchCategory() async {
    var listCategory = await getCategory();
    if (listCategory != null) {
      category = listCategory;
      _category.refresh();
    }
  }

  Future goToAddCategory() async {
    final result = await Get.to(() => AddCategory());
    if (result != null) {
      _category.add(result);
      _category.refresh();
    }
  }

  Future<List<Category>> getCategory() async {
    List<Category> list;
    String token = (await getToken());
    try {
      http.Response response = await http.get(
        Uri.parse(Apis.getCategoryUrl),
        headers: <String, String>{
          'Accept': 'application/json',
          'Authorization': "Bearer $token",
        },
      );
      if (response.statusCode == 200) {
        var parsedJson = jsonDecode(response.body);
        list = ListCategory.fromJson(parsedJson).category.obs;
        return list;
      }
      if (response.statusCode == 401) {
        showToast("Loading faild");
      }
    } on TimeoutException catch (e) {
      showError(e.toString());
    } on SocketException catch (e) {
      showError(e.toString());
    }
    return null;
  }
}
