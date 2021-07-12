import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrepareScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // child: Expanded(
        child: ListView(
          children: [PrepareItem(), PrepareItem()],
        ),
      // ),
    );
  }
}

class PrepareItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: FractionalOffset.topCenter,
      margin: new EdgeInsets.only(top: 1.h),
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CardTop(),
            Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom:
                            BorderSide(width: 0.5, color: Colors.grey[300])))),
            CardBody(),
            Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom:
                            BorderSide(width: 0.5, color: Colors.grey[300])))),
            CardBottom()
          ],
        ),
      ),
    );
  }
}

class CardTop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 2.h,
        left: 10.h,
      ),
      height: 70.h,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              //img user
              Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.black12),
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                  // margin: EdgeInsets.all(5),
                  //image
                  child: Container(
                    width: 50.w,
                    height: 50.h,
                    padding: EdgeInsets.only(
                        right: 12.w, bottom: 12.h, left: 12.w, top: 12.h),
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
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.call,
                      size: 20,
                      color: Colors.grey,
                    )),
                IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.print, size: 20, color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

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
                      child: Text('1 ' + 'X',style: TextStyle(fontSize: 16.sp),),
                    ),
                    Container(
                      width: 230.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bún bò',
                            style: TextStyle(fontSize: 16.sp),
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
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 24.w,
                      child: Text('1 ' + 'X',style: TextStyle(fontSize: 16.sp),),
                    ),
                    Container(
                      width: 230.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Trà đào cam sả',
                            style: TextStyle(fontSize: 16.sp),
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
                        style: TextStyle(fontSize: 15.sp),
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
                      child: Text('1 ' + 'X',style: TextStyle(fontSize: 16.sp),),
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
                        style: TextStyle(fontSize: 15.sp),
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

class CardBottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55.h,
      child: Column(
        children: [
          Container(
            height: 45.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () {},
                  child: Container(
                    alignment: Alignment.center,
                    width: 190.w,
                    child: Text('Giao bởi quán',
                        style: TextStyle(fontSize: 15.sp, color: Colors.blue)),
                  ),
                ),
                Center(
                  child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                              right:
                                  BorderSide(width: 1, color: Colors.grey)))),
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    alignment: Alignment.center,
                    width: 190.w,
                    child: Text(
                      'Báo cho tài xế',
                      style: TextStyle(fontSize: 15.sp, color: Colors.blue),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
