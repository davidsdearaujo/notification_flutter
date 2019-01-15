import 'package:flutter/material.dart';

import '../notfication-resume/notification-resume-model.dart';
import 'firebase-messaging-receive-bloc.dart';
import '../notfication-resume/notification-resume-screen.dart';

mixin ScaffoldNotificationMixin<T extends StatefulWidget> on State<T> {
  FirebaseMessagingReceiveBloc _bloc = FirebaseMessagingReceiveBloc.instance();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _bloc.outNotificacao.listen((notificacao) {
      if (notificacao != null) {
        scaffoldKey.currentState.showSnackBar(
          SnackBar(
            duration: Duration(seconds: 5),
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

  void _abrirNotificacao(NotificationResumeModel notificacao) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NotificationResumeScreen(model: notificacao),
      ),
    );
  }
}
