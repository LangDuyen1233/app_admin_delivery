import 'package:app_delivery/components/choose_item.dart';
import 'package:app_delivery/screen/admin_discounts/add_discount_voucher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'add_discount_food.dart';

class ChooseDiscount extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text("Chọn loại khuyến mãi"),
      ),
      body: Container(
        color: Color(0xFFEEEEEE),
        height: 834.h,
        width: double.infinity,
        child: Column(
          children: [
            ChooseItem(
              icon: Icons.local_offer,
              name: 'Voucher',
              content: 'Dùng kiểu khuyến mãi này để ap dụng cho cả đơn hàng',
              page: AddDiscountVoucher(),
              type_discount_id: 2,
            ),
            ChooseItem(
              icon: Icons.food_bank,
              name: 'Giảm giá món',
              content:
                  'Dùng loại khuyến mãi này khi bạn muốn giảm giá theo từng món',
              page: AddDiscountFood(),
              type_discount_id: 1,
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
  final int type_discount_id;

  const ChooseItem(
      {Key key,
      this.icon,
      this.name,
      this.content,
      this.page,
      this.type_discount_id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(page, arguments: {'type_discount_id': type_discount_id});
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
                  width: 250.w,
                  padding: EdgeInsets.only(left: 5.w, right: 10.w),
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
                  width: 50.w,
                  alignment: Alignment.center,
                  child: IconButton(
                      onPressed: () {
                        Get.to(page,
                            arguments: {'type_discount_id': type_discount_id});
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
