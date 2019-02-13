import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'send-message-model.dart';

class SendMessageService {
  var urlApi = "https://app.lagoinha.com/api/app";

  Future<List<Topico>> getTopics() async {
    var httpResponse = await http.get("$urlApi/getlista?lista=Todo");

    print("Response status: ${httpResponse.statusCode}");
    print("Response body: ${httpResponse.body}");

    final List<dynamic> mapa = json.decode(httpResponse.body);
    List<Topico> lista = mapa.map((t) => Topico.fromJson(t)).toList();
    return lista;
  }

  Future<int> sendMessage({
    @required String uid,
    @required int listaId,
    @required String titulo,
    String texto,
    @required DateTime data,
    @required TimeOfDay hora,
    @required TipoEnum tipo,
    File arquivo,
    String url,
  }) async {
    Dio dio = new Dio();
    FormData formdata = FormData.from({
      "uid": uid,
      "lista_id": listaId,
      "titulo": titulo,
      "data": "${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year.toString().padLeft(2, '0')}",
      "hora": "${hora.hour.toString().padLeft(2, '0')}:${hora.minute.toString().padLeft(2, '0')}",
      "tipo": TipoMensagemModel.fromEnum(tipo).apiValue
    });
    
    switch(tipo){
      case TipoEnum.youtube:
        // formdata.add("texto", titulo);
        formdata.add("url", url);
        break;

      case TipoEnum.texto:
        formdata.add("texto", texto);
        break;

      default: 
        formdata.add("arquivo", new UploadFileInfo(arquivo, basename(arquivo?.path)));
      break;
    }

    int _response = 0;

      var response = await dio.post(
        '$urlApi/postnotificacao',
        data: formdata,
        // options: Options(method: 'POST', responseType: ResponseType.JSON),
      );
      print(response.statusCode);
      print(response.data);

      _response = response.data;
    return _response;
  }
}

enum TipoEnum { texto, imagem, video, youtube }

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
    TipoMensagemModel(tipo: TipoEnum.youtube, texto: "Youtube", apiValue: "Y"),
  ];

  factory TipoMensagemModel.fromEnum(TipoEnum tipo) =>
      list.lastWhere((t) => t.tipo == tipo);

  factory TipoMensagemModel.fromApiValue(String value) =>
      list.lastWhere((t) => t.apiValue == value);
}
