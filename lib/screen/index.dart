import 'package:app_delivery/screen/chat/home.dart';
import 'package:app_delivery/screen/home/home_screen.dart';
import 'package:app_delivery/screen/person/person_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'admin_categories/category_product.dart';
import 'admin_order/order_screen.dart';

class MyStatefulWidgetState extends StatefulWidget {
  final int selectedIndex;

  const MyStatefulWidgetState({@required this.selectedIndex});

  @override
  State<StatefulWidget> createState() {
    return _MyStatefulWidgetState(selectedIndex: selectedIndex);
  }
}

class _MyStatefulWidgetState extends State<MyStatefulWidgetState> {
  int selectedIndex;

  List<Widget> _widgetOptions = <Widget>[
    OrderScreen(),
    HomProduct(),
    Home(),
    HomeScreen(),
    PersonProfile(),
  ];
  // final Rx<int> tabIndex = 2.obs;

  _MyStatefulWidgetState({@required this.selectedIndex});

  void changeTabIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  void initState() {
    getUserUID();
    super.initState();
  }

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  User user;
  String currentUserId;

  Future<void> getUserUID() async {
    user = await FirebaseAuth.instance.currentUser;
    currentUserId = user.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Center(
        child: _widgetOptions.elementAt(selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
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
            label: 'Trang chủ',
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
        currentIndex: selectedIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blueAccent,
        onTap: changeTabIndex,
      ),
    );
  }
}
