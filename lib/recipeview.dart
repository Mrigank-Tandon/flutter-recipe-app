import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RecipeView extends StatefulWidget {
  String url;
  RecipeView(this.url);

  @override
  _RecipeViewState createState() => _RecipeViewState();
}

class _RecipeViewState extends State<RecipeView> {
  late String finalurl;
  final Completer<WebViewController> controller =
      Completer<WebViewController>();

  @override
  void initState() {
    if (widget.url.toString().contains("http://")) {
      finalurl = widget.url.toString().replaceAll("http://", "https://");
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url:finalurl ,
      withZoom: true,
    
      hidden: true,
      appBar: AppBar(
        title: Text("Flutter Food Recipe App"),
      ),
      initialChild: Container(
        child: WebView(
          initialUrl: finalurl,
          
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            setState(() {
              controller.complete(webViewController);
            });
          },
        ),
      ),
    );
  }
}
