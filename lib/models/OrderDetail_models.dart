import 'dart:convert';

List<OrderDetail> orderDetailFromJson(String str) => List<OrderDetail>.from(
    json.decode(str).map((x) => OrderDetail.fromJson(x)));

class OrderDetail {
  OrderDetail(
      {required this.OrderDetailID,
      required this.OrderID,
      required this.MenuID,
      required this.Amount});

  String OrderDetailID;
  String OrderID;
  String MenuID;
  int Amount;

  factory OrderDetail.fromJson(Map<String, dynamic> json) => OrderDetail(
      OrderDetailID: json["id"],
      OrderID: json["id"],
      MenuID: json["menuID"],
      Amount: json["amount"]);
}
