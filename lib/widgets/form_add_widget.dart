import 'package:app_delivery/screen/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FormAddWidget extends StatelessWidget {
  final Widget widget;

  const FormAddWidget({Key key, this.widget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 15.h, left: 10.w, right: 10.w),
      decoration: BoxDecoration(
        color: defaulColorThem,
        border: Border.all(width: 1, color: Colors.black12),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: widget,
    );
  }
}
