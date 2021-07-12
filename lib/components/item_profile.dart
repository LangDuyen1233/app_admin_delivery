import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ItemProfile extends StatelessWidget {
  final String title;
  final String description;
  Widget page;

  ItemProfile({this.title, this.description, this.page});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 15.w,right: 10.w),
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(width: 0.3, color: Colors.black12))),
      width: MediaQuery.of(context).size.width,
      child: Row(

        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // LineDecoration(),
          Container(
            child: Text(
              title,
              style: TextStyle(fontSize: 17.sp),
            ),
          ),
          Container(
            child: Row(
              children: [
                Text(
                  description,
                  style: TextStyle(fontSize: 16.sp, color: Colors.blue,),
                ),
                IconButton(
                    onPressed: () {
                      Get.to(page);
                    },
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
