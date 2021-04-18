import 'dart:io';

import 'package:appsynergies/auth/register/registerProvider.dart';
import 'package:appsynergies/utils/appButtons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class RegisterView extends StatefulWidget {
  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  TextEditingController uidTextController = TextEditingController();
  TextEditingController uNameTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  TextEditingController repasswordTextController = TextEditingController();
  final GlobalKey<FormState> registerKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {

    var register = Provider.of<RegisterProvider>(context,listen: false);
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
                    height: MediaQuery.of(context).size.height / 3,

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
                    top: MediaQuery.of(context).size.height / 2.8,
                    height: MediaQuery.of(context).size.height,
                    child: Container(
                      //color: Colors.redAccent,
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(left: 20, right: 20),

                      child: Form(
                        key: registerKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Register",
                              style: TextStyle(
                                  fontSize: 40, fontWeight: FontWeight.bold,color: Color(0xff9E81BE)),
                            ),
                            SizedBox(height: 20,),
                            TextFormField(
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(25),

                              ],
                              validator: (value){
                                if(value.isEmpty){
                                  return "enter name";
                                } else {
                                  return null;
                                }
                              },
                              keyboardType: TextInputType.text,
                              controller: uNameTextController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: new EdgeInsets.symmetric(
                                    vertical: 20.0, horizontal: 10.0),
                                hintText: 'enter name',
                              ),
                            ),
                            SizedBox(height: 15),
                            TextFormField(
                              inputFormatters: [


                              ],
                              controller: uidTextController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: new EdgeInsets.symmetric(
                                    vertical: 20.0, horizontal: 10.0),
                                hintText: 'enter email',
                              ),
                              validator: (value){
                               if(value.isEmpty){
                                  return "enter email";
                                } else {
                                  return null;
                                }
                              },
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
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: new EdgeInsets.symmetric(
                                    vertical: 20.0, horizontal: 10.0),
                                hintText: 'enter password',
                              ),
                              validator: (value){
                                if(value.isEmpty){
                                  return "enter password";
                                } else {
                                  return null;
                                }
                              },
                            ),
                            SizedBox(height: 15),
                            TextFormField(
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(20),
                                FilteringTextInputFormatter.allow(
                                    RegExp("[a-zA-Z0-9]")),
                              ],
                              validator: (value){
                                if(value != passwordTextController.text){
                                  return "password not matching";
                                } else if(value.isEmpty){
                                  return "enter password";
                                } else {
                                  return null;
                                }
                              },
                              keyboardType: TextInputType.visiblePassword,
                              controller: repasswordTextController,
                              obscureText: true,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: new EdgeInsets.symmetric(
                                    vertical: 20.0, horizontal: 10.0),
                                hintText: 'Re-enter password',
                              ),

                            ),
                            SizedBox(height: 15),
                            Container(
                              child: primaryButton(
                                  btnontap: () {
                                    if(registerKey.currentState.validate()){
                                      register.registerUser(email: uidTextController.text,password: passwordTextController.text,name:uNameTextController.text,context: context );
                                    }else{
                                      registerKey.currentState.validate();
                                    }


                                  },
                                  height: 60,
                                  buttoncolor: Color(0xff9E81BE),
                                  buttontext: "Register",
                                  size: 18,
                                  color: Colors.white),
                            ),
                            SizedBox(height: 100),

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
