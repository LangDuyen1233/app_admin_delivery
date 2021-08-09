import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmptyScreen extends StatelessWidget {
  final String text;

  EmptyScreen({this.text});

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
                  ),
                ),
                Text(
                  text,
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
