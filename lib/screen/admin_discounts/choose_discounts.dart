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
      appBar: buildAppBar(),
      body: Body(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      centerTitle: true,
      elevation: 0,
      title: Text("Chọn loại khuyến mãi"),
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
      child: Column(
        children: [
          ChooseItem(
            icon: Icons.local_offer,
            name: 'Voucher',
            content: 'Dùng kiểu khuyến mãi này để ap dụng cho cả đơn hàng',
            page: AddDiscountVoucher(),
          ),
          ChooseItem(
            icon: Icons.food_bank,
            name: 'Giảm giá món',
            content:
                'Dùng loại khuyến mãi này khi bạn muốn giảm giá theo từng món',
            page: AddDiscountFood(),
          )
        ],
      ),
    );
  }
}

