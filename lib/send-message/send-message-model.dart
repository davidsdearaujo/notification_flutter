class SendMessageModel {
  List<Topico> topicos = List<Topico>();
}

class Topico {
  String nome;
  int id;
  int count;

  Topico({this.nome, this.id, this.count});
  factory Topico.fromJson(Map<String, dynamic> parsedJson) {
    return Topico(
      id: parsedJson['id'],
      nome: parsedJson['lista'],
      count: parsedJson['count'],
    );
  }

  @override
  String toString() {
    return "$nome ($count)";
  }
}
