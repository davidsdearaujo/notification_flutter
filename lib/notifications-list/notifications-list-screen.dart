import 'package:flutter/material.dart';
import '../firebase-messaging-receive/scaffold-notification-mixin.dart';

class NotificationsListScreen extends StatefulWidget {
  @override
  _NotificationsListScreenState createState() => _NotificationsListScreenState();
}

class _NotificationsListScreenState extends State<NotificationsListScreen> 
    with ScaffoldNotificationMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(title: Text("Histórico de notificações")),
    );
  }
}