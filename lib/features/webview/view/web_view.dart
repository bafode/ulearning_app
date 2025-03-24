import 'package:beehive/common/utils/app_colors.dart';
import 'package:beehive/features/application/provider/application_nav_notifier.dart';
import 'package:beehive/features/webview/notifiers/webview_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Webview extends ConsumerStatefulWidget {
  const Webview({super.key});

  @override
  ConsumerState<Webview> createState() => _WebviewState();
}

class _WebviewState extends ConsumerState<Webview> {
  late WebViewController controller;
  final ValueNotifier<int> progressNotifier = ValueNotifier<int>(0);
  bool isApplication = false;
  bool _isInitialized = false;
  bool _hasError = false;
  String _errorMessage = '';
  String _url = '';

  @override
  void initState() {
    super.initState();
    // On utilise un Future.microtask pour s'assurer que cette opération se produit
    // après la construction du widget mais avant le rendu
    Future.microtask(() {
      _prepareWebView();
    });
  }

  void _prepareWebView() {
    try {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
              {};

      isApplication = args['url'] == null;
      _url = args['url'] as String? ?? 'https://beehiveapp.fr/contact';

      // Mise à jour du provider à l'extérieur des méthodes de cycle de vie
      Future.microtask(() {
        ref.read(webviewProvider.notifier).onUrlChanged(UrlChanged(_url));
      });

      _initializeController();
    } catch (e) {
      debugPrint("Erreur lors de la préparation de WebView: $e");
      _handleError("Erreur de préparation: $e");
    }
  }

  void _initializeController() {
    try {
      controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(Colors.white)
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              progressNotifier.value = progress;
            },
            onPageStarted: (String url) {
              debugPrint("Page started loading: $url");
              // Réinitialiser l'état d'erreur quand une nouvelle page commence à charger
              if (_hasError) {
                setState(() {
                  _hasError = false;
                  _errorMessage = '';
                });
              }
            },
            onPageFinished: (String url) {
              debugPrint("Page finished loading: $url");
            },
            onHttpError: (HttpResponseError error) {
              debugPrint("HTTP error: $error");
              _handleError("Erreur HTTP $error");
            },
            onWebResourceError: (WebResourceError error) {
              debugPrint("Web resource error: ${error.description}");
              _handleError("Erreur de chargement: ${error.description}");
            },
            onNavigationRequest: (NavigationRequest request) {
              if (request.url.startsWith('https://www.youtube.com/')) {
                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            },
          ),
        )
        ..loadRequest(Uri.parse(_url))
        ..setOnConsoleMessage((message) {
          debugPrint("Console WebView: ${message.message}");
        });

      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      debugPrint("Erreur d'initialisation de WebView: $e");
      _handleError("Impossible d'initialiser la page web: $e");
    }
  }

  void _handleError(String message) {
    setState(() {
      _hasError = true;
      _errorMessage = message;
    });

    // Afficher un SnackBar avec le message d'erreur
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_errorMessage),
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: 'Réessayer',
            onPressed: () {
              _reloadWebView();
            },
          ),
        ),
      );
    }
  }

  void _reloadWebView() {
    setState(() {
      _hasError = false;
      _errorMessage = '';
    });
    if (_isInitialized) {
      controller.reload();
    } else {
      _initializeController();
    }
  }

  @override
  void dispose() {
    try {
      if (_isInitialized) {
        // Arrêter tous les processus en cours avant de nettoyer
       // controller.stopLoading();
        // Nettoyer le cache pour éviter les fuites mémoire
        controller.clearCache();
        // Détruire la WebView proprement
        controller.clearLocalStorage();
      }
    } catch (e) {
      debugPrint("Erreur lors de la fermeture de WebView: $e");
    }

    // Libérer les notifiers
    progressNotifier.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(webviewProvider);

    return WillPopScope(
      onWillPop: () async {
        // Intercepter le bouton retour pour gérer la navigation dans la WebView
        if (_isInitialized && await controller.canGoBack()) {
          await controller.goBack();
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: isApplication
              ? IconButton(
                  icon: const Icon(
                    Icons.menu,
                    color: Colors.white,
                  ),
                  onPressed: () => {
                    ref.read(appZoomControllerProvider).toggle?.call(),
                  },
                )
              : IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () async {
                    if (_isInitialized && await controller.canGoBack()) {
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
              return progress < 100 && progress > 0
                  ? LinearProgressIndicator(
                      value: progress / 100.0, backgroundColor: Colors.white)
                  : const SizedBox.shrink();
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: _reloadWebView,
            ),
          ],
        ),
        backgroundColor: Colors.white,
        body: _hasError
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 60,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Une erreur est survenue',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        _errorMessage,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _reloadWebView,
                      child: const Text('Réessayer'),
                    ),
                  ],
                ),
              )
            : !_isInitialized || state.url.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : WebViewWidget(controller: controller),
      ),
    );
  }
}
