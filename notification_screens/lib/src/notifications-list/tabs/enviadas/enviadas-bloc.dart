import 'package:rxdart/rxdart.dart';

import '../../notifications-list-model.dart';
import '../../notifications-list-service.dart';

class EnviadasBloc {
  NotificationsListService service;
  EnviadasBloc(String uid) {
    service = NotificationsListService(uid);
  }

  int _currentPage = 0;
  int _lastPage = 0;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool get isFinish => (_lastPage != 0 && _lastPage <= _currentPage);

  var _pageIsLoadingController = BehaviorSubject<bool>(seedValue: false);

  final _apiResults = new ReplaySubject<Set<NotificationsListModel>>();
  Observable<Set<NotificationsListModel>> get apiResultsFlux => _apiResults.stream;
  Sink<Set<NotificationsListModel>> get apiResultsEvent => _apiResults.sink;

  Observable<List<NotificationsListModel>> get apiTotalFlux =>
      apiResultsFlux.map((allItems) {
        List listAll = _apiResults.values
            .reduce((before, current) => before..addAll(current))
            .toList();
        return listAll;
      });

  //Métodos
  Future<bool> buscarNotificacoes({int pages = 1}) async {
    var response = true;
    _isLoading = true;
    int nextPage = (_currentPage + 1);

    try {
      var dados = await service.buscarListaNotificacoesEnviadas(nextPage);
      apiResultsEvent.add(dados.data.toSet());
      _lastPage = dados.lastPage;
      _currentPage = nextPage;
    } catch (ex) {
      print("Não foi possível buscar mais dados.");
      print(ex);
      response = false;
    } finally {
      _isLoading = false;
    }
    return response;
  }

  void dispose() {
    _pageIsLoadingController?.close();
    _apiResults?.close();
  }
}
