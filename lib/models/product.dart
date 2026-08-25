/// A single item a shop sells.
class Product {
  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.categoryId,
    this.imageEmoji = '🛍️',
    this.inStock = true,
  });

  final String id;
  final String name;
  final String description;
  final double price;
  final String categoryId;

  /// Mock data has no real images yet, so each product gets an emoji
  /// as a stand-in for a product photo.
  final String imageEmoji;
  final bool inStock;

  Product copyWith({
    String? name,
    String? description,
    double? price,
    String? categoryId,
    String? imageEmoji,
    bool? inStock,
  }) {
    return Product(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      categoryId: categoryId ?? this.categoryId,
      imageEmoji: imageEmoji ?? this.imageEmoji,
      inStock: inStock ?? this.inStock,
    );
  }
}
