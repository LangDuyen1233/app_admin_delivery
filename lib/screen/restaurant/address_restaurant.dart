import 'package:address_picker_vn/address_picker.dart';
import 'package:app_delivery/components/item_field.dart';
import 'package:app_delivery/widgets/form_add_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddressRestaurant extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text("Địa chỉ quán"),
        actions: [
          IconButton(
            icon: Icon(Icons.check_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
          color: Color(0xFFEEEEEE),
          // height: 834.h,
          child: Container(
              height: 290.h,
              color: Color(0xFFEEEEEE),
              child: FormAddWidget(
                  widget: Column(
                    children: [
                      Container(
                        color: Colors.white,
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
                      ),
                      Container(
                        height: 55.h,
                        child: ItemField(
                          hintText: "Địa chỉ cụ thể",
                        ),
                      ),
                    ],
                  )))),
    );
  }
}
