import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmptyCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: ListView(
        shrinkWrap: true,
        children: [
          Container(
            height: 630.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  child: Image.asset(
                    'assets/images/empty_order.png',
                    width: 120.w,
                    fit: BoxFit.cover,
                    color: Colors.black26,
                  ),
                ),
                Text(
                  "Bạn không có đơn hàng nào!!!",
                  style: TextStyle(color: Colors.blue, fontSize: 24.sp),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
