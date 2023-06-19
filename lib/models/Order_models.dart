import 'dart:convert';

List<Order> orderFromJson(String str) =>
    List<Order>.from(json.decode(str).map((x) => Order.fromJson(x)));

class Order {
  Order(
      {required this.orderID,
      required this.addressID,
      required this.payID,
      required this.cartID,
      required this.storeID,
      required this.riderID,
      required this.date,
      required this.time,
      required this.status,
      required this.userID});

  String orderID;
  String addressID;
  String payID;
  String cartID;
  String storeID;
  String riderID;
  String date;
  String time;
  int status;
  String userID;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
      orderID: json["id"],
      addressID: json["addressID"],
      payID: json["payID"],
      cartID: json["cartID"],
      storeID: json["storeID"],
      riderID: json["riderID"] ?? "",
      date: json["date"],
      time: json["time"],
      status: json["status"],
      userID: json['userID']);
}
