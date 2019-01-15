import 'package:flutter/material.dart';

import 'notification-resume-model.dart';
import '../firebase-messaging-receive/scaffold-notification-mixin.dart';

class NotificationResumeScreen extends StatefulWidget {
  final NotificationResumeModel model;

  const NotificationResumeScreen({Key key, this.model}) : super(key: key);
  @override
  _NotificationResumeScreenState createState() =>
      _NotificationResumeScreenState();
}

class _NotificationResumeScreenState extends State<NotificationResumeScreen>
    with ScaffoldNotificationMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Notificação")),
      body: ListView(
        children: <Widget>[
          Text(
            widget.model.titulo,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          _buildConteudo(),
          Text("Enviado em: ${widget.model.enviadoem}"),
          Text("Enviado por: ${widget.model.enviadopor}"),
        ],
      ),
    );
  }

  Widget _buildConteudo() {
    switch (widget.model.tipo) {
      case "T":
        return Text(widget.model.texto);
      case "I":
        return Image.network(widget.model.arquivo);

      default:
        return Container();
    }
  }
}
