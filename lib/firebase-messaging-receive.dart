import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

mixin FirebaseMessagingReceiveMixin<T extends StatefulWidget> on State<T> {
  var fbMsg = FirebaseMessaging();

  void initState() {
    fbMsg.configure(
      onLaunch: (Map<String, dynamic> msg) {
        print("onLaunch called");
      },
      onResume: (Map<String, dynamic> msg) {
        print("onResume called");
      },
      onMessage: (Map<String, dynamic> msg) {
        print("onMessage called");
        //msg ---- {notification: {title: teste01, body: esse é um teste!}, data: {}}
        // Scaffold.of(context).showSnackBar(
        //   SnackBar(
        //     duration: Duration(seconds: 3),
        //     content: Column(
        //       mainAxisSize: MainAxisSize.min, 
        //       children: <Widget>[Text(msg["notification"]["title"]),Text(msg["notification"]["body"]),],
        //     ),
        //   ),
        // );
      },
    );
    fbMsg.requestNotificationPermissions(const IosNotificationSettings(
      sound: true,
      alert: true,
      badge: true,
    ));
    fbMsg.onIosSettingsRegistered.listen(
      (setting) => print("IOS Setting Registered"),
    );
    fbMsg.getToken().then((token) => update(token));
    super.initState();
  }

  void update(String token) {
    print(token);
  }
}
