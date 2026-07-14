import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
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
  final _dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 8),
      receiveTimeout: const Duration(seconds: 8)));
  bool _placingOrder = false;

  Future<void> _placeOrder() async {
    final cart = context.read<CartProvider>();
    final auth = context.read<AuthProvider>();
    final user = auth.user;
    if (cart.lines.isEmpty || user == null) return;

    setState(() => _placingOrder = true);
    final order = {
      'customer': {'name': user.name, 'email': user.email},
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
      'paymentTarget': '8238713571',
      'ownerEmail': 'maruroank5@gmail.com',
    };

    try {
      await _dio.post('http://localhost:5000/api/orders', data: order);
    } catch (_) {
      // Checkout still opens email/UPI links when the local API is offline.
    }

    final bill = _billText(user.name, cart);
    final mailUri = Uri(
      scheme: 'mailto',
      path: 'maruroank5@gmail.com',
      queryParameters: {
        'cc': user.email,
        'subject': 'Nouveau order bill - ${user.name}',
        'body': bill,
      },
    );
    try {
      await launchUrl(mailUri, mode: LaunchMode.externalApplication);
    } catch (_) {}

    final upi = Uri.parse(
      'upi://pay?pa=8238713571@upi&pn=Nouveau&am=${cart.subtotal.toStringAsFixed(2)}&cu=INR&tn=Nouveau%20order',
    );
    try {
      await launchUrl(upi, mode: LaunchMode.externalApplication);
    } catch (_) {}

    cart.clear();
    if (mounted) {
      setState(() => _placingOrder = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Order placed and bill generated'),
            backgroundColor: AppColors.crimson),
      );
    }
  }

  String _billText(String name, CartProvider cart) {
    final rows = cart.lines
        .map((line) =>
            '${line.product.title} | Size: ${line.size} | Qty: ${line.quantity} | ${CurrencyFormatter.inr(line.lineTotal)}')
        .join('\n');
    return 'Nouveau order bill\nCustomer: $name\n\n$rows\n\nSubtotal: ${CurrencyFormatter.inr(cart.subtotal)}\nPayment number: 8238713571';
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
          : _CartBody(placingOrder: _placingOrder, onPlaceOrder: _placeOrder),
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
