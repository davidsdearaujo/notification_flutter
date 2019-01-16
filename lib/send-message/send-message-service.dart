import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
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
    File arquivo,
  }) async {
    Dio dio = new Dio();
    FormData formdata = new FormData();
    formdata.add("lista_id", listaId.toString());
    formdata.add("tipo", TipoMensagemModel.fromEnum(tipo).apiValue);
    formdata.add("titulo", titulo);
    formdata.add("uid", uid);
    formdata.add("data",
        "${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year.toString().padLeft(2, '0')}");
    formdata.add("hora",
        "${hora.hour.toString().padLeft(2, '0')}:${hora.minute.toString().padLeft(2, '0')}");

    if (tipo == TipoEnum.texto)
      formdata.add("texto", texto);
    else
      formdata.add("arquivo", new UploadFileInfo(arquivo, 'arquivo'));

    try {
      var response = await dio.post<String>(
        '$url/postnotificacao',
        data: formdata,
        options: Options(method: 'POST', responseType: ResponseType.JSON),
      );
      print(response.statusCode);
      print(response.data);
    } on DioError catch (e) {
      print(e.message);
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

  factory TipoMensagemModel.fromApiValue(String value) =>
      list.lastWhere((t) => t.apiValue == value);
}
