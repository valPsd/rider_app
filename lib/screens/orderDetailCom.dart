import 'package:flutter/material.dart';
import 'package:riderapp/models/Address_models.dart';
import 'package:riderapp/models/CartDetail_model.dart';
import 'package:riderapp/models/Menu_models.dart';
import 'package:riderapp/models/OrderDetail_models.dart';
import 'package:riderapp/models/Order_models.dart';
import 'package:riderapp/models/Rider_models.dart';
import 'package:riderapp/models/User_models.dart';
import 'package:riderapp/models/api.dart';
import 'package:riderapp/screens/home.dart';
import 'package:riderapp/screens/login.dart';
import 'package:riderapp/screens/messageScreen.dart';
import 'package:quickalert/quickalert.dart';
import 'package:http/http.dart' as http;

import '../models/restuarant_model.dart';
import 'location.dart';

class OrderDetailComPage extends StatefulWidget {
  OrderDetailComPage({super.key, required this.Orderid});
  String Orderid;
  @override
  State<OrderDetailComPage> createState() => _OrderDetailComState();
}

class _OrderDetailComState extends State<OrderDetailComPage> {
  void showalert() {
    QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: ' Order delivery success',
        onConfirmBtnTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const HomePage())); // ERROR
        });
  }

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
  List<OrderDetail> orderdeteil = [];
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
  Restuarant restuarant = Restuarant(
      storeID: '',
      name: '',
      username: '',
      password: '',
      telNum: '',
      email: '',
      address: '');

  String UsernameU = "";
  List<String> Menulist = [];
  List<int> Amount = [];
  int Total = 0;
  double incomeRider = 0.0;

  @override
  void initState() {
    // EasyLoading.show(status: 'loading...');
    getOrder();
    getMenu();
    getOrderDetail();
    getUser();
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
                              Character == 0
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
                        SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "${restuarant.name}",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 44, 41, 41),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
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
                              Text('Completed',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 7, 114, 43),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                              SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        ),
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
        UsernameU = user.username;
        Character.add(user.character);
        break;
      }
    }

    setState(() {
      UsernameU;
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

    for (var orderDetail in listCartDetail) {
      if (order.cartID == orderDetail.CartID) {
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
}
