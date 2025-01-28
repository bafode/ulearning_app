import 'package:beehive/common/utils/app_colors.dart';
import 'package:beehive/features/webview/notifiers/webview_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Webview extends ConsumerStatefulWidget {
  const Webview({super.key});

  @override
  ConsumerState<Webview> createState() => _PayWebviewPage();
}

class _PayWebviewPage extends ConsumerState<Webview> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();

    // Initialiser la WebView après le chargement des arguments
    Future.delayed(Duration.zero, () {
      final args = ModalRoute.of(context)?.settings.arguments;

      // Vérifier et définir l'URL à charger
      final String url = (args is Map<String, dynamic> &&
              args["url"] is String &&
              args["url"].isNotEmpty)
          ? args["url"]
          : 'https://beehiveapp.fr/contact';

      // Notifier le provider de l'URL actuelle
      ref.read(webviewProvider.notifier).onUrlChanged(UrlChanged(url));

      // Configurer le contrôleur WebView
      controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              // Vous pouvez ajouter une logique pour afficher la progression si nécessaire
            },
            onPageStarted: (String url) {
              debugPrint("Page started loading: $url");
            },
            onPageFinished: (String url) {
              debugPrint("Page finished loading: $url");
            },
            onHttpError: (HttpResponseError error) {
              debugPrint("HTTP error: $error");
            },
            onWebResourceError: (WebResourceError error) {
              debugPrint("Web resource error: ${error.description}");
            },
            onNavigationRequest: (NavigationRequest request) {
              if (request.url.startsWith('https://www.youtube.com/')) {
                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            },
          ),
        )
        ..loadRequest(Uri.parse(url));
    });
  }

  @override
  void dispose() {
    // Nettoyer le cache et réinitialiser la WebView
    controller.clearCache();
    controller.loadRequest(Uri.parse('about:blank'));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(webviewProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: AppColors.primaryElement,
      ),
      backgroundColor: Colors.white,
      body: state.url.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : WebViewWidget(controller: controller),
    );
  }
}
