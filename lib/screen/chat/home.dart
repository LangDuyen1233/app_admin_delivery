import 'dart:async';

import 'package:app_delivery/screen/widget/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

  final ScrollController listScrollController = ScrollController();

  int _limit = 20;
  int _limitIncrement = 20;
  bool isLoading = false;

  @override
  void initState() {
    getUserUID();
    super.initState();
    listScrollController.addListener(scrollListener);
  }

  void scrollListener() {
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      setState(() {
        _limit += _limitIncrement;
      });
    }
  }

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
            Positioned(
              child: isLoading ? const Loading() : Container(),
            )
          ],
        ),
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
            onPressed: () {
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
