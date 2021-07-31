import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app_delivery/models/Staff.dart';
import 'package:app_delivery/screen/admin_staff/edit_staff.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../apis.dart';
import '../../utils.dart';
import 'add_staff.dart';

class StaffScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _StaffScreen();
  }
}

RxList<Staff> staff;

class _StaffScreen extends State<StaffScreen> {
  @override
  void initState() {
    staff = new RxList<Staff>();
    fetchStaff();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: Text("Danh sách nhân viên"),
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () async {
                print("mày có vô đây không???");
                final result = await Get.to(AddStaff());
                // final result = await Get.arguments['staff'];
                // print(result);
                setState(() {
                  print('đahkdja');
                  if (result != null) {
                    staff.assign(result);
                    staff.refresh();
                  }
                });
              },
            ),
          ],
        ),
        body: Container(
            padding: EdgeInsets.only(top: 5.h),
            color: Color(0xFFEEEEEE),
            height: 834.h,
            child: Obx(
              () => ListView.builder(
                shrinkWrap: true,
                itemCount: staff.length,
                itemBuilder: (context, index) {
                  return Slidable(
                    actionPane: SlidableDrawerActionPane(),
                    actionExtentRatio: 0.12,
                    child: StaffCard(
                      item: staff[index],
                    ),
                    secondaryActions: <Widget>[
                      Container(
                        child: IconSlideAction(
                          caption: 'Edit',
                          color: Color(0xFFEEEEEE),
                          icon: Icons.edit,
                          foregroundColor: Colors.blue,
                          onTap: () async {
                            var result = await Get.to(() => EditStaff(),
                                arguments: {'staff_id': staff.value[index].id});
                            print(result);
                            setState(() {
                              if (result != null) {
                                fetchStaff();
                              }
                            });
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5),
                        child: IconSlideAction(
                          caption: 'Delete',
                          color: Color(0xFFEEEEEE),
                          icon: Icons.delete,
                          foregroundColor: Colors.red,
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                      title: Text('Xóa nhân viên'),
                                      content: const Text(
                                          'Bạn có chắc chắn muốn xóa không?'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () => Get.back(),
                                          child: const Text('Hủy'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            await deleteStaff(staff[index].id);

                                            setState(() {
                                              staff.removeAt(index);
                                              staff.refresh();
                                              Get.back();
                                              showToast("Xóa thành công");
                                            });

                                            // Get.to(ListProduct());

                                            // food.refresh();
                                          },
                                          child: const Text(
                                            'Xóa',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ]);
                                });
                          },
                        ),
                      )
                    ],
                  );
                },
              ),
            ))
        // ],
        // ),
        // ),
        );
  }

  Future<void> fetchStaff() async {
    var list = await getStaff();
    if (list != null) {
      // printInfo(info: listFood.length.toString());
      // print(listFood.length);
      staff.assignAll(list);
      staff.refresh();
      // print(food.length);
    }
  }

  Future<List<Staff>> getStaff() async {
    List<Staff> list;
    String token = (await getToken());
    try {
      print(Apis.getStaffUrl);
      http.Response response = await http.get(
        Uri.parse(Apis.getStaffUrl),
        headers: <String, String>{
          'Accept': 'application/json',
          'Authorization': "Bearer $token",
        },
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        var parsedJson = jsonDecode(response.body);
        // print(parsedJson['food']);
        list = ListStaffJson.fromJson(parsedJson).staff;
        print(list);
        return list;
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

  Future<Staff> deleteStaff(int staff_id) async {
    String token = await getToken();
    print(token);

    try {
      EasyLoading.show(status: 'Loading...');
      http.Response response = await http.post(
        Uri.parse(Apis.deleteStaffUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': "Bearer $token",
        },
        body: jsonEncode(<String, dynamic>{
          'staff_id': staff_id,
        }),
      );

      print(response.statusCode);
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        var parsedJson = jsonDecode(response.body);
        // print(parsedJson['success']);
        Staff staff = Staff.fromJson(parsedJson['staff']);
        return staff;
      }
      if (response.statusCode == 404) {
        EasyLoading.dismiss();
        var parsedJson = jsonDecode(response.body);
        print(parsedJson['error']);
      }
    } on TimeoutException catch (e) {
      showError(e.toString());
    } on SocketException catch (e) {
      showError(e.toString());
    }
  }
}

class StaffCard extends StatelessWidget {
  final Staff item;

  const StaffCard({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 3.h,
        left: 8.h,
      ),
      margin: EdgeInsets.only(top: 10.h, left: 12.h, right: 10.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8.sp)),
        color: Colors.white,
      ),
      height: 100.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.black12),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: item.avatar == null
                    ? Container(
                        width: 80.w,
                        height: 80.w,
                        padding: EdgeInsets.only(
                            right: 12.w, bottom: 12.h, left: 12.w, top: 12.h),
                        child: Image.asset(
                          'assets/images/person.png',
                          fit: BoxFit.fill,
                          color: Colors.black26,
                        ),
                      )
                    : Container(
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          child: Image.network(
                            Apis.baseURL + item.avatar,
                            width: 80.w,
                            height: 80.w,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
              ),
              Container(
                padding: EdgeInsets.only(left: 15.w, right: 10.w),
                height: 92.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      item.name,
                      style: TextStyle(
                          fontSize: 20.sp, fontWeight: FontWeight.w600),
                    ),
                    Text('Số điện thoại: ' + item.phone.toString()),
                    Text('Địa chỉ : ' + item.address.toString()),
                    Text('Lương : ' + item.salary.toString() + ' /h'),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
