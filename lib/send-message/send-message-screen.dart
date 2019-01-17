import 'dart:io';

import 'package:flutter/material.dart';
import 'package:custom_chewie/custom_chewie.dart';
import 'package:video_player/video_player.dart';

import 'send-message-model.dart';
import 'send-message-bloc.dart';
import 'send-message-service.dart';

import '../helpers/date-time-helper.dart';
import '../helpers/image-picker-helper.dart';
import '../dropdown/dropdown-widget.dart';
import '../firebase-messaging-receive/scaffold-notification-mixin.dart';

class SendMessageScreen extends StatefulWidget {
  @override
  _SendMessageScreenState createState() => _SendMessageScreenState();
}

class _SendMessageScreenState extends State<SendMessageScreen>
    with ScaffoldNotificationMixin {
  SendMessageBloc bloc;
  ImagePickerHelper helper;

  var conteudoController = TextEditingController();
  var tituloController = TextEditingController();

  @override
  void initState() {
    super.initState();
    helper = ImagePickerHelper();
    bloc = SendMessageBloc()..getTopics();
  }

  @override
  void dispose() {
    bloc.dispose();
    conteudoController.dispose();
    tituloController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(title: Text("Nova Notificação")),
      body: ListView(
        padding: EdgeInsets.all(15),
        children: <Widget>[
          DropdownWidget<Topico>(
            listStream: bloc.outListTopics,
            selectedStream: bloc.outSelectedTopic,
            setSelected: bloc.setSelectedTopic,
            label: "Tópico",
          ),
          DropdownWidget(
            listStream: bloc.outListProgramacao,
            selectedStream: bloc.outSelectedProgramacao,
            setSelected: bloc.setSelectedProgramacao,
            label: "Programação",
          ),
          _buildDateTimeButtons(),
          DropdownWidget<TipoMensagemModel>(
            listStream: bloc.outListTypes,
            selectedStream: bloc.outSelectedType,
            setSelected: bloc.setType,
            label: "Tipo de Mensagem",
          ),
          SizedBox(height: 15),
          TextFormField(
            controller: tituloController,
            maxLength: 100,
            maxLines: null,
            decoration: InputDecoration(labelText: "Título"),
            keyboardType: TextInputType.multiline,
          ),
          SizedBox(height: 25),
          _buildContentWidget(),
          SizedBox(height: 25),
          _buildBotaoSalvar(),
        ],
      ),
    );
  }

  Widget _buildContentWidget() {
    return StreamBuilder<TipoMensagemModel>(
      stream: bloc.outSelectedType,
      builder: (context, selectedType) {
        switch (selectedType.data?.tipo) {
          case TipoEnum.imagem:
            return _buildImageContent();
            break;
          case TipoEnum.video:
            return _buildVideoContent();
            break;
          case TipoEnum.texto:
            return TextFormField(
              controller: conteudoController,
              maxLength: 140,
              maxLines: null,
              decoration: InputDecoration(labelText: "Conteúdo"),
              keyboardType: TextInputType.multiline,
            );
            break;
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
                          : null),
                  Container(color: Color.fromRGBO(0, 0, 0, 490)),
                  InkWell(
                    onTap: () =>
                        helper.showImage(context, bloc.setSelectedImage),
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
    return StreamBuilder<File>(
      stream: bloc.outSelectedVideo,
      builder: (context, snapshot) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 15),
              child: (snapshot.data?.path == null)
                  ? Text("Nenhum vídeo selecionado")
                  : Stack(
                      children: <Widget>[
                        // new Material(
                        //   child: new AspectRatio(
                        //     aspectRatio: 4 / 2,
                        //     child: new VideoPlayer(bloc.playerController),
                        //   ),
                        // ),
                        Chewie(
                          bloc.playerController, 
                          aspectRatio: 4 / 2,
                          autoPlay: true,
                          looping: true,
                        ),
                        // Container(
                        //   alignment: Alignment.topLeft,
                        //   padding: EdgeInsets.all(5),
                        //   child: FloatingActionButton(
                        //     child: Icon(Icons.video_call),
                        //     onPressed: () => helper.showVideo(
                        //           context,
                        //           bloc.setSelectedVideo,
                        //         ),
                        //     tooltip: "Alterar Vídeo",
                        //     mini: true,
                        //   ),
                        // ),
                      ],
                    ),
            ),
            (snapshot.data?.path == null)
                ? Container(
                    height: 60,
                    child: RaisedButton(
                      color: Theme.of(context).accentColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      onPressed: () =>
                          helper.showVideo(context, bloc.setSelectedVideo),
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
                  )
                : Container(),
          ],
        );
      },
    );
  }

  Widget _buildDateTimeButtons() {
    return StreamBuilder<String>(
      stream: bloc.outSelectedProgramacao,
      builder: (context, snapshot) {
        bool agora = (snapshot.hasData && snapshot.data == "Agora");
        if (agora) {
          return Container();
        } else {
          return Row(
            children: <Widget>[
              Expanded(
                child: _buildDateButton(),
              ),
              Expanded(
                child: _buildTimeButton(),
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildDateButton() {
    return StreamBuilder<DateTime>(
      stream: bloc.outDataProgramacao,
      builder: (_, dateSnap) {
        return FlatButton(
          child:
              Text(DateTimeHelper.dateFormat(dateSnap.data ?? DateTime.now())),
          onPressed: () {
            showDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2022),
                    initialDate: DateTime.now())
                .then(
              (date) {
                if (date != null)
                  bloc.setDataProgramacao(date ?? DateTime.now());
              },
            );
          },
        );
      },
    );
  }

  Widget _buildTimeButton() {
    return StreamBuilder<TimeOfDay>(
      stream: bloc.outHoraProgramacao,
      builder: (_, timeSnap) {
        return FlatButton(
          child:
              Text(DateTimeHelper.timeFormat(timeSnap.data ?? TimeOfDay.now())),
          onPressed: () {
            showTimePicker(
              context: context,
              initialTime: timeSnap.data ?? TimeOfDay.now(),
            ).then(
              (time) {
                if (time != null) bloc.setHoraProgramacao(time);
              },
            );
          },
        );
      },
    );
  }

  Widget _buildBotaoSalvar() {
    return StreamBuilder<bool>(
      stream: bloc.outSalvarIsLoading,
      builder: (context, loading) {
        return Container(
          height: 60,
          child: RaisedButton(
            color: Theme.of(context).accentColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            child: (loading.hasData && !loading.data)
                ? Text(
                    "< ENVIAR >",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  )
                : SizedBox(
                    height: 15.0,
                    width: 15.0,
                    child: const CircularProgressIndicator(
                      backgroundColor: Colors.white,
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
            onPressed: () {
              if (loading.hasData && !loading.data) {
                bloc.enviar(
                  titulo: tituloController.text,
                  texto: conteudoController.text,
                );
              }
            },
          ),
        );
      },
    );
  }
}
