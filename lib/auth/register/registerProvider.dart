import 'package:appsynergies/screen/dashboard/DashBoard.dart';
import 'package:appsynergies/utils/appButtons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class RegisterProvider extends ChangeNotifier{

  Future<void> registerUser({String email,password,name,BuildContext context}) async {
    try {
      onLoading(context: context,strMessage: "Loading");
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) =>
          DashBoard()), (Route<dynamic> route) => false);
      FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser.uid).set(
          {'uid': FirebaseAuth.instance.currentUser.uid, 'email':email,'name':name});
      await FirebaseMessaging.instance.subscribeToTopic('fcm_test');
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code == 'weak-password') {
        alert(context: context,msg: 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        alert(context: context,msg: 'email-already-in-use');
      }
    } catch (e) {
      print(e);
    }
  }


  Future<void> facebookLogin({BuildContext context}) async{

    try {
      onLoading(context: context,strMessage: "Loading");
      final AccessToken result = await FacebookAuth.instance.login();
      final FacebookAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(result.token);
      await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential).whenComplete(() async{


      });

      print("-----------------login-------------------");
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) =>
          DashBoard()), (Route<dynamic> route) => false);

      FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser.uid).set(
          {'uid': FirebaseAuth.instance.currentUser.uid, 'email':FirebaseAuth.instance.currentUser.email,'name':FirebaseAuth.instance.currentUser.displayName});
      await FirebaseMessaging.instance.subscribeToTopic('fcm_test');

    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      alert(context: context,msg: e.message);
    } catch (e) {
      print(e);
    }

}

  Future<void> loginUser({String email,password,BuildContext context}) async {
    try {
      onLoading(context: context,strMessage: "Loading");
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      ).whenComplete(() async{
        if(FirebaseAuth.instance.authStateChanges().isEmpty != null) {


        }
      });
      await FirebaseMessaging.instance.subscribeToTopic('fcm_test');
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) =>
          DashBoard()), (Route<dynamic> route) => false);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      alert(context: context,msg: e.message);
    } catch (e) {
      print(e);
    }
  }


}