import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gradients/gradients.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:riderapp/models/Address_models.dart';
import 'package:riderapp/models/CartDetail_model.dart';
import 'package:riderapp/models/User_models.dart';
import 'package:riderapp/models/api.dart';
import 'package:riderapp/models/rider_log_models.dart';
import 'package:riderapp/screens/History.dart';
import 'package:riderapp/screens/incomeRider.dart';
import 'package:riderapp/screens/login.dart';
import 'package:riderapp/screens/orderDetail.dart';
import 'package:riderapp/screens/profile.dart';
import 'package:http/http.dart' as http;
import 'package:riderapp/screens/varifyAgain.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../models/Menu_models.dart';
import '../models/Order_models.dart';
import '../models/Rider_models.dart';
import '../models/Verify_models.dart';

class HomePage extends StatefulWidget {
  const HomePage(
      {super.key,
      this.color1 = const Color.fromARGB(255, 238, 186, 15),
      this.color2 = const Color.fromARGB(255, 231, 131, 15)});
  final Color color1;
  final Color color2;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // final _channel = WebSocketChannel.connect(
  //   Uri.parse('wss://avn-websocket-rider.onrender.com'),
  // );
  // final _channelOrder = WebSocketChannel.connect(
  //   Uri.parse('wss://avn-websocket-order.onrender.com'),
  // );

  var glowing = false;
  var scale = 1.0;
  final colors = <Color>[
    Color.fromARGB(255, 109, 63, 201),
    Color(0xfff8E70C9),
  ];
  final color1 = <Color>[
    Color.fromARGB(255, 172, 126, 2),
    Color(0xfff8E70C9),
  ];
  String path = Api().path;
  void showalertLogout() {
    QuickAlert.show(
        context: context,
        type: QuickAlertType.confirm,
        customAsset: 'assets/images/logout.gif',
        text: 'Do you want to logout?',
        confirmBtnText: 'Yes',
        cancelBtnText: 'No',
        confirmBtnColor: Colors.green,
        onConfirmBtnTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const LoginPage())); // ERROR
        });
  }

  String Username = "";
  // int Character = 0;
  String Name = "";
  String Surname = "";
  String ProfileImage = "";
  VerifyRider VS = new VerifyRider(
      verifyID: 'verifyID',
      verifyStatusID: 'verifyStatusID',
      adminID: 'adminID',
      faceImage: 'faceImage',
      cardImage: 'cardImage');
  UserRider Rider = new UserRider(
      riderID: 'riderID',
      verifyID: 'verifyID',
      username: 'username',
      password: 'password',
      phoneNum: 'phoneNum',
      name: 'name',
      surname: 'surname',
      profile: 'profile');

//List Order
  List<String> Amount = [];
  List<String> Total = [];
  List<String> UsernameU = [];

  List<UserRider> listRider = [];
  List<OrderModel> listOrder = [];
  List<User> listUser = [];
  List<Address> listAddress = [];
  List<Menu> listMenu = [];
  List<int> Character = [];
  List<VerifyRider> listVerify = [];
  List<RiderLog> listRiderLog = [];

  @override
  void initState() {
    FirebaseFirestore.instance.collection("VerifyRiders").snapshots().listen((event) {
      for (var change in event.docChanges) {
        switch (change.type) {
          case DocumentChangeType.added:
            print("New City: ${change.doc.data()}");
            if (VS.verifyID == change.doc.data()!['verifyID']) {
              if (change.doc.data()!['statusID'] == 'VS5') {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ));
              } else {
                getData();
              }
            }
            break;
          case DocumentChangeType.modified:
            print("Modified City: ${change.doc.data()}");
            if (VS.verifyID == change.doc.data()!['verifyID']) {
              if (change.doc.data()!['statusID'] == 'VS5') {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ));
              } else {
                getData();
              }
            }
            break;
          case DocumentChangeType.removed:
            // TODO: Handle this case.
            break;
        }
      }
    });
    // _channel.stream.listen((onData) {
    //   Map<String, dynamic> data = json.decode(onData);
    //   if (VS.verifyID == data['verifyID']) {
    //     if (data['statusID'] == 'VS5') {
    //       Navigator.pushReplacement(
    //           context,
    //           MaterialPageRoute(
    //             builder: (context) => LoginPage(),
    //           ));
    //     } else {
    //       getData();
    //     }
    //     // setState(() {
    //     //   VS.verifyStatusID = data['statusID'];
    //     // });
    //   }
    // });
    FirebaseFirestore.instance.collection("Orders").snapshots().listen((event) {
      for (var change in event.docChanges) {
        switch (change.type) {
          case DocumentChangeType.added:
            print("New City: ${change.doc.data()}");
            getData();
            break;
          case DocumentChangeType.modified:
            print("Modified City: ${change.doc.data()}");
            getData();
            break;
          case DocumentChangeType.removed:
            // TODO: Handle this case.
            break;
        }
      }
    });
    // _channelOrder.stream.listen((onData) {
    //   //String dataString = onData.toString();
    //   // Map<String, dynamic> data = json.decode(onData);
    //   // var data = jsonDecode(onData);
    //   // print(data.runtimeType);
    //   // print(onData.runtimeType);
    //   // if ((data['orderStatus']) == 0 ||
    //   //     (data['orderStatus']) == 1 ||
    //   //     (data['orderStatus']) == 4) {
    //   //   getData();
    //   // }
    //   getData();
    // });
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: VS.verifyStatusID != "VS1" &&
                VS.verifyStatusID != "VS3" &&
                VS.verifyStatusID != "VS4"
            ? Color(0xfff8E70C9)
            : Color.fromARGB(255, 215, 215, 219),
        appBar: AppBar(
          titleSpacing: 00.0,
          centerTitle: true,
          toolbarHeight: 60.2,
          toolbarOpacity: 0.8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(30),
                bottomLeft: Radius.circular(30)),
          ),
          elevation: 0.00,
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
              width: 120,
              height: 120,
              image: AssetImage("assets/images/ff.png")),
          leading: Builder(builder: (BuildContext context) {
            return IconButton(
                icon: Image(image: AssetImage("assets/images/menu.png")),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                });
          }),
          actions: <Widget>[
            Builder(builder: (BuildContext context) {
              return IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Income()));
                },
                icon: Image(
                    width: 60,
                    height: 60,
                    image: AssetImage(
                        "assets/images/coin_dollar_finance_icon_125510.png")),
              );
            }),
            SizedBox(
              width: 20,
            )
          ],
        ),
        drawer: Drawer(
          backgroundColor: Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(),
                      ));
                },
                child: UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                      gradient: LinearGradientPainter(
                          // colors for gradient
                          colors: colors,
                          colorSpace: ColorSpace.lab),
                      borderRadius: new BorderRadius.only(
                          bottomLeft: const Radius.circular(40.0),
                          bottomRight: const Radius.circular(40.0))),
                  accountName: Text(
                    Name + " " + Surname,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 250, 249, 249),
                        fontSize: 15),
                  ),
                  accountEmail: Row(
                    children: [
                      Text(
                        Username,
                        style: TextStyle(
                            color: Color.fromARGB(255, 247, 243, 243),
                            fontSize: 12),
                      ),
                      SizedBox(
                        width: 13,
                      ),
                    ],
                  ),
                  currentAccountPicture: ProfileImage != ""
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(ProfileImage),
                          radius: 50,
                        )
                      : CircleAvatar(
                          backgroundImage:
                              AssetImage("assets/images/female.png"),
                          radius: 50,
                        ),
                ),
              ),
              ListTile(
                leading: Image(
                  image: AssetImage("assets/images/activity.png"),
                  width: 30,
                  height: 30,
                ),
                title: Text(
                  "History",
                  style: TextStyle(
                      color: Color.fromARGB(255, 85, 2, 78), fontSize: 16),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => History(),
                      ));
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.logout_rounded,
                  color: Color.fromARGB(255, 138, 4, 4),
                ),
                title: Text(
                  "Logout",
                  style: TextStyle(
                      color: Color.fromARGB(255, 138, 4, 4), fontSize: 16),
                ),
                onTap: () {
                  showalertLogout();
                },
              ),
              AboutListTile(
                icon: Icon(
                  Icons.info,
                ),
                child: Text('About app'),
                applicationIcon: Icon(
                  Icons.local_play,
                ),
                applicationName: 'AVN Food Delivery',
                applicationVersion: '1.0.25',
                applicationLegalese: '© 2022 Company',
                aboutBoxChildren: [],
              ),
            ],
          ),
        ),
        body: Container(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              VS.verifyStatusID == "VS2"
                  ? Center(
                      child: Text(
                        "Incoming Order",
                        style: TextStyle(
                            color: Color.fromARGB(255, 240, 205, 237),
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  : SizedBox(),

              // if(VS.verifyStatusID == "VS1" &&
              //         VS.verifyStatusID == "VS3" &&
              //        VS.verifyStatusID == "VS4")
              //       SizedBox(),

              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  children: createOrders(),
                ),
              )
            ],
          ),
        )
        // StreamBuilder(
        //   stream: _channel.stream,
        //   builder: (context, snapshot) {
        //     if (snapshot.hasData) {
        //       Map<String, dynamic> data = json.decode(snapshot.data);
        //       if (VS.verifyID == data['verifyID'] &&
        //           VS.verifyStatusID != data['statusID']) {
        //         VS.verifyStatusID = data['statusID'];
        //       }
        //     }
        //     return Container(
        //       child: Column(
        //         children: [
        //           SizedBox(
        //             height: 20,
        //           ),
        //           VS.verifyStatusID != "VS1" &&
        //                   VS.verifyStatusID != "VS3" &&
        //                   VS.verifyStatusID != "VS4"
        //               ? Center(
        //                   child: Text(
        //                     "Incoming Order",
        //                     style: TextStyle(
        //                         color: Color.fromARGB(255, 240, 205, 237),
        //                         fontSize: 22,
        //                         fontWeight: FontWeight.bold),
        //                   ),
        //                 )
        //               : SizedBox(),
        //           SizedBox(
        //             height: 20,
        //           ),
        //           Padding(
        //             padding: EdgeInsets.all(8),
        //             child: Column(
        //               children: createOrders(),
        //             ),
        //           )
        //         ],
        //       ),
        //     );
        //   },
        // )
        );
  }

  List<Widget> createOrders() {
    List<Widget> orders = [];

    if (VS.verifyStatusID == "VS1") {
      orders.add(Center(
          child: Center(
        child: Column(
          children: [
            SizedBox(
              height: 100,
            ),
            Image(
              image: AssetImage("assets/images/Waiting.png"),
              width: 80,
              height: 80,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "อยู่ระหว่างรอการยืนยันตัวตน",
              style: TextStyle(
                  color: Color.fromARGB(255, 28, 61, 133),
                  fontSize: 19,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              "คุณสามารถเช็คสถานะการยืนยันตัวตนได้ที่นี่",
              style: TextStyle(
                color: Color.fromARGB(255, 60, 61, 63),
                fontSize: 15,
              ),
            ),
          ],
        ),
      )));
    } else if (VS.verifyStatusID == "VS3") {
      orders.add(Center(
        child: Column(
          children: [
            SizedBox(
              height: 100,
            ),
            Image(
              image: AssetImage("assets/images/warning.png"),
              width: 70,
              height: 70,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "คุณไม่ผ่านการยืนยันตัวตน",
              style: TextStyle(
                  color: Color.fromARGB(255, 187, 142, 60),
                  fontSize: 19,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              "เหตุผล: ${listRiderLog[listRiderLog.length - 1].reason}",
              style: TextStyle(
                  color: Color.fromARGB(255, 187, 142, 60),
                  fontSize: 19,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              "กรุณายืนยันตัวตนใหม่อีกครั้ง",
              style: TextStyle(
                color: Color.fromARGB(255, 59, 58, 58),
                fontSize: 15,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VaerifyA(),
                    ));
              },
              onTapUp: (val) {
                setState(() {
                  glowing = false;
                  scale = 1.0;
                });
              },
              onTapDown: (val) {
                setState(() {
                  glowing = true;
                  scale = 1.1;
                });
              },
              child: AnimatedContainer(
                transform: Matrix4.identity()..scale(scale),
                duration: Duration(milliseconds: 200),
                height: 48,
                width: 160,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    gradient: LinearGradient(
                      colors: [
                        widget.color1,
                        widget.color2,
                      ],
                    ),
                    boxShadow: glowing
                        ? [
                            BoxShadow(
                              color: widget.color1.withOpacity(0.6),
                              spreadRadius: 1,
                              blurRadius: 16,
                              offset: Offset(-8, 0),
                            ),
                            BoxShadow(
                              color: widget.color2.withOpacity(0.6),
                              spreadRadius: 1,
                              blurRadius: 16,
                              offset: Offset(8, 0),
                            ),
                            BoxShadow(
                              color: widget.color1.withOpacity(0.2),
                              spreadRadius: 16,
                              blurRadius: 32,
                              offset: Offset(-8, 0),
                            ),
                            BoxShadow(
                              color: widget.color2.withOpacity(0.2),
                              spreadRadius: 16,
                              blurRadius: 32,
                              offset: Offset(8, 0),
                            )
                          ]
                        : []),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon(
                    //   Icons.photo,
                    //   color: Colors.white,
                    // ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Verify again",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Image(
                      width: 40,
                      height: 40,
                      image: AssetImage("assets/images/skip.png"),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ));
    } else if (VS.verifyStatusID == "VS4") {
      orders.add(Center(
          child: Center(
        child: Column(
          children: [
            SizedBox(
              height: 100,
            ),
            Image(
              image: AssetImage("assets/images/suspended.png"),
              width: 60,
              height: 60,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "ไม่สามารถใช้งานได้",
              style: TextStyle(
                  color: Color.fromARGB(255, 245, 12, 12),
                  fontSize: 19,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              "บัญชีของคุณถูกระงับเนื่องจาก ${listRiderLog[listRiderLog.length - 1].reason}",
              style: TextStyle(
                color: Color.fromARGB(255, 60, 61, 63),
                fontSize: 15,
              ),
            ),
            Text(
              "คุณสามารถยื่นอุธรณ์ได้ที่อีเมล metaverse.avn@gmail.com",
              style: TextStyle(
                color: Color.fromARGB(255, 60, 61, 63),
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      )));
    } else if (VS.verifyStatusID == "VS2") {
      if (listOrder.length > 0 && UsernameU.length > 0 && listMenu.length > 0) {
        for (int i = 0; i < listOrder.length; i++) {
          orders.add(
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderDetailPage(
                              Orderid: listOrder[i].orderID,
                            ),
                          ));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color.fromARGB(255, 253, 253, 253),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Character[i] == 0
                                  ? CircleAvatar(
                                      backgroundImage: AssetImage(
                                          "assets/images/female.png"),
                                      radius: 30,
                                    )
                                  : CircleAvatar(
                                      backgroundImage:
                                          AssetImage("assets/images/male.png"),
                                      radius: 30,
                                    ),
                              SizedBox(
                                width: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    UsernameU[i],
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 77, 7, 71),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  Text(
                                    Amount[i] + " products",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 114, 111, 114),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              Spacer(),
                              Row(
                                children: [
                                  Text(
                                    Total[i],
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 8, 102, 47),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "Bath",
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 8, 102, 47),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          );
        }
      } else if (listOrder.isEmpty) {
        orders.add(Center(
          child: Column(
            children: [
              SizedBox(
                height: 100,
              ),
              Image(
                image: AssetImage("assets/images/grocery-cart.png"),
                width: 80,
                height: 80,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "ยังไม่มีออเดอร์",
                style: TextStyle(
                    color: Color.fromARGB(255, 253, 252, 252),
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "คุณสามารถเช็คออเดอร์ได้ที่นี่",
                style: TextStyle(
                  color: Color.fromARGB(255, 251, 251, 252),
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ));
      }
    }
    return orders;
  }

  // getRider() async {
  //   await Hive.initFlutter();
  //   await Hive.openBox('id');
  //   var idRider = await Hive.box('id');
  //   String ridarid = idRider.get(0);

  //   var url = Uri.parse("https://avn-api.onrender.com/Rider");

  //   var response = await http.get(url);
  //   listRider = riderFromJson(response.body);
  //   for (var item in listRider) {
  //     if (item.riderID == ridarid) {
  //       setState(() {
  //         ProfileImage = item.profile.replaceAll('#', '&');
  //         ProfileImage = item.profile.replaceAll('rider/', 'rider%2F');
  //         Username = item.username;
  //         Name = item.name;
  //         Surname = item.surname;
  //         Rider = item;
  //       });
  //     }
  //   }
  // }

  getData() async {
    var url = Uri.parse(path + "/Order");

    var response = await http.get(url);
    List<OrderModel> listOrderTemp = orderModelFromJson(response.body);
    listOrder = [];
    for (var order in listOrderTemp) {
      if (order.status == 0) {
        listOrder.add(order);
      }
    }

    var url2 = Uri.parse(path + "/Menu");
    var response2 = await http.get(url2);
    listMenu = menuFromJson(response2.body);

    var url3 = Uri.parse(path + "/CartDetail");
    var response3 = await http.get(url3);
    List<CartDetail> listCartDetail = CartDetailFromJson(response3.body);
    for (var order in listOrder) {
      int amount = 0;
      int total = 0;
      for (var orderDetail in listCartDetail) {
        if (order.cartID == orderDetail.CartID) {
          amount += 1;
          for (var menu in listMenu) {
            if (menu.menuID == orderDetail.MenuID) {
              total += (orderDetail.Amount * menu.price);
              break;
            }
          }
        }
      }
      Total.add(total.toString());
      Amount.add(amount.toString());
    }

    var url4 = Uri.parse(path + "/User");
    var response4 = await http.get(url4);
    List<User> listUserTemp = userFromJson(response4.body);
    for (var order in listOrder) {
      for (var user in listUserTemp) {
        if (user.userID == order.userID) {
          Character.add(user.character);
          UsernameU.add(user.username);
          break;
        }
      }
    }

    await Hive.initFlutter();
    await Hive.openBox('id');
    var idRider = await Hive.box('id');
    String ridarid = idRider.get(0);
    var url6 = Uri.parse("${Api().path}/Rider");
    var response6 = await http.get(url6);
    listRider = riderFromJson(response6.body);
    for (var item in listRider) {
      if (item.riderID == ridarid) {
        ProfileImage = item.profile.replaceAll('#', '&');
        ProfileImage = item.profile.replaceAll('rider/', 'rider%2F');
        Username = item.username;
        Name = item.name;
        Surname = item.surname;
        Rider = item;
        break;
      }
    }

    var url7 = Uri.parse(path + "/VerifyRider");

    var response7 = await http.get(url7);
    if (response7.body.isNotEmpty) {
      listVerify = verifyFromJson(response7.body);
      for (var element in listVerify) {
        if (element.verifyID == Rider.verifyID) {
          VS = element;
        }
      }
    }

    var url8 = Uri.parse("$path/RiderLog/SearchVerify?keyword=${VS.verifyID}");

    var response8 = await http.get(url8);
    if (response8.body.isNotEmpty) {
      listRiderLog = riderLogFromJson(response8.body);
      // for (var element in listVerify) {
      //   if (element.verifyID == Rider.verifyID) {
      //     VS = element;
      //   }
      // }
    }

    setState(() {
      listOrder;
      listMenu;
      Total;
      Amount;
      UsernameU;
      Character;
      VS;
      ProfileImage;
      Username;
      Name;
      Surname;
      Rider;
      listRiderLog;
    });
  }
}
