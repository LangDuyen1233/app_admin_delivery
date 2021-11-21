import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FormAddWidget extends StatelessWidget {
  final Widget widget;

  const FormAddWidget({Key key, this.widget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 15.h, left: 10.w, right: 10.w),
      child: widget,
    );
  }
}
