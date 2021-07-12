import 'package:app_delivery/components/choose_food.dart';
import 'package:app_delivery/components/item_field.dart';
import 'package:app_delivery/controllers/discount_controller.dart';
import 'package:app_delivery/widgets/form_add_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AddDiscountFood extends StatelessWidget {
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
      title: Text("Thêm khuyến mãi"),
      actions: [
        IconButton(
          icon: Icon(Icons.check_outlined),
          onPressed: () {},
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
        child: Center(
          child: Column(
            children: <Widget>[
              FormAddWidget(
                widget: Column(
                  children: [
                    // Avatar(icon: Icons.add_a_photo,name: "Image",),
                    ItemField(
                      hintText: "Name",
                    ),
                    ItemField(
                      hintText: "Percent",
                    ),
                    ItemField(
                      hintText: "Content",
                    ),
                  ],
                ),
              ),
              FormAddWidget(
                  widget: Column(
                children: [
                  StartDate(),
                  SizedBox(
                    child: Container(
                      decoration: BoxDecoration(
                          // color: defaulColorThem,
                          border: Border(
                              bottom: BorderSide(
                                  width: 0.5, color: Colors.black12))),
                    ),
                  ),
                  EndDate(),
                  SizedBox(
                    child: Container(
                      decoration: BoxDecoration(
                          // color: defaulColorThem,
                          border: Border(
                              bottom: BorderSide(
                                  width: 0.5, color: Colors.black12))),
                    ),
                  ),
                  ChooseFood()
                ],
              ))
            ],
          ),
        ));
  }
}

class StartDate extends StatelessWidget {
  final DiscountController controller = Get.put(DiscountController());

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              padding: EdgeInsets.only(left: 15.w), child: Text('Start date')),
          Row(
            children: [
              GetBuilder<DiscountController>(builder: (context) {
                return Text(
                  controller.startDates,
                  style: TextStyle(fontSize: 15.sp, color: Colors.grey),
                );
              }),
              IconButton(
                onPressed: () {
                  print('dduj mas m');
                  controller.selectStartDate(context);
                },
                icon: Icon(
                  Icons.calendar_today_rounded,
                  size: 18,
                  color: Colors.grey,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class EndDate extends StatelessWidget {
  final DiscountController controller = Get.put(DiscountController());

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              padding: EdgeInsets.only(left: 15.w), child: Text('End date')),
          Row(
            children: [
              GetBuilder<DiscountController>(builder: (context) {
                return Text(controller.endDates,
                    style: TextStyle(fontSize: 15.sp, color: Colors.grey));
              }),
              IconButton(
                onPressed: () {
                  print('dduj mas m');
                  controller.selectEndDate(context);
                },
                icon: Icon(
                  Icons.calendar_today_rounded,
                  size: 18,
                  color: Colors.grey,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
