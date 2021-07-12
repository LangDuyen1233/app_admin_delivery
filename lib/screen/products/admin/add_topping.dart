import 'package:app_delivery/components/item_field.dart';
import 'package:app_delivery/widgets/form_add_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddToppings extends StatelessWidget {
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
      title: Text("Thêm topping"),
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
      child: AddTopping(),
    );
  }
}

class AddTopping extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          FormAddWidget(
            widget: Column(
              children: [
                // Avatar(icon: Icons.add_a_photo,name: "Image",),
                ItemField(
                  hintText: "Tên topping",
                ),
                ItemField(
                  hintText: "Số lượng",
                ),
                ItemField(
                  hintText: "Giá bán",
                ),
                ItemField(
                  hintText: "Trạng thái",
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
