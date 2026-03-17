import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/app_logger.dart';

class PaymentWebViewPage extends StatefulWidget {
  final String paymentUrl;
  final String orderId;

  const PaymentWebViewPage({
    super.key,
    required this.paymentUrl,
    required this.orderId,
  });

  /// Shows the payment webview and returns:
  /// - true  = payment confirmed
  /// - false = payment failed
  /// - null  = user closed
  static Future<bool?> show(
    BuildContext context, {
    required String paymentUrl,
    required String orderId,
  }) async {
    return Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => PaymentWebViewPage(
          paymentUrl: paymentUrl,
          orderId: orderId,
        ),
      ),
    );
  }

  @override
  State<PaymentWebViewPage> createState() => _PaymentWebViewPageState();
}

class _PaymentWebViewPageState extends State<PaymentWebViewPage> {
  late final WebViewController _controller;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() => _isLoading = true);
            AppLogger.debug('[PaymentWebView] Loading: $url');
          },
          onPageFinished: (url) {
            setState(() => _isLoading = false);
            _checkPaymentResult(url);
          },
          onWebResourceError: (error) {
            AppLogger.error('[PaymentWebView] Error: ${error.description}');
            setState(() {
              _isLoading = false;
              _error = error.description;
            });
          },
          onNavigationRequest: (request) {
            final url = request.url;
            // Check for callback URLs
            if (url.contains('payment/success') || url.contains('payment/callback')) {
              Navigator.of(context).pop(true);
              return NavigationDecision.prevent;
            }
            if (url.contains('payment/cancel') || url.contains('payment/failed')) {
              Navigator.of(context).pop(false);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  void _checkPaymentResult(String url) {
    if (url.contains('payment/success') || url.contains('status=success')) {
      Navigator.of(context).pop(true);
    } else if (url.contains('payment/failed') || url.contains('status=failed')) {
      Navigator.of(context).pop(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Paiement #${widget.orderId}'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(null),
        ),
      ),
      body: Stack(
        children: [
          if (_error != null)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Erreur: $_error'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() => _error = null);
                      _controller.loadRequest(Uri.parse(widget.paymentUrl));
                    },
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            )
          else
            WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
