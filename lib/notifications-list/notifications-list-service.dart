import 'dart:convert';

import 'notifications-list-model.dart';
import 'package:http/http.dart' as http;

class NotificationsListService {
  final url = "https://app.lagoinha.com/api/app";
  final String uid;
  final sizeLimit = 50;

  NotificationsListService(this.uid);


  Future<ServiceRequestModel> buscarListaNotificacoesRecebidas(int page) async {
    var httpResponse =
        await http.get("$url/getlistanotificacaorecebida?uid=$uid&page=$page&limit=$sizeLimit");

    print("Response status: ${httpResponse.statusCode}");
    print("Response body: ${httpResponse.body}");

    final Map<String, dynamic> mapa = json.decode(httpResponse.body);
    final response = ServiceRequestModel.fromJson(mapa);
    return response;
  }

  Future<ServiceRequestModel> buscarListaNotificacoesEnviadas(int page) async {
    var httpResponse =
        await http.get("$url/getlistanotificacaoenviada?uid=$uid&page=$page&limit=$sizeLimit");

    print("Response status: ${httpResponse.statusCode}");
    print("Response body: ${httpResponse.body}");

    final Map<String, dynamic> mapa = json.decode(httpResponse.body);
    final response = ServiceRequestModel.fromJson(mapa);
    return response;
  }
}

class ServiceRequestModel {
  List<NotificationsListModel> data;
  int lastPage;
  int total;

  ServiceRequestModel({
    this.data,
    this.lastPage,
    this.total,
  });

  factory ServiceRequestModel.fromJson(Map<String, dynamic> parsedJson) {

    var response = ServiceRequestModel(
      lastPage: parsedJson["last_page"],
      total: parsedJson["last_page"],
    ); 

    List<Map<String, dynamic>> teste = 
      parsedJson["data"].cast<Map<String, dynamic>>();
      
    response.data = teste.map(
        (item) => NotificationsListModel.fromJson(item),
      ).toList();

    return response;
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