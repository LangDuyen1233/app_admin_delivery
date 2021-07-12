import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChooseItem extends StatelessWidget {
  final IconData icon;
  final String name;
  final String content;
  final Widget page;

  const ChooseItem({Key key, this.icon, this.name, this.content, this.page})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(page);
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
                        Get.to(page);
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