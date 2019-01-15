import 'package:rxdart/rxdart.dart';

import '../notfication-resume/notification-resume-model.dart';

class FirebaseMessagingReceiveBloc {
  FirebaseMessagingReceiveBloc();
  static FirebaseMessagingReceiveBloc _instance;
  factory FirebaseMessagingReceiveBloc.instance() {
    if (_instance == null) _instance = FirebaseMessagingReceiveBloc();
    return _instance;
  }

  var _notificacaoController = BehaviorSubject<NotificationResumeModel>();
  Observable<NotificationResumeModel> get outNotificacao =>
      _notificacaoController.stream;

  void adicionarNotificacao(NotificationResumeModel notificacao) {
    _notificacaoController.add(notificacao);
  }

  void dispose() {
    _notificacaoController.close();
  }
}
