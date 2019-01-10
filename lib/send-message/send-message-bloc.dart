import 'dart:io';

import 'package:rxdart/rxdart.dart';

class SendMessageBloc {
  //Groups
  var _listGroupsController =
      BehaviorSubject<List<String>>(seedValue: List<String>());
  Observable<List<String>> get outListGroups => _listGroupsController.stream;

  var _selectedGroupController = BehaviorSubject<String>();
  Observable<String> get outSelectedGroup => _selectedGroupController.stream;

  void setGroup(String tipo) {
    _selectedGroupController.add(tipo);
  }

  void getGroups() {
    _listGroupsController.add(List.generate(4, (i) => "Grupo ${i + 1}"));
  }

  //Types
  var _listTypesController = BehaviorSubject<List<String>>(
    seedValue: [
      "Texto",
      "Imagem",
      "Vídeo",
    ],
  );
  Observable<List<String>> get outListTypes => _listTypesController.stream;

  var _selectedTypeController = BehaviorSubject<String>(seedValue: "Texto");
  Observable<String> get outSelectedType => _selectedTypeController.stream;

  void setType(String tipo) {
    _selectedTypeController.add(tipo);
  }

  //Image
  var _selectedImageController = BehaviorSubject<File>();
  Observable<File> get outSelectedImage => _selectedImageController.stream;

  void setSelectedImage(File file){
    _selectedImageController.add(file);
  }

  //Video
  var _selectedVideoController = BehaviorSubject<File>();
  Observable<File> get outSelectedVideo => _selectedVideoController.stream;

  void setSelectedVideo(File file){
    _selectedVideoController.add(file);
  }

  var _videoIsPlayingController = BehaviorSubject<bool>();
  Observable<bool> get outVideoIsPlaying => _videoIsPlayingController.stream;

  void dispose() {
    _listGroupsController.close();
    _selectedGroupController.close();
    _listTypesController.close();
    _selectedTypeController.close();
    _selectedImageController.close();
    _videoIsPlayingController.close();
  }
}
