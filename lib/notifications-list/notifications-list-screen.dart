import 'package:flutter/material.dart';
import 'tabs/enviadas/enviadas-tab.dart';
import 'tabs/recebidas/recebidas-tab.dart';
import '../firebase-messaging-receive/scaffold-notification-mixin.dart';

class NotificationsListScreen extends StatefulWidget {
  final bool somenteRecebidos;

  const NotificationsListScreen({Key key, this.somenteRecebidos = false})
      : super(key: key);
  @override
  _NotificationsListScreenState createState() =>
      _NotificationsListScreenState();
}

class _NotificationsListScreenState extends State<NotificationsListScreen>
    with ScaffoldNotificationMixin {
  @override
  Widget build(BuildContext context) {
    return (widget.somenteRecebidos) ? _buildSomenteRecebidos() : _buildTabs();
  }

  Widget _buildSomenteRecebidos() {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Histórico de notificações recebidas"),
      ),
      body: RecebidasTab(),
    );
  }

  Widget _buildTabs() {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text("Histórico de notificações"),
          bottom: TabBar(
            tabs: [
              Tab(icon: Text("Enviadas")),
              Tab(icon: Text("Recebidas")),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            EnviadasTab(),
            RecebidasTab(),
          ],
        ),
      ),
    );
  }
}
