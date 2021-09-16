import 'package:app_delivery/controllers/bottom_navidation_controller.dart';
import 'package:app_delivery/screen/chat/home.dart';
import 'package:app_delivery/screen/home/home_screen.dart';
import 'package:app_delivery/screen/person/person_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
    PersonProfile(),
  ];
  final Rx<int> tabIndex = 2.obs;

  void changeTabIndex(int index) {
    tabIndex.value = index;
  }

  @override
  void initState() {
    getUserUID();
    registerNotification();
    configLocalNotification();
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

  void registerNotification() {
    firebaseMessaging.requestPermission();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('onMessage: $message');
      if (message.notification != null) {
        showNotification(message.notification);
      }
      return;
    });

    firebaseMessaging.getToken().then((token) {
      print('token: $token');
      FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .update({'pushToken': token});
    }).catchError((err) {
      Fluttertoast.showToast(msg: err.message.toString());
    });
  }

  void configLocalNotification() {
    AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings();
    InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void showNotification(RemoteNotification remoteNotification) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'com.nlu.app_delivery',
      // Platform.isAndroid ? 'com.nlu.app_delivery' : 'com.nlu.app_delivery',
      'Chat',
      'Description',
      playSound: true,
      enableVibration: true,
      importance: Importance.max,
      priority: Priority.high,
    );
    IOSNotificationDetails iOSPlatformChannelSpecifics =
        IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    print('remoteNotification: $remoteNotification');

    await flutterLocalNotificationsPlugin.show(
      0,
      // remoteNotification.title,
      // remoteNotification.body,
      'title',
      'body',
      platformChannelSpecifics,
      payload: null,
    );
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
