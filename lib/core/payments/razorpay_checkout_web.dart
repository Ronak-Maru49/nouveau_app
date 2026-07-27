import 'dart:async';
import 'dart:html' as html;
import 'dart:js_util' as js_util;

typedef RazorpaySuccessHandler = Future<void> Function(
  String? paymentId,
  String? orderId,
  String? signature,
);

Future<bool> openRazorpayWebCheckout({
  required Map<String, dynamic> options,
  required RazorpaySuccessHandler onSuccess,
}) async {
  final razorpayConstructor = js_util.getProperty<Object?>(
    js_util.globalThis,
    'Razorpay',
  );
  if (razorpayConstructor == null) return false;

  final completer = Completer<bool>();
  final checkoutOptions = Map<String, dynamic>.from(options);
  checkoutOptions['handler'] = js_util.allowInterop((dynamic response) async {
    await onSuccess(
      js_util.getProperty<String?>(response, 'razorpay_payment_id'),
      js_util.getProperty<String?>(response, 'razorpay_order_id'),
      js_util.getProperty<String?>(response, 'razorpay_signature'),
    );
    if (!completer.isCompleted) completer.complete(true);
  });
  checkoutOptions['modal'] = {
    'ondismiss': js_util.allowInterop(() {
      if (!completer.isCompleted) completer.complete(false);
    }),
  };

  final checkout = js_util.callConstructor(
    razorpayConstructor,
    [js_util.jsify(checkoutOptions)],
  );
  js_util.callMethod<void>(checkout, 'open', []);

  html.window.onBeforeUnload.first.then((_) {
    if (!completer.isCompleted) completer.complete(false);
  });

  return completer.future.timeout(
    const Duration(minutes: 10),
    onTimeout: () => false,
  );
}
