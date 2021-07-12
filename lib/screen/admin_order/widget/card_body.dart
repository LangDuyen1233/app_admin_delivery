import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CardBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 1.w, top: 10.h),
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.only(right: 8.w, top: 8.h, bottom: 8.w),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 24.w,
                      child: Text('1 ' + 'X'),
                    ),
                    Container(
                      width: 230.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bún bò',
                            style: TextStyle(fontSize: 18.sp),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 70.w,
                      child: Text(
                        '139.00đ',
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
                // Container(
                //     decoration: BoxDecoration(
                //         border: Border(
                //             bottom:
                //             BorderSide(width: 0.5, color: Colors.grey[300])))),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 24.w,
                      child: Text('1 ' + 'X'),
                    ),
                    Container(
                      width: 230.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Trà đào cam sả',
                            style: TextStyle(fontSize: 18.sp),
                          ),
                          Text(
                            '1 X thạch củ năng',
                            style:
                                TextStyle(fontSize: 15.sp, color: Colors.grey),
                          ),
                          Text(
                            '1 X hạt đẹp',
                            style:
                                TextStyle(fontSize: 15.sp, color: Colors.grey),
                          ),
                          // Text(
                          //   'Size ' + 'map.values.elementAt(i).size.name',
                          //   style: TextStyle(
                          //     fontSize: 16.sp,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    Container(
                      width: 70.w,
                      child: Text(
                        '139.00đ',
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 24.w,
                      child: Text('1 ' + 'X'),
                    ),
                    Container(
                      width: 230.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Trà đào cam sả',
                            style: TextStyle(fontSize: 18.sp),
                          ),
                          Text(
                            '1 X thạch củ năng',
                            style:
                                TextStyle(fontSize: 15.sp, color: Colors.grey),
                          ),
                          Text(
                            '1 X hạt đẹp',
                            style:
                                TextStyle(fontSize: 15.sp, color: Colors.grey),
                          ),
                          // Text(
                          //   'Size ' + 'map.values.elementAt(i).size.name',
                          //   style: TextStyle(
                          //     fontSize: 16.sp,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    Container(
                      width: 70.w,
                      child: Text(
                        '139.00đ',
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.all(10.sp),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8.sp)),
                    color: Colors.grey[100],
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        child: Text(
                          'Ghi chú của khách hàng:',
                          style: TextStyle(fontSize: 16.sp),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        child: Text(
                          'Bỏ đá riêng, dụng cụ ăn uống đầy đủ Bỏ đá riêng, dụng cụ ăn uống đầy đủBỏ đá riêng, dụng cụ ăn uống đầy đủBỏ đá riêng, dụng cụ ăn uống đầy đủBỏ đá riêng, dụng cụ ăn uống đầy đủ',
                          softWrap: true,
                          style: TextStyle(fontSize: 15.sp, color: Colors.grey),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
