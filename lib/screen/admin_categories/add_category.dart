import 'package:app_delivery/components/item_field.dart';
import 'package:app_delivery/controllers/category/category_controller.dart';
import 'package:app_delivery/widgets/form_add_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:app_delivery/controllers/category/add_category_controller.dart';

class AddCategory extends GetView<AddCategoryController> {
  AddCategoryController controller = Get.put(AddCategoryController());

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Builder(
        builder: (BuildContext ctx) => Scaffold(
          appBar: AppBar(
            centerTitle: true,
            elevation: 0,
            title: Text("Thêm danh mục"),
            actions: [
              IconButton(
                icon: Icon(Icons.check_outlined),
                onPressed: () {
                  controller.addCategory(ctx);
                  // controller.dispose();
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
                SizedBox(
                  height: 15.h,
                ),
                Column(
                  children: [
                    ItemField(
                      validator: (val) {
                        print(val);
                        if (val.length == 0) {
                          return 'Vui lòng nhập tên danh mục';
                        } else
                          return null;
                      },
                      controller: controller.name,
                      hintText: "Tên danh mục",
                    ),

                    ItemField(
                      controller: controller.description,
                      hintText: "Mô tả (không bắt buộc)",
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ListImages extends GetView<AddCategoryController> {
  final AddCategoryController controller = Get.put(AddCategoryController());

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20.h),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
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
              child: GetBuilder<AddCategoryController>(
                init: AddCategoryController(),
                builder: (_) {
                  return controller.image == null
                      ? Center(
                          child: Icon(
                          Icons.add_a_photo,
                          color: Colors.grey,
                          size: 30.0,
                        ))
                      : SizedBox(
                          width: 100.w,
                          height: 100.h,
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            child: Image.file(
                              controller.image,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                },
              ),
            ),
          ),
          Text(
            controller.imagePath == null ? controller.validateImage : '',
            style: TextStyle(color: Colors.red),
          ),
        ],
      ),
    );
  }
}
