import 'package:intl/intl.dart';

/// Formats prices the way nouveauz.com's `formatPrice` context helper does:
/// INR by default with the ₹ symbol and Indian digit grouping. The site
/// also supports multi-currency (USD, EUR, GBP, AUD, CAD, AED) via a
/// currency switcher in the navbar — this formatter is structured so that
/// a live exchange-rate provider can be plugged in later without changing
/// call sites.
class CurrencyFormatter {
  CurrencyFormatter._();

  static final NumberFormat _inr = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );

  static String inr(double amount) => _inr.format(amount);

  static String format(double amount, {String currencyCode = 'INR'}) {
    switch (currencyCode) {
      case 'INR':
        return inr(amount);
      default:
        // Placeholder passthrough until live FX rates are wired to the
        // /api/currency endpoint seen on the live site.
        return NumberFormat.currency(symbol: '$currencyCode ', decimalDigits: 0)
            .format(amount);
    }
  }
}
