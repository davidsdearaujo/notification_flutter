import 'package:flutter/material.dart';

import '../firebase-messaging-receive/scaffold-notification-mixin.dart';
import 'package:notification_screens/src/notfication-display/notification-display-screen.dart';
import 'package:notification_screens/src/send-message/send-message-screen.dart';
import 'package:notification_screens/src/notifications-list/notifications-list-screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with ScaffoldNotificationMixin {
  final String uid = "FEn2LN2KM6ZprhpeUul9ui6Ynm23";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Home"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(25),
        child: GridView(
          physics: ClampingScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 25,
            mainAxisSpacing: 25,
            childAspectRatio: 1.3,
          ),
          children: <Widget>[
            _buildButton(
              icon: Icons.add_alert,
              label: "Nova notificação",
              action: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SendMessageScreen(uid: uid),
                    ),
                  ),
            ),
            _buildButton(
              icon: Icons.content_copy,
              label: "Histórico 1",
              action: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => NotificationsListScreen(uid: uid),
                    ),
                  ),
            ),
            _buildButton(
              icon: Icons.content_copy,
              label: "Histórico Recebidos",
              action: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => NotificationsListScreen(
                            somenteRecebidos: true,
                            uid: uid,
                          ),
                    ),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(
      {@required IconData icon, @required String label, Function() action}) {
    return GestureDetector(
      onTap: action,
      child: Container(
        width: 25,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          gradient: LinearGradient(
              colors: [Theme.of(context).accentColor, Colors.black],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.5, 1]),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, color: Colors.white, size: 55),
            Text(
              label,
              style: TextStyle(color: Colors.white, fontSize: 20),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
