import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ulearning_app/features/buy_course/controller/buy_course_controller.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BuyCourse extends ConsumerStatefulWidget {
  const BuyCourse({super.key});

  @override
  ConsumerState<BuyCourse> createState() => _BuyCourseState();
}

class _BuyCourseState extends ConsumerState<BuyCourse> {
  late var args;
  late WebViewController webViewController;

  @override
  void didChangeDependencies() {
    var id = ModalRoute.of(context)!.settings.arguments as Map;

    args = id["id"];
    print("args: $args");
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var courseBuy =
        ref.watch(buyCourseControllerProvider(index: args.toString()));
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
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
      ..loadRequest(
          Uri.parse('https://stripe.com/en-fr/payments/payment-links'));
    return Scaffold(
      appBar: AppBar(),
      body: courseBuy.when(
        data: (data) {
          if (data == null) {
            return Center(
              child: Text(
                "Order exist or something went wrong",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22.sp,
                ),
              ),
            );
          }
          return WebViewWidget(controller: webViewController);
        },
        error: (error, trace) => Text("Error getting webview"),
        loading: () => WebViewWidget(controller: webViewController),
      ),
    );
  }
}
