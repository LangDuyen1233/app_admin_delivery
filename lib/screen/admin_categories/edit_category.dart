import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app_delivery/apis.dart';
import 'package:app_delivery/components/item_field.dart';
import 'package:app_delivery/controllers/image_controler.dart';
import 'package:app_delivery/models/Category.dart';
import 'package:app_delivery/utils.dart';
import 'package:app_delivery/widgets/form_add_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

class EditCategory extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _EditCategory();
  }
}

class _EditCategory extends State<EditCategory> {
  final ImageController controller = Get.put(ImageController());
  Category category;
  int category_id;
  TextEditingController name;
  TextEditingController description;

  @override
  void initState() {
    category_id = Get.arguments['category_id'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidate: true,
      child: FutureBuilder(
        future: fetchCategory(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                elevation: 0,
                title: Text("Sửa danh mục"),
                actions: [
                  IconButton(
                    icon: Icon(Icons.check_outlined),
                    onPressed: () {
                      updateCategory(context);
                    },
                  ),
                ],
              ),
              body: Container(
                color: Color(0xFFEEEEEE),
                height: 834.h,
                width: 414.w,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ListImages(
                        avatar: category.image,
                      ),
                      FormAddWidget(
                        widget: Column(
                          children: [
                            ItemField(
                              hintText: "Tên danh mục",
                              controller: name,
                              type: TextInputType.text,
                              validator: (val) {
                                if (val.length == 0) {
                                  return 'Vui lòng nhập tên nguyên liệu';
                                } else
                                  return null;
                              },
                            ),
                            ItemField(
                              hintText: "Mô tả",
                              controller: description,
                              type: TextInputType.text,
                            ),
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

  Future<bool> fetchCategory() async {
    var c = await editCategory();
    if (c != null) {
      category = c;
    }

    name = TextEditingController(text: category.name);
    description = TextEditingController(text: category.description);

    return category.isBlank;
  }

  Future<Category> editCategory() async {
    String token = (await getToken());
    Map<String, String> queryParams = {
      'category_id': category_id.toString(),
    };
    String queryString = Uri(queryParameters: queryParams).query;
    try {
      http.Response response = await http.get(
        Uri.parse(Apis.editCategoryUrl + '?' + queryString),
        headers: <String, String>{
          'Accept': 'application/json',
          'Authorization': "Bearer $token",
        },
      );
      if (response.statusCode == 200) {
        var parsedJson = jsonDecode(response.body);
        print(parsedJson['category']);
        Category category = CategoryJson.fromJson(parsedJson).category;
        return category;
      }
      if (response.statusCode == 401) {}
    } on TimeoutException catch (e) {
      showError(e.toString());
    } on SocketException catch (e) {
      showError(e.toString());
      print(e.toString());
    }
    return null;
  }

  Future<void> updateCategory(BuildContext context) async {
    String token = await getToken();
    String nameImage;

    if (Form.of(context).validate()) {
      if (category.image != null) {
        if (controller.imagePath != null) {
          int code = await uploadImage(controller.image, controller.imagePath);
          if (code == 200) {
            nameImage = controller.imagePath.split('/').last;
          }
        } else {
          nameImage = category.image.split('/').last;
        }
      } else {
        if (controller.imagePath != null) {
          int code = await uploadImage(controller.image, controller.imagePath);
          if (code == 200) {
            nameImage = controller.imagePath.split('/').last;
          }
        } else {
          nameImage = category.image.split('/').last;
        }
      }
      if (name.text.isNotEmpty) {
        try {
          http.Response response = await http.post(
            Uri.parse(Apis.updateCategoryUrl),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': "Bearer $token",
            },
            body: jsonEncode(<String, dynamic>{
              'category_id': category_id,
              'name': name.text,
              'description': description.text,
              'image': nameImage
            }),
          );

          if (response.statusCode == 200) {
            var parsedJson = jsonDecode(response.body);
            Category category = CategoryJson.fromJson(parsedJson).category;
            Get.back(result: category);
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
      showToast('Vui lòng điền đầy đủ các trường');
    }
  }
}

class ListImages extends StatelessWidget {
  final ImageController controller = Get.put(ImageController());
  final String avatar;

  ListImages({Key key, this.avatar}) : super(key: key);

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
                  return avatar != null
                      ? controller.image == null
                          ? Image.network(
                              Apis.baseURL + avatar,
                              width: 100.w,
                              height: 100.h,
                              fit: BoxFit.cover,
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
                            )
                      : controller.image == null
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
        ],
      ),
    );
  }
}
