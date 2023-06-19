import 'dart:convert';

List<CartDetail> CartDetailFromJson(String str) =>
    List<CartDetail>.from(json.decode(str).map((x) => CartDetail.fromJson(x)));

class CartDetail {
  CartDetail(
      {required this.CartDetailID,
      required this.CartID,
      required this.MenuID,
      required this.Amount});

  String CartDetailID;
  String CartID;
  String MenuID;
  int Amount;

  factory CartDetail.fromJson(Map<String, dynamic> json) => CartDetail(
      CartDetailID: json["id"],
      CartID: json["cartID"],
      MenuID: json["menuID"],
      Amount: json["amount"]);
}
