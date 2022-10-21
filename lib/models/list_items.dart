class ListItem {
  int? id;
  int idList;
  String name;
  String quantity;
  String note;
  ListItem(
      {this.id,
      required this.idList,
      required this.name,
      required this.quantity,
      required this.note});
  Map<String, dynamic> toMap() => {
        'id': id,
        'idList': idList,
        'name': name,
        'quantity': quantity,
        'note': note,
      };
}
