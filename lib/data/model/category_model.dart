class CategoryModel {
  final String name;

  CategoryModel({required this.name});

  factory CategoryModel.fromMap(Map<String, dynamic> category) {
    return CategoryModel(name: category['name'] ?? '');
  }
}
