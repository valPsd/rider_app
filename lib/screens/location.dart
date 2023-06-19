import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quickalert/quickalert.dart';
import 'package:riderapp/controller/chat_controller.dart';
import 'package:riderapp/models/Address_models.dart';
import 'package:riderapp/models/CartDetail_model.dart';
import 'package:riderapp/models/ChatMessage.dart';
import 'package:riderapp/models/Menu_models.dart';
import 'package:riderapp/models/Order_models.dart';
import 'package:riderapp/models/api.dart';
import 'package:riderapp/models/restuarant_model.dart';
import 'package:riderapp/models/transaction_model.dart';
import 'package:riderapp/models/wallet_store_model.dart';
import 'package:riderapp/screens/messageScreen.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';

import '../models/User_models.dart';
import '../models/wallet_model.dart';
import 'home.dart';

class LicationPage extends StatefulWidget {
  LicationPage(
      {super.key,
      required this.order,
      required this.orderDetails,
      required this.user,
      required this.total,
      required this.restuarant,
      required this.menus,
      required this.sendingChatID});

  Order order;
  User user;
  List<CartDetail> orderDetails;
  //List<Order> listOrder = [];
  int total;
  Restuarant restuarant;
  List<Menu> menus;
  String sendingChatID;
  // String status = '3';

  @override
  State<LicationPage> createState() => _LicationPageState();
}

class _LicationPageState extends State<LicationPage> {
  final _channel = WebSocketChannel.connect(
    Uri.parse('wss://avn-websocket-order.onrender.com'),
  );
  String path = Api().path;
  Address userAddress = Address(
      AddressID: '',
      UserID: '',
      House_Num: '',
      Lane_or_village: '',
      Road: '',
      Zip_Code: 0,
      District: '',
      Sub_District: '',
      Province: '');
  int status = 0;

  @override
  void initState() {
    _channel.stream.listen((onData) {
      Map<String, dynamic> data = json.decode(onData);
      if (widget.order.orderID == data['orderID']) {
        if (int.parse(data['orderStatus']) == 4) {
          showalertCancel();
        } else {
          setState(() {
            status = int.parse(data['orderStatus']);
          });
        }
      }
    });
    getStatusfromWidget();
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //ป้องกันการกดกลับ
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        floatingActionButton: Wrap(
          direction: Axis.horizontal,
          children: <Widget>[
            FloatingActionButton(
              onPressed: () {
                getChat();
              },
              backgroundColor: Color.fromARGB(255, 248, 246, 248),
              child: Icon(
                Icons.chat,
                color: Color.fromARGB(255, 127, 61, 129),
              ),
            ),
          ],
        ),
        backgroundColor: Color(0xfff8E70C9),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: createOrderDetail(),
          ),
        ),
      ),
    );
  }

  getData() async {
    var url = Uri.parse("$path/Address/Search?keyword=${widget.user.userID}");

    var response = await http.get(url);
    print(response.body);
    List<Address> listOrder = addressFromJson(response.body);
    if (listOrder[0].Lane_or_village == ".") {
      listOrder[0].Lane_or_village = "";
    }

    if (listOrder[0].Road == ".") {
      listOrder[0].Road = "";
    }

    setState(() {
      userAddress = listOrder[0];
    });
  }

  getChat() async {
    var url2 = Uri.parse("$path/Chat/Search?keyword=${widget.sendingChatID}");

    var response2 = await http.get(url2);
    List<ChatMessage> listMsg = ChatMessageFromJson(response2.body);
    Chat_Controller().clear();
    for (var msg in listMsg) {
      Chat_Controller().add(chat: msg);
    }

    await Hive.initFlutter();
    await Hive.openBox('sendingChatID');
    var box = await Hive.box('sendingChatID');
    box.put(0, widget.sendingChatID);

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MessageCsreen(
            user: widget.user,
            sendChatID: widget.sendingChatID,
          ),
        ));
  }

  List<Widget> createOrderDetail() {
    List<Widget> widgets = [];
    List<Widget> orderDetailWidgets = [];

    for (var orderDetail in widget.orderDetails) {
      Menu menu = Menu(
          menuID: '',
          storeID: '',
          name: '',
          price: 0,
          description: '',
          image: '',
          status: 0,
          menu_TypeID: '');
      for (var m in widget.menus) {
        if (m.menuID == orderDetail.MenuID) {
          menu = m;
          break;
        }
      }
      orderDetailWidgets.add(
        Row(
          children: [
            Text(menu.name,
                style: TextStyle(
                  color: Color.fromARGB(255, 92, 90, 92),
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                )),
            Spacer(),
            Text("X${orderDetail.Amount}",
                style: TextStyle(
                  color: Color.fromARGB(255, 92, 90, 92),
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                )),
          ],
        ),
      );
      orderDetailWidgets.add(
        SizedBox(
          height: 8,
        ),
      );
    }

    widgets.add(
      SizedBox(
        height: 50,
      ),
    );
    widgets.add(
      SingleChildScrollView(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Color(0xfffEFEFEF),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.location_history,
                      color: Color.fromARGB(255, 120, 21, 133),
                      size: 30,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("ข้อมูลการจัดส่ง",
                        style: TextStyle(
                          color: Color.fromARGB(255, 54, 53, 54),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          "${userAddress.House_Num} ${userAddress.Lane_or_village} ${userAddress.Road} ${userAddress.Sub_District} ${userAddress.District} ${userAddress.Province} ${userAddress.Zip_Code}",
                          style: TextStyle(
                            color: Color.fromARGB(255, 54, 53, 54),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          )),
                      Divider(),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text("ผู้รับ : ",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 12, 3, 12),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(
                            width: 10,
                          ),
                          Text("${widget.user.username}",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 12, 2, 12),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.phone,
                            color: Color.fromARGB(255, 120, 21, 133),
                            size: 20,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text("${widget.user.phoneNum}",
                              style: TextStyle(
                                color: Color.fromARGB(255, 75, 4, 75),
                                fontSize: 14,
                              )),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: [
                          Text("${widget.restuarant.name}",
                              style: TextStyle(
                                color: Color.fromARGB(255, 2, 31, 5),
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                              )),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Container(
                            width: 250,
                            child: Text("${widget.restuarant.address}",
                                softWrap: true,
                                style: TextStyle(
                                  color: Color.fromARGB(255, 2, 31, 5),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.phone,
                            color: Color.fromARGB(255, 120, 21, 133),
                            size: 30,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            width: 250,
                            child: Text("${widget.restuarant.telNum}",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 75, 4, 75),
                                  fontSize: 23,
                                )),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      const Divider(
                        height: 2,
                        thickness: 2,
                        indent: 2,
                        // endIndent: 0,
                        color: Color.fromARGB(255, 128, 79, 113),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.shopping_bag,
                            color: Color.fromARGB(255, 120, 21, 133),
                            size: 30,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text("รายละเอียดออเดอร์",
                              style: TextStyle(
                                color: Color.fromARGB(255, 54, 53, 54),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              )),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: orderDetailWidgets,
                        ),
                      ),
                      SizedBox(
                        height: 60,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          status != 2
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "ร้านอาหารกำลังเตรียมออเดอร์",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.yellow[900],
                                          fontSize: 20),
                                    )
                                  ],
                                )
                              : RawMaterialButton(
                                  onPressed: () => {orderComplete()},
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      gradient: LinearGradient(
                                        colors: [
                                          Color.fromARGB(255, 101, 57, 223),
                                          Color.fromARGB(255, 196, 42, 196),
                                        ],
                                      ),
                                    ),
                                    child: Text("Delivery Completed",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18)),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 50, vertical: 15),
                                  ),
                                ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
    return widgets;
  }

  getStatusfromWidget() {
    status = widget.order.status;
  }

  orderComplete() async {
    await Hive.initFlutter();
    await Hive.openBox('id');
    var idRider = Hive.box('id');
    String riderid = idRider.get(0);
    int status = 3;
    String transName = "เงินเข้า";
    var now = DateTime.now();
    String date = "${now.year}-${now.month}-${now.day}";
    String time = "${now.hour}:${now.minute}:${now.second}";

    //คิดรายได้ของไรเดอร์ 10 เปอร์เซ็นต์ของออเดอร์
    double incomeRider = widget.total * 10 / 100;
    //ค่าอาหารของร้านค้าหัก 30 เปอร์เซ็นจากราคาออเดอร์
    double incomeRestuarant = widget.total - (widget.total * 30 / 100);

    //เปลี่ยนสถานะของออเดอร์เป็น 3 (สำเร็จ)
    var url = Uri.parse(
        "$path/Order/Update?keyword1=${widget.order.orderID}&keyword2=$status");
    await http.post(url);

    //อัพเดท wallet ของไรเดอร์
    var url2 = Uri.parse("${Api().path}/WalletRider/Search?keyword=$riderid");
    var response2 = await http.get(url2);
    List<Wallet> wallet = walletFromJson(response2.body);
    double newBalanceRider = wallet[0].balance + incomeRider;
    var url3 = Uri.parse(
        "$path/WalletRider/Update?keyword1=${wallet[0].riderID}&keyword2=$newBalanceRider");
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
        "$path/TransactionRider/Create?keyword1=$transRiderID&keyword2=${wallet[0].walletID}&keyword3=$date&keyword4=$time&keyword5=$transName&keyword6=$incomeRider");
    await http.post(url5);

    //อัพเดท wallet ร้านค้า
    var url6 = Uri.parse(
        "${Api().path}/WalletStore/Search?keyword=${widget.restuarant.storeID}");
    var response6 = await http.get(url6);
    List<WalletStore> walletStore = walletStoreFromJson(response6.body);
    double newBalanceStore =
        walletStore[0].balance + incomeRestuarant; //need more edit
    var url7 = Uri.parse(
        "$path/WalletStore/Update?keyword1=${walletStore[0].storeID}&keyword2=$newBalanceStore");
    await http.post(url7);
    //สร้าง Transaction ร้านค้า
    var url8 = Uri.parse("${Api().path}/TransactionStore");
    var response8 = await http.get(url8);
    List<TransactionRider> listTransStores =
        transactionRiderFromJson(response8.body);
    String transStoreID = 'TS';
    if (listTransStores.isNotEmpty) {
      int lastTransStoreID = 0;
      String tempTransStoreID = listTransStores[0].TransactionID;
      var tempTransStoreIDArr = tempTransStoreID.split('TS');
      lastTransStoreID = int.parse(tempTransStoreIDArr[1]);

      for (var a in listTransStores) {
        if (a.TransactionID != tempTransStoreID) {
          String tempTransStoreID2 = a.TransactionID;
          var tempTransStoreIDArr2 = tempTransStoreID2.split('TS');
          if (int.parse(tempTransStoreIDArr2[1]) > lastTransStoreID) {
            lastTransStoreID = int.parse(tempTransStoreIDArr2[1]);
          }
        }
      }
      transStoreID = "$transStoreID${(lastTransStoreID + 1).toString()}";
    } else {
      transStoreID = "${transStoreID}1";
    }
    var url9 = Uri.parse(
        "$path/TransactionStore/Create?keyword1=$transStoreID&keyword2=${walletStore[0].walletID}&keyword3=$date&keyword4=$time&keyword5=$transName&keyword6=$incomeRestuarant");
    await http.post(url9);

    _channel.sink.add(jsonEncode({
      "storeID": widget.order.storeID,
      "orderStatus": status,
      "orderID": widget.order.orderID
    }));

    showalert();
  }

  void showalert() {
    QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: ' Order delivery success. Your income have added to your wallet.',
        onConfirmBtnTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const HomePage()));
        });
  }

  void showalertCancel() {
    QuickAlert.show(
        context: context,
        type: QuickAlertType.warning,
        text: ' Order have been canceled.',
        onConfirmBtnTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const HomePage()));
        });
  }
}
