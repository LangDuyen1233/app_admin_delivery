import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app_delivery/models/Material.dart';
import 'package:app_delivery/screen/widget/empty_screen.dart';
import 'package:app_delivery/screen/widget/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../apis.dart';
import '../../utils.dart';
import 'add_materials.dart';
import 'edit_materials.dart';

class MaterialsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MaterialsScreen();
  }
}

RxList<Materials> materials;

class _MaterialsScreen extends State<MaterialsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: Text("Danh sách nguyên vật liệu"),
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () async {
                print("mày có vô đây không???");
                final result = await Get.to(AddMaterials());
                // final result = await Get.arguments['staff'];
                // print(result);
                if (result != null) {
                  materials.add(result);
                  materials.refresh();
                }
              },
            ),
          ],
        ),
        body: Container(
            color: Color(0xFFEEEEEE),
            height: 834.h,
            child: FutureBuilder(
                future: fetchMaterials(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Loading();
                  } else {
                    if (snapshot.hasError) {
                      return EmptyScreen(text: 'Bạn chưa có nguyên liệu nào.');
                    } else {
                      // return buildLoading();
                      return RefreshIndicator(
                        onRefresh: () => fetchMaterials(),
                        child: Obx(
                              () => materials.length == 0
                              ? EmptyScreen(
                            text: "Bạn chưa có nguyên liệu nào.",
                          )
                              : ListView.builder(
                                shrinkWrap: true,
                                itemCount: materials.length,
                                itemBuilder: (context, index) {
                                  return Slidable(
                                    actionPane: SlidableDrawerActionPane(),
                                    actionExtentRatio: 0.12,
                                    child: MaterialItem(
                                      item: materials[index],
                                    ),
                                    secondaryActions: <Widget>[
                                      Container(
                                        child: IconSlideAction(
                                          caption: 'Edit',
                                          color: Color(0xFFEEEEEE),
                                          icon: Icons.edit,
                                          foregroundColor: Colors.blue,
                                          onTap: () async {
                                            var result = await Get.to(() => EditMaterials(),
                                                arguments: {
                                                  'materials_id': materials.value[index].id
                                                });
                                            // final result = await Get.arguments['materials'];
                                            // print(result);
                                            setState(() {
                                              if (result != null) {
                                                fetchMaterials();
                                                // materials.add(result);
                                                // materials.refresh();
                                              }
                                            });
                                          },
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 5),
                                        child: IconSlideAction(
                                          caption: 'Delete',
                                          color: Color(0xFFEEEEEE),
                                          icon: Icons.delete,
                                          foregroundColor: Colors.red,
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                      title: Text('Xóa nguyên vật liệu'),
                                                      content: const Text(
                                                          'Bạn có chắc chắn muốn xóa không?'),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          onPressed: () => Get.back(),
                                                          child: const Text('Hủy'),
                                                        ),
                                                        TextButton(
                                                          onPressed: () async {
                                                            await deleteMaterials(
                                                                materials[index].id);
                                                            setState(() {
                                                              materials.removeAt(index);
                                                              materials.refresh();
                                                              Get.back();
                                                              showToast("Xóa thành công");
                                                            });

                                                            // Get.to(ListProduct());

                                                            // food.refresh();
                                                          },
                                                          child: const Text(
                                                            'Xóa',
                                                            style: TextStyle(color: Colors.red),
                                                          ),
                                                        ),
                                                      ]);
                                                });
                                          },
                                        ),
                                      )
                                    ],
                                  );
                                },
                              ),
                        ),
                      );
                    }
                  }
                }),));
  }

  @override
  void initState() {
    materials = new RxList<Materials>();
    fetchMaterials();
    super.initState();
  }

  Future<void> fetchMaterials() async {
    var list = await getMaterials();
    if (list != null) {
      // printInfo(info: listFood.length.toString());
      // print(listFood.length);
      materials.assignAll(list);
      materials.refresh();
      // print(food.length);
    }
  }

  Future<List<Materials>> getMaterials() async {
    List<Materials> list;
    String token = (await getToken());
    try {
      print(Apis.getMaterialsUrl);
      http.Response response = await http.get(
        Uri.parse(Apis.getMaterialsUrl),
        headers: <String, String>{
          'Accept': 'application/json',
          'Authorization': "Bearer $token",
        },
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        var parsedJson = jsonDecode(response.body);
        // print(parsedJson['food']);
        list = ListMaterialsJson.fromJson(parsedJson).materials;
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

  Future<Materials> deleteMaterials(int materials_id) async {
    String token = await getToken();
    print(token);

    try {
      EasyLoading.show(status: 'Loading...');
      http.Response response = await http.post(
        Uri.parse(Apis.deleteMaterialsUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': "Bearer $token",
        },
        body: jsonEncode(<String, dynamic>{
          'materials_id': materials_id,
        }),
      );

      print(response.statusCode);
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        var parsedJson = jsonDecode(response.body);
        // print(parsedJson['success']);
        Materials materials = Materials.fromJson(parsedJson['materials']);
        return materials;
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
  }
}

class MaterialItem extends StatelessWidget {
  final Materials item;

  const MaterialItem({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.only(
          top: 3.h,
          left: 8.h,
        ),
        margin: EdgeInsets.only(top: 10.h, left: 12.h, right: 10.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.sp)),
          color: Colors.white,
        ),
        height: 100.h,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.black12),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: item.image == null
                      ? Container(
                          width: 80.w,
                          height: 80.w,
                          padding: EdgeInsets.only(
                              right: 12.w, bottom: 12.h, left: 12.w, top: 12.h),
                          child: Image.asset(
                            'assets/images/fast-food.png',
                            fit: BoxFit.fill,
                            color: Colors.black26,
                          ),
                        )
                      : Container(
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            child: Image.network(
                              Apis.baseURL + item.image,
                              width: 80.w,
                              height: 80.w,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 15.w, right: 10.w),
                  height: 92.h,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        item.name,
                        style: TextStyle(
                            fontSize: 20.sp, fontWeight: FontWeight.w600),
                      ),
                      Text('Số lượng còn lại : ' +
                          item.quantity.toString() +
                          ' phần'),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
