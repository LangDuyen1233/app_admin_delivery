import 'package:app_delivery/screen/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ItemField extends StatelessWidget {
  final String hintText;

  const ItemField({Key key, this.hintText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          // color: defaulColorThem,
          border:
              Border(bottom: BorderSide(width: 0.5, color: Colors.black12))),
      width: MediaQuery.of(context).size.width,
      child: TextField(
          style: TextStyle(
              fontSize: 16.0.sp,
              color: Colors.black
          ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(top:20.w,bottom: 20,left: 12,right: 15),
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
