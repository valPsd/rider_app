import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quickalert/quickalert.dart';
import 'package:riderapp/models/Rider_models.dart';
import 'package:riderapp/models/api.dart';
import 'package:http/http.dart' as http;
import 'package:riderapp/models/transaction_model.dart';
import 'package:riderapp/models/wallet_model.dart';
import 'package:riderapp/screens/home.dart';

import '../component/dropdownWidgetQ.dart';

class Income extends StatefulWidget {
  @override
  _IncomeState createState() => _IncomeState();
}

class _IncomeState extends State<Income> {
  String? _selectedValue;
  late String positions;
  final List<Map> _items = [
    {'id': '1', 'name': 'BBL ', 'imageBank': 'assets/images/BBL.png'},
    {'id': '2', 'name': 'KBank', 'imageBank': 'assets/images/KBank.png'},
    {'id': '3', 'name': 'KTB', 'imageBank': 'assets/images/KTB.png'},
    {'id': '4', 'name': 'SCB', 'imageBank': 'assets/images/SCB.png'},
    {'id': '5', 'name': 'BAY', 'imageBank': 'assets/images/BAY.jpg'},
    {'id': '6', 'name': 'TTB', 'imageBank': 'assets/images/TTB.png'},
  ];

  String path = Api().path;
  List<TransactionRider> transactionRider = [];
  Wallet riderWallet = Wallet(walletID: "", riderID: "", balance: 0);
  double totalWithdrawnAmount = 0;
  double totalIncomeAmount = 0;
  String ProfileImage = "";
  final BankNumberController = TextEditingController();
  final AmountController = TextEditingController();

  void showalert() {
    QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: ' transfer money successfully',
        onConfirmBtnTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => Income()));
        });
  }

  void showalertNotEnoungBalnace() {
    QuickAlert.show(
        context: context,
        type: QuickAlertType.warning,
        text: 'Your balance is not enough.',
        onConfirmBtnTap: () {
          Navigator.pop(context);
        });
  }

  void showalertCancle() {
    QuickAlert.show(
        context: context,
        type: QuickAlertType.confirm,
        text: 'Do you wish to cancle?',
        confirmBtnText: 'Yes',
        cancelBtnText: 'No',
        confirmBtnColor: Colors.green,
        onConfirmBtnTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => Income()));
        });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Color.fromARGB(255, 120, 56, 192),
                      Color.fromARGB(255, 120, 5, 131)
                    ]),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          RawMaterialButton(
                            onPressed: () => {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomePage()))
                            },
                            child: Icon(
                              Icons.arrow_back_ios,
                              size: 20,
                              color: Color.fromARGB(255, 253, 252, 252),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20.0, top: 30),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 80.0,
                                  height: 80.0,
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 62, 4, 77),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black.withOpacity(.1),
                                          blurRadius: 8,
                                          spreadRadius: 3)
                                    ],
                                    border: Border.all(
                                      width: 1.5,
                                      color: Colors.white,
                                    ),
                                    borderRadius: BorderRadius.circular(40.0),
                                  ),
                                  padding: EdgeInsets.all(5),
                                  child: ProfileImage != ""
                                      ? CircleAvatar(
                                          backgroundImage:
                                              NetworkImage(ProfileImage),
                                          radius: 50,
                                        )
                                      : CircleAvatar(
                                          backgroundImage: AssetImage(
                                              "assets/images/female.png"),
                                          radius: 50,
                                        ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Your Balance",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Image(
                                            width: 20,
                                            height: 20,
                                            image: AssetImage(
                                                "assets/images/coin_dollar_finance_icon_125510.png")),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(riderWallet.balance.toString(),
                                                style: TextStyle(
                                                  fontSize: 30,
                                                  color: Colors.white,
                                                )),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text("Bath",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white,
                                                )),
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    color: Colors.grey.shade100,
                    child: Padding(
                      padding: EdgeInsets.only(top: 130),
                      child: SingleChildScrollView(
                        child: Column(
                          children: createTransactions(),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Positioned(
              top: 360,
              left: 150,
              child: MaterialButton(
                onPressed: () {
                  _showMyDialog();
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image(
                        width: 50,
                        height: 50,
                        image: AssetImage("assets/images/money-transfer.png")),
                    SizedBox(
                      height: 5,
                    ),
                    Text("Bank Transfer",
                        style: TextStyle(
                          color: Color.fromARGB(255, 57, 97, 109),
                          // fontWeight: FontWeight.bold,
                          fontSize: 15,
                        )),
                    // Divider(
                    //   color: Colors.black,
                    // ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 185,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                width: MediaQuery.of(context).size.width * 0.85,
                height: 145,
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.05),
                        blurRadius: 8,
                        spreadRadius: 3,
                        offset: Offset(0, 10),
                      ),
                    ],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(50),
                    )),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Income",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 13, 116, 64),
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(
                                  Icons.arrow_downward,
                                  color: Color(0XFF00838F),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  "฿",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                      color: Color.fromARGB(221, 209, 149, 18)),
                                ),
                                Text(
                                  totalIncomeAmount.toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                      color: Colors.black87),
                                ),
                              ],
                            )
                          ],
                        ),
                        Container(width: 1, height: 50, color: Colors.grey),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Withdrawn",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 175, 7, 7),
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(
                                  Icons.arrow_upward,
                                  color: Color.fromARGB(255, 211, 7, 7),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  "฿",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                      color: Color.fromARGB(221, 209, 149, 18)),
                                ),
                                Text(
                                  totalWithdrawnAmount.toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                      color: Colors.black87),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 1,
                      width: double.maxFinite,
                      color: Colors.grey.withOpacity(0.5),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Income 10% from order delivery",
                      style: TextStyle(
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _getCloseButton(context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 10, 0),
      child: GestureDetector(
        onTap: () {},
        child: Container(
          alignment: FractionalOffset.topRight,
          child: GestureDetector(
            child: Icon(
              Icons.clear,
              color: Colors.red,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Column(
                children: [
                  _getCloseButton(context),
                  Row(
                    children: [
                      Text('Bank Transfer',
                          style: TextStyle(
                              color: Color.fromARGB(255, 67, 6, 107),
                              fontWeight: FontWeight.bold,
                              fontSize: 18)),
                    ],
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text('Bank',
                        style: TextStyle(
                            color: Color.fromARGB(255, 83, 82, 82),
                            fontWeight: FontWeight.bold,
                            fontSize: 15)),
                    // TestDropDown(),
                    Row(
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              height: 5,
                            ),

                            // Write a new DropdownButton with adding styling.
                            Container(
                              // width: 250,
                              padding: EdgeInsets.only(left: 10, right: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  // border: Border.all(),
                                  color: Color.fromARGB(255, 245, 247, 247)),
                              child: DropdownButtonHideUnderline(
                                child: ButtonTheme(
                                  alignedDropdown: true,
                                  child: DropdownButton(
                                    hint: Text(
                                      "Please choose Your Bank  ",
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 85, 84, 84),
                                        fontSize: 14,
                                      ),
                                    ),
                                    icon: Icon(Icons.arrow_drop_down_circle,
                                        color: Colors.grey.withOpacity(0.7)),
                                    onChanged: (newValue) {
                                      setState(() {
                                        _selectedValue = newValue as String?;
                                      });
                                    },
                                    value: _selectedValue,
                                    items: _items.map((bankItem) {
                                      return DropdownMenuItem(
                                          value: bankItem['id'],
                                          child: Row(
                                            children: [
                                              Image.asset(
                                                bankItem['imageBank'],
                                                height: 20,
                                                width: 20,
                                              ),
                                              Container(
                                                margin:
                                                    EdgeInsets.only(left: 10),
                                                child: Text(bankItem['name']),
                                              )
                                            ],
                                          ));
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Text('Account No.',
                        style: TextStyle(
                            color: Color.fromARGB(255, 83, 82, 82),
                            fontWeight: FontWeight.bold,
                            fontSize: 15)),
                    SizedBox(
                      height: 5,
                    ),
                    TextField(
                      controller: BankNumberController,
                      cursorColor: Color.fromARGB(255, 20, 20, 20),
                      style: TextStyle(color: Color.fromARGB(255, 29, 28, 28)),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color.fromARGB(255, 212, 220, 233),
                        hintText: 'Enter Account No.',
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text('Amount',
                        style: TextStyle(
                            color: Color.fromARGB(255, 83, 82, 82),
                            fontWeight: FontWeight.bold,
                            fontSize: 15)),
                    SizedBox(
                      height: 5,
                    ),
                    TextField(
                      controller: AmountController,
                      cursorColor: Color.fromARGB(255, 20, 20, 20),
                      style: TextStyle(color: Color.fromARGB(255, 29, 28, 28)),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color.fromARGB(255, 212, 220, 233),
                        hintText: '0.00',
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                MaterialButton(
                  onPressed: () async {
                    _showMyDialog2();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("Next ",
                          style: TextStyle(
                              color: Color.fromARGB(255, 219, 136, 12),
                              fontSize: 18)),
                      // SizedBox(
                      //   width: 5,
                      // ),
                      Image(
                        width: 30,
                        height: 30,
                        image: AssetImage("assets/images/skip.png"),
                      ),
                    ],
                  ),
                ),

                // TextButton(
                //   child: const Text('Comferm'),
                //   onPressed: () {
                //     Navigator.of(context).pop();
                //   },
                // ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _showMyDialog2() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              // _getCloseButton(context),
              Row(
                children: [
                  Text('Conferm Your Transfer',
                      style: TextStyle(
                          color: Color.fromARGB(255, 67, 6, 107),
                          fontWeight: FontWeight.bold,
                          fontSize: 18)),
                ],
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                // Text('Bank',
                //     style: TextStyle(
                //         color: Color.fromARGB(255, 83, 82, 82),
                //         fontWeight: FontWeight.bold,
                //         fontSize: 15)),
                Row(
                  children: [
                    Image(
                        width: 50,
                        height: 50,
                        image: AssetImage(_items.elementAt(
                            int.parse(_selectedValue!))['imageBank'])),
                    SizedBox(
                      width: 10,
                    ),
                    Text(_items.elementAt(int.parse(_selectedValue!))['name'],
                        style: TextStyle(
                            color: Color.fromARGB(255, 83, 82, 82),
                            fontWeight: FontWeight.bold,
                            fontSize: 18)),
                  ],
                ),
                Divider(
                  // height: 100,
                  color: Colors.green,
                  thickness: 1,
                  indent: 10,
                  endIndent: 10,
                ),
                SizedBox(
                  height: 10,
                ),
                // TestDropDown(),
                Text('Account No.',
                    style: TextStyle(
                        color: Color.fromARGB(255, 83, 82, 82),
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Text(
                      '',
                    ),
                    Spacer(),
                    Text(BankNumberController.text,
                        style: TextStyle(
                            color: Color.fromARGB(255, 116, 114, 114),
                            fontWeight: FontWeight.bold,
                            fontSize: 18)),
                  ],
                ),

                SizedBox(
                  height: 10,
                ),
                Text('Amount',
                    style: TextStyle(
                        color: Color.fromARGB(255, 83, 82, 82),
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Text(
                      '',
                    ),
                    Spacer(),
                    Text(AmountController.text + ' Baht',
                        style: TextStyle(
                            color: Color.fromARGB(255, 116, 114, 114),
                            fontWeight: FontWeight.bold,
                            fontSize: 18)),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              children: [
                MaterialButton(
                  onPressed: () async {
                    showalertCancle();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        width: 25,
                        height: 25,
                        image: AssetImage("assets/images/x-button.png"),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text("Cancle",
                          style: TextStyle(
                              color: Color.fromARGB(255, 138, 6, 6),
                              fontSize: 16)),
                    ],
                  ),
                ),
                Spacer(),
                MaterialButton(
                  onPressed: () async {
                    // showalert();
                    transferMoney();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Confirm",
                          style: TextStyle(
                              color: Color.fromARGB(255, 4, 97, 27),
                              fontSize: 16)),
                      SizedBox(
                        width: 5,
                      ),
                      Image(
                        width: 25,
                        height: 25,
                        image: AssetImage("assets/images/checked.png"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  getData() async {
    await Hive.openBox('id');
    var idRider = await Hive.box('id');
    String riderID = idRider.get(0);

    var url = Uri.parse("$path/WalletRider/Search?keyword=$riderID");
    var response = await http.get(url);
    List<Wallet> listRiderWallet = walletFromJson(response.body);
    riderWallet = listRiderWallet[0];

    var url2 = Uri.parse(
        "$path/TransactionRider/Search?keyword=${riderWallet.walletID}");
    var response2 = await http.get(url2);
    transactionRider = transactionRiderFromJson(response2.body);

    totalWithdrawnAmount = 0;
    totalIncomeAmount = 0;
    for (var t in transactionRider) {
      if (t.Trans_Name == "เงินเข้า") {
        totalIncomeAmount += t.Amount;
      } else {
        totalWithdrawnAmount += t.Amount;
      }
    }

    var url3 = Uri.parse("${Api().path}/Rider/Search?keyword=$riderID");
    var response3 = await http.get(url3);
    List<UserRider> listRider = riderFromJson(response3.body);
    ProfileImage = listRider[0].profile.replaceAll('#', '&');
    ProfileImage = listRider[0].profile.replaceAll('rider/', 'rider%2F');

    setState(() {
      riderWallet;
      transactionRider;
      totalWithdrawnAmount;
      totalIncomeAmount;
      ProfileImage;
    });
  }

  List<Widget> createTransactions() {
    List<Widget> list = [];
    list.add(
      SizedBox(
        height: 15,
      ),
    );
    list.add(
      Row(
        children: [
          Text(
            "Transactions",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 65, 5, 80)),
          ),
        ],
      ),
    );

    list.add(
      SizedBox(
        height: 20,
      ),
    );

    for (var item in transactionRider) {
      var dateArr = item.Date.split(" ");
      String date = dateArr[0];
      if (item.Trans_Name == "เงินเข้า") {
        list.add(
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Color.fromARGB(255, 253, 253, 253),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    Image(
                        width: 30,
                        height: 30,
                        image: AssetImage("assets/images/rightt.png")),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "รายการเงินเข้า",
                          style: TextStyle(
                              color: Color.fromARGB(255, 13, 110, 4),
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Row(
                          children: [
                            Text(
                              date,
                              style: TextStyle(
                                color: Color.fromARGB(255, 114, 111, 114),
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(
                              width: 6,
                            ),
                            Text(
                              item.Time,
                              style: TextStyle(
                                color: Color.fromARGB(255, 114, 111, 114),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Text(
                          "+",
                          style: TextStyle(
                              color: Color.fromARGB(255, 8, 102, 47),
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          item.Amount.toString(),
                          style: TextStyle(
                              color: Color.fromARGB(255, 6, 148, 18),
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        );
      } else {
        list.add(
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Color.fromARGB(255, 253, 253, 253),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    Image(
                        width: 30,
                        height: 30,
                        image: AssetImage("assets/images/left.png")),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "รายการเงินออก",
                          style: TextStyle(
                              color: Color.fromARGB(255, 185, 8, 38),
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Row(
                          children: [
                            Text(
                              date,
                              style: TextStyle(
                                color: Color.fromARGB(255, 114, 111, 114),
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(
                              width: 6,
                            ),
                            Text(
                              item.Time,
                              style: TextStyle(
                                color: Color.fromARGB(255, 114, 111, 114),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Text(
                          "-",
                          style: TextStyle(
                              color: Color.fromARGB(255, 185, 8, 38),
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          item.Amount.toString(),
                          style: TextStyle(
                              color: Color.fromARGB(255, 185, 8, 38),
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        );
      }
      list.add(
        SizedBox(
          height: 10,
        ),
      );
    }

    return list;
  }

  transferMoney() async {
    if (double.parse(AmountController.text) <= riderWallet.balance) {
      await Hive.openBox('id');
      var idRider = await Hive.box('id');
      String riderID = idRider.get(0);
      String transName = "เงินออก";
      var now = DateTime.now();
      String date = "${now.year}-${now.month}-${now.day}";
      String time = "${now.hour}:${now.minute}:${now.second}";

      //อัพเดท wallet ของไรเดอร์
      double newBalanceRider =
          riderWallet.balance - double.parse(AmountController.text);
      var url3 = Uri.parse(
          "$path/WalletRider/Update?keyword1=${riderWallet.riderID}&keyword2=$newBalanceRider");
      await http.post(url3);
      //สร้าง Transaction Rider
      var url4 = Uri.parse("${Api().path}/TransactionRider");
      var response4 = await http.get(url4);
      List<TransactionRider> listTransRider =
          transactionRiderFromJson(response4.body);
      String transRiderID = 'TR';
      if (listTransRider.isNotEmpty) {
        int lastTransRiderID = 0;
        String tempTransRiderID = listTransRider[0].TransactionID;
        var tempTransRiderIDArr = tempTransRiderID.split('TR');
        lastTransRiderID = int.parse(tempTransRiderIDArr[1]);

        for (var a in listTransRider) {
          if (a.TransactionID != tempTransRiderID) {
            String tempTransRiderID2 = a.TransactionID;
            var tempTransRiderIDArr2 = tempTransRiderID2.split('TR');
            if (int.parse(tempTransRiderIDArr2[1]) > lastTransRiderID) {
              lastTransRiderID = int.parse(tempTransRiderIDArr2[1]);
            }
          }
        }
        transRiderID = "$transRiderID${(lastTransRiderID + 1).toString()}";
      } else {
        transRiderID = "${transRiderID}1";
      }
      var url5 = Uri.parse(
          "$path/TransactionRider/Create?keyword1=$transRiderID&keyword2=${riderWallet.walletID}&keyword3=$date&keyword4=$time&keyword5=$transName&keyword6=${double.parse(AmountController.text)}");
      await http.post(url5);

      showalert();
    } else {
      showalertNotEnoungBalnace();
    }
  }
}
