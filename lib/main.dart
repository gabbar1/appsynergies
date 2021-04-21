import 'dart:convert';
import 'package:appsynergies/auth/register/registerProvider.dart';
import 'package:appsynergies/screen/dashboard/DashBoard.dart';
import 'package:appsynergies/screen/dashboard/dashBoardProvider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:splashscreen/splashscreen.dart';

import 'service/authservice.dart';


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

/// Create a [AndroidNotificationChannel] for heads up notifications
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
);

/// Initialize the [FlutterLocalNotificationsPlugin] package.
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  runApp(
    MultiProvider(providers:[

      ChangeNotifierProvider<RegisterProvider>(create: (_) => RegisterProvider()),
      ChangeNotifierProvider<DashBoardProvider>(create: (_) => DashBoardProvider()),

    ],
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
//GoogleFonts.barlowCondensed(
//           textStyle: Theme.of(context).textTheme.headline5
            theme: ThemeData(primaryColor: Color(0xff9E81BE),
                accentColor:  Color(0xff9E81BE)),
            home: MyApp()
        )
    ),
  );
}

String constructFCMPayload(String token) {

  return jsonEncode({
    'token': token,
    'data': {
      'via': 'FlutterFire Cloud Messaging!!!',
      'count': "1",
    },
    'notification': {
      'title': 'Hello FlutterFire!',
      'body': 'This notification  was created via FCM!',
    },
  });
}
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {


  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      if (message != null) {
        Navigator.pushNamed(context, '/message',
            arguments: DashBoard());
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("--------------listen");
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                // TODO add a proper drawable resource to android, for now using
                //      one that already exists in example app.
                icon: 'launch_background',
              ),
            ));
      } else{
       print( android.channelId);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      Navigator.pushNamed(context, '/message',
          arguments: DashBoard());
    });



  }


  @override
  Widget build(BuildContext context) {

    return new SplashScreen(seconds: 1,
      navigateAfterSeconds:  AuthService().handleAuth(),
      title: new Text("Let's chat",
        style:TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.white),
      ),

      //  backgroundGradient: new LinearGradient(colors: [Colors.cyan, Colors.blue], begin: Alignment.topLeft, end: Alignment.bottomRight),
      backgroundColor: Color(0xff9E81BE),
      styleTextUnderTheLoader: new TextStyle(),
      photoSize: 100.0,
      onClick: ()=>print("Flutter Egypt"),
      loaderColor: Colors.red,
    );
  }
}
//TextStyle(fontSize: 15,fontWeight: FontWeight.bold)
