import 'package:app_delivery/screen/admin_categories/category_product.dart';
import 'package:app_delivery/screen/admin_order/order_screen.dart';
import 'package:app_delivery/screen/chats/chats_screen.dart';
import 'package:app_delivery/screen/home/home_screen.dart';
import 'package:app_delivery/screen/person/person_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomNavigationController extends GetxController {
  final Rx<int> tabIndex = 2.obs;

  List<Widget> widgetOptions = <Widget>[
    OrderScreen(),
    HomProduct(),
    Home(),
    ChatsScreen(),
    Person(),
  ];

  void changeTabIndex(int index) {
    tabIndex.value = index;
  }
}
