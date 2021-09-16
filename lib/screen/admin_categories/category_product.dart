import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app_delivery/apis.dart';
import 'package:app_delivery/controllers/category/category_controller.dart';
import 'package:app_delivery/models/Category.dart';
import 'package:app_delivery/screen/admin_categories/edit_category.dart';
import 'package:app_delivery/screen/products/admin/list_products.dart';
import 'package:app_delivery/screen/widget/empty_screen.dart';
import 'package:app_delivery/screen/widget/loading.dart';
import 'package:app_delivery/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class HomProduct extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomProduct();
  }
}

class _HomProduct extends State<HomProduct> {
  CategoryController controller = Get.put(CategoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 0,
        title: Text("Danh mục"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => controller.goToAddCategory(),
          ),
        ],
      ),
      body: Container(
        color: Color(0xFFEEEEEE),
        height: 834.h,
        width: double.infinity,
        padding: EdgeInsets.only(left: 12.w, right: 12.w, top: 10.h),
        child: FutureBuilder(
            future: controller.fetchCategory(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Loading();
              } else {
                if (snapshot.hasError) {
                  return EmptyScreen(text: 'Bạn chưa có danh mục nào.');
                } else {
                  // return buildLoading();
                  return RefreshIndicator(
                    onRefresh: () => controller.fetchCategory(),
                    child: Obx(
                      () => controller.category.length == 0
                          ? EmptyScreen(
                              text: "Bạn chưa có danh mục nào.",
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: controller.category.length,
                              itemBuilder: (context, index) {
                                return Slidable(
                                  actionPane: SlidableDrawerActionPane(),
                                  actionExtentRatio: 0.12,
                                  child: CategoryItem(
                                    item: controller.category[index],
                                  ),
                                  secondaryActions: <Widget>[
                                    Container(
                                      child: IconSlideAction(
                                        caption: 'Edit',
                                        color: Color(0xFFEEEEEE),
                                        icon: Icons.edit,
                                        foregroundColor: Colors.blue,
                                        onTap: () async {
                                          var result = await Get.to(
                                              () => EditCategory(),
                                              arguments: {
                                                'category_id': controller
                                                    .category[index].id
                                              });
                                          // // final result = await Get.arguments['materials'];
                                          // // print(result);
                                          setState(() {
                                            if (result != null) {
                                              controller.fetchCategory();
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
                                                    title:
                                                        Text('Xóa danh mục'),
                                                    content: const Text(
                                                        'Bạn có chắc chắn muốn xóa không?'),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () =>
                                                            Get.back(),
                                                        child:
                                                            const Text('Hủy'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () async {
                                                          await deleteCategory(
                                                              controller
                                                                  .category[
                                                                      index]
                                                                  .id);
                                                          setState(() {
                                                            controller.category
                                                                .removeAt(
                                                                    index);
                                                            Get.back();
                                                            showToast(
                                                                "Xóa thành công");
                                                          });

                                                          // Get.to(ListProduct());

                                                          // food.refresh();
                                                        },
                                                        child: const Text(
                                                          'Xóa',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red),
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
            }),
      ),
    );
  }

  Future<Category> deleteCategory(int category_id) async {
    String token = await getToken();
    print(token);

    try {
      EasyLoading.show(status: 'Loading...');
      http.Response response = await http.post(
        Uri.parse(Apis.deleteCategoryUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': "Bearer $token",
        },
        body: jsonEncode(<String, dynamic>{
          'category_id': category_id,
        }),
      );

      print(response.statusCode);
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        var parsedJson = jsonDecode(response.body);
        // print(parsedJson['success']);
        Category category = CategoryJson.fromJson(parsedJson).category;
        return category;
      }
      if (response.statusCode == 401) {
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

class CategoryItem extends StatelessWidget {
  final Category item;

  const CategoryItem({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(ListProduct(), arguments: {'category_id': item.id});
      },
      child: Container(
        padding: EdgeInsets.only(
          top: 3.h,
          left: 8.h,
        ),
        margin: EdgeInsets.only(top: 10.h),
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
