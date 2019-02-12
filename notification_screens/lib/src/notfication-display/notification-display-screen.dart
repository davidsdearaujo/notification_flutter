import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:notification_screens/src/widgets/youtube-player/youtube-player-widget.dart';
import 'package:video_player/video_player.dart';

import '../widgets/loading/loading-widget.dart';
import 'notification-display-model.dart';

class NotificationDisplayScreen extends StatefulWidget {
  final NotificationDisplayModel model;

  const NotificationDisplayScreen({Key key, @required this.model})
      : assert(model != null),
        super(key: key);
  @override
  _NotificationDisplayScreenState createState() =>
      _NotificationDisplayScreenState();
}

class _NotificationDisplayScreenState extends State<NotificationDisplayScreen> {
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
        ],
      ),
    );
  }

  Widget _buildConteudo() {
    switch (widget.model.tipo.tipo) {
      case TipoEnum.texto:
        return ListTile(title: Text(widget.model.texto));

      case TipoEnum.imagem:
        return CachedNetworkImage(
          imageUrl: widget.model.arquivo,
          errorWidget: new Icon(Icons.error),
          placeholder: AspectRatio(
            aspectRatio: 1,
            child: LoadingWidget(small: true),
          ),
        );

      case TipoEnum.video:
        return Chewie(
          playerController,
          aspectRatio: 4 / 2,
          autoPlay: true,
          looping: false,
        );

      case TipoEnum.youtube:
        return YoutubePlayerWidget(
          link: widget.model.arquivo,
          autoPlay: true,
        );
    }
  }
}
