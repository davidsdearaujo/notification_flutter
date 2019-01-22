import 'package:flutter/material.dart';
import 'tabs/enviadas/enviadas-tab.dart';
import 'tabs/recebidas/recebidas-tab.dart';

class NotificationsListScreen extends StatefulWidget {
  final bool somenteRecebidos;
  final String uid;

  const NotificationsListScreen({
    Key key,
    this.somenteRecebidos = false,
    @required this.uid,
  })  : assert(uid != null),
        super(key: key);
  @override
  _NotificationsListScreenState createState() =>
      _NotificationsListScreenState();
}

class _NotificationsListScreenState extends State<NotificationsListScreen>{
  @override
  Widget build(BuildContext context) {
    return (widget.somenteRecebidos) ? _buildSomenteRecebidos() : _buildTabs();
  }

  Widget _buildSomenteRecebidos() {
    return Scaffold(
      appBar: AppBar(
        title: Text("Histórico de notificações recebidas"),
      ),
      body: RecebidasTab(uid: widget.uid),
    );
  }

  Widget _buildTabs() {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
            EnviadasTab(uid: widget.uid),
            RecebidasTab(uid: widget.uid),
          ],
        ),
      ),
    );
  }
}
