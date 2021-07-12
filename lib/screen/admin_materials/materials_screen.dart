import 'package:app_delivery/models/Material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

import 'add_materials.dart';

class MaterialsScreen extends StatelessWidget {
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
      title: Text("Danh sách nguyên vật liệu"),
      actions: [
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            print("mày có vô đây không???");
            Get.to(AddMaterial());
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
                    child: MaterialItem(
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

class MaterialItem extends StatelessWidget {
  final Materials item;

  const MaterialItem({Key key, this.item}) : super(key: key);

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
                  padding: EdgeInsets.only(top: 5.h, left: 10.w),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: Image.network(
                      item.image,
                      width: 100.w,
                      height: 100.w,
                      fit: BoxFit.cover,
                    ),
                  ),
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
                      Text('Số lượng còn lại : ' +
                          item.quantity.toString() +
                          ' phần'),
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
