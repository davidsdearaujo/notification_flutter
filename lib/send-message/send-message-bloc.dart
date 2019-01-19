import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:video_player/video_player.dart';

import 'send-message-model.dart';
import 'send-message-service.dart';

class SendMessageBloc {
  SendMessageService service;
  VideoPlayerController playerController;

  String uid = "FEn2LN2KM6ZprhpeUul9ui6Ynm23";

  SendMessageBloc() {
    service = SendMessageService();
    outListTopics = Observable.fromFuture(service.getTopics());
  }

  //Topics
  Observable<List<Topico>> outListTopics;

  var _selectedTopicController = BehaviorSubject<Topico>();
  Observable<Topico> get outSelectedTopic => _selectedTopicController.stream;
  Sink<Topico> get outSinkSelectedTopic => _selectedTopicController.sink;

  //Types
  Observable<List<TipoMensagemModel>> get outListTypes =>
      Observable.just(TipoMensagemModel.list);

  var _selectedTypeController = BehaviorSubject<TipoMensagemModel>(
    seedValue:
        TipoMensagemModel.list.lastWhere((t) => t.tipo == TipoEnum.texto),
  );
  Observable<TipoMensagemModel> get outSelectedType =>
      _selectedTypeController.stream;

  void setType(TipoMensagemModel tipo) async {
    if (tipo.tipo != TipoEnum.video) {
      await playerController?.dispose();
      playerController = null;
    }
    _selectedTypeController.add(tipo);
  }

  //Image
  var _selectedImageController = BehaviorSubject<File>(seedValue: null);
  Observable<File> get outSelectedImage => _selectedImageController.stream;
  Sink<File> get outSelectedImageSink => _selectedImageController.sink;

  //Video
  var _selectedVideoController = BehaviorSubject<File>(seedValue: null);
  Observable<File> get outSelectedVideo => _selectedVideoController.stream;

  void setSelectedVideo(File file) async {
    if (_selectedVideoController.value != null &&
        playerController?.dataSource != "file://${file.path}") {
      await playerController?.dispose();
      playerController = null;
      playerController = VideoPlayerController.file(file);
    }
    playerController = VideoPlayerController.file(file);

    _selectedVideoController.add(file);
  }

  //Programação
  Observable<List<String>> get outListProgramacao => Observable.just(
        [
          "Agora",
          "Agendar",
        ],
      );

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
      //Validação dos campos obrigatórios
      if (_selectedTopicController.value == null) {
        _selectedTopicController.addError("Campo obrigatório.");
      }

      if (_selectedTypeController.value == null) {
        _selectedTypeController.addError("Campo obrigatório.");
      } else {
        switch (_selectedTypeController.value.tipo) {
          case TipoEnum.imagem:
            if (_selectedImageController.value == null)
              _selectedImageController.addError("Campo obrigatório.");
            break;

          case TipoEnum.video:
            if (_selectedVideoController.value == null)
              _selectedVideoController.addError("Campo obrigatório.");
            break;

          case TipoEnum.texto:
            if (texto == null || texto == "")
              // _selectedVideoController.addError("Campo obrigatório.");
            break;
        }
      }

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

      await service.sendMessage(
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
    _selectedTypeController.close();
    _selectedImageController.close();
    _selectedTopicController.close();
    _selectedProgramacaoController.close();

    _selectedDataProgramacaoController.close();
    _selectedHoraProgramacaoController.close();

    _salvarIsLoadingController.close();
    playerController?.dispose();
  }
}
