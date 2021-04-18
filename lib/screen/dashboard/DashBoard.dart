import 'package:appsynergies/screen/dashboard/dashBoardProvider.dart';
import 'package:appsynergies/screen/startPage/startPage.dart';
import 'package:appsynergies/service/authservice.dart';
import 'package:appsynergies/utils/full_photo.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'loading.dart';

class DashBoard extends StatefulWidget {
  @override
  State createState() => DashBoardScreenState();
}

class DashBoardScreenState extends State<DashBoard> {
  String id;
  bool isLoading;
  bool isShowSticker;
  String imageUrl;

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();
  final FocusNode focusNode = FocusNode();

  _scrollListener() {
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {}
  }

  @override
  void initState() {
    super.initState();
    focusNode.addListener(onFocusChange);
    listScrollController.addListener(_scrollListener);
    isLoading = false;
    isShowSticker = false;
    imageUrl = '';
    id = FirebaseAuth.instance.currentUser.uid;
  }

  void onFocusChange() {
    if (focusNode.hasFocus) {
      // Hide sticker when keyboard appear
      setState(() {
        isShowSticker = false;
      });
    }
  }

  void getSticker() {
    // Hide keyboard when sticker appear
    focusNode.unfocus();
    setState(() {
      isShowSticker = !isShowSticker;
    });
  }

  void onSendMessage(String content, int type) async {
    // type: 0 = text, 1 = image, 2 = sticker
    final data = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get();
    if (content.trim() != '') {
      textEditingController.clear();
      FirebaseFirestore.instance.collection('chat').add(
        {
          'idFrom': FirebaseAuth.instance.currentUser.uid,
          'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
          'content': content,
          'type': type,
          'name': data.data()['name']
        },
      );
      Provider.of<DashBoardProvider>(context, listen: false).sendNotification(
          title: "Message", topic: "fcm_test", subject: content);
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
    print(document.data()['idFrom']);
    // Right (my message)
    return Row(
      children: <Widget>[
        document.data()['type'] == 0
            // Text
            ? Container(
                child: Column(
                  children: [
                Container(
                margin:
                EdgeInsets.only(left: 10, bottom: 10, top: 5),
        child: Text(
          document.data()['name'],
          style: TextStyle(fontWeight: FontWeight.bold),
        )),
                    Text(
                      document.data()['content'],
                      style: TextStyle(color: Colors.black),
                    )
                  ],
                ),
                padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                width: 200.0,
                decoration: BoxDecoration(
                    color: Color(0xff9E81BE),
                    borderRadius: BorderRadius.circular(8.0)),
                margin: EdgeInsets.only(
                    top: 5.0, bottom: 10.0, right: 10.0, left: 10.0),
                alignment: Alignment.centerLeft,
              )
            : document.data()['type'] == 1
                // Image
                ? Container(
                    decoration: BoxDecoration(
                        color: Color(0xff9E81BE),
                        borderRadius: BorderRadius.circular(8.0)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            margin:
                                EdgeInsets.only(left: 20, bottom: 10, top: 5),
                            child: Text(
                              document.data()['name'],
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                        InkWell(
                          onTap: () {
                            {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => FullPhoto(
                                          url: document.data()['content'])));
                            }
                          },
                          child: Container(
                            child: Material(
                              child: CachedNetworkImage(
                                placeholder: (context, url) => Container(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Color(0xff9E81BE)),
                                  ),
                                  width: 200.0,
                                  height: 200.0,
                                  padding: EdgeInsets.all(70.0),
                                  decoration: BoxDecoration(
                                    color: Color(0xff9E81BE),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8.0),
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Material(
                                  child: Image.asset(
                                    'assets/images/img_not_available.jpeg',
                                    width: 200.0,
                                    height: 200.0,
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                  clipBehavior: Clip.hardEdge,
                                ),
                                imageUrl: document.data()['content'],
                                width: 200.0,
                                height: 200.0,
                                fit: BoxFit.cover,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                              clipBehavior: Clip.hardEdge,
                            ),
                            padding: EdgeInsets.all(0),
                          ),
                        )
                      ],
                    ),
                    margin: EdgeInsets.only(
                        top: 5.0, bottom: 10.0, right: 10.0, left: 10.0),
                  )
                // Sticker
                : Container(
                    decoration: BoxDecoration(
                        color: Color(0xff9E81BE),
                        borderRadius: BorderRadius.circular(8.0)),
                    child: Column(
                      children: [
                    Container(
                    margin:
                    EdgeInsets.only(left: 20, bottom: 10, top: 5),
        child: Text(
          document.data()['name'],
          style: TextStyle(fontWeight: FontWeight.bold),
        )),
                        Image.asset(
                          'assets/images/${document.data()['content']}.gif',
                          width: 100.0,
                          height: 100.0,
                          fit: BoxFit.cover,
                        )
                      ],
                    ),
                    margin: EdgeInsets.only(
                        top: 5.0, bottom: 10.0, right: 10.0, left: 10.0),
                  ),
      ],
      mainAxisAlignment: document.data()['idFrom'] == id
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Group Chat"),actions: [
        IconButton(
          icon: Icon(Icons.logout),
          onPressed: () {
            AuthService().signOut();
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) =>
                StartPage()), (Route<dynamic> route) => false);
          },
        ),

        SizedBox(
          width: 20,
        )
      ],
      ),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              // List of messages
              buildListMessage(),

              // Sticker
              (isShowSticker ? buildSticker() : Container()),

              // Input content
              buildInput(),
            ],
          ),
          buildLoading()
        ],
      ),
    );
  }

  Widget buildSticker() {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              InkWell(
                onTap: () => onSendMessage('mimi1', 2),
                child: Container(
                  child: Image.asset(
                    'assets/images/mimi1.gif',
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              InkWell(
                onTap: () => onSendMessage('mimi2', 2),
                child: Container(
                  child: Image.asset(
                    'assets/images/mimi2.gif',
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              InkWell(
                onTap: () => onSendMessage('mimi3', 2),
                child: Container(
                  child: Image.asset(
                    'assets/images/mimi3.gif',
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          Row(
            children: <Widget>[
              InkWell(
                onTap: () => onSendMessage('mimi4', 2),
                child: Container(
                  child: Image.asset(
                    'assets/images/mimi4.gif',
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              InkWell(
                onTap: () => onSendMessage('mimi5', 2),
                child: Container(
                  child: Image.asset(
                    'assets/images/mimi5.gif',
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              InkWell(
                onTap: () => onSendMessage('mimi6', 2),
                child: Container(
                  child: Image.asset(
                    'assets/images/mimi6.gif',
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          Row(
            children: <Widget>[
              InkWell(
                onTap: () => onSendMessage('mimi7', 2),
                child: Container(
                  child: Image.asset(
                    'assets/images/mimi7.gif',
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              InkWell(
                onTap: () => onSendMessage('mimi8', 2),
                child: Container(
                  child: Image.asset(
                    'assets/images/mimi8.gif',
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              InkWell(
                onTap: () => onSendMessage('mimi9', 2),
                child: Container(
                  child: Image.asset(
                    'assets/images/mimi9.gif',
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          )
        ],
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      ),
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
          color: Colors.white),
      padding: EdgeInsets.all(5.0),
      height: 180.0,
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
          // Button send image
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: Icon(Icons.image),
                onPressed:
                    Provider.of<DashBoardProvider>(context, listen: false)
                        .getImage,
                color: Color(0xff9E81BE),
              ),
            ),
            color: Colors.white,
          ),
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: Icon(Icons.face),
                onPressed: getSticker,
                color: Color(0xff9E81BE),
              ),
            ),
            color: Colors.white,
          ),

          // Edit text
          Flexible(
            child: Container(
              child: TextField(
                onSubmitted: (value) {
                  onSendMessage(textEditingController.text, 0);
                },
                style: TextStyle(color: Color(0xff9E81BE), fontSize: 15.0),
                controller: textEditingController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                focusNode: focusNode,
              ),
            ),
          ),

          // Button send message
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: () => onSendMessage(textEditingController.text, 0),
                color: Color(0xff9E81BE),
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
          color: Colors.white),
    );
  }

  Widget buildListMessage() {
    return Flexible(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("chat")
            .orderBy("timestamp", descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xff9E81BE)),
              ),
            );
          } else {
            return ListView.builder(
              reverse: true,
              controller: listScrollController,
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, chatSnap) =>
                  buildItem(chatSnap, snapshot.data.docs[chatSnap]),
            );
          }
        },
      ),
    );
  }
}
