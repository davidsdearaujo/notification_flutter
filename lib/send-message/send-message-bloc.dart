import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:video_player/video_player.dart';

import 'send-message-model.dart';
import 'send-message-service.dart';

class SendMessageBloc {
  SendMessageService service;
  VideoPlayerController playerController;

  String uid;

  SendMessageBloc(this.uid) {
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

  // final _validateField =
  //     StreamTransformer<String, String>.fromHandlers(handleData: (value, sink) {
  //   String text = value.trim();
  //   if (text.isEmpty) {
  //     sink.addError(new Exception("Campo obrigatório"));
  //   } else {
  //     sink.add(text);
  //   }
  // });

  String validateTitle(String value) {
    String text = value.trim();
    if (text.isEmpty) {
      return "Campo obrigatório";
    } else {
      _tituloController.add(text);
      return null;
    }
  }

  String validateTexto(String value) {
    String text = value.trim();
    if (_selectedTypeController.value.tipo == TipoEnum.texto && text.isEmpty) {
      return "Campo obrigatório";
    } else {
      _textoController.add(text);
      return null;
    }
  }

  String validateDropdown<T>(T value) {
    String response;

    if (value == null) response = "Campo obrigatório";
    return response;
  }

  //Titulo
  var _tituloController = BehaviorSubject<String>(seedValue: "");
  // Observable<String> get outTitulo =>_tituloController.stream;//.transform(_validateField);
  // Sink<String> get outTituloSink => _tituloController.sink;

  //Texto
  var _textoController = BehaviorSubject<String>(seedValue: "");

  //Scaffold
  var _scaffoldController = BehaviorSubject<ScaffoldState>();
  StreamSink<ScaffoldState> get outScaffoldSink => _scaffoldController.sink;
  // Observable<String> get outConteudo =>_textoController.stream;//.transform(_validateField);
  // Sink<String> get outConteudoSink => _textoController.sink;

  //Salvar
  // var _salvarEvent = BehaviorSubject<bool>(seedValue: false);
  // Sink<bool> get salvarSink => _salvarEvent.sink;
  // Observable<bool> get salvarFlux => Observable.combineLatest2(salvarIsLoad, _salvarEvent, (a, b)=> b);
  // salvarIsLoad..switchMap((v) => _salvarEvent.stream);

  // Observable<bool> get salvarIsLoad => _salvarEvent.stream
  //         .map((v) => v)
  //         .where((val) => val)
  //         .debounce(Duration(seconds: 5))
  //         .asyncMap((val) async {
  //       DateTime data = (_selectedProgramacaoController.value == "Agora")
  //           ? DateTime.now()
  //           : _selectedDataProgramacaoController.value;

  //       TimeOfDay hora = (_selectedProgramacaoController.value == "Agora")
  //           ? TimeOfDay.now()
  //           : _selectedHoraProgramacaoController.value;

  //       File arquivo;
  //       switch (_selectedTypeController.value.tipo) {
  //         case TipoEnum.imagem:
  //           arquivo = _selectedImageController.value;
  //           break;

  //         case TipoEnum.video:
  //           arquivo = _selectedVideoController.value;
  //           break;

  //         default:
  //           arquivo = null;
  //           break;
  //       }

  //       await service.sendMessage(
  //         uid: this.uid,
  //         data: data,
  //         hora: hora,
  //         listaId: _selectedTopicController.value.id,
  //         tipo: _selectedTypeController.value.tipo,
  //         titulo: _tituloController.value,
  //         texto: _textoController.value,
  //         arquivo: arquivo,
  //       );
  //     })
  //           ..doOnDone(() => _salvarEvent.add(false));

  var _salvarIsLoadingController = BehaviorSubject<bool>(seedValue: false);
  Observable<bool> get outSalvarIsLoading => _salvarIsLoadingController.stream;

  void enviar({@required String titulo, String texto}) async {
    _salvarIsLoadingController.add(true);
    try {
      //Validação dos campos obrigatórios
      bool hasError = false;
      if (_selectedTopicController.value == null) {
        _selectedTopicController.addError("Campo obrigatório.");
        hasError = true;
      }

      if (_selectedTypeController.value == null) {
        _selectedTypeController.addError("Campo obrigatório.");
        hasError = true;
      } else {
        switch (_selectedTypeController.value.tipo) {
          case TipoEnum.imagem:
            if (_selectedImageController.value == null)
              _selectedImageController.addError("Campo obrigatório.");
            hasError = true;
            break;

          case TipoEnum.video:
            if (_selectedVideoController.value == null)
              _selectedVideoController
                  .addError("Você precisa selecionar um vídeo.");
            hasError = true;
            break;

          case TipoEnum.texto:
            if (texto == null || texto == "") hasError = true;
            // _selectedVideoController.addError("Campo obrigatório.");
            break;
        }
      }

      if (hasError) {
        _scaffoldController.value?.showSnackBar(
          SnackBar(
            content: Text("Notificação não enviada"),
            duration: Duration(seconds: 1),
          ),
        );
      } else {
        bool _agora = (_selectedProgramacaoController.value == "Agora");

        DateTime data =
            _agora ? DateTime.now() : _selectedDataProgramacaoController.value;

        TimeOfDay hora =
            _agora ? TimeOfDay.now() : _selectedHoraProgramacaoController.value;

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
      }
    } catch (ex) {
      _scaffoldController.addError(
          Exception("Não foi possível enviar a mensagem. ${ex?.message}"));
    }
    _salvarIsLoadingController.add(false);
    _scaffoldController.value?.showSnackBar(
          SnackBar(
            content: Text("Notificação enviada com sucesso!"),
            duration: Duration(seconds: 1),
            action: SnackBarAction(label: "OK",onPressed: () {}, ),
          ),
        );
  }

  void dispose() {
    _selectedTypeController.close();
    _selectedImageController.close();
    _selectedTopicController.close();
    _selectedProgramacaoController.close();

    _selectedDataProgramacaoController.close();
    _selectedHoraProgramacaoController.close();

    _scaffoldController.close();

    _tituloController.close();
    _textoController.close();
    _salvarIsLoadingController.close();
    playerController?.dispose();
  }
}
