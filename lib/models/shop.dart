/// The shop profile an owner sets up during onboarding.
class Shop {
  Shop({required this.name, this.description = '', this.emoji = '🏪'});

  final String name;
  final String description;
  final String emoji;

  Shop copyWith({String? name, String? description, String? emoji}) {
    return Shop(
      name: name ?? this.name,
      description: description ?? this.description,
      emoji: emoji ?? this.emoji,
    );
  }
}
