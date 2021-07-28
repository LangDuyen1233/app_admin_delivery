import 'package:app_delivery/controllers/bottom_navidation_controller.dart';
import 'package:app_delivery/screen/home/home_screen.dart';
import 'package:app_delivery/screen/person/person_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'admin_categories/category_product.dart';
import 'admin_order/order_screen.dart';
import 'chats/chats_screen.dart';

class MyStatefulWidgetState extends GetView<BottomNavigationController> {
  final BottomNavigationController controller =
      Get.put(BottomNavigationController());

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  // static List<Widget> _widgetOptions = <Widget>[
  //   OrderScreen(),
  //   HomProduct(),
  //   Home(),
  //   ChatsScreen(),
  //   Person(),
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => Center(
            child:
                controller.widgetOptions.elementAt(controller.tabIndex.value),
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
          currentIndex: controller.tabIndex.value,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.blueAccent,
          onTap: controller.changeTabIndex,
        ),
      ),
    );
  }
}
