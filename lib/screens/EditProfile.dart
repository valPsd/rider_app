import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gradients/gradients.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riderapp/models/Rider_models.dart';
import 'package:riderapp/models/api.dart';
import 'package:riderapp/screens/home.dart';
import 'package:riderapp/screens/profile.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/quickalert.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String path = Api().path;
  String ProfileImage = "";
  void showalertLogout() {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      text: 'Do you want to Save?',
      confirmBtnText: 'Yes',
      onConfirmBtnTap: () {
        editProfile();
      },
      cancelBtnText: 'No',
      confirmBtnColor: Colors.green,
    );
  }

  final colors = <Color>[
    Color.fromARGB(255, 109, 63, 201),
    Color(0xfff8E70C9),
  ];

  final getUsername = TextEditingController();
  final getName = TextEditingController();
  final getSurname = TextEditingController();
  final getPhoneNum = TextEditingController();
  final getPassword = TextEditingController();
  // bool isPasswordVisible = false;
  List<UserRider> listRider = [];

  String id = "";
  String Username = "";
  String Name = "";
  String Surname = "";
  String PhoneNum = "";

  final formKey = GlobalKey<FormState>();

  File? image;
  String _imageurl = "";

  final ImagePicker picker = ImagePicker();

  // get media => null;

  Future getImage() async {
    try {
      final img = await picker.pickImage(source: ImageSource.gallery);

      setState(() {
        if (img != null) {
          image = File(img.path);
        }
      });
    } catch (e) {
      print(e);
    }
  }

  Future create() async {
    await FirebaseAuth.instance.signInAnonymously();
    _imageurl = await uploedImage(image!);
  }

  Future uploedImage(File image) async {
    String url;
    Reference reference = FirebaseStorage.instance
        .ref()
        .child("rider/Profile_" + getUsername.text);
    await reference.putFile(image);
    url = await reference.getDownloadURL();
    return url;
  }

  @override
  void initState() {
    getRider();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          floatingActionButton: Wrap(
            //will break to another line on overflow
            direction: Axis.horizontal, //use vertical to show  on vertical axis
            children: <Widget>[
              Container(
                  margin: EdgeInsets.all(10),
                  child: FloatingActionButton(
                    onPressed: () {
                      showalertLogout();
                      //editProfile();
                    },
                    backgroundColor: Color.fromARGB(255, 11, 104, 65),
                    child: Icon(Icons.save),
                  )),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
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
                            // RawMaterialButton(
                            //   onPressed: () => {Navigator.of(context).pop()},
                            //   child: Icon(
                            //     Icons.arrow_back,
                            //     size: 20,
                            //     color: Color.fromARGB(255, 253, 252, 252),
                            //   ),
                            // ),
                            SizedBox(
                              height: 80,
                            ),
                            RawMaterialButton(
                              onPressed: () => {Navigator.of(context).pop()},
                              child: Icon(
                                Icons.arrow_back_ios,
                                size: 20,
                                color: Color.fromARGB(255, 253, 252, 252),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        image != null
                            ? CircleAvatar(
                                backgroundImage: FileImage(
                                  image as File,
                                ),
                                radius: 50,
                              )
                            : MaterialButton(
                                onPressed: () => {getImage()},
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
                        Text(
                          Name + " " + Surname,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 250, 249, 249),
                              fontSize: 18),
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
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              "Edit Account Info",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 56, 55, 55),
                                  fontSize: 18),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                                Text(
                                  "Name",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 8, 100, 57),
                                      fontSize: 16),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child: TextFormField(
                                controller: getName,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                                Text(
                                  "Username",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 67, 134, 98),
                                      fontSize: 16),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child: TextFormField(
                                controller: getUsername,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Image(
                                  image: AssetImage("assets/images/lock.png"),
                                  width: 35,
                                  height: 35,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Password",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 42, 122, 79),
                                      fontSize: 16),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child: TextFormField(
                                controller: getPassword,
                                keyboardType: TextInputType.text,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Image(
                                  image:
                                      AssetImage("assets/images/calling.png"),
                                  width: 35,
                                  height: 35,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Mobile",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 42, 122, 79),
                                      fontSize: 16),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child: TextFormField(
                                controller: getPhoneNum,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  getRider() async {
    await Hive.initFlutter();
    await Hive.openBox('id');
    var idRider = await Hive.box('id');
    String ridarid = idRider.get(0);

    var url = Uri.parse(path + "/Rider");

    var response = await http.get(url);
    listRider = riderFromJson(response.body);
    // print(listRider);
    // print(idRider);
    // print(ridarid);
    for (var item in listRider) {
      if (item.riderID == ridarid) {
        setState(() {
          id = item.riderID;
          ProfileImage = item.profile.replaceAll('#', '&');
          ProfileImage = item.profile.replaceAll('rider/', 'rider%2F');
          Username = item.username;
          Name = item.name;
          Surname = item.surname;
          PhoneNum = item.phoneNum;

          getName.text = Name + " " + Surname;
          getUsername.text = Username;
          getPhoneNum.text = PhoneNum;
          getPassword.text = item.password;
        });
        break;
      }
    }
  }

  editProfile() async {
    String email = "test";
    List<String> fullName = getName.text.split(" ");
    if (fullName[1] == "") {
      fullName[1] = ".";
    }

    if (image == null) {
      var url = Uri.parse(path +
          "/Rider/UpdateNoImg?keyword1=$id&keyword2=${getUsername.text}&keyword3=${getPhoneNum.text}&keyword4=${fullName[0]}&keyword5=${fullName[1]}&keyword6=$email");
      var res = await http.post(url);
    } else {
      await create();
      _imageurl = _imageurl.replaceAll('&', '%23');

      _imageurl = _imageurl.replaceAll('://', '%3A%2F%2F');

      _imageurl = _imageurl.replaceAll('/v0/b/', '%2Fv0%2Fb%2F');

      _imageurl = _imageurl.replaceAll('/o/', '%2Fo%2F');

      _imageurl = _imageurl.replaceAll('?', '%3F');

      _imageurl = _imageurl.replaceAll('=', '%3D');

      var url = Uri.parse(path +
          "/Rider/Update?keyword1=$id&keyword2=${getUsername.text}&keyword3=${getPhoneNum.text}&keyword4=${fullName[0]}&keyword5=${fullName[1]}&keyword6=$_imageurl&keyword7=$email");

      var res = await http.post(url);
    }

    Fluttertoast.showToast(msg: 'แก้ไขสำเร็จ');
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilePage(),
        ));
  }
}
