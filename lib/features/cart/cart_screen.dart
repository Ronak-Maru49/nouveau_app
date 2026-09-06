import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../core/payments/razorpay_checkout.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/providers/cart_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/widgets/app_buttons.dart';
import '../../core/widgets/app_navbar.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  static const _apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:5000',
  );
  final _dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 8),
      receiveTimeout: const Duration(seconds: 8)));
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _notesController = TextEditingController();
  Razorpay? _razorpay;
  bool _placingOrder = false;
  String? _activeOrderId;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      _razorpay = Razorpay();
      _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
      _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
      _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    }
  }

  @override
  void dispose() {
    _razorpay?.clear();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _openCheckoutForm() async {
    final auth = context.read<AuthProvider>();
    _nameController.text = auth.user?.name ?? '';
    _emailController.text = auth.user?.email ?? '';
    _phoneController.text = '';
    _addressController.text = '';
    _cityController.text = '';
    _stateController.text = '';
    _pincodeController.text = '';
    _notesController.text = '';

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Complete your order'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Full name'),
                    validator: (value) =>
                        (value == null || value.trim().isEmpty)
                            ? 'Required'
                            : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (value) => (value == null || value.contains('@'))
                        ? null
                        : 'Valid email required',
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration:
                        const InputDecoration(labelText: 'Phone number'),
                    validator: (value) =>
                        (value == null || value.trim().length >= 10)
                            ? null
                            : 'Required',
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _addressController,
                    maxLines: 2,
                    decoration: const InputDecoration(labelText: 'Address'),
                    validator: (value) =>
                        (value == null || value.trim().isEmpty)
                            ? 'Required'
                            : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _cityController,
                    decoration: const InputDecoration(labelText: 'City'),
                    validator: (value) =>
                        (value == null || value.trim().isEmpty)
                            ? 'Required'
                            : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _stateController,
                    decoration: const InputDecoration(labelText: 'State'),
                    validator: (value) =>
                        (value == null || value.trim().isEmpty)
                            ? 'Required'
                            : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _pincodeController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'PIN code'),
                    validator: (value) =>
                        (value == null || value.trim().length < 4)
                            ? 'Required'
                            : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _notesController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                        labelText: 'Delivery notes (optional)'),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                if (!_formKey.currentState!.validate()) return;
                Navigator.of(context).pop();
                await _placeOrder(
                  name: _nameController.text.trim(),
                  email: _emailController.text.trim(),
                  phone: _phoneController.text.trim(),
                  address: _addressController.text.trim(),
                  city: _cityController.text.trim(),
                  state: _stateController.text.trim(),
                  pincode: _pincodeController.text.trim(),
                  notes: _notesController.text.trim(),
                );
              },
              child: const Text('Pay now'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _placeOrder({
    required String name,
    required String email,
    required String phone,
    required String address,
    required String city,
    required String state,
    required String pincode,
    required String notes,
  }) async {
    final cart = context.read<CartProvider>();
    if (cart.lines.isEmpty) return;

    setState(() => _placingOrder = true);
    final shippingFee = cart.subtotal >= 2500 ? 0.0 : 99.0;
    final totalAmount = cart.subtotal + shippingFee;
    final order = {
      'customer': {
        'name': name,
        'email': email,
        'phone': phone,
      },
      'shipping': {
        'address': address,
        'city': city,
        'state': state,
        'pincode': pincode,
        'notes': notes,
      },
      'items': cart.lines
          .map((line) => {
                'productId': line.product.id,
                'title': line.product.title,
                'size': line.size,
                'quantity': line.quantity,
                'price': line.product.price,
                'total': line.lineTotal,
              })
          .toList(),
      'subtotal': cart.subtotal,
      'shippingFee': shippingFee,
      'discount': 0.0,
      'totalAmount': totalAmount,
      'payment': {'method': 'razorpay', 'status': 'pending'},
      'notes': notes,
    };

    try {
      final response =
          await _dio.post('$_apiBaseUrl/api/orders', data: order);
      final data = response.data as Map<String, dynamic>;
      _activeOrderId = data['_id']?.toString() ?? data['id']?.toString();
      final paymentData = data['payment'] as Map<String, dynamic>?;

      if (paymentData != null && paymentData['orderId'] != null) {
        await _openRazorpay(paymentData, name, email, phone);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Order saved. Your bill is ready for payment. ${paymentData?['message'] ?? ''}'
                      .trim()),
              backgroundColor: AppColors.crimson,
            ),
          );
        }
        cart.clear();
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('We could not create the order. Please try again.'),
            backgroundColor: AppColors.crimson,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _placingOrder = false);
      }
    }
  }

  Future<void> _openRazorpay(
    Map<String, dynamic> paymentData,
    String name,
    String email,
    String phone,
  ) async {
    final key = paymentData['keyId']?.toString() ?? '';
    final orderId = paymentData['orderId']?.toString() ?? '';
    final amount = paymentData['amount'] ?? 0;

    if (key.isEmpty || orderId.isEmpty || amount == 0) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              paymentData['message']?.toString().isNotEmpty == true
                  ? 'Razorpay order could not be created: ${paymentData['message']}'
                  : 'Razorpay keys are not configured on the backend.',
            ),
            backgroundColor: AppColors.crimson,
          ),
        );
      }
      return;
    }

    final options = {
      'key': key,
      'amount': amount,
      'name': 'Nouveau',
      'description': 'Nouveau order payment',
      'order_id': orderId,
      'prefill': {'contact': phone, 'email': email, 'name': name},
      'theme': {'color': '#B76E79'},
    };

    try {
      if (kIsWeb) {
        final opened = await openRazorpayWebCheckout(
          options: options,
          onSuccess: (paymentId, orderId, signature) => _markPaymentPaid(
            paymentId: paymentId,
            orderId: orderId,
            signature: signature,
          ),
        );
        if (!opened && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Razorpay checkout was closed.'),
              backgroundColor: AppColors.crimson,
            ),
          );
        }
        return;
      }

      _razorpay?.open(options);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Razorpay could not be opened: $error'),
            backgroundColor: AppColors.crimson,
          ),
        );
      }
    }
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    await _markPaymentPaid(
      paymentId: response.paymentId,
      orderId: response.orderId,
      signature: response.signature,
    );
  }

  Future<void> _markPaymentPaid({
    String? paymentId,
    String? orderId,
    String? signature,
  }) async {
    if (_activeOrderId == null) return;
    try {
      final response = await _dio.patch(
        '$_apiBaseUrl/api/orders/$_activeOrderId/payment',
        data: {
          'paymentId': paymentId,
          'orderId': orderId,
          'signature': signature,
          'method': 'razorpay',
        },
      );
      if (response.statusCode != 200) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
        );
      }
    } on DioException catch (error) {
      if (mounted) {
        final message = error.response?.data is Map
            ? (error.response?.data['error']?.toString() ??
                'Payment verification failed.')
            : 'Payment verification failed. Please contact support.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: AppColors.crimson),
        );
      }
      return;
    }

    if (mounted) {
      context.read<CartProvider>().clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment successful. Your order is confirmed.'),
          backgroundColor: AppColors.crimson,
        ),
      );
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Payment failed: ${response.message}'),
          backgroundColor: AppColors.crimson,
        ),
      );
    }
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('External wallet selected: ${response.walletName}'),
          backgroundColor: AppColors.crimson,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final cart = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppNavBar(
        cartCount: cart.itemCount,
        isAuthenticated: auth.isAuthenticated,
        userInitials: auth.user?.initials,
        onMenuTap: () {},
        onSearchTap: () {},
        onWishlistTap: () => context.go('/wishlist'),
        onCartTap: () {},
        onProfileTap: () => context.go('/profile'),
      ),
      body: cart.lines.isEmpty
          ? const _EmptyCart()
          : _CartBody(
              placingOrder: _placingOrder, onPlaceOrder: _openCheckoutForm),
    );
  }
}

class _CartBody extends StatelessWidget {
  final bool placingOrder;
  final VoidCallback onPlaceOrder;

  const _CartBody({required this.placingOrder, required this.onPlaceOrder});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('Cart', style: AppTypography.sectionTitle(28)),
        const SizedBox(height: 16),
        ...cart.lines.map(
          (line) => Card(
            color: Colors.white,
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  const Icon(Icons.checkroom, color: AppColors.crimson),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(line.product.title,
                            style: AppTypography.poppins(
                                fontWeight: FontWeight.w700)),
                        Text(
                            '${line.size} - ${CurrencyFormatter.inr(line.product.price)}',
                            style: AppTypography.poppins(
                                fontSize: 12, color: AppColors.textMuted)),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => context
                        .read<CartProvider>()
                        .updateQuantity(
                            line.product, line.size, line.quantity - 1),
                    icon: const Icon(Icons.remove_circle_outline),
                  ),
                  Text('${line.quantity}',
                      style:
                          AppTypography.poppins(fontWeight: FontWeight.w700)),
                  IconButton(
                    onPressed: () => context
                        .read<CartProvider>()
                        .updateQuantity(
                            line.product, line.size, line.quantity + 1),
                    icon: const Icon(Icons.add_circle_outline),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Text('Subtotal',
                style: AppTypography.poppins(
                    fontSize: 16, fontWeight: FontWeight.w700)),
            const Spacer(),
            Text(CurrencyFormatter.inr(cart.subtotal),
                style: AppTypography.sectionTitle(22)),
          ],
        ),
        const SizedBox(height: 20),
        Center(
          child: PrimaryPillButton(
            label: placingOrder ? 'PLACING ORDER' : 'PLACE ORDER',
            disabled: placingOrder,
            onPressed: onPlaceOrder,
            trailing:
                const Icon(Icons.receipt_long, color: Colors.white, size: 16),
          ),
        ),
      ],
    );
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.shopping_bag_outlined,
                size: 56, color: AppColors.textLight),
            const SizedBox(height: 16),
            Text('Your cart is empty',
                style: AppTypography.playfair(
                    fontSize: 20, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text('Add products from the shop to build your order.',
                textAlign: TextAlign.center,
                style: AppTypography.poppins(color: AppColors.textMuted)),
            const SizedBox(height: 24),
            PrimaryPillButton(
                label: 'START SHOPPING', onPressed: () => context.go('/shop')),
          ],
        ),
      ),
    );
  }
}
