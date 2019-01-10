import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../helpers/image-picker-helper.dart';
import 'send-message-bloc.dart';
import '../dropdown/dropdown-widget.dart';
import '../google-sign-in-mixin.dart';
import '../firebase-messaging-receive.dart';

class SendMessageScreen extends StatefulWidget {
  @override
  _SendMessageScreenState createState() => _SendMessageScreenState();
}

class _SendMessageScreenState extends State<SendMessageScreen> 
with GoogleSignInMixin, FirebaseMessagingReceiveMixin {
  
  SendMessageBloc bloc = SendMessageBloc()..getGroups();
  var conteudoController = TextEditingController();
  var tituloController = TextEditingController();
  ImagePickerHelper helper;

  @override
  void initState() {
    super.initState();
    helper = ImagePickerHelper();
  }

  @override
  void dispose() {
    bloc.dispose();
    conteudoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Message Sender")),
      body: ListView(
        padding: EdgeInsets.all(15),
        children: <Widget>[
          DropdownWidget(
            listStream: bloc.outListGroups,
            selectedStream: bloc.outSelectedGroup,
            setSelected: bloc.setGroup,
            label: "Grupos",
          ),
          DropdownWidget(
            listStream: bloc.outListTypes,
            selectedStream: bloc.outSelectedType,
            setSelected: bloc.setType,
            label: "Tipo de Mensagem",
          ),
          SizedBox(height: 25),
          TextField(
            controller: tituloController,
            maxLength: 100,
            maxLines: null,
            decoration: InputDecoration(labelText: "Título"),
            keyboardType: TextInputType.multiline,
          ),
          TextField(
            controller: conteudoController,
            maxLength: 100,
            maxLines: null,
            decoration: InputDecoration(labelText: "Descrição"),
            keyboardType: TextInputType.multiline,
          ),
          SizedBox(height: 25),
          _buildContentWidget(),
        ],
      ),
    );
  }

  Widget _buildContentWidget() {
    return StreamBuilder<String>(
      stream: bloc.outSelectedType,
      builder: (context, selectedType) {
        switch (selectedType.data) {
          case "Imagem":
            return _buildImageContent();
            break;
          case "Vídeo":
            return _buildVideoContent();
            break;
          case "Texto":
          default:
            return Container();
            break;
        }
      },
    );
  }

  Widget _buildImageContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        StreamBuilder<File>(
          stream: bloc.outSelectedImage,
          builder: (context, snapshot) {
            return Container(
              height: 394,
              child: Stack(
                children: <Widget>[
                  Container(
                    child: (snapshot.hasData)
                        ? Image.file(snapshot.data, fit: BoxFit.cover)
                        : null
                  ),
                  Container(color: Color.fromRGBO(0, 0, 0, 490)),
                  InkWell(
                    onTap: () => helper.showImage(context, bloc.setSelectedImage),
                    child: Center(
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.white.withOpacity(0.7),
                        size: 45,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildVideoContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        StreamBuilder<File>(
          stream: bloc.outSelectedVideo,
          builder: (context, video) {
            return Padding(
              padding: EdgeInsets.only(bottom: 15),
              child: Text(video.data?.path ?? "Nenhum vídeo selecionado"));
          },
        ),
        Container(
          height: 60,
          child: RaisedButton(
            color: Theme.of(context).accentColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            onPressed: () => helper.showVideo(context, bloc.setSelectedVideo),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.movie_creation, color: Colors.white),
                SizedBox(width: 15),
                Text(
                  "Selecionar Vídeo",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
