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
  final ValueNotifier<int> progressNotifier = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
              {};
      final url = args['url'] as String? ?? 'https://beehiveapp.fr/contact';

      ref.read(webviewProvider.notifier).onUrlChanged(UrlChanged(url));

      controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              progressNotifier.value = progress;
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
    progressNotifier.dispose();
    controller.clearCache();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(webviewProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () async {
            if (await controller.canGoBack()) {
              await controller.goBack();
            } else {
              Navigator.pop(context);
            }
          },
        ),
        backgroundColor: AppColors.primaryElement,
        title: ValueListenableBuilder<int>(
          valueListenable: progressNotifier,
          builder: (context, progress, child) {
            return progress < 100
                ? LinearProgressIndicator(
                    value: progress / 100.0, backgroundColor: Colors.white)
                : const SizedBox.shrink();
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: state.url.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : WebViewWidget(controller: controller),
    );
  }
}
