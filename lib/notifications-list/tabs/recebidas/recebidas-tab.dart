import 'package:flutter/material.dart';
import 'package:loadmore/loadmore.dart';

import '../../../notfication-display/notification-display-model.dart';
import '../../../notfication-display/notification-display-screen.dart';
import '../../../widgets/loading/loading-widget.dart';
import '../../notifications-list-model.dart';
import 'recebidas-bloc.dart';

class RecebidasTab extends StatefulWidget {
  final String uid;

  const RecebidasTab({Key key, @required this.uid})
      : assert(uid != null),
        super(key: key);
  @override
  _RecebidasTabState createState() => _RecebidasTabState();
}

class _RecebidasTabState extends State<RecebidasTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  RecebidasBloc bloc;
  // ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    bloc = RecebidasBloc(widget.uid);
    bloc..buscarNotificacoes();
    // _scrollController = new ScrollController()..addListener(_scrollListener);
  }

  // void _scrollListener() {
  //   if ((_scrollController.offset >
  //           _scrollController.position.maxScrollExtent - 300) &&
  //       !bloc.isLoading) bloc.buscarNotificacoes();
  // }

  @override
  void dispose() {
    super.dispose();
    bloc?.dispose();
    // _scrollController
    //   ..removeListener(_scrollListener)
    //   ..dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<NotificationsListModel>>(
      stream: bloc.apiTotalFlux,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data.length == 0) {
          return LoadingWidget(small: false);
        } else {
          return LoadMore(
            isFinish: bloc.isFinish,
            onLoadMore: bloc.buscarNotificacoes,
            textBuilder: (status) {
              switch (status) {
                case LoadMoreStatus.fail:
                  return "Não foi possível buscar os dados";

                case LoadMoreStatus.nomore:
                case LoadMoreStatus.loading:
                case LoadMoreStatus.idle:
                  return "";
              }
            },
            child: ListView.builder(
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
                        builder: (context) => NotificationDisplayScreen(
                              model: NotificationDisplayModel.fromJson(
                                currentItem.parsedJson,
                              ),
                            ),
                      ),
                    );
                  },
                );
              },
            ),
          );
        }
      },
    );
  }
}
