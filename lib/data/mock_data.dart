import '../models/category.dart';
import '../models/product.dart';
import '../models/shop.dart';

/// Starting mock data so the storefront has something to show before an
/// owner has gone through onboarding. There is no backend yet - everything
/// lives in memory for the lifetime of the app.
class MockData {
  MockData._();

  static Shop defaultShop() => Shop(
    name: 'Corner Cafe',
    description: 'Fresh coffee, pastries, and lunch bites.',
    emoji: '☕',
  );

  static List<ProductCategory> defaultCategories() => [
    ProductCategory(id: 'cat_drinks', name: 'Drinks'),
    ProductCategory(id: 'cat_bakery', name: 'Bakery'),
    ProductCategory(id: 'cat_lunch', name: 'Lunch'),
  ];

  static List<Product> defaultProducts() => [
    Product(
      id: 'p1',
      name: 'Cappuccino',
      description: 'Espresso with steamed milk foam.',
      price: 4.50,
      categoryId: 'cat_drinks',
      imageEmoji: '☕',
    ),
    Product(
      id: 'p2',
      name: 'Cold Brew',
      description: 'Slow-steeped for 18 hours, served over ice.',
      price: 4.75,
      categoryId: 'cat_drinks',
      imageEmoji: '🧊',
    ),
    Product(
      id: 'p3',
      name: 'Croissant',
      description: 'Buttery, flaky, baked fresh every morning.',
      price: 3.25,
      categoryId: 'cat_bakery',
      imageEmoji: '🥐',
    ),
    Product(
      id: 'p4',
      name: 'Blueberry Muffin',
      description: 'Loaded with blueberries, topped with sugar.',
      price: 3.75,
      categoryId: 'cat_bakery',
      imageEmoji: '🧁',
    ),
    Product(
      id: 'p5',
      name: 'Turkey Club Sandwich',
      description: 'Turkey, bacon, lettuce, tomato on sourdough.',
      price: 8.95,
      categoryId: 'cat_lunch',
      imageEmoji: '🥪',
    ),
    Product(
      id: 'p6',
      name: 'Garden Salad',
      description: 'Mixed greens, cherry tomatoes, house dressing.',
      price: 7.50,
      categoryId: 'cat_lunch',
      imageEmoji: '🥗',
    ),
  ];
}
