import 'product_model.dart';

/// Local fallback catalogue — mirrors the exact seed array shipped in
/// nouveauz.com's production bundle (module 2769), used there as an
/// offline/first-load fallback before the live API responds.
///
/// In this app it powers Phase 1's Home screen out of the box. Once the
/// ASP.NET Core API is wired up (see ProductRepository), live data will
/// take over automatically.
class SeedProducts {
  SeedProducts._();

  static final List<Product> all = [
    _p('e1', 'Off White Maxi', 1396, 1800, 'Indian Ethnic Wear', 'Maxi',
        ['/ethnic1.jpeg'], ['L', 'XL'], 4.5, 12, 20, true, 22,
        'Beautiful Off White Maxi in Pure Cotton. Lightweight and comfortable, perfect for festive and casual wear.'),
    _p('e2', '3 Piece Off Shoulder with Inner', 4042, 5000, 'Indian Ethnic Wear', 'Set',
        ['/ethnic2.jpeg'], ['Free Size'], 4.8, 8, 15, true, 19,
        'Elegant 3 Piece Off Shoulder with Inner in Silk. Perfect for parties and festive occasions.'),
    _p('e3', 'Shirt and Pant Pair', 1543, 2000, 'Indian Ethnic Wear', 'Co-Ord Set',
        ['/ethnic3.jpeg'], ['Free Size'], 4.6, 15, 25, true, 23,
        'Stylish Shirt and Pant Pair in Pure Cotton. Comfortable and chic for everyday wear.'),
    _p('e4', 'Night Suit Pair', 880, 1200, 'Indian Ethnic Wear', 'Night Suit',
        ['/ethnic4.jpeg'], ['Free Size'], 4.4, 20, 30, false, 27,
        "Comfortable Night Suit Pair in Pure Cotton. Perfect for a good night's sleep."),
    _p('e5', 'Brown Maxi', 1396, 1800, 'Indian Ethnic Wear', 'Maxi',
        ['/ethnic5.jpeg'], ['L'], 4.7, 10, 10, true, 22,
        'Gorgeous Brown Maxi in Pure Cotton. Earthy tones for a natural, elegant look.'),
    _p('e6', 'Shirt and Cotton Palazzo Pant', 1543, 2000, 'Indian Ethnic Wear', 'Co-Ord Set',
        ['/ethnic6.jpeg'], ['Free Size'], 4.5, 18, 20, false, 23,
        'Trendy Shirt and Cotton Palazzo Pant in Pure Cotton. Breezy and stylish for all occasions.'),
    _p('e7', 'Cotton Jaipuri Shirt Top', 735, 1000, 'Indian Ethnic Wear', 'Top',
        ['/ethnic7.jpeg'], ['Free Size'], 4.3, 25, 40, false, 27,
        'Beautiful Cotton Jaipuri Shirt Top with traditional Rajasthani prints. Light and comfortable.'),
    _p('e8', 'Semi Silk Red with Gota Patti Border', 1396, 1800, 'Indian Ethnic Wear', 'Kurti',
        ['/ethnic8.jpeg'], ['L', 'XL'], 4.9, 30, 15, true, 22,
        'Stunning Semi Silk Red Kurti with Gota Patti Border. Perfect for festivals and celebrations.'),
    _p('e9', 'Jaipuri Cotton Top', 735, 1000, 'Indian Ethnic Wear', 'Top',
        ['/ethnic9.jpeg'], ['Free Size'], 4.4, 22, 35, false, 27,
        'Charming Jaipuri Cotton Top with vibrant prints. Casual and festive wear.'),
    _p('e10', 'Jodhpuri Kurti Palazzo with Gota Patti', 1396, 1800, 'Indian Ethnic Wear',
        'Co-Ord Set', ['/ethnic10.jpeg'], ['M', 'L', 'XL'], 4.8, 28, 18, true, 22,
        'Elegant Jodhpuri Kurti Palazzo Pair with Gota Patti Border in Silk. Regal and graceful.'),
    _p('e11', 'Jodhpuri Dupatta Pair', 2250, 2800, 'Indian Ethnic Wear', 'Set',
        ['/ethnic11.jpeg'], ['L', 'XL', 'XXL'], 4.7, 14, 12, false, 20,
        'Luxurious Jodhpuri Dupatta Pair in Cotton Silk Fabric. Perfect for special occasions.'),
    _p('e12', 'Chaniya Choli', 4042, 5000, 'Indian Ethnic Wear', 'Lehenga',
        ['/ethnic12.jpeg'], ['Free Size'], 5.0, 35, 8, true, 19,
        'Gorgeous Chaniya Choli in Silk. Perfect for Navratri and wedding celebrations.'),
    _p('e13', 'Khadi Cotton Frock', 1396, 1800, 'Indian Ethnic Wear', 'Frock',
        ['/ethnic13.jpeg'], ['S', 'L', 'XL', 'XXL'], 4.5, 16, 22, false, 22,
        'Stylish Frock in Khadi Cotton. Eco-friendly and comfortable for everyday wear.'),
    _p('e14', 'Shirt and Palazzo Cotton Pair', 1543, 2000, 'Indian Ethnic Wear', 'Co-Ord Set',
        ['/ethnic14.jpeg'], ['Free Size'], 4.6, 19, 28, false, 23,
        'Comfortable Shirt and Cotton Palazzo Pant in Pure Cotton. Versatile and stylish.'),
    _p('w1', 'Black Embellished Sequin Jumpsuit', 3300, 3300, 'Indian Western Wear',
        'Jumpsuit', ['/western2.jpeg'], ['S', 'M', 'L', 'XL'], 0, 0, 10, true, 0,
        'Stunning black wide-leg jumpsuit with intricate sequin and bead embellishment on the bodice. A showstopper for parties, receptions and festive evenings.'),
    _p('w2', 'Ivory Silk Corset & Skirt Set', 3300, 3300, 'Indian Western Wear',
        'Co-Ord Set', ['/western1.jpeg'], ['S', 'M', 'L', 'XL'], 0, 0, 10, true, 0,
        'Elegant ivory silk corset top paired with a flowy A-line maxi skirt. Timeless and graceful, perfect for weddings and festive occasions.'),
  ];

  static List<Product> get ethnicWear =>
      all.where((p) => p.category == 'Indian Ethnic Wear').toList();

  static List<Product> get westernWear =>
      all.where((p) => p.category == 'Indian Western Wear').toList();

  static List<Product> get newArrivals =>
      all.where((p) => p.isNew).take(4).toList();

  static List<Product> get trending {
    final western = westernWear;
    final rest = all.where((p) => !western.contains(p));
    return [...western, ...rest].take(4).toList();
  }

  static Product _p(
    String id,
    String title,
    num price,
    num originalPrice,
    String category,
    String subcategory,
    List<String> images,
    List<String> sizes,
    double rating,
    int reviews,
    int stock,
    bool isNew,
    int discount,
    String description,
  ) {
    final perSize = sizes.isEmpty ? stock : (stock / sizes.length).floor();
    return Product(
      id: id,
      title: title,
      price: price.toDouble(),
      originalPrice: originalPrice.toDouble(),
      category: category,
      subcategory: subcategory,
      gender: 'Women',
      images: images,
      sizes: sizes.map((s) => ProductSize(size: s, quantity: perSize)).toList(),
      rating: rating,
      reviews: reviews,
      stock: stock,
      description: description,
      isNew: isNew,
      discount: discount,
    );
  }
}
