import 'dart:io';

import 'package:appsynergies/auth/login/loginView.dart';
import 'package:appsynergies/auth/register/registerProvider.dart';
import 'package:appsynergies/utils/appButtons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {

  final GlobalKey<FormState> loginKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
   // var login = Provider.of<RegisterProvider>(context,listen: false);
    return Scaffold(
      key: loginKey,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: Platform.isIOS
            ? SystemUiOverlayStyle.dark
            : SystemUiOverlayStyle.light,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration( color: Color(0xff9E81BE), borderRadius: BorderRadius. only(bottomLeft: Radius. circular(30),bottomRight: Radius. circular(30)) ),
                    height: MediaQuery.of(context).size.height / 2,

                    width: MediaQuery.of(context).size.width,
                  ),
                  Positioned(
                    child: Column(

                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [Container(
                        margin: EdgeInsets.only(left: 20, top: 60),
                        child: Text(
                          "Welcome",
                          style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.bold,color: Colors.white),
                        ),
                      ),Container(
                        margin: EdgeInsets.only(left: 20, top: 5),
                        child: Text(
                          " Let's chat!",
                          style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold,color: Colors.white),
                        ),
                      )],),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height / 2.3,
                    height: MediaQuery.of(context).size.height,
                    child: Container(
                      //color: Colors.redAccent,
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(left: 20, right: 20),


                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [

                          SizedBox(height: 140,),
                          Container(
                            child: primaryButton(
                                btnontap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) {
                                        return LoginView();
                                      }));
                                },
                                height: 60,
                                buttoncolor: Color(0xff9E81BE),
                                buttontext: "login with email",
                                size: 18,
                                color: Colors.white),
                          ),
                          SizedBox(height: 15),
                          Container(
                            child: primaryButton(
                                btnontap: () {
                                  Provider.of<RegisterProvider>(context,listen: false).facebookLogin(context: context);
                                },
                                height: 60,
                                buttoncolor: Color(0xff3b5998),
                                buttontext: "facebook login",
                                size: 18,
                                color: Colors.white),
                          ),

                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
