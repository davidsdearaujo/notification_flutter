import 'package:flutter/material.dart';
import 'package:flutter_inappbrowser/flutter_inappbrowser.dart';

class YoutubePlayerWidget extends StatefulWidget {
  @override
  _YoutubePlayerWidgetState createState() => _YoutubePlayerWidgetState(link);

  final String link;
  final bool autoPlay;
  YoutubePlayerWidget({@required this.link, this.autoPlay = false});
}

class _YoutubePlayerWidgetState extends State<YoutubePlayerWidget> {
  final String link;
  _YoutubePlayerWidgetState(this.link);
  InAppWebViewController _controller;

  String get _url {
    String response;
    RegExp rgx = RegExp(r".*(youtu.be\/|v\/|u\/\w\/|embed\/|watch\?v=|\&v=|\?v=)([^#\&\?]*).*");
    print(rgx.hasMatch(link));
    var t = rgx.allMatches(link);
    response = (t.length > 0 && t.last?.groupCount != null && t.last.groupCount >= 2) ? t.last.group(2) : link;
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: InAppWebView(
        initialUrl: "https://www.youtube.com/embed/${_url}" + (widget.autoPlay ? "?autoplay=1" : ""),
        onWebViewCreated: (InAppWebViewController controller) {
          _controller = controller;
        },
      ),
    );
  }
}
