import 'package:app_delivery/components/item_field.dart';
import 'package:app_delivery/widgets/form_add_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:app_delivery/controllers/image_controler.dart';
import '../constants.dart';
import 'package:get/get.dart';

class AddCategory extends StatelessWidget {
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
      title: Text("Thêm loại đồ ăn"),
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
      child: Column(
        children: [
          ListImages(),
          FormAddWidget(
            widget: Column(
              children: [
                // Avatar(icon: Icons.add_a_photo,name: "Image",),
                ItemField(
                  hintText: "Name",
                ),
                ItemField(
                  hintText: "Quantity",
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ListImages extends StatelessWidget {
  final ImageController controller = Get.put(ImageController());

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 5.h),
      child: Row(
        children: [
          SizedBox(
            width: 60.w,
            height: 60.h,
            child: RaisedButton(
              onPressed: () {
                controller.getImage();
              },
              color: Colors.white,
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(5.0)),
              child: SizedBox(
                // child: Center(
                child: Icon(
                  Icons.add_a_photo,
                  color: Colors.grey,
                  size: 30.0,
                ),
                // ),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          SizedBox(
              width: 60.w,
              height: 60.h,
              child: GetBuilder<ImageController>(
                builder: (_) {
                  return controller.image == null
                      ? Text('')
                      : ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          child: Image.file(
                            controller.image,
                            fit: BoxFit.cover,
                          ),
                        );
                },
              )),
        ],
      ),
    );
  }
}
