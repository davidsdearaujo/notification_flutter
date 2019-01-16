import 'package:flutter/material.dart';

import '../../../notfication-resume/notification-resume-model.dart';
import '../../../notfication-resume/notification-resume-screen.dart';
import '../../notifications-list-model.dart';
import 'enviadas-bloc.dart';

class EnviadasTab extends StatefulWidget {
  @override
  _EnviadasTabState createState() => _EnviadasTabState();
}

class _EnviadasTabState extends State<EnviadasTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  EnviadasBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = EnviadasBloc()..buscarNotificacoes();
  }

  @override
  void dispose() {
    super.dispose();
    bloc.dispose();
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
            controller: bloc.scrollController,
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              var currentItem = snapshot.data[index];
              return ListTile(
                title: Text(currentItem.titulo),
                subtitle: Text(currentItem.enviadopor),
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(currentItem.tipo.texto),
                    SizedBox(height: 5),
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
