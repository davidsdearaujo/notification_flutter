import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

import '../../notifications-list-model.dart';
import '../../notifications-list-service.dart';

class EnviadasBloc {
  var service = NotificationsListService();
  var scrollController = ScrollController();

  EnviadasBloc(){
    scrollController.addListener(scroolListener);
  }

  //Controllers
  var _currentPageController = BehaviorSubject<int>(seedValue: 0);

  var _lastPageController = BehaviorSubject<int>(seedValue: 0);

  var _totalController = BehaviorSubject<int>(seedValue: 0);

  var _pageIsLoadingController = BehaviorSubject<bool>(seedValue: false);

  var _notificacoesController = BehaviorSubject<List<NotificationsListModel>>(
    seedValue: List<NotificationsListModel>(),
  );

  //Streams
  Observable<List<NotificationsListModel>> get outNotificacoes =>
      _notificacoesController.stream;

  Observable<int> get outTotal => _totalController.stream;

  //Métodos
  void buscarNotificacoes() async {
    int nextPage = _currentPageController.value + 1;

    //se a próxima página não for a ultima, prossegue com o fluxo
    if (_lastPageController.value == 0 || _lastPageController.value > nextPage) {
      try {
        var dados = await service.buscarListaNotificacoesEnviadas(nextPage);

        var newList = _notificacoesController.value..addAll(dados.data);
        _notificacoesController.add(newList);
        _lastPageController.add(dados.lastPage);
        _totalController.add(dados.total); 
        _currentPageController.add(nextPage);
      } catch (ex) {
        print("Não foi possível buscar mais dados.");
        print(ex);
      }
    }
  }

  void scroolListener() {
    if ((scrollController.offset > scrollController.position.maxScrollExtent - 200) &&
        !_pageIsLoadingController.value) buscarNotificacoes();
  }

  void dispose() {
    _currentPageController.close();
    _lastPageController.close();
    _totalController.close();
    _notificacoesController.close();
    _pageIsLoadingController.close();
  }
}
