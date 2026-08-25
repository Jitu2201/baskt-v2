/// A product category within a shop, e.g. "Drinks" or "Bakery".
///
/// Named `ProductCategory` (not `Category`) because Flutter's own
/// `foundation` library already exports a `Category` class.
class ProductCategory {
  ProductCategory({required this.id, required this.name});

  final String id;
  final String name;
}
