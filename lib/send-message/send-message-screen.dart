import 'package:flutter/material.dart';
import 'package:message/send-message/send-message-bloc.dart';

import '../dropdown/dropdown-widget.dart';

class SendMessageScreen extends StatefulWidget {
  @override
  _SendMessageScreenState createState() => _SendMessageScreenState();
}

class _SendMessageScreenState extends State<SendMessageScreen> {
  SendMessageBloc bloc = SendMessageBloc()..getGroups();
  var conteudoColtroller = TextEditingController();

  @override
  void dispose() {
    bloc.dispose();
    conteudoColtroller.dispose();
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
          SizedBox(height: 35),
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
          case "Texto":
            return TextField(
              controller: conteudoColtroller,
              maxLength: 100,
              maxLines: null,
              decoration: InputDecoration(labelText: "Conteúdo"),
              keyboardType: TextInputType.multiline,
            );

          case "Imagem":
            return Container(
              height: 60,
              child: RaisedButton(
                color: Theme.of(context).accentColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.image, color: Colors.white),
                    SizedBox(width: 15),
                    Text(
                      "Selecionar Imagem",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            );

          case "Vídeo":
            return Container(
              height: 60,
              child: RaisedButton(
                color: Theme.of(context).accentColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                onPressed: () {},
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
            );

          default:
            return Container();
        }
      },
    );
  }
}
