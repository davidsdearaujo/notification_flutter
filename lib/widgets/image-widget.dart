import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  final String imageUrl;
  final String text;

  ImageWidget({@required this.imageUrl, this.text = "Imagem"});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Flexible(
            flex: 10,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Hero(
                  tag: imageUrl ?? "images/sem-foto.jpeg",
                  child: imageUrl == null
                      ? Image.asset(
                          "images/sem_foto.png",
                          fit: BoxFit.fitWidth,
                        )
                      : Image.network(
                          imageUrl,
                          fit: BoxFit.fitWidth,
                        ),
                ),
                Container(
                  alignment: Alignment.topRight,
                  padding: const EdgeInsets.only(top: 35, right: 5),
                  child: Material(
                    type: MaterialType.transparency,
                    child: IconButton(
                      icon: Icon(
                        Icons.close,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      iconSize: 35,
                    ),
                  ),
                )
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child: Align(
              alignment: Alignment.topCenter,
              child: Hero(
                tag: text,
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 35,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  static void show(BuildContext context, String urlImagem, {String text}) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => ImageWidget(
              imageUrl: urlImagem,
              text: text ?? "Imagem",
            ),
      ),
    );
  }
}
