import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app_delivery/components/item_field.dart';
import 'package:app_delivery/controllers/image_controler.dart';
import 'package:app_delivery/models/Material.dart';
import 'package:app_delivery/widgets/form_add_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

import '../../apis.dart';
import '../../utils.dart';

class EditMaterials extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _EditMaterials();
  }
}

class _EditMaterials extends State<EditMaterials> {
  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidate: true,
      child: FutureBuilder(
        future: fetchMaterials(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                elevation: 0,
                title: Text("Sửa nguyên liệu"),
                actions: [
                  IconButton(
                    icon: Icon(Icons.check_outlined),
                    onPressed: () {
                      updateMaterials(context);
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
                        avatar: s.image,
                      ),
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
                              hintText: "Số lượng",
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
              ),
            );
          } else
            return Container();
        },
      ),
    );
  }

  TextEditingController name;
  TextEditingController quantity;
  int materialsId;
  final ImageController controller = Get.put(ImageController());
  Materials s;

  @override
  void initState() {
    materialsId = Get.arguments['materials_id'];
    // print(staffId);
    super.initState();
  }

  Future<bool> fetchMaterials() async {
    var materials = await editMaterials();
    if (materials != null) {
      s = materials;
    }
    print(s.name);
    name = TextEditingController(text: s.name);
    quantity = TextEditingController(text: s.quantity.toString());

    return materials.isBlank;
  }

  Future<Materials> editMaterials() async {
    Materials materials;
    String token = (await getToken());
    materialsId = Get.arguments['materials_id'];
    print(materials);
    Map<String, String> queryParams = {
      'materialsId': materialsId.toString(),
    };
    String queryString = Uri(queryParameters: queryParams).query;
    try {
      print(Apis.editMaterialsUrl);
      http.Response response = await http.get(
        Uri.parse(Apis.editMaterialsUrl + '?' + queryString),
        headers: <String, String>{
          'Accept': 'application/json',
          'Authorization': "Bearer $token",
        },
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        var parsedJson = jsonDecode(response.body);
        print(parsedJson['materials']);
        materials = MaterialsJson.fromJson(parsedJson).materials;
        print(materials);
        return materials;
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

  Future<void> updateMaterials(BuildContext context) async {
    String token = await getToken();
    print(token);
    String nameImage;

    if (Form.of(context).validate()) {
      if (s.image != null) {
        if (controller.imagePath != null) {
          int code = await uploadImage(controller.image, controller.imagePath);
          if (code == 200) {
            nameImage = controller.imagePath.split('/').last;
          }
        } else {
          nameImage = s.image.split('/').last;
        }
      }else{
        if (controller.imagePath != null) {
          int code = await uploadImage(controller.image, controller.imagePath);
          if (code == 200) {
            nameImage = controller.imagePath.split('/').last;
          }
        } else {
          nameImage = s.image.split('/').last;
        }
      }
      if (name.text.isNotEmpty && quantity.text.isNotEmpty) {
        try {
          http.Response response = await http.post(
            Uri.parse(Apis.updateMaterialsUrl),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': "Bearer $token",
            },
            body: jsonEncode(<String, dynamic>{
              'name': name.text,
              'quantity': quantity.text,
              'materialsId': s.id,
              'image': nameImage
            }),
          );

          print(response.statusCode);
          if (response.statusCode == 200) {
            EasyLoading.dismiss();
            var parsedJson = jsonDecode(response.body);
            Materials materials = Materials.fromJson(parsedJson['materials']);
            Get.back(result: materials);
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
                // img = controller.imagePath;
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
                                    // width: 90.w,
                                    // height: 90.h,
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
