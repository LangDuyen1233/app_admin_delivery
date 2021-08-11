import 'package:app_delivery/screen/admin_order/tab_history/history_screen.dart';
import 'package:app_delivery/screen/admin_order/tab_new/tab_new_screen.dart';
import 'package:app_delivery/screen/admin_order/tab_received/tab_received_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:badges/badges.dart';

class OrderScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _OrderScreen();
  }

}

class _OrderScreen extends State<OrderScreen> {

  int tabBarCount =0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 0,
        title: Text("Danh sách hóa đơn"),
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.add),
        //     onPressed: () {
        //       print("mày có vô đây không???");
        //       // Get.to(ChooseDiscount());
        //     },
        //   ),
        // ],
      ),
      body: Container(
        color: Color(0xFFEEEEEE),
        height: 834.h,
        width: double.infinity,
        child: DefaultTabController(
          length: 3,
          child: Column(
            children: <Widget>[
              Container(
                color: Colors.white,
                constraints: BoxConstraints.expand(height: 50.h),
                child: TabBar(
                  unselectedLabelColor: Colors.black87,
                  tabs: [
                    Tab(text: "Mới"),
                    Tab(
                        icon: Badge(
                      shape: BadgeShape.square,
                      borderRadius: BorderRadius.circular(5),
                      position: BadgePosition.topEnd(),
                      padding: EdgeInsets.all(2),
                      badgeContent: Text(
                        '2',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold),
                      ),
                      child: Text('Đã nhận'),
                    )),
                    Tab(text: "Lịch sử"),
                  ],
                  indicatorColor: Colors.blue,
                  labelColor: Colors.blue,
                ),
              ),
              Expanded(
                child: Container(
                  child: TabBarView(children: [
                    TabNew(),
                    TabReceivedScreen(),
                    HistoryScreen(),
                  ]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
