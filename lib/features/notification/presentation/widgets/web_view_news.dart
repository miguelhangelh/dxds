import 'dart:async';

import 'package:appdriver/global_widgets/global_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewContainer extends StatefulWidget {
  final String url;
  const WebViewContainer({Key? key, required this.url}) : super(key: key);

  @override
  _WebViewContainerState createState() => _WebViewContainerState();
}

class _WebViewContainerState extends State<WebViewContainer> {
  bool isLoading = true;
  int position = 1;

  final _key = UniqueKey();
  final Completer<WebViewController> _controller = Completer<WebViewController>();
  doneLoading(String A) {
    setState(() {
      position = 0;
    });
  }

  startLoading(String A) {
    setState(() {
      position = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: position,
          children: [
            WebView(
              zoomEnabled: true,
              key: _key,
              javascriptMode: JavascriptMode.unrestricted,
              initialUrl: widget.url,
              onWebViewCreated: (WebViewController webViewController) {
                _controller.complete(webViewController);
              },
              onProgress: (value) {
                if (value >= 100) {
                  setState(() {
                    position = 0;
                  });
                }
              },
            ),
            const Center(
              child: CircularProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }
}
