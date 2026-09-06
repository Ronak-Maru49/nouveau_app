import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

typedef RazorpaySuccessHandler = Future<void> Function(
  String? paymentId,
  String? orderId,
  String? signature,
);

Future<bool> openRazorpayWebCheckout({
  required Map<String, dynamic> options,
  required RazorpaySuccessHandler onSuccess,
}) async {
  final razorpayConstructor =
      globalContext.getProperty<JSFunction?>('Razorpay'.toJS);
  if (razorpayConstructor == null) return false;

  final completer = Completer<bool>();
  final checkoutOptions = _toJsObject(options);
  checkoutOptions.setProperty(
      'handler'.toJS,
      ((JSAny? response) {
        unawaited(_handlePaymentSuccess(
          response,
          onSuccess,
          completer,
        ));
      }).toJS);
  checkoutOptions.setProperty(
      'modal'.toJS,
      _toJsObject({
        'ondismiss': (() {
          if (!completer.isCompleted) completer.complete(false);
        }).toJS,
      }));

  final checkout =
      razorpayConstructor.callAsConstructor(checkoutOptions) as JSObject;
  final open = checkout.getProperty<JSFunction?>('open'.toJS);
  if (open == null) return false;
  open.callAsFunction(checkout);

  return completer.future.timeout(
    const Duration(minutes: 10),
    onTimeout: () => false,
  );
}

Future<void> _handlePaymentSuccess(
  JSAny? response,
  RazorpaySuccessHandler onSuccess,
  Completer<bool> completer,
) async {
  final responseObject = response as JSObject?;
  await onSuccess(
    responseObject?.getProperty<JSString?>('razorpay_payment_id'.toJS)?.toDart,
    responseObject?.getProperty<JSString?>('razorpay_order_id'.toJS)?.toDart,
    responseObject?.getProperty<JSString?>('razorpay_signature'.toJS)?.toDart,
  );
  if (!completer.isCompleted) completer.complete(true);
}

JSObject _toJsObject(Map<String, dynamic> values) {
  final result = JSObject();
  for (final entry in values.entries) {
    result.setProperty(entry.key.toJS, _toJsValue(entry.value));
  }
  return result;
}

JSAny? _toJsValue(Object? value) {
  if (value == null) return null;
  if (value is String) return value.toJS;
  if (value is num) return value.toJS;
  if (value is bool) return value.toJS;
  if (value is Map<String, dynamic>) return _toJsObject(value);
  if (value is List) {
    return value.map(_toJsValue).toList().toJS;
  }
  return value.toString().toJS;
}
