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
  // TextEditingController name;
  // TextEditingController description;
  // String validateImage;

  @override
  void onReady() {
    fetchCategory();
    // getCategory();
    super.onReady();
  }

  @override
  void onInit() {
    // fetchCategory();
    // validateImage = '';
    fetchCategory();
    // images = TextEditingController();
    // name = TextEditingController();
    // description = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    // validateImage = '';
    // name.clear();
    // imagePath = "";
    // description.clear();
    super.dispose();
  }

  @override
  void onClose() {
    // validateImage = '';
    super.onClose();
  }

  Future<void> fetchCategory() async {
    var listCategory = await getCategory();
    if (listCategory != null) {
      printInfo(info: listCategory.length.toString());
      category = listCategory;
      _category.refresh();
    }
  }
  Future goToAddCategory()async{
   final result = await Get.to(() => AddCategory());
   if(result!=null){
     _category.add(result);
     _category.refresh();
   }
  }
  Future<List<Category>> getCategory() async {
    List<Category> list;
    String token = (await getToken());
    try {
      print(Apis.getCategoryUrl);
      http.Response response = await http.get(
        Uri.parse(Apis.getCategoryUrl),
        headers: <String, String>{
          'Accept': 'application/json',
          'Authorization': "Bearer $token",
        },
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        var parsedJson = jsonDecode(response.body);
        print(parsedJson['category']);
        list = ListCategory.fromJson(parsedJson).category.obs;
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

// File image;
// String imagePath;
// final _picker = ImagePicker();

// Future<void> addCategory(BuildContext context) async {
//   String token = await getToken();
//   print(token);
//   print(name.text);
//   print(description.text);
//   print(imagePath);
//   if (Form.of(context).validate()) {
//     print(name.text);
//     print(imagePath);
//     if (name.text.isNotEmpty && imagePath.isNotEmpty) {
//       try {
//         EasyLoading.show(status: 'Loading...');
//         print(name.text);
//         print(imagePath);
//         http.Response response = await http.post(
//           Uri.parse(Apis.addCategoryUrl),
//           headers: <String, String>{
//             'Content-Type': 'application/json; charset=UTF-8',
//             'Authorization': "Bearer $token",
//           },
//           body: jsonEncode(<String, String>{
//             'image': imagePath,
//             'name': name.text,
//             'description': description.text,
//           }),
//         );
//         print(response.statusCode);
//         if (response.statusCode == 200) {
//           EasyLoading.dismiss();
//           var parsedJson = jsonDecode(response.body);
//           print(parsedJson['success']);
//           Get.to(HomProduct());
//           showToast("Tạo thành công");
//         }
//         if (response.statusCode == 404) {
//           EasyLoading.dismiss();
//           var parsedJson = jsonDecode(response.body);
//           print(parsedJson['error']);
//         }
//       } on TimeoutException catch (e) {
//         showError(e.toString());
//       } on SocketException catch (e) {
//         showError(e.toString());
//       }
//     } else {
//       showToast('Vui lòng điền đầy đủ các trường');
//     }
//   } else {
//     imagePath == '' ? validateImage = '' : validateImage = 'vui long';
//     showToast('Vui lòng điền đầy đủ các trường');
//   }
// }
//
// Future<void> getImage() async {
//   final pickedFile = await _picker.getImage(source: ImageSource.gallery);
//
//   if (pickedFile != null) {
//     image = File(pickedFile.path);
//     imagePath = pickedFile.path;
//     print(imagePath);
//     update();
//   } else {
//     print('No image selected.');
//   }
// }
}
