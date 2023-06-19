import 'dart:convert';

List<Wallet> walletFromJson(String str) =>
    List<Wallet>.from(json.decode(str).map((x) => Wallet.fromJson(x)));

class Wallet {
  Wallet({
    required this.walletID,
    required this.riderID,
    required this.balance,
  });

  String walletID;
  String riderID;
  double balance;

  factory Wallet.fromJson(Map<String, dynamic> json) => Wallet(
        walletID: json["walletID"],
        riderID: json["riderID"],
        balance: double.parse(json["balance"].toString()),
      );
}
