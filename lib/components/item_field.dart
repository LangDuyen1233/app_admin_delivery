import 'package:app_delivery/screen/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ItemField extends StatelessWidget {
  final TextEditingController controller;
  final FormFieldValidator<String> validator;
  final TextInputType type;
  final String hintText;
  final ValueChanged<String> onChanged;

  const ItemField(
      {Key key, this.hintText, this.controller, this.validator, this.type, this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 5.h, left: 10.w, right: 10.w),
      width: MediaQuery.of(context).size.width,
      child: TextFormField(
        onChanged: onChanged,
        validator: validator,
        controller: controller,
        keyboardType: type,
        style: TextStyle(fontSize: 16.0.sp, color: Colors.black),
        decoration: InputDecoration(
          fillColor: Colors.white,
          contentPadding:
              EdgeInsets.only(top: 20.h, bottom: 20.h, left: 12.w, right: 15.w),
          hintText: hintText,
          // border: InputBorder.none,
          border: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(5.0.w),
            borderSide: const BorderSide(color: Colors.black12, width: 0.1),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black12, width: 0.7),
          ),
        ),
      ),
    );
  }
}
