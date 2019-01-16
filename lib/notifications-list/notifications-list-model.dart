class NotificationsListModel {
  Map<String, dynamic> parsedJson;
  int id;
  String uid;
  int listaId;
  String titulo;
  String texto;
  String arquivo;
  String data;
  String hora;
  TipoMensagemModel tipo;
  String createdAt;
  String enviadopor;
  String enviadopara;
  String enviadoem;

  NotificationsListModel({
    this.id,
    this.uid,
    this.listaId,
    this.titulo,
    this.texto,
    this.arquivo,
    this.data,
    this.hora,
    this.tipo,
    this.createdAt,
    this.enviadopor,
    this.enviadopara,
    this.enviadoem,
    this.parsedJson,
  });

  factory NotificationsListModel.fromJson(Map<String, dynamic> parsedJson) {
    return NotificationsListModel(
      arquivo: parsedJson["arquivo"],
      createdAt: parsedJson["created_at"],
      data: parsedJson["data"],
      enviadoem: parsedJson["enviadoem"],
      enviadopara: parsedJson["enviadopara"],
      enviadopor: parsedJson["enviadopor"],
      hora: parsedJson["hora"],
      id: parsedJson["id"],
      listaId: parsedJson["lista_id"],
      texto: parsedJson["texto"],
      tipo: TipoMensagemModel.fromApiValue(parsedJson["tipo"]),
      titulo: parsedJson["titulo"],
      uid: parsedJson["uid"],
      parsedJson: parsedJson
    );
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
