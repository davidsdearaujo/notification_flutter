import 'package:custom_chewie/custom_chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

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
  VideoPlayerController playerController;
  @override
  void initState() {
    super.initState();
    playerController = VideoPlayerController.network(widget.model.arquivo);
  }

  @override
  void dispose() {
    playerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Notificação")),
      body: ListView(
        padding: EdgeInsets.all(15),
        children: <Widget>[
          ListTile(
            title: Text(
              widget.model.titulo,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          _buildConteudo(),
          Padding(
            padding: EdgeInsets.only(top: 10, right: 5),
            child: Text(
              "~${widget.model.enviadopor}  ${widget.model.enviadoem}",
              textAlign: TextAlign.end,
              style: TextStyle(color: Colors.black45),
            ),
          ),
          widget.model.enviadopara == null || widget.model.enviadopara.isEmpty
              ? Container()
              : ListTile(
                  title: Text("Enviado para: ${widget.model.enviadopara}"),
                ),
          // ListTile(title: Text("Identificador: ${widget.model.id}")),
        ],
      ),
    );
  }

  Widget _buildConteudo() {
    switch (widget.model.tipo.tipo) {
      case TipoEnum.texto:
        return ListTile(title: Text(widget.model.texto));
      case TipoEnum.imagem:
        return Image.network(widget.model.arquivo);
      case TipoEnum.video:
        return Chewie(
          playerController,
          aspectRatio: 4 / 2,
          autoPlay: true,
          looping: true,
        );

      default:
        return Container();
    }
  }
}
