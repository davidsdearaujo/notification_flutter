import 'package:flutter/material.dart';

import '../../../notfication-resume/notification-resume-model.dart';
import '../../../notfication-resume/notification-resume-screen.dart';
import '../../notifications-list-model.dart';
import 'recebidas-bloc.dart';

class RecebidasTab extends StatefulWidget {
  @override
  _RecebidasTabState createState() => _RecebidasTabState();
}

class _RecebidasTabState extends State<RecebidasTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  RecebidasBloc bloc;
  ScrollController scrollController;

  @override
  void initState() {
    bloc = RecebidasBloc()..buscarNotificacoes();

    scrollController = ScrollController()
      ..addListener(() => bloc.scroolListener(scrollController));
    super.initState();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<NotificationsListModel>>(
      stream: bloc.outNotificacoes,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data.length == 0) {
          return Center(child: CircularProgressIndicator());
        } else {
          return ListView.builder(
            controller: scrollController,
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              var currentItem = snapshot.data[index];
              return ListTile(
                title: Text(currentItem.titulo),
                subtitle: Text(currentItem.enviadopor),
                trailing: Column(
                  children: <Widget>[
                    Text(currentItem.tipo.texto),
                    Text(currentItem.enviadoem),
                  ],
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => NotificationResumeScreen(
                            model: NotificationResumeModel.fromJson(
                                currentItem.parsedJson),
                          ),
                    ),
                  );
                },
              );
            },
          );
        }
      },
    );
  }
}
