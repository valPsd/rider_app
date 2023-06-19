import 'dart:convert';

List<WalletStore> walletStoreFromJson(String str) => List<WalletStore>.from(
    json.decode(str).map((x) => WalletStore.fromJson(x)));

class WalletStore {
  WalletStore({
    required this.walletID,
    required this.storeID,
    required this.balance,
  });

  String walletID;
  String storeID;
  double balance;

  factory WalletStore.fromJson(Map<String, dynamic> json) => WalletStore(
        walletID: json["walletID"],
        storeID: json["storeID"],
        balance: double.parse(json["balance"].toString()),
      );
}
