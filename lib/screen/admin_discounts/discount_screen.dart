import 'package:app_delivery/models/discount.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

import 'choose_discounts.dart';

class DiscountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Body(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      centerTitle: true,
      elevation: 0,
      title: Text("Danh sách khuyến mãi"),
      actions: [
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            print("mày có vô đây không???");
            Get.to(ChooseDiscount());
          },
        ),
      ],
    );
  }
}

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Color(0xFFEEEEEE),
        height: 834.h,
        width: double.infinity,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: list.length,
                itemBuilder: (context, index) {
                  return Slidable(
                    actionPane: SlidableDrawerActionPane(),
                    actionExtentRatio: 0.25,
                    child: DiscountItem(
                      item: list[index],
                    ),
                    secondaryActions: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 5),
                        child: IconSlideAction(
                          caption: 'Delete',
                          color: Color(0xFFEEEEEE),
                          icon: Icons.delete,
                          foregroundColor: Colors.red,
                          onTap: () {},
                        ),
                      )
                    ],
                  );
                },
              ),
            )
          ],
        ));
  }
}

class DiscountItem extends StatelessWidget {
  final Discount item;

  const DiscountItem({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.only(top: 10.h, left: 15, right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.sp)),
          color: Colors.white,
        ),
        height: 120.h,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 10.w),
                  child: Icon(
                    Icons.local_offer,
                    size: 35.h,
                    color: Colors.amber,
                  ),
                  // child: ClipRRect(
                  //   borderRadius: BorderRadius.all(Radius.circular(10)),

                  // child: Image.network(
                  //   item.img,
                  //   width: 110.w,
                  //   height: 110.w,
                  //   fit: BoxFit.cover,
                  // ),
                  // ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 15.w, right: 10.w),
                  height: 92.h,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        item.name,
                        style: TextStyle(
                            fontSize: 20.sp, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        item.content,
                        style: TextStyle(fontSize: 15.sp, color: Colors.grey),
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
