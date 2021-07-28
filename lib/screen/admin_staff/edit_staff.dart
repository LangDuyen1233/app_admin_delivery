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

class EditStaff extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _EditStaff();
  }
}

class _EditStaff extends State<EditStaff> {
  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidate: true,
      child: Builder(
        builder: (BuildContext ctx) => FutureBuilder(
          future: fetchStaff(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  elevation: 0,
                  title: Text("Sửa nhân viên"),
                  actions: [
                    IconButton(
                      icon: Icon(Icons.check_outlined),
                      onPressed: () {
                        updateStaff(context);
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
                        ListImages(
                          avatar: s.avatar,
                        ),
                        FormAddWidget(
                          widget: Column(
                            children: [
                              // Avatar(icon: Icons.add_a_photo,name: "Image",),
                              ItemField(
                                hintText: "Tên nhân viên",
                                controller: name,
                                type: TextInputType.text,
                                validator: (val) {
                                  print(val);
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
                                  print(val);
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
                                  print(val);
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
                                  print(val);
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
              );
            } else
              return Container();
          },
        ),
      ),
    );
  }

  TextEditingController name;
  TextEditingController salary;
  TextEditingController address;
  TextEditingController phone;
  int staffId;
  final ImageController controller = Get.put(ImageController());
  final DiscountController date = Get.put(DiscountController());
  Staff s;

  @override
  void initState() {
    // staffId = Get.arguments['staff_id'];
    // print(staffId);
    super.initState();
  }

  Future<bool> fetchStaff() async {
    var staff = await editStaff();
    if (staff != null) {
      printInfo(info: staff.toString());
      s = staff;
    }
    print(s.name);
    name = TextEditingController(text: s.name);
    salary = TextEditingController(text: s.salary.toString());
    address = TextEditingController(text: s.address);
    phone = TextEditingController(text: s.phone);
    date.startDates = s.startDate;
    date.endDates = s.endDate;

    return staff.isBlank;
  }

  Future<Staff> editStaff() async {
    Staff staff;
    String token = (await getToken());
    staffId = Get.arguments['staff_id'];
    print(staffId);
    Map<String, String> queryParams = {
      'staffId': staffId.toString(),
    };
    String queryString = Uri(queryParameters: queryParams).query;
    try {
      print(Apis.editStaffUrl);
      http.Response response = await http.get(
        Uri.parse(Apis.editStaffUrl + '?' + queryString),
        headers: <String, String>{
          'Accept': 'application/json',
          'Authorization': "Bearer $token",
        },
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        var parsedJson = jsonDecode(response.body);
        print(parsedJson['staff']);
        staff = StaffJson.fromJson(parsedJson).staff;
        print(staff);
        return staff;
      }
      if (response.statusCode == 401) {
        showToast("Loading faild");
      }
    } on TimeoutException catch (e) {
      showError(e.toString());
    } on SocketException catch (e) {
      showError(e.toString());
      print(e.toString());
    }
    return null;
  }

  Future<void> updateStaff(BuildContext context) async {
    String token = await getToken();
    print(token);
    String startDate = date.startDates;
    String endDate = date.endDates;
    String nameImage;

    if (Form.of(context).validate()) {
      if (s.avatar != null) {
        if (controller.imagePath != null) {
          int code = await uploadAvatar(controller.image, controller.imagePath);
          if (code == 200) {
            nameImage = controller.imagePath.split('/').last;
          }
        } else {
          nameImage = s.avatar.split('/').last;
        }
      }else{
        if (controller.imagePath != null) {
          int code = await uploadAvatar(controller.image, controller.imagePath);
          if (code == 200) {
            nameImage = controller.imagePath.split('/').last;
          }
        } else {
          nameImage = s.avatar.split('/').last;
        }
      }

      if (name.text.isNotEmpty &&
          address.text.isNotEmpty &&
          salary.text.isNotEmpty &&
          phone.text.isNotEmpty) {
        try {
          http.Response response = await http.post(
            Uri.parse(Apis.updateStaffUrl),
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
              'end_date': endDate,
              'staffId': s.id,
            }),
          );

          print(response.statusCode);
          if (response.statusCode == 200) {
            EasyLoading.dismiss();
            var parsedJson = jsonDecode(response.body);
            // print(parsedJson['success']);
            Staff staff = Staff.fromJson(parsedJson['staff']);
            print(staff.name);
            Get.back(result: staff);
            showToast("Sửa thành công");
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
  final String avatar;

  ListImages({Key key, this.avatar}) : super(key: key);

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
                // img = controller.imagePath;
              },
              color: Colors.white,
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(5.0)),
              child: GetBuilder<ImageController>(
                builder: (_) {
                  return avatar != null
                      ? controller.image == null
                          ? Image.network(
                              Apis.baseURL + avatar,
                              width: 100.w,
                              height: 100.h,
                              fit: BoxFit.cover,
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
                                    // width: 90.w,
                                    // height: 90.h,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            )
                      : controller.image == null
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
                                    // width: 90.w,
                                    // height: 90.h,
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
              padding: EdgeInsets.only(left: 15.w),
              child: Text('Ngày bắt đầu')),
          Row(
            children: [
              GetBuilder<DiscountController>(builder: (context) {
                return controller.startDates != null
                    ? Text(
                        controller.startDates,
                        style: TextStyle(fontSize: 15.sp, color: Colors.grey),
                      )
                    : Text('Chọn ngày bắt đầu');
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
      margin: EdgeInsets.only(left: 10.w, right: 10.w),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      height: 60.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              padding: EdgeInsets.only(left: 15.w),
              child: Text('Ngày kết thúc')),
          Row(
            children: [
              GetBuilder<DiscountController>(builder: (context) {
                return controller.endDates != null
                    ? Text(controller.endDates,
                        style: TextStyle(fontSize: 15.sp, color: Colors.grey))
                    : Text('Chọn ngày kết thúc');
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
