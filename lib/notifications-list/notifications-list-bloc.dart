import 'package:rxdart/rxdart.dart';

import 'notifications-list-model.dart';
import 'notifications-list-service.dart';

class NotificationsListBloc {
  var service = NotificationsListService();

  //Controllers
  var _currentPageController = BehaviorSubject<int>(seedValue: 0);

  var _lastPageController = BehaviorSubject<int>(seedValue: 0);

  var _totalEnviadasController = BehaviorSubject<int>(seedValue: 0);

  var _totalRecebidasController = BehaviorSubject<int>(seedValue: 0);

  var _notificacoesRecebidasController =
      BehaviorSubject<List<NotificationsListModel>>(
          seedValue: List<NotificationsListModel>());

  var _notificacoesEnviadasController =
      BehaviorSubject<List<NotificationsListModel>>(
          seedValue: List<NotificationsListModel>());

  //Streams
  Observable<List<NotificationsListModel>> get outNotificacoesEnviadas =>
      _notificacoesEnviadasController.stream;
  Observable<List<NotificationsListModel>> get outNotificacoesRecebidas =>
      _notificacoesRecebidasController.stream;

  Observable<int> get outTotalEnviadas => _totalEnviadasController.stream;
  Observable<int> get outTotalRecebidas => _totalRecebidasController.stream;

  //Métodos
  void buscarNotificacoesRecebidas() {
    int nextPage = _currentPageController.value + 1;

    //se a próxima página não for a ultima, prossegue com o fluxo
    if (_lastPageController.value == 0 ||
        _lastPageController.value > nextPage) {
      try {
        service.buscarListaNotificacoesRecebidas(nextPage);
        _currentPageController.add(nextPage);
      } catch (ex) {
        print("Não foi possível buscar mais dados.");
        print(ex);
      }
    }
  }

  void buscarNotificacoesEnviadas() async {
    int nextPage = _currentPageController.value + 1;

    //se a próxima página não for a ultima, prossegue com o fluxo
    if (_lastPageController.value == 0 ||
        _lastPageController.value > nextPage) {
      try {
        var dados = await service.buscarListaNotificacoesEnviadas(nextPage);
        var newData = _notificacoesEnviadasController.value..addAll(dados.data);
        _notificacoesEnviadasController.add(newData);

        _lastPageController.add(dados.lastPage);
        _totalEnviadasController.add(dados.total);

        _currentPageController.add(nextPage);
      } catch (ex) {
        print("Não foi possível buscar mais dados.");
        print(ex);
      }
    }
  }

  void dispose() {
    _notificacoesRecebidasController.close();
    _notificacoesEnviadasController.close();
    
    _totalEnviadasController.close();
    _totalRecebidasController.close();

    _currentPageController.close();
    _lastPageController.close();
  }
}
