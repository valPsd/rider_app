import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:riderapp/models/Address_models.dart';
import 'package:riderapp/models/CartDetail_model.dart';
import 'package:riderapp/models/Menu_models.dart';
import 'package:riderapp/models/OrderDetail_models.dart';
import 'package:riderapp/models/Order_models.dart';
import 'package:riderapp/models/Rider_models.dart';
import 'package:riderapp/models/Sendingchat_model.dart';
import 'package:riderapp/models/User_models.dart';
import 'package:riderapp/models/api.dart';
import 'package:riderapp/models/restuarant_model.dart';
import 'package:riderapp/screens/home.dart';
import 'package:riderapp/screens/login.dart';
import 'package:riderapp/screens/messageScreen.dart';
import 'package:quickalert/quickalert.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';

import 'location.dart';

class OrderDetailPage extends StatefulWidget {
  OrderDetailPage({super.key, required this.Orderid});
  String Orderid;
  @override
  State<OrderDetailPage> createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetailPage> {
  final _channel = WebSocketChannel.connect(
    Uri.parse('wss://avn-websocket-order.onrender.com'),
  );

  void showalertLogout() {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      text: 'Do you want to Cancle Order?',
      confirmBtnText: 'Yes',
      cancelBtnText: 'No',
      confirmBtnColor: Colors.green,
    );
  }

  List<UserRider> listRider = [];
  List<Order> listOrder = [];
  List<User> listUser = [];
  List<Address> listAddress = [];
  List<Menu> listMenu = [];
  List<Menu> Menus = [];
  List<CartDetail> orderdeteil = [];
  List<int> Character = [];

  Order order = Order(
      orderID: "",
      addressID: " ",
      payID: " ",
      cartID: " ",
      storeID: "",
      riderID: " ",
      date: " ",
      time: " ",
      status: 0,
      userID: " ");

  String UsernameU = "";
  List<String> Menulist = [];
  List<int> Amount = [];
  int Total = 0;
  String userID = "";
  User userDetail = User(
      userID: '',
      username: '',
      password: '',
      phoneNum: '',
      email: '',
      character: 0);
  Restuarant restuarant = Restuarant(
      storeID: '',
      name: '',
      username: '',
      password: '',
      telNum: '',
      email: '',
      address: '');
  double incomeRider = 0.0;

  @override
  void initState() {
    // EasyLoading.show(status: 'loading...');
    getOrder();
    // getMenu();
    // getOrderDetail();
    // getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff8E70C9),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            // LinearGradient
            gradient: LinearGradient(
              // colors for gradient
              colors: [
                Color.fromARGB(255, 101, 57, 223),
                Color.fromARGB(255, 196, 42, 196),
              ],
            ),
          ),
        ),
        title: Image(
            width: 120, height: 120, image: AssetImage("assets/images/ff.png")),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Center(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Order Detail",
                  style: TextStyle(
                      color: Color(0xfffEFEFEF),
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color(0xfffEFEFEF),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // ignore: unrelated_type_equality_checks
                              Character == 0
                                  ? CircleAvatar(
                                      backgroundImage:
                                          AssetImage("assets/images/male.png"),
                                      radius: 30,
                                    )
                                  : CircleAvatar(
                                      backgroundImage: AssetImage(
                                          "assets/images/female.png"),
                                      radius: 30,
                                    ),
                              SizedBox(
                                width: 12,
                              ),
                              Text(
                                UsernameU,
                                style: TextStyle(
                                    color: Color.fromARGB(255, 59, 6, 55),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("${restuarant.name}",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 44, 41, 41),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: 300,
                                child: Text("${restuarant.address}",
                                    softWrap: true,
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 44, 41, 41),
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Container(
                            width: 360,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Color.fromARGB(255, 253, 253, 253),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(children: createMenu()),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 220,
                            ),
                            Text(
                              "Total",
                              style: TextStyle(
                                color: Color.fromARGB(255, 15, 15, 15),
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "${Total}",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 3, 68, 8),
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 6,
                            ),
                            Text(
                              "Bath",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 15, 15, 15),
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),

                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "You will earn",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 44, 41, 41),
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    "฿ ${incomeRider.toString()}",
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 15, 75, 17),
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Spacer(),
                              ElevatedButton(
                                onPressed: () => {AcceptOrder()},
                                style: ElevatedButton.styleFrom(
                                    padding:
                                        EdgeInsets.fromLTRB(60, 15, 60, 15),
                                    primary: Color.fromARGB(255, 146, 4, 58),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    )),
                                child: Text('Accept',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14)),
                              ),
                            ],
                          ),
                        ),
                        // RawMaterialButton(
                        //   onPressed: () => {showalertLogout()},
                        //   // fillColor: Colors.blue,
                        //   child: Text(
                        //     'ยกเลิกออเดอร์',
                        //     style: TextStyle(
                        //         color: Color.fromARGB(255, 175, 26, 26),
                        //         fontWeight: FontWeight.w100),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String path = Api().path;

  getOrder() async {
    var url = Uri.parse(path + "/Order");

    var response = await http.get(url);
    List<Order> listOrderTemp = orderFromJson(response.body);
    for (var item in listOrderTemp) {
      if (item.orderID == widget.Orderid) {
        order = item;
      }
    }
    setState(() {
      order;
    });

    getMenu();
  }

  getUser() async {
    var url = Uri.parse(path + "/User");

    var response = await http.get(url);
    List<User> listUserTemp = userFromJson(response.body);

    for (var user in listUserTemp) {
      if (user.userID == order.userID) {
        userDetail = user;
        userID = user.userID;
        UsernameU = user.username;
        Character.add(user.character);
        break;
      }
    }

    setState(() {
      UsernameU;
      userID;
      Character;
      userDetail;
    });

    getRestuarant();
  }

  getRestuarant() async {
    var url = Uri.parse(path + "/Store/Search?keyword=${order.storeID}");

    var response = await http.get(url);
    List<Restuarant> listResTemp = restuarantFromJson(response.body);

    setState(() {
      restuarant = listResTemp[0];
    });
  }

  getMenu() async {
    var url = Uri.parse(path + "/Menu");

    var response = await http.get(url);
    listMenu = menuFromJson(response.body);
    setState(() {
      listMenu;
    });
    getOrderDetail();
  }

  getOrderDetail() async {
    var url = Uri.parse(path + "/CartDetail");

    var response3 = await http.get(url);
    List<CartDetail> listCartDetail = CartDetailFromJson(response3.body);

    int total = 0;

    Menus = [];
    orderdeteil = [];

    for (var orderDetail in listCartDetail) {
      if (order.cartID == orderDetail.CartID) {
        orderdeteil.add(orderDetail);
        for (var menu in listMenu) {
          if (menu.menuID == orderDetail.MenuID) {
            total += (orderDetail.Amount * menu.price);
            Menus.add(menu);
            Amount.add(orderDetail.Amount);
            break;
          }
        }
      }
    }

    Total = total;
    incomeRider = total * 10 / 100;

    setState(() {
      incomeRider;
      orderdeteil;
      Total;
      Amount;
      Menus;
    });

    getUser();
  }

  List<Widget> createMenu() {
    List<Widget> menus = [];
    for (int i = 0; i < Menus.length; i++) {
      menus.add(
        Row(
          children: [
            Text(
              Menus[i].name,
              style: TextStyle(
                color: Color.fromARGB(255, 59, 6, 55),
                fontSize: 13,
              ),
            ),
            Spacer(),
            Text(
              "x",
              style: TextStyle(
                color: Color.fromARGB(255, 59, 6, 55),
                fontSize: 13,
              ),
            ),
            Text(
              Amount[i].toString(),
              style: TextStyle(
                color: Color.fromARGB(255, 59, 6, 55),
                fontSize: 13,
              ),
            ),
          ],
        ),
      );
    }
    return menus;
  }

  AcceptOrder() async {
    await Hive.initFlutter();
    await Hive.openBox('id');
    var idRider = await Hive.box('id');
    String riderid = idRider.get(0);

    int status = 1;
    var url = Uri.parse(
        "$path/Order/UpdateAccept?keyword1=${widget.Orderid}&keyword2=$status&keyword3=$riderid");
    await http.post(url);

    String sendingChatID = 'SC';
    var url3 = Uri.parse("$path/SendingChat");
    var response = await http.get(url3);
    List<SendingChat> listSendingChat = SendingChatFromJson(response.body);
    if (listSendingChat.isNotEmpty) {
      int lastChatID = 0;
      String tempchatID = listSendingChat[0].sendingChatID;
      var tempchatIDArr = tempchatID.split('SC');
      lastChatID = int.parse(tempchatIDArr[1]);

      for (var a in listSendingChat) {
        if (a.sendingChatID != tempchatID) {
          String tempchatID2 = a.sendingChatID;
          var tempchatIDArr2 = tempchatID2.split('SC');
          if (int.parse(tempchatIDArr2[1]) > lastChatID) {
            lastChatID = int.parse(tempchatIDArr2[1]);
          }
        }
      }
      sendingChatID = "$sendingChatID${(lastChatID + 1).toString()}";
    } else {
      sendingChatID = "${sendingChatID}1";
    }

    var url2 = Uri.parse(
        "$path/SendingChat/Create?keyword1=$sendingChatID&keyword2=$riderid&keyword3=$userID&keyword4=${order.orderID}");
    print(url2);
    await http.post(url2);

    _channel.sink.add(jsonEncode({
      "storeID": order.storeID,
      "orderStatus": 1,
      "orderID": order.orderID
    }));

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => LicationPage(
                  order: order,
                  orderDetails: orderdeteil,
                  user: userDetail,
                  total: Total,
                  restuarant: restuarant,
                  menus: Menus,
                  sendingChatID: sendingChatID,
                )));
  }
}
