import 'package:app_delivery/controllers/discount_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class StatisticsRevenueScreen extends StatelessWidget {
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
      title: Text("Báo cáo doanh thu"),
    );
  }
}

class Body extends StatelessWidget {
  final DiscountController controller = Get.put(DiscountController());

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFEEEEEE),
      height: 834.h,
      width: double.infinity,
      child: Column(
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // StartDate(),
                Container(
                  width: 400.w,
                  child: Row(
                    children: [
                      Text(controller.range),
                      IconButton(
                        onPressed: () {
                          showDialog<Widget>(
                              context: context,
                              builder: (BuildContext context) {
                                return Center(
                                  child: Container(
                                    width: 414.w,
                                    height: 400.h,
                                    child: Card(
                                      margin: EdgeInsets.only(
                                          left: 12.w, right: 12.w),
                                      child: SfDateRangePicker(
                                        backgroundColor: Colors.white,
                                        showActionButtons: true,
                                        onSubmit: (Object value) {
                                          print('object' + controller.range);
                                          Navigator.pop(context);
                                        },
                                        onCancel: () {
                                          Navigator.pop(context);
                                        },
                                        onSelectionChanged:
                                            controller.onSelectionChanged,
                                        selectionMode:
                                            DateRangePickerSelectionMode.range,
                                      ),
                                    ),
                                  ),
                                );
                              });
                        },
                        icon: Icon(Icons.calendar_today),
                      ),
                    ],
                  ),
                ),
                Container(
                    height: 50.h,
                    decoration: BoxDecoration(
                        color: Colors.black87,
                        border: Border(
                            right: BorderSide(
                                width: 1, color: Colors.blue[100])))),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: 220.h,
            child: Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  Container(
                    width: 55.w,
                    height: 55.h,
                    decoration: BoxDecoration(
                      color: Color(0xFFDAECFF),
                      borderRadius: BorderRadius.circular(5.sp),
                    ),
                    child: Icon(
                      Icons.monetization_on,
                      size: 35.h,
                      color: Colors.blue,
                    ),
                  ),
                  Text(
                    'Doanh thu'.toUpperCase(),
                    style: TextStyle(fontSize: 20.sp),
                  ),
                  Text(
                    '0',
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold),
                  ),
                  Text('Số đơn hàng: 0'),
                  SizedBox(
                    height: 10.h,
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [ListDate(), ListDate(), ListDate(), ListDate()],
            ),
          )
        ],
      ),
    );
  }
}

class ShowRangDate extends StatelessWidget {
  final DiscountController controller = Get.put(DiscountController());

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text('Show picker'),
      onPressed: () {
        // showDialog<Widget>(
        //     context: context,
        //     builder: (BuildContext context) {
        //       return SfDateRangePicker(
        //         showActionButtons: true,
        //         onSubmit: (Object value) {
        //           print('object' + controller.selectedDateMultiPicker);
        //           Navigator.pop(context);
        //         },
        //         onCancel: () {
        //           Navigator.pop(context);
        //         },
        //         onSelectionChanged: controller.onSelectionChanged,
        //         selectionMode: DateRangePickerSelectionMode.range,
        //         initialSelectedRange: PickerDateRange(
        //             DateTime.now().subtract(const Duration(days: 4)),
        //             DateTime.now().add(const Duration(days: 3))),
        //       );
        //     });
      },
    );
  }
}

class ListDate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              bottom: BorderSide(
            width: 0.8,
            color: Color(0xFFEEEEEE),
          ))),
      height: 80.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              margin: EdgeInsets.only(left: 10.w), child: Text('13/06/2021')),
          Container(
              margin: EdgeInsets.only(right: 10.w),
              child: Text('Doanh thu: 10000000')),
        ],
      ),
    );
  }
}
