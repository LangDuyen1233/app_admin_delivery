import 'package:app_delivery/screen/admin_order/widget/card_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TabNew extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: [TabNewItem(), TabNewItem(), TabNewItem()],
      ),
    );
  }
}

class TabNewItem extends StatelessWidget {
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
                    child: Text('Từ chối',
                        style: TextStyle(fontSize: 16, color: Colors.grey)),
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
                      'Xác nhận',
                      style: TextStyle(fontSize: 16, color: Colors.blue),
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
