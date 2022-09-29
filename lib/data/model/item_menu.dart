class ItemMenu {
  final String name;

  ItemMenu({required this.name});

  factory ItemMenu.fromMap(Map<String, dynamic> itemMenu) {
    return ItemMenu(name: itemMenu['name'] ?? '');
  }
}
