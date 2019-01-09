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

  var _selectedTypeController = BehaviorSubject<String>();
  Observable<String> get outSelectedType => _selectedTypeController.stream;

  void setType(String tipo) {
    _selectedTypeController.add(tipo);
  }

  void dispose() {
    _listGroupsController.close();
    _selectedGroupController.close();
    _listTypesController.close();
    _selectedTypeController.close();
  }
}
