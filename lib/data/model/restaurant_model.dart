class RestaurantModel {
  final String id;
  final String name;
  final String description;
  final String pictureId;
  final String city;
  final double rating;

  RestaurantModel(
      {required this.id,
      required this.name,
      required this.description,
      required this.pictureId,
      required this.city,
      required this.rating});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'pictureId': pictureId,
      'city': city,
      'rating': rating
    };
  }

  factory RestaurantModel.fromMap(Map<String, dynamic> restaurant) {
    return RestaurantModel(
        id: restaurant['id'] ?? '',
        name: restaurant['name'] ?? '',
        description: restaurant['description'] ?? '',
        pictureId: restaurant['pictureId'] ?? '',
        city: restaurant['city'] ?? '',
        rating: restaurant['rating']?.toDouble() ?? 0.0);
  }
}
