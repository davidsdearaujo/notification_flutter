import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  Color color;
  final Color backgroundColor;
  final bool small;

  LoadingWidget({Key key, this.color, this.backgroundColor = Colors.white, this.small = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    color = color ?? Theme.of(context).accentColor;

    if (small)
      return Center(
        child: SizedBox(
          height: 15.0,
          width: 15.0,
          child: CircularProgressIndicator(
            backgroundColor: Colors.white,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      );
    else
      return Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.white,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      );
  }
}
