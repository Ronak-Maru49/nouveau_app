/// Product model — mirrors the shape returned by the Nouveau backend
/// (`GET /api/products`) so the UI can be swapped from local seed data to
/// a live ASP.NET Core API without changing widget code.
class ProductSize {
  final String size;
  final int quantity;

  const ProductSize({required this.size, required this.quantity});

  factory ProductSize.fromJson(Map<String, dynamic> json) {
    return ProductSize(
      size: (json['size'] ?? '').toString(),
      quantity: (json['quantity'] ?? json['stock'] ?? 0) is int
          ? (json['quantity'] ?? json['stock'] ?? 0) as int
          : int.tryParse('${json['quantity'] ?? json['stock'] ?? 0}') ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {'size': size, 'quantity': quantity};
}

class Product {
  final String id;
  final String title;
  final double price;
  final double originalPrice;
  final String category;
  final String subcategory;
  final String gender;
  final List<String> images;
  final List<ProductSize> sizes;
  final double rating;
  final int reviews;
  final int stock;
  final String description;
  final bool isNew;
  final int discount;
  final String? material;

  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.originalPrice,
    required this.category,
    required this.subcategory,
    required this.gender,
    required this.images,
    required this.sizes,
    required this.rating,
    required this.reviews,
    required this.stock,
    required this.description,
    required this.isNew,
    required this.discount,
    this.material,
  });

  bool get hasDiscount => originalPrice > price;
  bool get isOutOfStock => sizes.isEmpty
      ? stock <= 0
      : sizes.fold<int>(0, (sum, s) => sum + s.quantity) <= 0;

  String get primaryImage => images.isNotEmpty ? images.first : '/product1.jpeg';

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      title: (json['title'] ?? 'Nouveau Signature Piece').toString(),
      price: _toDouble(json['price']),
      originalPrice: _toDouble(json['originalPrice'] ?? json['price']),
      category: (json['category'] ?? 'Nouveau Collection').toString(),
      subcategory: (json['subcategory'] ?? 'Womenswear').toString(),
      gender: (json['gender'] ?? 'Women').toString(),
      images: (json['images'] as List?)?.map((e) => e.toString()).toList() ??
          const ['/product1.jpeg'],
      sizes: (json['sizes'] as List?)
              ?.map((e) => e is Map<String, dynamic>
                  ? ProductSize.fromJson(e)
                  : ProductSize(size: e.toString(), quantity: 1))
              .toList() ??
          const [],
      rating: _toDouble(json['rating']),
      reviews: json['reviews'] is List
          ? (json['reviews'] as List).length
          : (json['reviews'] is int ? json['reviews'] as int : 0),
      stock: json['stock'] is int
          ? json['stock'] as int
          : int.tryParse('${json['stock'] ?? 0}') ?? 0,
      description: (json['description'] ?? '').toString(),
      isNew: json['isNew'] == true,
      discount: json['discount'] is int
          ? json['discount'] as int
          : int.tryParse('${json['discount'] ?? 0}') ?? 0,
      material: json['material']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'title': title,
        'price': price,
        'originalPrice': originalPrice,
        'category': category,
        'subcategory': subcategory,
        'gender': gender,
        'images': images,
        'sizes': sizes.map((s) => s.toJson()).toList(),
        'rating': rating,
        'reviews': reviews,
        'stock': stock,
        'description': description,
        'isNew': isNew,
        'discount': discount,
        if (material != null) 'material': material,
      };

  static double _toDouble(dynamic v) {
    if (v == null) return 0;
    if (v is double) return v;
    if (v is int) return v.toDouble();
    return double.tryParse(v.toString()) ?? 0;
  }
}
