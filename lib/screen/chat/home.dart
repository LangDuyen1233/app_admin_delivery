import 'dart:async';

import 'package:app_delivery/screen/widget/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'chat.dart';
import 'const.dart';
import 'model/user_chat.dart';

class HomeScreen extends StatefulWidget {
  @override
  State createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User user;

  Future<void> getUserUID() async {
    user = await FirebaseAuth.instance.currentUser;
    currentUserId = user.uid;
  }

  String currentUserId;

  // _HomeScreenState({@required this.currentUserId});

  // final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();
  final ScrollController listScrollController = ScrollController();

  int _limit = 20;
  int _limitIncrement = 20;
  bool isLoading = false;

  @override
  void initState() {
    getUserUID();
    super.initState();
    // registerNotification();
    // configLocalNotification();
    listScrollController.addListener(scrollListener);
    // showNotification();
  }

  // void registerNotification() {
  //   firebaseMessaging.requestPermission();
  //
  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     print('onMessage: $message');
  //     if (message.notification != null) {
  //       // showNotification(message.notification);
  //     }
  //     return;
  //   });
  //
  //   firebaseMessaging.getToken().then((token) {
  //     print('token: $token');
  //     FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(currentUserId)
  //         .update({'pushToken': token});
  //   }).catchError((err) {
  //     Fluttertoast.showToast(msg: err.message.toString());
  //   });
  // }

  // void configLocalNotification() {
  //   AndroidInitializationSettings initializationSettingsAndroid =
  //       AndroidInitializationSettings('app_icon');
  //   IOSInitializationSettings initializationSettingsIOS =
  //       IOSInitializationSettings();
  //   InitializationSettings initializationSettings = InitializationSettings(
  //       android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  //   flutterLocalNotificationsPlugin.initialize(initializationSettings);
  // }

  void scrollListener() {
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      setState(() {
        _limit += _limitIncrement;
      });
    }
  }

  // void showNotification(
  //     RemoteNotification remoteNotification
  //     ) async {
  //   AndroidNotificationDetails androidPlatformChannelSpecifics =
  //       AndroidNotificationDetails(
  //     'com.nlu.app_delivery',
  //     // Platform.isAndroid ? 'com.nlu.app_delivery' : 'com.nlu.app_delivery',
  //     'Chat',
  //     'Description',
  //     playSound: true,
  //     enableVibration: true,
  //     importance: Importance.max,
  //     priority: Priority.high,
  //   );
  //   IOSNotificationDetails iOSPlatformChannelSpecifics =
  //       IOSNotificationDetails();
  //   NotificationDetails platformChannelSpecifics = NotificationDetails(
  //       android: androidPlatformChannelSpecifics,
  //       iOS: iOSPlatformChannelSpecifics);
  //
  //   print('remoteNotification: $remoteNotification');
  //
  //   await flutterLocalNotificationsPlugin.show(
  //     0,
  //     // remoteNotification.title,
  //     // remoteNotification.body,
  //     'title',
  //     'body',
  //     platformChannelSpecifics,
  //     payload: null,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Tin nhắn',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: WillPopScope(
        onWillPop: () {},
        child: Stack(
          children: <Widget>[
            Container(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .limit(_limit)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      padding: EdgeInsets.all(8.0),
                      itemBuilder: (context, index) =>
                          buildItem(context, snapshot.data?.docs[index]),
                      itemCount: snapshot.data.docs.length,
                      controller: listScrollController,
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                      ),
                    );
                  }
                },
              ),
            ),

            // Loading
            Positioned(
              child: isLoading ? const Loading() : Container(),
            )
          ],
        ),
        // onWillPop: onBackPress,
      ),
    );
  }

  Widget buildItem(BuildContext context, DocumentSnapshot document) {
    if (document != null) {
      UserChat userChat = UserChat.fromDocument(document);
      if (userChat.id == currentUserId) {
        return SizedBox.shrink();
      } else {
        return Container(
          child: TextButton(
            child: Row(
              children: <Widget>[
                Material(
                  child: userChat.photoUrl != null
                      ? Image.network(
                          userChat.photoUrl,
                          fit: BoxFit.cover,
                          width: 50.0,
                          height: 50.0,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              width: 50,
                              height: 50,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: primaryColor,
                                  value: loadingProgress.expectedTotalBytes !=
                                              null &&
                                          loadingProgress.expectedTotalBytes !=
                                              null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes
                                      : null,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, object, stackTrace) {
                            return Icon(
                              Icons.account_circle,
                              size: 50.0,
                              color: greyColor,
                            );
                          },
                        )
                      : Icon(
                          Icons.account_circle,
                          size: 50.0,
                          color: greyColor,
                        ),
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  clipBehavior: Clip.hardEdge,
                ),
                Flexible(
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Text(
                            '${userChat.nickname}',
                            maxLines: 1,
                            style: TextStyle(color: primaryColor),
                          ),
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                        ),
                      ],
                    ),
                    margin: EdgeInsets.only(left: 10.0),
                  ),
                ),
              ],
            ),
            onPressed: ()  {
              print('userChat: ${userChat.toString()} ');
              // SharedPreferences prefs =
              // await SharedPreferences
              //     .getInstance();
              // await prefs.setString(
              //     'id', userChat.id);
              // await prefs.setString(
              //     'nickname',
              //     userChat.nickname);
              // await prefs.setString(
              //     'photoUrl',
              //     userChat.photoUrl ??
              //         "");
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Chat(
                    peerId: userChat.id,
                    peerNickname: userChat.nickname,
                    peerAvatar: userChat.photoUrl,
                  ),
                ),
              );
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(greyColor2),
              shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
          ),
          margin: EdgeInsets.only(bottom: 10.0, left: 5.0, right: 5.0),
        );
      }
    } else {
      return SizedBox.shrink();
    }
  }
}

class Choice {
  const Choice({@required this.title, @required this.icon});

  final String title;
  final IconData icon;
}
