import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app_delivery/components/item_field.dart';
import 'package:app_delivery/controllers/image_controler.dart';
import 'package:app_delivery/models/Material.dart';
import 'package:app_delivery/widgets/form_add_widget.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../apis.dart';
import '../../utils.dart';

class AddMaterials extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddMaterials();
  }
}

class _AddMaterials extends State<AddMaterials> {
  @override
  void initState() {
    name = TextEditingController();
    quantity = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        autovalidate: true,
        child: Builder(
            builder: (BuildContext ctx) => Scaffold(
                  appBar: AppBar(
                    centerTitle: true,
                    elevation: 0,
                    title: Text("Thêm nguyên liệu"),
                    actions: [
                      IconButton(
                        icon: Icon(Icons.check_outlined),
                        onPressed: () {
                          addMaterials(ctx);
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
                        FormAddWidget(
                          widget: Column(
                            children: [
                              // Avatar(icon: Icons.add_a_photo,name: "Image",),
                              ItemField(
                                hintText: "Tên nguyên liệu",
                                controller: name,
                                type: TextInputType.text,
                                validator: (val) {
                                  print(val);
                                  if (val.length == 0) {
                                    return 'Vui lòng nhập tên nguyên liệu';
                                  } else
                                    return null;
                                },
                              ),
                              ItemField(
                                hintText: "Số lượng (tính theo kg)",
                                controller: quantity,
                                type: TextInputType.number,
                                validator: (val) {
                                  print(val);
                                  if (val.length == 0) {
                                    return 'Vui lòng nhập số lượng';
                                  } else
                                    return null;
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )));
  }

  TextEditingController name;
  TextEditingController quantity;
  final ImageController controller = Get.put(ImageController());

  Future<void> addMaterials(BuildContext context) async {
    String token = await getToken();
    print(token);
    if (Form.of(context).validate()) {
      String nameImage;
      if (controller.imagePath != null) {
        int code = await uploadImage(controller.image, controller.imagePath);
        if (code == 200) {
          nameImage = controller.imagePath.split('/').last;
        }
      }
      if (name.text.isNotEmpty && quantity.text.isNotEmpty) {
        try {
          EasyLoading.show(status: 'Loading...');

          http.Response response = await http.post(
            Uri.parse(Apis.addMaterialsUrl),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': "Bearer $token",
            },
            body: jsonEncode(<String, dynamic>{
              'name': name.text,
              'quantity': quantity.text.toString(),
              'image': nameImage,
            }),
          );

          print(response.statusCode);
          if (response.statusCode == 200) {
            EasyLoading.dismiss();
            var parsedJson = jsonDecode(response.body);
            // print(parsedJson['success']);
            Materials material = Materials.fromJson(parsedJson['materials']);
            // Get.back(result: food);
            Get.back(result: material);
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
      // controller.imagePath == ''
      //     ? validateImage = ''
      //     : validateImage = 'Vui lòng chọn hình ảnh cho món ăn';
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
        ],
      ),
    );
  }
}
