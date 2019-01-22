import 'package:flutter/material.dart';

import 'firebase-messaging-receive-bloc.dart';
import 'package:notification_screens/src/notfication-display/notification-display-screen.dart';
import 'package:notification_screens/src/notfication-display/notification-display-model.dart';

mixin ScaffoldNotificationMixin<T extends StatefulWidget> on State<T> {
  FirebaseMessagingReceiveBloc _bloc;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _bloc = FirebaseMessagingReceiveBloc.instance();
    _bloc.outNotificacao.listen((notificacao) {
      if (notificacao != null) {
        scaffoldKey.currentState.showSnackBar(
          SnackBar(
            duration: Duration(milliseconds: notificacao.tempoEmMs ?? 5000),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  notificacao.titulo,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  notificacao.texto,
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            action: SnackBarAction(
              label: "Visualizar",
              onPressed: () => _abrirNotificacao(notificacao),
            ),
          ),
        );
        _bloc.adicionarNotificacao(null);
      }
    });
  }

  void _abrirNotificacao(NotificationDisplayModel notificacao) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NotificationDisplayScreen(model: notificacao),
      ),
    );
  }
}
