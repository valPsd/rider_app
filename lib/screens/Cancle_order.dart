import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:riderapp/models/Address_models.dart';
import 'package:riderapp/models/CartDetail_model.dart';
import 'package:riderapp/models/Menu_models.dart';
import 'package:riderapp/models/OrderDetail_models.dart';
import 'package:riderapp/models/Order_models.dart';
import 'package:riderapp/models/Rider_models.dart';
import 'package:riderapp/models/User_models.dart';
import 'package:http/http.dart' as http;
import 'package:riderapp/models/api.dart';
import 'package:riderapp/screens/orderDetail.dart';
import 'package:riderapp/screens/orderDetailCancle.dart';
import 'package:riderapp/screens/orderDetailCom.dart';

import '../models/Verify_models.dart';

class Cancle_Order extends StatefulWidget {
  const Cancle_Order({super.key});

  @override
  State<Cancle_Order> createState() => _Cancle_OrderState();
}

class _Cancle_OrderState extends State<Cancle_Order> {
  //List Order
  String Username = "";

  // int Character = 0;
  String Name = "";
  String Surname = "";
  String ProfileImage = "";
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
  List<Order> listOrder = [];
  List<User> listUser = [];
  List<Address> listAddress = [];
  List<Menu> listMenu = [];
  List<int> Character = [];
  //  List<int> Status = [];

  @override
  void initState() {
    // EasyLoading.show(status: 'loading...');
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 186, 169, 221),
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
              width: 120,
              height: 120,
              image: AssetImage("assets/images/ff.png")),
          centerTitle: true,
        ),
        body: Container(
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Cancle History",
                  style: TextStyle(
                      color: Color.fromARGB(255, 100, 6, 138),
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 25,
                ),
                Column(
                  children: createOrders(),
                )
              ],
            ),
          ),
        ));
  }

  String path = Api().path;

  List<Widget> createOrders() {
    List<Widget> orders = [];
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
                        builder: (context) => OrderDetailCPage(
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
                                  backgroundImage:
                                      AssetImage("assets/images/female.png"),
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
                          Text('Canceled',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color.fromARGB(255, 221, 17, 17),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18)),
                          // Text('Completed',
                          //     textAlign: TextAlign.center,
                          //     style: TextStyle(
                          //         color: Color.fromARGB(255, 11, 163, 92),
                          //         fontWeight: FontWeight.bold,
                          //         fontSize: 18)),
                          SizedBox(
                            width: 10,
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
    return orders;
  }

  getData() async {
    await Hive.initFlutter();
    await Hive.openBox('id');
    var idRider = await Hive.box('id');
    String ridarid = idRider.get(0);
    var url6 = Uri.parse(Api().path + "/Rider");
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
      }
      break;
    }

    var url = Uri.parse(path + "/Order");

    var response = await http.get(url);
    List<Order> listOrderTemp = orderFromJson(response.body);
    for (var order in listOrderTemp) {
      if (order.status == 4 && order.riderID == Rider.riderID) {
        listOrder.add(order);
        // Status.add(order.status);
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

    setState(() {
      listOrder;
      listMenu;
      Total;
      Amount;
      UsernameU;
      Character;
      ProfileImage;
      Username;
      Name;
      Surname;
      Rider;
    });
  }
}
