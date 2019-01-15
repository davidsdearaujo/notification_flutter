import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'send-message-model.dart';

class SendMessageService {
  var url = "https://app.lagoinha.com/api/app";

  Future<List<Topico>> getTopics() async {
    var httpResponse = await http.get("$url/getlista?lista=Todo");

    print("Response status: ${httpResponse.statusCode}");
    print("Response body: ${httpResponse.body}");

    final List<dynamic> mapa = json.decode(httpResponse.body);
    List<Topico> lista = mapa.map((t) => Topico.fromJson(t)).toList();
    return lista;
  }

  void sendMessage({
    @required String uid,
    @required int listaId,
    @required String titulo,
    String texto,
    @required DateTime data,
    @required TimeOfDay hora,
    @required TipoEnum tipo,
    List<int> arquivo,
  }) async {
    var httpResponse = await http.post(
      "$url/postnotificacao",
      body: {
        "lista_id": listaId.toString(),
        "texto": texto,
        "tipo": TipoMensagemModel.fromEnum(tipo).apiValue,
        "titulo": titulo,
        "uid": uid,
        "data":
            "${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year.toString().padLeft(2, '0')}",
        "hora":
            "${hora.hour.toString().padLeft(2, '0')}:${hora.minute.toString().padLeft(2, '0')}",
      },
    );
    switch (httpResponse.statusCode) {
      case 500:
        //Tratamento do erro
        break;

      case 200:
        break;
    }
  }
}

enum TipoEnum { texto, imagem, video }

class TipoMensagemModel {
  final TipoEnum tipo;
  final String texto;
  final String apiValue;

  @override
  String toString() => texto;

  TipoMensagemModel({this.tipo, this.texto, this.apiValue});

  static var list = [
    TipoMensagemModel(tipo: TipoEnum.texto, texto: "Texto", apiValue: "T"),
    TipoMensagemModel(tipo: TipoEnum.imagem, texto: "Imagem", apiValue: "I"),
    TipoMensagemModel(tipo: TipoEnum.video, texto: "Vídeo", apiValue: "V"),
  ];

  factory TipoMensagemModel.fromEnum(TipoEnum tipo) =>
      list.lastWhere((t) => t.tipo == tipo);
}
