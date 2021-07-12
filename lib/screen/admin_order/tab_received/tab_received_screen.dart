import 'package:app_delivery/screen/admin_order/tab_received/widget/prepare_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TabReceivedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 10.h,
      ),
      color: Color(0xFFEEEEEE),
      width: double.infinity,
      child: DefaultTabController(
        length: 3,
        child: Column(
          children: <Widget>[
            Container(
              color: Color(0xFFEEEEEE),
              constraints: BoxConstraints.expand(height: 35.h),
              child: TabBar(
                unselectedLabelColor: Colors.black87,
                indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.blue),
                tabs: [
                  Tab(
                    child: Container(
                      // padding: EdgeInsets.all(5.sp),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(color: Colors.blue, width: 1)),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Đang chuẩn bị",
                          style: TextStyle(fontSize: 14.sp),
                        ),
                      ),
                    ),
                  ),
                  Tab(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(color: Colors.blue, width: 1)),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text("Đang giao",
                            style: TextStyle(fontSize: 14.sp)),
                      ),
                    ),
                  ),
                  Tab(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(color: Colors.blue, width: 1)),
                      child: Align(
                        alignment: Alignment.center,
                        child:
                            Text("Đã giao", style: TextStyle(fontSize: 14.sp)),
                      ),
                    ),
                  ),
                ],
                indicatorColor: Colors.blue,
                labelColor: Colors.white,
              ),
            ),
            Expanded(
              child: Container(
                child: TabBarView(children: [
                  PrepareScreen(),
                  Container(
                    child: Text("Articles Body"),
                  ),
                  Container(
                    child: Text("User Body"),
                  ),
                ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}
