import 'dart:convert';

List<Address> addressFromJson(String str) =>
    List<Address>.from(json.decode(str).map((x) => Address.fromJson(x)));

class Address {
  Address({
    required this.AddressID,
    required this.UserID,
    required this.House_Num,
    required this.Lane_or_village,
    required this.Road,
    // required this.Lat,
    // required this.Long,
    required this.Zip_Code,
    required this.District,
    required this.Sub_District,
    required this.Province,
  });

  String AddressID;
  String UserID;
  String House_Num;
  String Lane_or_village;
  String Road;
  // String Lat;
  // String Long;
  int Zip_Code;
  String District;
  String Sub_District;
  String Province;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        AddressID: json["addressID"],
        UserID: json["userID"],
        House_Num: json["hoseNum"],
        Lane_or_village: json["lane_or_village"],
        Road: json["road"],
        // Lat: json["lat"],
        // Long: json["long"],
        Zip_Code: json["zip_Code"],
        District: json["district"],
        Sub_District: json["sub_District"],
        Province: json["province"],
      );
}
