import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomeScreen extends StatelessWidget {
  
  WebViewController webViewController = WebViewController()
  ..loadRequest(Uri.parse('https://blog.codefactory.ai'))
  ..setJavaScriptMode(JavaScriptMode.unrestricted);
  
  HomeScreen({Key? key}) : super(key: key);
  //const HomeScreen 인스턴스 위젯은 하드웨어 리소스를 적게 사용할 수 있다.
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[100],
          title: TextButton(
            onPressed: () {
              webViewController.loadRequest(Uri.parse('https://blog.codefactory.ai'));
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: Text('코드팩토리 홈'),
          ),
        centerTitle: true,

        leading: IconButton(
            onPressed: () {
              webViewController.goBack();
            },
            icon: Icon(
              Icons.arrow_back_ios,
            )
        ),

        actions: [


          IconButton(
              onPressed: () {
                webViewController.goForward();
              },
              icon: Icon(
                Icons.arrow_forward_ios,
              )),
        ],
      ),

      body: WebViewWidget(
        controller: webViewController,
      )
    );
  }
}