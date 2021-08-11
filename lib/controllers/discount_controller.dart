import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DiscountController extends GetxController {
  static DiscountController get to => Get.find<DiscountController>();
  DateTime selectedDate = DateTime.now();

  String startDates = "Chọn ngày";
  String endDates = "Chọn ngày";
  String dob = "Chọn ngày";

  selectStartDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      print('vo dday ah');
      print(picked);
      selectedDate = picked;
      startDates = DateFormat('yyyy-MM-dd').format(picked);
      print('vo dday ah ' + selectedDate.toString());
    }
    update();
  }

  selectEndDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      print('vo dday ah');
      print(picked);
      selectedDate = picked;
      endDates = DateFormat('yyyy-MM-dd').format(picked);
      print('vo dday ah ' + selectedDate.toString());
    }
    update();
  }

  selectDateDob(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      print('vo dday ah');
      print(picked);
      selectedDate = picked;
      dob = DateFormat('yyyy-MM-dd').format(picked);
      print('vo dday ah ' + selectedDate.toString());
    }
    update();
  }

  //select date and rang date for page statistic revenue
  String formattedDate =DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();

  String selectedDateMultiPicker = '';
  String dateCount = '';
  RxString range = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString().obs;
  String rangeCount = '';

  void onSelectionChanged(DateRangePickerSelectionChangedArgs args) async {
    if (args.value is PickerDateRange) {
      if (args.value.startDate ==
          (args.value.endDate ?? args.value.startDate)) {
        print('bang');
        range.value =
            DateFormat('yyyy-MM-dd').format(args.value.startDate).toString();
      } else {
        print('khac');
        range.value =
            DateFormat('yyyy-MM-dd').format(args.value.startDate).toString() +
                ' - ' +
                DateFormat('yyyy-MM-dd')
                    .format(args.value.endDate ?? args.value.startDate)
                    .toString();
      }
    } else if (args.value is DateTime) {
      print('dgasj');
      selectedDateMultiPicker =
          DateFormat('yyyy-MM-dd').format(args.value.startDates).toString();
    } else if (args.value is List<DateTime>) {
      dateCount = args.value.length.toString();
    } else {
      rangeCount = args.value.length.toString();
    }
  }
}
