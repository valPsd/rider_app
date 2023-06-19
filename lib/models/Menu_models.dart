import 'dart:convert';

List<Menu> menuFromJson(String str) =>
    List<Menu>.from(json.decode(str).map((x) => Menu.fromJson(x)));

class Menu {
  Menu({
    required this.menuID,
    required this.storeID,
    required this.name,
    required this.price,
    required this.description,
    required this.image,
    required this.status,
    required this.menu_TypeID,
  });

  String menuID;
  String storeID;
  String name;
  int price;
  String description;
  String image;
  int status;
  String menu_TypeID;

  factory Menu.fromJson(Map<String, dynamic> json) => Menu(
        menuID: json["id"],
        storeID: json["storeID"],
        name: json["name"],
        price: json["price"],
        description: json["description"],
        image: json["image"],
        status: json["status"],
        menu_TypeID: json["menu_TypeID"],
      );
}
