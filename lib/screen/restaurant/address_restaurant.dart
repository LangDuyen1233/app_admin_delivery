import 'package:address_picker_vn/address_picker.dart';
import 'package:app_delivery/components/item_field.dart';
import 'package:app_delivery/widgets/form_add_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddressRestaurant extends StatelessWidget {
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
      title: Text("Thông tin quán"),
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
        // height: 834.h,
        child: Container(
            height: 284.h,
            color: Color(0xFFEEEEEE),
            child: FormAddWidget(
                widget: Column(
              children: [
                AddressR(),
                Container(
                  height: 55.h,
                  child: ItemField(
                    hintText: "Địa chỉ cụ thể",
                  ),
                ),
              ],
            ))));
  }
}

class AddressR extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10.w, right: 10.w),
      margin: EdgeInsets.only(top: 5.h),
      child: AddressPicker(
        onAddressChanged: (address) {
          print(address);
        },
        buildItem: (text) {
          return Text(text,
              style: TextStyle(color: Colors.black, fontSize: 16.sp));
        },
      ),
      // ),
      // Container(
      //   child: ItemField(
      //     hintText: "Địa chỉ cụ thể",
      //   ),
      // ),
      // Container(
      //     decoration: BoxDecoration(
      //         border: Border(
      //             bottom: BorderSide(width: 0.5, color: Colors.grey[300])))),
    );
  }
}
