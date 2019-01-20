import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
// import 'package:shimmer/shimmer.dart';

import '../widgets/loading/loading-widget.dart';
import 'notification-display-model.dart';
import '../firebase-messaging-receive/scaffold-notification-mixin.dart';

class NotificationDisplayScreen extends StatefulWidget {
  final NotificationDisplayModel model;

  const NotificationDisplayScreen({Key key, this.model}) : super(key: key);
  @override
  _NotificationDisplayScreenState createState() =>
      _NotificationDisplayScreenState();
}

class _NotificationDisplayScreenState extends State<NotificationDisplayScreen>
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
        return Stack(
          children: <Widget>[
            AspectRatio(
              aspectRatio: 1,
              child: LoadingWidget(small: false),
              
              // Shimmer.fromColors(
              //   baseColor: Colors.grey[300],
              //   highlightColor: Colors.grey[250],
              //   child: Image.network(widget.model.arquivo),
              // ),
            ),
            Image.network(widget.model.arquivo),
          ],
        );

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