import 'package:app_delivery/models/Category.dart';
import 'package:app_delivery/screen/products/admin/list_products.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'add_category.dart';

class HomProduct extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text("Thể loại"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              print("mày có vô đây không???");
              Get.to(AddCategory());
            },
          ),
        ],
      ),
      body: Body(),
      resizeToAvoidBottomInset: false,
    );
  }
}

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFEEEEEE),
      height: 834.h,
      width: double.infinity,
      padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 10.h),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 20.w,
            childAspectRatio: 140.w / 120.h,
            mainAxisSpacing: 20.h),
        itemCount: list_category.length,
        itemBuilder: (BuildContext context, int index) {
          return CategoriesItem(
            item: list_category[index],
          );
        },
      ),
    );
  }
}

class CategoriesItem extends StatelessWidget {
  final Category item;

  const CategoriesItem({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print('aefkeahfkwhfkjef');
        Get.to(ListProduct());
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.sp),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 1),
              blurRadius: 5,
              color: Color(0xFFB0CCE1).withOpacity(0.3),
            ),
          ],
        ),
        // width: 180.w,
        // height: 140.h,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 20.sp),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(3.sp),
                child: Image.asset(
                  item.icon,
                  width: 50.w,
                  height: 50.h,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 15.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    item.name,
                    style:
                        TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'Số lượng: ' + item.quantity.toString(),
                    style: TextStyle(fontSize: 15.sp),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
