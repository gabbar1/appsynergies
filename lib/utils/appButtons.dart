import 'dart:ui';
import 'package:flutter/material.dart';

Widget primaryButton(
    {String buttontext,
      Color color,
      double size,
      double height,
      double width,
      Color buttoncolor,
      Function btnontap,
      TextAlign textAlign,
      FontWeight style,
      EdgeInsets padding}) {
  return Container(
      child: GestureDetector(
        onTap: () async {
          btnontap();
        },
        child: Container(
          padding: padding,
          height: height,
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: buttoncolor,
          ),
          child: Center(
            child: Text(
              buttontext,
              textAlign: textAlign,
              style: TextStyle(
                fontSize: size,
                color: color,
                fontWeight: style,
              ),
            ),
          ),
        ),
      ));
}

text(
    {String text,
      double fontsize,
      Color color,
      FontWeight style,
      TextOverflow overflow,
      TextAlign textAlign}) {
  return Text(
    text,
    textAlign: textAlign,
    overflow: overflow,
    style: TextStyle(
        color: color,
        fontSize: fontsize,
        fontWeight: style,
        fontFamily: 'Poppins'),
  );
}

void onLoading(
    {
      BuildContext
      context
      ,String strMessage}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        // shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.all(Radius.circular(15))),
        content: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                // alignment: Alignment.center,
                //height: 100,
                //padding: EdgeInsets.only(left: 20, right: 20),
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                ),
                // margin: EdgeInsets.only(bottom: 20),
              ),
              (strMessage != null)
                  ? Flexible(
                child: Text(
                  "",
                  //strMessage,
                  // maxLines: 2,
                  style: new TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                flex: 1,
              )
                  : Container(),
            ],
          ),
        ),
      );
    },
  );
}


void alert({BuildContext context,String msg}){

  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: new Text(
          "OneDay",
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        content:
        Text(msg, style: TextStyle(fontWeight: FontWeight.w500)),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          new FlatButton(
            child: new Text(
              "Ok",
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}