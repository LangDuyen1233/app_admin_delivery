import 'dart:async';
import 'dart:io';

import 'package:app_delivery/screen/chat/widget/full_photo.dart';
import 'package:app_delivery/screen/widget/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'const.dart';

class Chat extends StatefulWidget {
  final String peerId;
  final String peerNickname;
  final String peerAvatar;

  Chat(
      {Key key,
      @required this.peerId,
      @required this.peerNickname,
      @required this.peerAvatar})
      : super(key: key);

  @override
  State createState() => ChatScreenState(
      peerId: peerId, peerNickname: peerNickname, peerAvatar: peerAvatar);
}

class ChatScreenState extends State<Chat> {
  final String peerId;
  final String peerNickname;
  final String peerAvatar;

  ChatScreenState(
      {Key key,
      @required this.peerId,
      @required this.peerNickname,
      @required this.peerAvatar});

  String id;

  List<QueryDocumentSnapshot> listMessage = new List.from([]);
  int _limit = 20;
  int _limitIncrement = 20;
  String groupChatId = "";
  SharedPreferences prefs;

  File imageFile;
  bool isLoading = false;
  bool isShowSticker = false;
  String imageUrl = "";

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();
  final FocusNode focusNode = FocusNode();

  _scrollListener() {
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      setState(() {
        _limit += _limitIncrement;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    focusNode.addListener(onFocusChange);
    listScrollController.addListener(_scrollListener);
    readLocal();
  }

  void onFocusChange() {
    if (focusNode.hasFocus) {
      setState(() {
        isShowSticker = false;
      });
    }
  }

  readLocal() async {
    prefs = await SharedPreferences.getInstance();
    id = prefs?.getString('id');
    if (id.hashCode <= peerId.hashCode) {
      groupChatId = '$id-$peerId';
    } else {
      groupChatId = '$peerId-$id';
    }
    FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .update({'chattingWith': peerId});

    setState(() {});
  }

  Future getImage() async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile pickedFile;

    pickedFile = await imagePicker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      if (imageFile != null) {
        setState(() {
          isLoading = true;
        });
        uploadFile();
      }
    }
  }

  void getSticker() {
    focusNode.unfocus();
    setState(() {
      isShowSticker = !isShowSticker;
    });
  }

  Future uploadFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = reference.putFile(imageFile);

    try {
      TaskSnapshot snapshot = await uploadTask;
      imageUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        isLoading = false;
        onSendMessage(imageUrl, 1);
      });
    } on FirebaseException catch (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: e.message ?? e.toString());
    }
  }

  void onSendMessage(String content, int type) {
    if (content.trim() != '') {
      textEditingController.clear();

      var documentReference = FirebaseFirestore.instance
          .collection('messages')
          .doc(groupChatId)
          .collection(groupChatId)
          .doc(DateTime.now().millisecondsSinceEpoch.toString());

      FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(
          documentReference,
          {
            'idFrom': id,
            'idTo': peerId,
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'content': content,
            'type': type
          },
        );
      });
      listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      Fluttertoast.showToast(
          msg: 'Nothing to send',
          backgroundColor: Colors.black,
          textColor: Colors.red);
    }
  }

  Widget buildItem(int index, DocumentSnapshot document) {
    if (document != null) {
      if (document.get('idFrom') == id) {
        return Row(
          children: <Widget>[
            document.get('type') == 0
                ? Container(
                    child: Text(
                      document.get('content'),
                      style: TextStyle(color: primaryColor),
                    ),
                    padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                    width: 200.0,
                    decoration: BoxDecoration(
                        color: greyColor2,
                        borderRadius: BorderRadius.circular(8.0)),
                    margin: EdgeInsets.only(
                        bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                        right: 10.0),
                  )
                : document.get('type') == 1
                    ? Container(
                        child: OutlinedButton(
                          child: Material(
                            child: Image.network(
                              document.get("content"),
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  decoration: BoxDecoration(
                                    color: greyColor2,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8.0),
                                    ),
                                  ),
                                  width: 200.0,
                                  height: 200.0,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: primaryColor,
                                      value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null &&
                                              loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                          ? loadingProgress
                                                  .cumulativeBytesLoaded /
                                              loadingProgress.expectedTotalBytes
                                          : null,
                                    ),
                                  ),
                                );
                              },
                              errorBuilder: (context, object, stackTrace) {
                                return Material(
                                  child: Image.asset(
                                    'images/img_not_available.jpeg',
                                    width: 200.0,
                                    height: 200.0,
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                  clipBehavior: Clip.hardEdge,
                                );
                              },
                              width: 200.0,
                              height: 200.0,
                              fit: BoxFit.cover,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                            clipBehavior: Clip.hardEdge,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FullPhoto(
                                  url: document.get('content'),
                                ),
                              ),
                            );
                          },
                          style: ButtonStyle(
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                  EdgeInsets.all(0))),
                        ),
                        margin: EdgeInsets.only(
                            bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                            right: 10.0),
                      )
                    : Container(
                        child: Image.asset(
                          'images/${document.get('content')}.gif',
                          width: 100.0,
                          height: 100.0,
                          fit: BoxFit.cover,
                        ),
                        margin: EdgeInsets.only(
                            bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                            right: 10.0),
                      ),
          ],
          mainAxisAlignment: MainAxisAlignment.end,
        );
      } else {
        return Container(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  isLastMessageLeft(index)
                      ? Material(
                          child: peerAvatar != null
                              ? Image.network(
                                  peerAvatar,
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        color: primaryColor,
                                        value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null &&
                                                loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes
                                            : null,
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, object, stackTrace) {
                                    return Icon(
                                      Icons.account_circle,
                                      size: 35,
                                      color: greyColor,
                                    );
                                  },
                                  width: 35,
                                  height: 35,
                                  fit: BoxFit.cover,
                                )
                              : Icon(
                                  Icons.account_circle,
                                  size: 50.0,
                                  color: greyColor,
                                ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(18.0),
                          ),
                          clipBehavior: Clip.hardEdge,
                        )
                      : Container(width: 35.0),
                  document.get('type') == 0
                      ? Container(
                          child: Text(
                            document.get('content'),
                            style: TextStyle(color: Colors.white),
                          ),
                          padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                          width: 200.0,
                          decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(8.0)),
                          margin: EdgeInsets.only(left: 10.0),
                        )
                      : document.get('type') == 1
                          ? Container(
                              child: TextButton(
                                child: Material(
                                  child: Image.network(
                                    document.get('content'),
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Container(
                                        decoration: BoxDecoration(
                                          color: greyColor2,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8.0),
                                          ),
                                        ),
                                        width: 200.0,
                                        height: 200.0,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            color: primaryColor,
                                            value: loadingProgress
                                                            .expectedTotalBytes !=
                                                        null &&
                                                    loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes
                                                : null,
                                          ),
                                        ),
                                      );
                                    },
                                    errorBuilder:
                                        (context, object, stackTrace) =>
                                            Material(
                                      child: Image.asset(
                                        'images/img_not_available.jpeg',
                                        width: 200.0,
                                        height: 200.0,
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8.0),
                                      ),
                                      clipBehavior: Clip.hardEdge,
                                    ),
                                    width: 200.0,
                                    height: 200.0,
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                  clipBehavior: Clip.hardEdge,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => FullPhoto(
                                              url: document.get('content'))));
                                },
                                style: ButtonStyle(
                                    padding:
                                        MaterialStateProperty.all<EdgeInsets>(
                                            EdgeInsets.all(0))),
                              ),
                              margin: EdgeInsets.only(left: 10.0),
                            )
                          : Container(
                              child: Image.asset(
                                'images/${document.get('content')}.gif',
                                width: 100.0,
                                height: 100.0,
                                fit: BoxFit.cover,
                              ),
                              margin: EdgeInsets.only(
                                  bottom:
                                      isLastMessageRight(index) ? 20.0 : 10.0,
                                  right: 10.0),
                            ),
                ],
              ),

              isLastMessageLeft(index)
                  ? Container(
                      child: Text(
                        DateFormat('dd MMM kk:mm').format(
                            DateTime.fromMillisecondsSinceEpoch(
                                int.parse(document.get('timestamp')))),
                        style: TextStyle(
                            color: greyColor,
                            fontSize: 12.0,
                            fontStyle: FontStyle.italic),
                      ),
                      margin:
                          EdgeInsets.only(left: 50.0, top: 5.0, bottom: 5.0),
                    )
                  : Container()
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
          margin: EdgeInsets.only(bottom: 10.0),
        );
      }
    } else {
      return SizedBox.shrink();
    }
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 && listMessage[index - 1].get('idFrom') == id) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 && listMessage[index - 1].get('idFrom') != id) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> onBackPress() {
    if (isShowSticker) {
      setState(() {
        isShowSticker = false;
      });
    } else {
      FirebaseFirestore.instance
          .collection('users')
          .doc(id)
          .update({'chattingWith': null});
      Navigator.pop(context);
    }

    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${peerNickname}',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: WillPopScope(
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                buildListMessage(),
                buildInput(),
              ],
            ),

            buildLoading()
          ],
        ),
        onWillPop: onBackPress,
      ),
    );
  }

  Widget buildLoading() {
    return Positioned(
      child: isLoading ? const Loading() : Container(),
    );
  }

  Widget buildInput() {
    return Container(
      child: Row(
        children: <Widget>[
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: Icon(Icons.image),
                onPressed: getImage,
                color: primaryColor,
              ),
            ),
            color: Colors.white,
          ),

          Flexible(
            child: Container(
              child: TextField(
                onSubmitted: (value) {
                  onSendMessage(textEditingController.text, 0);
                },
                style: TextStyle(color: primaryColor, fontSize: 15.0),
                controller: textEditingController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(color: greyColor),
                ),
                focusNode: focusNode,
              ),
            ),
          ),

          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: () => onSendMessage(textEditingController.text, 0),
                color: primaryColor,
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: greyColor2, width: 0.5)),
          color: Colors.white),
    );
  }

  Widget buildListMessage() {
    return Flexible(
      child: groupChatId.isNotEmpty
          ? StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .doc(groupChatId)
                  .collection(groupChatId)
                  .orderBy('timestamp', descending: true)
                  .limit(_limit)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  listMessage.addAll(snapshot.data.docs);
                  return ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemBuilder: (context, index) =>
                        buildItem(index, snapshot.data?.docs[index]),
                    itemCount: snapshot.data?.docs.length,
                    reverse: true,
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
            )
          : Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
              ),
            ),
    );
  }
}
