typedef RazorpaySuccessHandler = Future<void> Function(
  String? paymentId,
  String? orderId,
  String? signature,
);

Future<bool> openRazorpayWebCheckout({
  required Map<String, dynamic> options,
  required RazorpaySuccessHandler onSuccess,
}) async {
  return false;
}
