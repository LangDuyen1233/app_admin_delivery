import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app_delivery/components/item_field.dart';
import 'package:app_delivery/controllers/discount_controller.dart';
import 'package:app_delivery/controllers/image_controler.dart';
import 'package:app_delivery/models/Staff.dart';
import 'package:app_delivery/widgets/form_add_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../apis.dart';
import '../../utils.dart';

class AddStaff extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddStaff();
  }
}

class _AddStaff extends State<AddStaff> {
  @override
  void initState() {
    name = TextEditingController();
    salary = TextEditingController();
    address = TextEditingController();
    phone = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        autovalidate: true,
        child: Builder(
            builder: (BuildContext ctx) => Scaffold(
                  appBar: AppBar(
                    centerTitle: true,
                    elevation: 0,
                    title: Text("Thêm nhân viên"),
                    actions: [
                      IconButton(
                        icon: Icon(Icons.check_outlined),
                        onPressed: () {
                          addStaff(ctx);
                        },
                      ),
                    ],
                  ),
                  body: Container(
                    color: Color(0xFFEEEEEE),
                    height: 834.h,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ListImages(),
                          FormAddWidget(
                            widget: Column(
                              children: [
                                ItemField(
                                  hintText: "Tên nhân viên",
                                  controller: name,
                                  type: TextInputType.text,
                                  validator: (val) {
                                    if (val.length == 0) {
                                      return 'Vui lòng nhập tên nhân viên';
                                    } else
                                      return null;
                                  },
                                ),
                                ItemField(
                                  hintText: "Địa chỉ",
                                  controller: address,
                                  type: TextInputType.text,
                                  validator: (val) {
                                    if (val.length == 0) {
                                      return 'Vui lòng nhập địa chỉ nhân viên';
                                    } else
                                      return null;
                                  },
                                ),
                                ItemField(
                                  hintText: "Số điện thoại",
                                  controller: phone,
                                  type: TextInputType.number,
                                  validator: (val) {
                                    if (val.length == 0) {
                                      return 'Vui lòng nhập tên số điện thoại nhân viên';
                                    } else
                                      return null;
                                  },
                                ),
                                ItemField(
                                  hintText: "Lương/h",
                                  controller: salary,
                                  type: TextInputType.number,
                                  validator: (val) {
                                    if (val.length == 0) {
                                      return 'Vui lòng nhập tiền lương tính theo giờ';
                                    } else
                                      return null;
                                  },
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                StartDate(),
                                SizedBox(
                                  height: 5.h,
                                ),
                                EndDate(),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )));
  }

  TextEditingController name;
  TextEditingController salary;
  TextEditingController address;
  TextEditingController phone;
  final ImageController controller = Get.put(ImageController());
  final DiscountController date = Get.put(DiscountController());

  Future<void> addStaff(BuildContext context) async {
    String token = await getToken();
    if (Form.of(context).validate()) {
      String nameImage;
      String startDate = date.startDates;
      String endDate = date.endDates;
      if (controller.imagePath != null) {
        int code = await uploadAvatar(controller.image, controller.imagePath);
        if (code == 200) {
          nameImage = controller.imagePath.split('/').last;
        }
      }
      if (name.text.isNotEmpty &&
          address.text.isNotEmpty &&
          salary.text.isNotEmpty &&
          phone.text.isNotEmpty) {
        try {
          EasyLoading.show(status: 'Loading...');

          http.Response response = await http.post(
            Uri.parse(Apis.addStaffUrl),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': "Bearer $token",
            },
            body: jsonEncode(<String, dynamic>{
              'name': name.text,
              'salary': salary.text,
              'address': address.text,
              'phone': phone.text,
              'avatar': nameImage,
              'start_date': startDate,
              'end_date': endDate
            }),
          );

          if (response.statusCode == 200) {
            EasyLoading.dismiss();
            var parsedJson = jsonDecode(response.body);
            Staff staff = Staff.fromJson(parsedJson['staff']);
            Get.back(result: staff);
            showToast("Tạo thành công");
          }
          if (response.statusCode == 404) {
            EasyLoading.dismiss();
            var parsedJson = jsonDecode(response.body);
          }
        } on TimeoutException catch (e) {
          showError(e.toString());
        } on SocketException catch (e) {
          showError(e.toString());
        }
      } else {
        showToast('Vui lòng điền đầy đủ các trường');
      }
    } else {
      showToast('Vui lòng điền đầy đủ các trường');
    }
  }
}

class ListImages extends StatelessWidget {
  final ImageController controller = Get.put(ImageController());

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20.h),
      child: Column(
        children: [
          SizedBox(
            width: 120.w,
            height: 120.h,
            child: RaisedButton(
              onPressed: () {
                controller.getImage();
              },
              color: Colors.white,
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(5.0)),
              child: GetBuilder<ImageController>(
                builder: (_) {
                  return controller.image == null
                      ? Icon(
                          Icons.add_a_photo,
                          color: Colors.grey,
                          size: 25.0.sp,
                        )
                      : Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.only(top: 5.h, bottom: 5.h),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(maxHeight: 120.h),
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              child: Image.file(
                                controller.image,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StartDate extends StatelessWidget {
  final DiscountController controller = Get.put(DiscountController());

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10.w, right: 10.w),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      height: 60.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              padding: EdgeInsets.only(left: 15.w), child: Text('Ngày bắt đầu')),
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
      margin: EdgeInsets.only(left: 10.w, right: 10.w),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      height: 60.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              padding: EdgeInsets.only(left: 15.w), child: Text('Ngày kết thúc')),
          Row(
            children: [
              GetBuilder<DiscountController>(builder: (context) {
                return Text(controller.endDates,
                    style: TextStyle(fontSize: 15.sp, color: Colors.grey));
              }),
              IconButton(
                onPressed: () {
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
