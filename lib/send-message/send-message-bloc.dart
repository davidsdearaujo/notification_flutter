import 'dart:io';

import 'package:flutter/material.dart';
import 'send-message-model.dart';
import 'package:rxdart/rxdart.dart';
import 'send-message-service.dart';

class SendMessageBloc {
  SendMessageService service;
  String uid = "FEn2LN2KM6ZprhpeUul9ui6Ynm23";

  SendMessageBloc() {
    service = SendMessageService();
  }

  //Topics
  var _listTopicsController =
      BehaviorSubject<List<Topico>>(seedValue: List<Topico>());
  Observable<List<Topico>> get outListTopics => _listTopicsController.stream;

  var _selectedTopicController = BehaviorSubject<Topico>();
  Observable<Topico> get outSelectedTopic => _selectedTopicController.stream;

  void setSelectedTopic(Topico val) {
    _selectedTopicController.add(val);
  }

  Future<Null> getTopics() async {
    var lista = await service.getTopics();
    _listTopicsController.add(lista);
  }

  //Types
  var _listTypesController = BehaviorSubject<List<TipoMensagemModel>>(
    seedValue: TipoMensagemModel.list,
  );
  Observable<List<TipoMensagemModel>> get outListTypes =>
      _listTypesController.stream;

  var _selectedTypeController = BehaviorSubject<TipoMensagemModel>(
    seedValue:
        TipoMensagemModel.list.lastWhere((t) => t.tipo == TipoEnum.texto),
  );
  Observable<TipoMensagemModel> get outSelectedType =>
      _selectedTypeController.stream;

  void setType(TipoMensagemModel tipo) {
    _selectedTypeController.add(tipo);
  }

  //Image
  var _selectedImageController = BehaviorSubject<File>(seedValue: null);
  Observable<File> get outSelectedImage => _selectedImageController.stream;

  void setSelectedImage(File file) {
    _selectedImageController.add(file);
  }

  //Video
  var _selectedVideoController = BehaviorSubject<File>(seedValue: null);
  Observable<File> get outSelectedVideo => _selectedVideoController.stream;

  void setSelectedVideo(File file) {
    _selectedVideoController.add(file);
  }

  //Programação
  var _listProgramacaoController = BehaviorSubject<List<String>>(
    seedValue: [
      "Agora",
      "Agendar",
    ],
  );
  Observable<List<String>> get outListProgramacao =>
      _listProgramacaoController.stream;

  var _selectedProgramacaoController =
      BehaviorSubject<String>(seedValue: "Agora");
  Observable<String> get outSelectedProgramacao =>
      _selectedProgramacaoController.stream;

  void setSelectedProgramacao(String tipo) {
    _selectedProgramacaoController.add(tipo);
  }

  //Data Programacao
  var _selectedDataProgramacaoController =
      BehaviorSubject<DateTime>(seedValue: DateTime.now());
  Observable<DateTime> get outDataProgramacao =>
      _selectedDataProgramacaoController.stream;

  void setDataProgramacao(DateTime date) {
    _selectedDataProgramacaoController.add(date);
  }

  //Hora Programacao
  var _selectedHoraProgramacaoController =
      BehaviorSubject<TimeOfDay>(seedValue: TimeOfDay.now());
  Observable<TimeOfDay> get outHoraProgramacao =>
      _selectedHoraProgramacaoController.stream;

  void setHoraProgramacao(TimeOfDay time) {
    _selectedHoraProgramacaoController.add(time);
  }

  //Salvar
  var _salvarIsLoadingController = BehaviorSubject<bool>(seedValue: false);
  Observable<bool> get outSalvarIsLoading => _salvarIsLoadingController.stream;

  void enviar({@required String titulo, String texto}) async {
    _salvarIsLoadingController.add(true);
    try {
      DateTime data = (_selectedProgramacaoController.value == "Agora")
          ? DateTime.now()
          : _selectedDataProgramacaoController.value;

      TimeOfDay hora = (_selectedProgramacaoController.value == "Agora")
          ? TimeOfDay.now()
          : _selectedHoraProgramacaoController.value;

      File arquivo;
      switch (_selectedTypeController.value.tipo) {
        case TipoEnum.imagem:
          arquivo = _selectedImageController.value;
          break;

        case TipoEnum.video:
          arquivo = _selectedVideoController.value;
          break;

        default:
          arquivo = null;
          break;
      }

      service.sendMessage(
        uid: this.uid,
        data: data,
        hora: hora,
        listaId: _selectedTopicController.value.id,
        tipo: _selectedTypeController.value.tipo,
        titulo: titulo,
        texto: texto,
        arquivo: arquivo,
      );
    } catch (ex) {
      _salvarIsLoadingController.addError(
          Exception("Não foi possível enviar a mensagem. ${ex?.message}"));
    }
    _salvarIsLoadingController.add(false);
  }

  void dispose() {
    _listTypesController.close();
    _selectedTypeController.close();

    _selectedImageController.close();

    _listTopicsController.close();
    _selectedTopicController.close();

    _listProgramacaoController.close();
    _selectedProgramacaoController.close();

    _selectedDataProgramacaoController.close();
    _selectedHoraProgramacaoController.close();

    _salvarIsLoadingController.close();
  }
}
