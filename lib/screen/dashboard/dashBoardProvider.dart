import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
class DashBoardProvider extends ChangeNotifier{
  PickedFile pickedFile;
  File imageFile;
  Future<void> sendNotification({subject, title, topic}) async {

    String toParams = "/topics/" + topic;

    final data = {
      "notification": {"body": subject, "title": title},
      "priority": "high",
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "id": "1",
        "status": "done",
        "sound": 'default',
        "screen": "yourTopicName",
      },
      "to": "${toParams}"
    };

    final headers = {
      'content-type': 'application/json',
      'Authorization':
      'key=AAAAO51_mjo:APA91bFycmVepScFfwpQXzMZcWJ5oK_9ozP_eKH_pet-6NtUT8j4cURxTazTwGhqg5gKE7nIkjw39gDmisuwSGmjC-QYY_nWDgn-csd5UulArSfrHMLFRE9ML3Vna2Zm5vWcDdu61DYD'
    };

    final response = await http.post(Uri.https("fcm.googleapis.com", "fcm/send"),
        body: json.encode(data),
        encoding: Encoding.getByName('utf-8'),
        headers: headers);

    if (response.statusCode == 200) {
// on success do
      print("true");
    } else {
// on failure do
      print("false");
    }
  }

  Future getImage() async {
    ImagePicker imagePicker = ImagePicker();
    pickedFile = await imagePicker.getImage(source: ImageSource.gallery,imageQuality: 10);

    imageFile = File(pickedFile.path);
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    print("------------------------------00");
    print(pickedFile.path);
    try {
      final data = await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser.uid)
          .get();
      await firebase_storage.FirebaseStorage.instance.ref(fileName).putFile(File(pickedFile.path)).whenComplete(() async{
        String downloadURL = await firebase_storage.FirebaseStorage.instance.ref(fileName).getDownloadURL();
        FirebaseFirestore.instance.collection('chat').add(
          {
            'idFrom': FirebaseAuth.instance.currentUser.uid,
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'content': downloadURL,
            'type': 1,
            'name': data.data()['name']
          },
        );

        sendNotification(title: "Message",topic: "fcm_test",subject: "You received image");

      });
    } on FirebaseException {
      // e.g, e.code == 'canceled'
    }
  }
}