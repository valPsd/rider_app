import 'dart:convert';

List<TransactionRider> transactionRiderFromJson(String str) => List<TransactionRider>.from(
    json.decode(str).map((x) => TransactionRider.fromJson(x)));

class TransactionRider {
  TransactionRider({
    required this.TransactionID,
    required this.WalletID,
    required this.Date,
    required this.Time,
    required this.Trans_Name,
    required this.Amount,
  });

  String TransactionID;
  String WalletID;
  String Date;
  String Time;
  String Trans_Name;
  double Amount;

  factory TransactionRider.fromJson(Map<String, dynamic> json) => TransactionRider(
        TransactionID: json["transactionID"],
        WalletID: json["walletID"],
        Date: json["date"],
        Time: json["time"],
        Trans_Name: json["trans_Name"],
        Amount: double.parse(json["amount"].toString()),
      );
}
