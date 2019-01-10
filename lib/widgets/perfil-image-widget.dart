import 'package:flutter/material.dart';

import 'image-widget.dart';

class PerfilImageWidget extends StatelessWidget {
  final String imageUrl;
  final double size;
  final IconData icon;
  final double iconSize;
  final VoidCallback onPress;
  final bool center;

  PerfilImageWidget(
      {@required this.imageUrl = "",
      this.size = 80,
      this.icon,
      this.iconSize = 45,
      this.onPress,
      this.center = true}) {
    //"http://vargasmotos.com.br/images/sem_foto.png";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: center
          ? AlignmentDirectional.topCenter
          : AlignmentDirectional.topStart,
      padding: EdgeInsets.only(top: 15),
      child: Hero(
        tag: imageUrl,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Material(
              color: Colors.transparent,
              child: Stack(
                children: <Widget>[
                  icon == null
                      ? SizedBox()
                      : CircleAvatar(
                          radius: 100,
                          backgroundColor: Color.fromRGBO(0, 0, 0, 490),
                        ),
                  InkWell(
                    borderRadius: BorderRadius.circular(100),
                    onTap: onPress ?? () => ImageWidget.show(context, imageUrl),
                    child: null,
                  ),
                ],
              ),
            ),
            icon == null
                ? SizedBox()
                : IgnorePointer(
                    child: Icon(icon, size: iconSize),
                  ),
          ],
        ),
      ),
    );
  }
}
