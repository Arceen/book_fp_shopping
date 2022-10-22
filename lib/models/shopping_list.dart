class ShoppingList {
  int? id;
  String name;
  int priority;
  ShoppingList({this.id, required this.name, required this.priority});

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'priority': priority,
      };
  @override
  String toString() {
    return 'ID: $id - Name: $name - Priority: $priority';
  }
}
