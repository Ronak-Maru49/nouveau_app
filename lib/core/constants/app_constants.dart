/// App-wide constants mirrored from nouveauz.com copy & config.
class AppConstants {
  AppConstants._();

  static const String brandName = 'Nouveau';
  static const String brandTagline = 'Wear Your Aura';
  static const String brandTaglineAlt = 'Own Your Aura';
  static const String brandSubtitle = 'INDIAN ETHNIC WEAR, REDEFINED';
  static const String heroDescription =
      'Timeless designs that celebrate tradition with a modern soul.';

  static const String aboutBlurb =
      'Premium women\'s wear crafted for the modern Indian. Celebrating '
      'the finest ethnic traditions alongside contemporary elegance.';

  static const String philosophyParagraph1 =
      'Born from the rich tapestry of Indian craftsmanship, Nouveau™ '
      'bridges the timeless and the contemporary. Each piece is a dialogue '
      'between heritage artisans and modern sensibility.';

  static const String philosophyParagraph2 =
      'We celebrate the Indian woman in two ways: through our ethnic '
      'heritage and through contemporary premium western silhouettes, all '
      'crafted with the same love for quality and craft.';

  static const String newArrivalsBlurb =
      "Handpicked pieces defining the season's most coveted looks — for "
      'the modern Indian woman';

  // Free-shipping threshold used in the marquee ticker. Not confirmed from
  // the captured network trace (value is fetched at runtime on the live
  // site); using a reasonable placeholder pending confirmation.
  static const int freeShippingThresholdInr = 1999;

  static const String whatsappNumber = '+917733881577';
  static const String whatsappUrl = 'https://wa.me/917733881577';
  static const String contactEmail = 'nouveauzone@gmail.com';
  static const String instagramUrl =
      'https://www.instagram.com/nouveauzon?igsh=aWc4bGltMGxkOWU2';
  static const String facebookUrl =
      'https://www.facebook.com/share/19294L8VGF/?mibextid=wwXIfr';

  static const String copyright =
      '© 2026 Nouveau™. All rights reserved. Women\'s Wear Only.';
  static const String madeWith = 'Made with ♥ in India';

  static const List<String> marqueeItems = [
    'Indian Ethnic Wear',
    'Premium Western Wear',
    'Nouveau™',
    "Women's Wear",
    'Free Shipping ₹$freeShippingThresholdInrDisplay+',
  ];

  static const String freeShippingThresholdInrDisplay = '1,999';
}
