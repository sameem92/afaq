import 'dart:async';
import 'dart:io';

import 'package:Afaq/theme.dart';
import 'package:Afaq/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatelessWidget {
  final String url;
  final String? title;
  WebViewPage({Key? key, this.url = MyTheme.webSite, this.title})
      : super(key: key) {
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  final progressVal = 1.obs;
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainBackgroundcolor,
        title: Text(title ?? 'information'.tr,
            style: const TextStyle(color: Colors.black)),
        centerTitle: true,
        elevation: 0.3,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Builder(builder: (BuildContext context) {
        return Stack(
          children: [
            WebView(
              initialUrl: url,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _controller.complete(webViewController);
              },
              onProgress: (int progress) {
                debugPrint("WebView is loading (progress : $progress%)");
                progressVal.value = progress;
              },
              javascriptChannels: <JavascriptChannel>{
                _toasterJavascriptChannel(context),
              },
              navigationDelegate: (NavigationRequest request) {
                if (request.url.startsWith('https://www.youtube.com/')) {
                  //debugPrint('blocking navigation to $request}');
                  return NavigationDecision.prevent;
                }
                //debugPrint('allowing navigation to $request');
                return NavigationDecision.navigate;
              },
              onPageStarted: (String url) {
                debugPrint('Page started loading: $url');
              },
              onPageFinished: (String url) {
                debugPrint('Page finished loading: $url');
              },
              gestureNavigationEnabled: true,
            ),
            Positioned(
              child: Obx(
                () => Opacity(
                  opacity: 1 - (progressVal.value / 100),
                  child: Center(
                    child: Loading.type2(),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          // ignore: deprecated_member_use
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }
}
