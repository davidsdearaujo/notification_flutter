import 'package:rxdart/rxdart.dart';

import 'package:notification_screens/src/notfication-display/notification-display-screen.dart';
import 'package:notification_screens/src/notfication-display/notification-display-model.dart';

class FirebaseMessagingReceiveBloc {
  FirebaseMessagingReceiveBloc();
  static FirebaseMessagingReceiveBloc _instance;
  factory FirebaseMessagingReceiveBloc.instance() {
    if (_instance == null) _instance = FirebaseMessagingReceiveBloc();
    return _instance;
  }

  var _notificacaoController = BehaviorSubject<NotificationDisplayModel>();
  Observable<NotificationDisplayModel> get outNotificacao =>
      _notificacaoController.stream;

  void adicionarNotificacao(NotificationDisplayModel notificacao) {
    _notificacaoController.add(notificacao);
  }

  void dispose() {
    _notificacaoController.close();
  }
}
