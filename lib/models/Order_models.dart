import 'dart:convert';

List<OrderModel> orderModelFromJson(String str) =>
    List<OrderModel>.from(json.decode(str).map((x) => OrderModel.fromJson(x)));

class OrderModel {
  OrderModel(
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

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
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
