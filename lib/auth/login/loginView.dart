import 'dart:io';

import 'package:appsynergies/auth/register/registerProvider.dart';
import 'package:appsynergies/auth/register/registerView.dart';
import 'package:appsynergies/utils/appButtons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController uidTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  final GlobalKey<FormState> loginKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {

   // var login = Provider.of<LoginProvider>(context,listen: false);
    return Scaffold(

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
                    top: MediaQuery.of(context).size.height / 2 ,
                    height: MediaQuery.of(context).size.height,
                    child: Container(
                      //color: Colors.redAccent,
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(left: 20, right: 20),

                      child: Form(
                        key: loginKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Login",
                              style: TextStyle(
                                  fontSize: 40, fontWeight: FontWeight.bold,color: Color(0xff9E81BE)),
                            ),
                            SizedBox(height: 25),
                            TextFormField(

                              controller: uidTextController,
                              validator: (value){
                                if(value.isEmpty||value==null){
                                  return "enter email";
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: new EdgeInsets.symmetric(
                                    vertical: 20.0, horizontal: 10.0),
                                hintText: 'enter email',
                              ),
                            ),
                            SizedBox(height: 15),
                            TextFormField(
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(20),
                                FilteringTextInputFormatter.allow(
                                    RegExp("[a-zA-Z0-9]")),
                              ],
                              keyboardType: TextInputType.visiblePassword,
                              controller: passwordTextController,
                              obscureText: true,
                              validator: (value){
                                if(value.isEmpty||value==null){
                                  return "enter password";
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: new EdgeInsets.symmetric(
                                    vertical: 20.0, horizontal: 10.0),
                                hintText: 'enter password',
                              ),
                            ),
                            SizedBox(height: 15),
                            Container(
                              child: primaryButton(
                                  btnontap: () {
                                    if(loginKey.currentState.validate()){
                                    //  login.loginUser(email: uidTextController.text,password: passwordTextController.text,context: context);
                                      Provider.of<RegisterProvider>(context,listen: false).loginUser(email: uidTextController.text,password: passwordTextController.text,context: context);
                                    }else{
                                      loginKey.currentState.validate();
                                    }


                                  },
                                  height: 60,
                                  buttoncolor: Color(0xff9E81BE),
                                  buttontext: "Login",
                                  size: 18,
                                  color: Colors.white),
                            ),
                            SizedBox(height: 15),
                            Center(
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) {
                                        return RegisterView();
                                      }));
                                },
                                child: Text("register now!!"),
                              ),
                            ),
                          ],
                        ),
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
