import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:notification_screens/src/notfication-display/notification-display-screen.dart';
import 'package:notification_screens/src/notfication-display/notification-display-model.dart';
import 'firebase-messaging-receive-bloc.dart';

BuildContext currentContext;

mixin FirebaseMessagingReceiveMixin<T extends StatefulWidget> on State<T> {
  var fbMsg = FirebaseMessaging();
  FirebaseMessagingReceiveBloc get bloc =>
      FirebaseMessagingReceiveBloc.instance();

  void initState() {
    fbMsg.configure(
      onLaunch: (Map<String, dynamic> msg) {
        print("onLaunch called");
      },
      onResume: (Map<String, dynamic> msg) {
        print("onResume called");
        var notificacao = NotificationDisplayModel.fromJson(
          json.decode(msg["notificacao"]),
        );
        bloc.adicionarNotificacao(notificacao);
        // abrirNotificacao(notificacao);
      },
      onMessage: (Map<String, dynamic> msg) {
        print("onMessage called");
        //msg ---- {notification: {title: teste01, body: esse é um teste!}, data: {}}
        var notificacao = NotificationDisplayModel.fromJson(
          json.decode(msg["data"]["notificacao"]),
        );
        bloc.adicionarNotificacao(notificacao);
        print(msg);
      },
    );
    fbMsg.requestNotificationPermissions(
      const IosNotificationSettings(
        sound: true,
        alert: true,
        badge: true,
      ),
    );

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
