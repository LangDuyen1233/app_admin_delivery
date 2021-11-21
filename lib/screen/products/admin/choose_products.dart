import 'package:app_delivery/screen/products/admin/add_product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'add_topping.dart';

class ChooseProducts extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ChooseProducts();
  }
}

class _ChooseProducts extends State<ChooseProducts> {
  int categoryId;

  @override
  void initState() {
    categoryId = Get.arguments['category_id'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text("Chọn loại sản phẩm"),
      ),
      body: Container(
        color: Color(0xFFEEEEEE),
        height: 834.h,
        width: double.infinity,
        child: Column(
          children: [
            ChooseItem(
              icon: Icons.food_bank,
              name: 'Đồ ăn',
              content: 'Thêm một món ăn mới vào danh sách món ăn của quán',
              page: AddProduct(),
              category_id: categoryId,
            ),
            ChooseItem(
              icon: Icons.icecream,
              name: 'Topping',
              content: 'Thêm topping mới cho món ăn',
              page: AddToppings(),
              category_id: categoryId,
            )
          ],
        ),
      ),
    );
  }
}

class ChooseItem extends StatelessWidget {
  final IconData icon;
  final String name;
  final String content;
  final Widget page;
  final int category_id;

  ChooseItem(
      {Key key,
      this.icon,
      this.name,
      this.content,
      this.page,
      this.category_id});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.off(page, arguments: {'category_id': category_id});
      },
      child: Container(
        margin: EdgeInsets.only(top: 10.h, left: 15, right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.sp)),
          color: Colors.white,
        ),
        height: 120.h,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 55.w,
                  height: 55.h,
                  margin: EdgeInsets.only(left: 15.w),
                  decoration: BoxDecoration(
                    color: Color(0xFFDAECFF),
                    borderRadius: BorderRadius.circular(5.sp),
                  ),
                  child: Icon(
                    icon,
                    size: 35.h,
                    color: Colors.blue,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 15.w, right: 10.w),
                  width: 250.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 30.h,
                        child: Text(
                          name,
                          style: TextStyle(
                              fontSize: 20.sp, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Container(
                        width: 265.w,
                        child: Text(
                          content,
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: IconButton(
                      onPressed: () {
                        Get.to(page, arguments: {'category_id': category_id});
                      },
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                      )),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
