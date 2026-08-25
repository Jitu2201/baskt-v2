import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../data/mock_data.dart';
import '../models/category.dart';
import '../models/product.dart';
import '../models/shop.dart';

/// Holds the shop's profile, categories and products.
///
/// This acts as the app's in-memory "backend" for shop data - both the
/// owner app (which edits it) and the customer storefront (which reads
/// it) share this same store.
class ShopStore extends ChangeNotifier {
  ShopStore() : shop = MockData.defaultShop() {
    _categories.addAll(MockData.defaultCategories());
    _products.addAll(MockData.defaultProducts());
  }

  static const _uuid = Uuid();

  Shop shop;
  bool onboardingComplete = true;

  final List<ProductCategory> _categories = [];
  final List<Product> _products = [];

  List<ProductCategory> get categories => List.unmodifiable(_categories);
  List<Product> get products => List.unmodifiable(_products);

  List<Product> productsInCategory(String categoryId) =>
      _products.where((p) => p.categoryId == categoryId).toList();

  ProductCategory? categoryById(String id) {
    for (final category in _categories) {
      if (category.id == id) return category;
    }
    return null;
  }

  /// Clears everything so a fresh owner can walk through onboarding
  /// instead of seeing the cafe demo data.
  void startFreshOnboarding() {
    shop = Shop(name: '');
    _categories.clear();
    _products.clear();
    onboardingComplete = false;
    notifyListeners();
  }

  void updateShopProfile({
    required String name,
    String description = '',
    String emoji = '🏪',
  }) {
    shop = shop.copyWith(name: name, description: description, emoji: emoji);
    notifyListeners();
  }

  ProductCategory addCategory(String name) {
    final category = ProductCategory(id: _uuid.v4(), name: name);
    _categories.add(category);
    notifyListeners();
    return category;
  }

  void removeCategory(String categoryId) {
    _categories.removeWhere((c) => c.id == categoryId);
    _products.removeWhere((p) => p.categoryId == categoryId);
    notifyListeners();
  }

  Product addProduct({
    required String name,
    required String description,
    required double price,
    required String categoryId,
    String imageEmoji = '🛍️',
  }) {
    final product = Product(
      id: _uuid.v4(),
      name: name,
      description: description,
      price: price,
      categoryId: categoryId,
      imageEmoji: imageEmoji,
    );
    _products.add(product);
    notifyListeners();
    return product;
  }

  void updateProduct(Product updated) {
    final index = _products.indexWhere((p) => p.id == updated.id);
    if (index == -1) return;
    _products[index] = updated;
    notifyListeners();
  }

  void removeProduct(String productId) {
    _products.removeWhere((p) => p.id == productId);
    notifyListeners();
  }

  void toggleStock(String productId) {
    final index = _products.indexWhere((p) => p.id == productId);
    if (index == -1) return;
    _products[index] = _products[index].copyWith(
      inStock: !_products[index].inStock,
    );
    notifyListeners();
  }

  void finishOnboarding() {
    onboardingComplete = true;
    notifyListeners();
  }
}
