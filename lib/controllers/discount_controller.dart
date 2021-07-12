import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DiscountController extends GetxController {
  static DiscountController get to => Get.find<DiscountController>();
  DateTime selectedDate = DateTime.now();

  String startDates = "Select Date";
  String endDates = "Select Date";

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
      startDates = DateFormat('dd-MM-yyyy').format(picked);
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
      endDates = DateFormat('dd-MM-yyyy').format(picked);
      print('vo dday ah ' + selectedDate.toString());
    }
    update();
  }

  //select date and rang date for page statistic revenue
  String selectedDateMultiPicker = '';
  String dateCount = '';
  String range = '';
  String rangeCount = '';

  // void checkMulti(DateRangePickerSelectionChangedArgs args) {
  //   if (DateFormat('dd/MM/yyyy').format(args.value.startDates) !=
  //       DateFormat('dd/MM/yyyy')
  //           .format(args.value.endDates ?? args.value.startDates))
  //     selectedDateMultiPicker = args.value.toString();
  // }

  void onSelectionChanged(DateRangePickerSelectionChangedArgs args) async {
    if (args.value is PickerDateRange) {
      if (args.value.startDate ==
          (args.value.endDate ?? args.value.startDate)) {
        print('bang');
        range =
            DateFormat('dd/MM/yyyy').format(args.value.startDate).toString();
      } else {
        print('khac');
        range =
            DateFormat('dd/MM/yyyy').format(args.value.startDate).toString() +
                ' - ' +
                DateFormat('dd/MM/yyyy')
                    .format(args.value.endDate ?? args.value.startDate)
                    .toString();
      }
    } else if (args.value is DateTime) {
      print('dgasj');
      selectedDateMultiPicker =
          DateFormat('dd/MM/yyyy').format(args.value.startDates).toString();
    } else if (args.value is List<DateTime>) {
      dateCount = args.value.length.toString();
    } else {
      rangeCount = args.value.length.toString();
    }
  }
}
