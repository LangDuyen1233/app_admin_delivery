import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: [HistoryItem(), HistoryItem()],
      ),
    );
  }
}

class HistoryItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: FractionalOffset.topCenter,
      margin: new EdgeInsets.only(top: 1.h),
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // date and status
            Container(
              padding: EdgeInsets.only(left: 15.w, right: 15.w),
              height: 50.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text('07/06/2021'), Text('Đã giao')],
              ),
            ),
            Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom:
                            BorderSide(width: 0.5, color: Colors.grey[300])))),
            //
            Container(
              padding: EdgeInsets.only(left: 15, right: 18),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // user identify
                  Container(
                    height: 70.h,
                    child: Row(
                      children: [
                        Container(
                            decoration: BoxDecoration(
                              border:
                                  Border.all(width: 1, color: Colors.black12),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                            ),
                            // margin: EdgeInsets.all(5),
                            //image
                            child: Container(
                              width: 50.w,
                              height: 50.h,
                              padding: EdgeInsets.only(
                                  right: 12.w,
                                  bottom: 12.h,
                                  left: 12.w,
                                  top: 12.h),
                              child: Image.asset(
                                'assets/images/person.png',
                                fit: BoxFit.fill,
                                color: Colors.black26,
                              ),
                            )),
                        //user name
                        Container(
                          padding: EdgeInsets.only(left: 5.w),
                          child: Text('duyen duyen'),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  width: 0.2, color: Colors.grey[300])))),
                  Container(
                    height: 60.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // trạng thái đã giao hoặc đã hủy
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                'Đã giao',
                                style: TextStyle(color: Colors.grey),
                              ),
                              Text("20:57")
                            ],
                          ),
                        ),
                        // tổng số món
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                'Món',
                                style: TextStyle(color: Colors.grey),
                              ),
                              Text("2")
                            ],
                          ),
                        ),
                        // khoảng cách
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                'Khoảng cách',
                                style: TextStyle(color: Colors.grey),
                              ),
                              Text("1.7km")
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
                // color: Colors.blue,
                height: 40.h,
                padding: EdgeInsets.only(right: 15.w),
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.summarize,
                      size: 20.sp,
                      color: Colors.grey[700],
                    ),
                    Text('169.500đ'),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
