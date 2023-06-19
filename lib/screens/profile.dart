import 'dart:convert';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gradients/gradients.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:riderapp/screens/EditProfile.dart';
import 'package:riderapp/screens/home.dart';
import 'package:http/http.dart' as http;
import '../models/Rider_models.dart';
import '../models/api.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final colors = <Color>[
    Color.fromARGB(255, 109, 63, 201),
    Color(0xfff8E70C9),
  ];

  String ProfileImage = "";
  String Username = "";
  // String Email = "";
  String Name = "";
  String Surname = "";
  String PhoneNum = "";

  List<UserRider> listRider = [];

  @override
  void initState() {
    // EasyLoading.show(status: 'loading...');
    getRider();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final gradient =
        LinearGradientPainter(colors: colors, colorSpace: ColorSpace.cmyk);

    return SafeArea(
      child: Scaffold(
          // appBar: AppBar(),
          body: Column(
        children: [
          Container(
              height: 250,
              decoration: BoxDecoration(
                  gradient: LinearGradientPainter(
                      // colors for gradient
                      colors: colors,
                      colorSpace: ColorSpace.lab),
                  borderRadius: new BorderRadius.only(
                      bottomLeft: const Radius.circular(70.0),
                      bottomRight: const Radius.circular(70.0))),
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        height: 80,
                      ),
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
                  // SizedBox(
                  //   height: 10,
                  //ProfileImage == ""
                  ProfileImage != ""
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(ProfileImage),
                          radius: 50,
                        )
                      : CircleAvatar(
                          backgroundImage:
                              AssetImage("assets/images/female.png"),
                          radius: 50,
                        ),

                  // Container(child: Image.memory(ProfileImage)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        Name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 250, 249, 249),
                            fontSize: 18),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        Surname,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 250, 249, 249),
                            fontSize: 18),
                      ),
                    ],
                  ),
                  Text(
                    Username,
                    style: TextStyle(
                        color: Color.fromARGB(255, 201, 199, 199),
                        fontSize: 15),
                  ),
                ],
              )),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      "Account Info",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 56, 55, 55),
                          fontSize: 18),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProfile(),
                            ));
                      },
                      child: Icon(
                        Icons.edit,
                        size: 16,
                        color: Color.fromARGB(255, 68, 67, 67),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Image(
                      image: AssetImage("assets/images/user.png"),
                      width: 35,
                      height: 35,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Name",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 8, 100, 57),
                              fontSize: 16),
                        ),
                        Row(
                          children: [
                            Text(
                              Name,
                              style: TextStyle(
                                  color: Color.fromARGB(255, 97, 95, 95),
                                  fontSize: 16),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              Surname,
                              style: TextStyle(
                                  color: Color.fromARGB(255, 97, 95, 95),
                                  fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Image(
                      image: AssetImage("assets/images/userr.png"),
                      width: 35,
                      height: 35,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Username",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 67, 134, 98),
                              fontSize: 16),
                        ),
                        Text(
                          Username,
                          style: TextStyle(
                              color: Color.fromARGB(255, 97, 95, 95),
                              fontSize: 16),
                        ),
                      ],
                    )
                  ],
                ),
                // SizedBox(
                //   height: 15,
                // ),
                // Row(
                //   children: [
                //     Image(
                //       image: AssetImage("assets/images/emaill.png"),
                //       width: 35,
                //       height: 35,
                //     ),
                //     SizedBox(
                //       width: 10,
                //     ),
                //     Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         Text(
                //           "Email",
                //           style: TextStyle(
                //               fontWeight: FontWeight.bold,
                //               color: Color.fromARGB(255, 67, 134, 98),
                //               fontSize: 16),
                //         ),
                //         Text(
                //           Email,
                //           style: TextStyle(
                //               color: Color.fromARGB(255, 97, 95, 95),
                //               fontSize: 16),
                //         ),
                //       ],
                //     )
                //   ],
                // ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Image(
                      image: AssetImage("assets/images/calling.png"),
                      width: 35,
                      height: 35,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Mobile",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 42, 122, 79),
                              fontSize: 16),
                        ),
                        Text(
                          PhoneNum,
                          style: TextStyle(
                              color: Color.fromARGB(255, 97, 95, 95),
                              fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      )),
    );
  }

  getRider() async {
    await Hive.initFlutter();
    await Hive.openBox('id');
    var idRider = await Hive.box('id');
    String ridarid = idRider.get(0);

    var url = Uri.parse("${Api().path}/Rider");

    var response = await http.get(url);
    listRider = riderFromJson(response.body);
    for (var item in listRider) {
      if (item.riderID == ridarid) {
        setState(() {
          ProfileImage = item.profile.replaceAll('#', '&');
          ProfileImage = item.profile.replaceAll('rider/', 'rider%2F');
          print(ProfileImage);
          Username = item.username;
          Name = item.name;
          Surname = item.surname;
          PhoneNum = item.phoneNum;
        });
        break;
      }
    }
  }
}
