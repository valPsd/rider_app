import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';
import 'package:riderapp/models/ChatMessage.dart';
import 'package:riderapp/models/OrderDetail_models.dart';
import 'package:riderapp/models/api.dart';
import 'package:riderapp/models/wallet_model.dart';
import 'package:riderapp/screens/home.dart';
import 'package:riderapp/screens/location.dart';
import 'package:riderapp/screens/register.dart';
import 'package:http/http.dart' as http;
import '../models/CartDetail_model.dart';
import '../models/Menu_models.dart';
import '../models/Order_models.dart';
import '../models/Rider_models.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/User_models.dart';
import '../models/restuarant_model.dart';
import 'orderDetail.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String password = '';
  bool isPasswordVisible = false;
  bool _obscureText = true;
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final formkey = GlobalKey<FormState>();
  List<UserRider> allRider = [];
  UserRider adminCurrent = UserRider(
      riderID: '',
      password: '',
      verifyID: '',
      username: '',
      phoneNum: '',
      name: '',
      surname: '',
      profile: '');

  firbese() async {
    WidgetsFlutterBinding.ensureInitialized();
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyDH6BAciN_zTbcFKGk_3wXMghREeaZVcKQ",
            authDomain: "avnmetaverse.firebaseapp.com",
            projectId: "avnmetaverse",
            storageBucket: "avnmetaverse.appspot.com",
            messagingSenderId: "170904826922",
            appId: "1:170904826922:web:688f14dc453cb5ea3dbf53",
            measurementId: "G-XSWPGX1LSR"),
      );
    } else {
      await Firebase.initializeApp();
    }
  }

  @override
  void initState() {
    super.initState();
    firbese();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          // extendBodyBehindAppBar: true,
          body: SingleChildScrollView(
        child: Container(
          // width: double.infinity,
          child: Stack(children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/bk.jpg"),
                    fit: BoxFit.cover),
              ),
              width: double.infinity,
              height: size.height * 0.4,
            ),
            Row(
              children: [
                SizedBox(
                  width: 50,
                ),
                Container(
                  // alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 160),
                  width: 300,
                  height: 100,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/ff.png"),
                        fit: BoxFit.cover),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                const SizedBox(
                  height: 300,
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  width: double.infinity,
                  // height: 100,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black12,
                            blurRadius: 15,
                            offset: Offset(0, 5))
                      ]),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text("Login",
                          style: TextStyle(
                            color: Color.fromARGB(255, 80, 3, 70),
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          )),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        child: Form(
                            key: formkey,
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: usernameController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter username';
                                    }
                                  },
                                  autocorrect: false,
                                  decoration: InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color.fromARGB(
                                                  255, 123, 23, 148))),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color.fromARGB(
                                                  255, 213, 174, 223),
                                              width: 3)),
                                      hintText: 'Your Username...',
                                      labelText: 'Username',
                                      prefixIcon: Icon(
                                        Icons.person,
                                        size: 30,
                                        color: Color.fromARGB(255, 92, 11, 112),
                                      )),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  controller: passwordController,
                                  validator: (String? value) {
                                    if (value!.isEmpty) {
                                      return "Please enter password";
                                    }
                                    return null;
                                  },
                                  autocorrect: false,
                                  decoration: InputDecoration(
                                      isDense: true,
                                      suffixIcon: IconButton(
                                          icon: Icon(_obscureText
                                              ? Icons.visibility_off
                                              : Icons.visibility),
                                          onPressed: () {
                                            setState(() {
                                              _obscureText = !_obscureText;
                                            });
                                          }),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color.fromARGB(
                                                  255, 123, 23, 148))),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color.fromARGB(
                                                  255, 213, 174, 223),
                                              width: 3)),
                                      hintText: '********',
                                      labelText: 'Password',
                                      prefixIcon: Icon(
                                        Icons.lock,
                                        size: 30,
                                        color: Color.fromARGB(255, 92, 11, 112),
                                      )),
                                  obscureText: _obscureText,
                                ),
                                SizedBox(
                                  height: 50,
                                ),
                                MaterialButton(
                                  onPressed: () => {
                                    if (formkey.currentState!.validate())
                                      {getRider()}
                                  },
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
                                    child: Text("Login",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18)),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 80, vertical: 15),
                                  ),
                                )
                              ],
                            )),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                MaterialButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterPage(),
                        ));
                  },
                  child: Text(
                    "Create an Account",
                  ),
                )
              ],
            )
          ]),
        ),
      )),
    );
  }

  String path = Api().path;
  Order currentOrder = Order(
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
  List<CartDetail> orderDetails = [];
  User userOrder = User(
      userID: '',
      username: '',
      password: '',
      phoneNum: '',
      email: '',
      character: 0);
  int total = 0;
  Restuarant restuarant = Restuarant(
      storeID: "",
      name: "",
      username: "",
      password: "",
      telNum: "",
      email: "",
      address: "");
  List<Menu> menus = [];
  String sendingChatID = "";

  getRider() async {
    await Hive.initFlutter();
    await Hive.openBox('id');
    var idRider = await Hive.box('id');

    var url = Uri.parse(
        "${Api().path}/Rider/Login?keyword1=${usernameController.text}&keyword2=${passwordController.text}");
    var response = await http.get(url);
    allRider = riderFromJson(response.body);

    if (allRider.isNotEmpty) {
      idRider.put(0, allRider[0].riderID);

      getData();
    } else {
      Fluttertoast.showToast(msg: "username Or password is incorrect!");
    }
  }

  getData() async {
    var url1 = Uri.parse("${Api().path}/Order");
    var response1 = await http.get(url1);
    List<Order> listOrderTemp = orderFromJson(response1.body);
    bool isFound = false;
    Fluttertoast.showToast(msg: "Login correct");
    for (var order in listOrderTemp) {
      if (order.riderID == allRider[0].riderID) {
        if (order.status == 1 || order.status == 2) {
          isFound = true;
          currentOrder = order;
          break;
        }
      }
    }
    if (isFound) {
      var url = Uri.parse("$path/User");
      var response = await http.get(url);
      List<User> listUserTemp = userFromJson(response.body);

      var url2 =
          Uri.parse("$path/Store/Search?keyword=${currentOrder.storeID}");
      var response2 = await http.get(url2);
      List<Restuarant> listResTemp = restuarantFromJson(response2.body);
      restuarant = listResTemp[0];

      var url3 =
          Uri.parse(path + "/Menu/Search?keyword=${currentOrder.storeID}");
      var response3 = await http.get(url3);
      List<Menu> menusTemp = menuFromJson(response3.body);

      var url4 = Uri.parse(path + "/CartDetail");
      var response4 = await http.get(url4);
      List<CartDetail> listCartDetail = CartDetailFromJson(response4.body);
      int total = 0;

      menus = [];
      orderDetails = [];

      for (var orderDetail in listCartDetail) {
        if (currentOrder.cartID == orderDetail.CartID) {
          orderDetails.add(orderDetail);
          for (var menu in menusTemp) {
            if (menu.menuID == orderDetail.MenuID) {
              total += (orderDetail.Amount * menu.price);
              menus.add(menu);
              break;
            }
          }
        }
      }

      for (var user in listUserTemp) {
        if (user.userID == currentOrder.userID) {
          userOrder = user;
          break;
        }
      }

      var url5 = Uri.parse(
          path + "/SendingChat/Search?keyword=${currentOrder.orderID}");
      var response5 = await http.get(url5);
      Map<String, dynamic> chat = json.decode(response5.body);

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => LicationPage(
                  order: currentOrder,
                  orderDetails: orderDetails,
                  user: userOrder,
                  total: total,
                  restuarant: restuarant,
                  menus: menus,
                  sendingChatID: chat['id'])));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    }
  }
}
