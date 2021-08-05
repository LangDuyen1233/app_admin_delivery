import 'package:app_delivery/controllers/bottom_navidation_controller.dart';
import 'package:app_delivery/screen/chat/home.dart';
import 'package:app_delivery/screen/home/home_screen.dart';
import 'package:app_delivery/screen/person/person_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'admin_categories/category_product.dart';
import 'admin_order/order_screen.dart';

class MyStatefulWidgetState extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyStatefulWidgetState();
  }
}

class _MyStatefulWidgetState extends State<MyStatefulWidgetState> {


  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  List<Widget> _widgetOptions = <Widget>[

    OrderScreen(),
    HomProduct(),
    Home(),
    HomeScreen(),
    Person(),
  ];
  final Rx<int> tabIndex = 2.obs;

  void changeTabIndex(int index) {
    tabIndex.value = index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => Center(
            child: _widgetOptions.elementAt(tabIndex.value),
          )),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.article),
              label: 'Đơn hàng',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.apps),
              label: 'Sản phẩm',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.message),
              label: 'Tin nhắn',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Tôi',
            ),
          ],
          currentIndex: tabIndex.value,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.blueAccent,
          onTap: changeTabIndex,
        ),
      ),
    );
  }
}
