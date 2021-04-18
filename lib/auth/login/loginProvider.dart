import 'package:appsynergies/screen/dashboard/DashBoard.dart';
import 'package:appsynergies/utils/appButtons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class LoginProvider extends ChangeNotifier{

  Future<void> loginUser({String email,password,BuildContext context}) async {
    try {
      onLoading(context: context,strMessage: "Loading");
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      ).whenComplete(() async{
        if(FirebaseAuth.instance.authStateChanges().isEmpty != null) {
          await FirebaseMessaging.instance.subscribeToTopic('fcm_test');
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) =>
              DashBoard()), (Route<dynamic> route) => false);

        }
      });

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }


}