import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../drawer.dart';

class YouTubePage extends StatefulWidget {
  const YouTubePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _YouTubePageState createState() => _YouTubePageState();
}

class _YouTubePageState extends State<YouTubePage> {
  bool _isConnectedToInternet =
      true; // Variável para armazenar o status de conectividade à internet

  @override
  void initState() {
    super.initState();
    verificarConectividadeInternet();
  }

  Future<void> verificarConectividadeInternet() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _isConnectedToInternet = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isConnectedToInternet) {
      return Scaffold(
        appBar: AppBar(centerTitle: true, title: const Text('YouTube')),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Erro 404: Internet não encontrada ! 🕵️‍♂️🌐 \nVerifique seu Wi-Fi ou espere a mágica dos dados móveis acontecer ! 📶😄',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 30),
              SpinKitFadingCircle(
                color: Colors.black,
                size: 30,
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('YouTube'),
      ),
       drawer: const CustomDrawer(),
      body: WebViewWidget(controller: controller),
    );
  }

  WebViewController controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          // Atualize a barra de progresso.
        },
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) {
          if (request.url.startsWith('https://www.youtube.com/')) {
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    )
    ..loadRequest(Uri.parse('https://www.youtube.com/'));
}
