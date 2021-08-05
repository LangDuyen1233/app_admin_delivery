//
// import 'package:app_delivery/components/filled_outline_button.dart';
// import 'package:app_delivery/models/Chat.dart';
// import 'package:app_delivery/screen/chats/chats_screen.dart';
// import 'package:app_delivery/screen/messages/message_screen.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// import '../../constants.dart';
// import 'chat_card.dart';
//
// class Body extends StatelessWidget {
//
//   final String currentUserId;
//   final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//   // final GoogleSignIn googleSignIn = GoogleSignIn();
//   final ScrollController listScrollController = ScrollController();
//
//   int _limit = 20;
//   int _limitIncrement = 20;
//   bool isLoading = false;
//
//   Body({Key key, this.currentUserId}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     // return Column(
//     //   children: [
//     //     Expanded(
//     //       child: ListView.builder(
//     //         itemCount: chatsData.length,
//     //         itemBuilder: (context, index) => ChatCard(
//     //           chat: chatsData[index],
//     //           press: () => Navigator.push(
//     //             context,
//     //             MaterialPageRoute(
//     //               builder: (context) => MessagesScreen(),
//     //             ),
//     //           ),
//     //         ),
//     //       ),
//     //     ),
//     //   ],
//     // );
//     return WillPopScope(
//       child: Stack(
//         children: <Widget>[
//           // List
//           Container(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: FirebaseFirestore.instance.collection('users').limit(_limit).snapshots(),
//               builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                 if (snapshot.hasData) {
//                   return ListView.builder(
//                     padding: EdgeInsets.all(10.0),
//                     itemBuilder: (context, index) => buildItem(context, snapshot.data?.docs[index]),
//                     itemCount: snapshot.data?.docs.length,
//                     controller: listScrollController,
//                   );
//                 } else {
//                   return Center(
//                     child: CircularProgressIndicator(
//                       valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
//                     ),
//                   );
//                 }
//               },
//             ),
//           ),
//
//           // Loading
//           Positioned(
//             child: isLoading ? const Loading() : Container(),
//           )
//         ],
//       ),
//       onWillPop: onBackPress,
//     );
//   }
//
//   Widget buildItem(BuildContext context, DocumentSnapshot document) {
//     if (document != null) {
//       UserChat userChat = UserChat.fromDocument(document);
//       if (userChat.id == currentUserId) {
//         return SizedBox.shrink();
//       } else {
//         return Container(
//           child: TextButton(
//             child: Row(
//               children: <Widget>[
//                 Material(
//                   child: userChat.photoUrl.isNotEmpty
//                       ? Image.network(
//                     userChat.photoUrl,
//                     fit: BoxFit.cover,
//                     width: 50.0,
//                     height: 50.0,
//                     loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
//                       if (loadingProgress == null) return child;
//                       return Container(
//                         width: 50,
//                         height: 50,
//                         child: Center(
//                           child: CircularProgressIndicator(
//                             color: primaryColor,
//                             value: loadingProgress.expectedTotalBytes != null &&
//                                 loadingProgress.expectedTotalBytes != null
//                                 ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
//                                 : null,
//                           ),
//                         ),
//                       );
//                     },
//                     errorBuilder: (context, object, stackTrace) {
//                       return Icon(
//                         Icons.account_circle,
//                         size: 50.0,
//                         color: greyColor,
//                       );
//                     },
//                   )
//                       : Icon(
//                     Icons.account_circle,
//                     size: 50.0,
//                     color: greyColor,
//                   ),
//                   borderRadius: BorderRadius.all(Radius.circular(25.0)),
//                   clipBehavior: Clip.hardEdge,
//                 ),
//                 Flexible(
//                   child: Container(
//                     child: Column(
//                       children: <Widget>[
//                         Container(
//                           child: Text(
//                             'Nickname: ${userChat.nickname}',
//                             maxLines: 1,
//                             style: TextStyle(color: primaryColor),
//                           ),
//                           alignment: Alignment.centerLeft,
//                           margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
//                         ),
//                         Container(
//                           child: Text(
//                             'About me: ${userChat.aboutMe}',
//                             maxLines: 1,
//                             style: TextStyle(color: primaryColor),
//                           ),
//                           alignment: Alignment.centerLeft,
//                           margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
//                         )
//                       ],
//                     ),
//                     margin: EdgeInsets.only(left: 20.0),
//                   ),
//                 ),
//               ],
//             ),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => Chat(
//                     peerId: userChat.id,
//                     peerAvatar: userChat.photoUrl,
//                   ),
//                 ),
//               );
//             },
//             style: ButtonStyle(
//               backgroundColor: MaterialStateProperty.all<Color>(greyColor2),
//               shape: MaterialStateProperty.all<OutlinedBorder>(
//                 RoundedRectangleBorder(
//                   borderRadius: BorderRadius.all(Radius.circular(10)),
//                 ),
//               ),
//             ),
//           ),
//           margin: EdgeInsets.only(bottom: 10.0, left: 5.0, right: 5.0),
//         );
//       }
//     } else {
//       return SizedBox.shrink();
//     }
//   }
// }
