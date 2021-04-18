import 'package:appsynergies/screen/dashboard/DashBoard.dart';
import 'package:appsynergies/screen/startPage/startPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthService extends ChangeNotifier {
  AuthService();
  handleAuth() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context,spanshot){
        if(spanshot.hasData){
          return DashBoard();
        } else {
          return StartPage();
        }

      }
      );
  }

  signOut() {
    FirebaseAuth.instance.signOut();
    notifyListeners();
  }





}