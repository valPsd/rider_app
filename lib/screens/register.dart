// import 'dart:html';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riderapp/models/api.dart';
import 'package:riderapp/models/rider_log_models.dart';
import 'package:riderapp/models/wallet_model.dart';
import 'package:riderapp/screens/login.dart';
import 'package:http/http.dart' as http;
//import 'package:riderapp/screens/preview_camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/Rider_models.dart';
import '../models/Verify_models.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // String path = "http://10.0.2.2:5212";
  String path = Api().path;
  // final cameras = availableCameras();
  String password = '';
  bool isPasswordVisible = false;
  bool isPasswordVisible2 = false;
  bool isLoading = false;

  final getEmail = TextEditingController();
  final getUsername = TextEditingController();
  final getName = TextEditingController();
  final getSurname = TextEditingController();
  final getPhoneNum = TextEditingController();
  final getPassword = TextEditingController();
  final getConPass = TextEditingController();

  List<UserRider> listRider = [];
  List<VerifyRider> listVerify = [];
  List<RiderLog> listRiderLog = [];
  final formKey = GlobalKey<FormState>();

  File? image;
  File? image2;
  File? image3;
  String _imageurl = "";
  String _imageurl2 = "";
  String _imageurl3 = "";

  final ImagePicker picker = ImagePicker();

  Future create() async {
    await FirebaseAuth.instance.signInAnonymously();
    _imageurl = await uploedImage(image!);
    _imageurl2 = await uploedImage2(image2!);
    _imageurl3 = await uploedImage3(image3!);
  }

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

  Future uploedImage(File image) async {
    String url;
    Reference reference = FirebaseStorage.instance
        .ref()
        .child("rider/Profile_" + getUsername.text);
    await reference.putFile(image);
    url = await reference.getDownloadURL();
    return url;
  }

  Future getImage2() async {
    try {
      final img = await picker.pickImage(source: ImageSource.gallery);

      setState(() {
        if (img != null) {
          image2 = File(img.path);
        }
      });
    } catch (e) {
      print(e);
    }
  }

  Future uploedImage2(File image2) async {
    String url;
    Reference reference =
        FirebaseStorage.instance.ref().child("rider/Card_" + getUsername.text);
    await reference.putFile(image2);
    url = await reference.getDownloadURL();
    return url;
  }

  Future getImage3() async {
    try {
      final img = await picker.pickImage(source: ImageSource.camera);

      setState(() {
        if (img != null) {
          image3 = File(img.path);
        }
      });
    } catch (e) {
      print(e);
    }
  }

  Future uploedImage3(File image3) async {
    String url;
    Reference reference =
        FirebaseStorage.instance.ref().child("rider/Face_" + getUsername.text);
    await reference.putFile(image3);
    url = await reference.getDownloadURL();
    return url;
  }

  @override
  void initState() {
    getRider();
    getVerify();
    getRiderLog();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        body: SingleChildScrollView(
          child: Container(
              // height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/bk.jpg"),
                    fit: BoxFit.cover),
              ),
              child: Column(children: [
                SizedBox(
                  height: 50,
                ),
                Container(
                  padding: EdgeInsets.all(10),
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
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          image != null
                              ? CircleAvatar(
                                  backgroundImage: FileImage(
                                    image!,
                                  ),
                                  radius: 35,
                                )
                              : MaterialButton(
                                  onPressed: () => {getImage()},
                                  child: Image(
                                    width: 75,
                                    height: 75,
                                    image: AssetImage("assets/images/pro.png"),
                                  ),
                                ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Form(
                        key: formKey,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: SizedBox(
                            height: 650,
                            child: Column(
                              children: [
                                TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  controller: getEmail,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'This field is required';
                                    }

                                    if (!RegExp(r'\S+@\S+\.\S+')
                                        .hasMatch(value)) {
                                      return "Please enter a valid email address";
                                    }

                                    return null;
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
                                      hintText: 'metaverse.avn@gmail.com',
                                      labelText: 'E-mail',
                                      prefixIcon: Icon(
                                        Icons.email,
                                        size: 30,
                                        color: Color.fromARGB(255, 92, 11, 112),
                                      )),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.name,
                                  controller: getUsername,
                                  validator: (value) {
                                    if (value == "") {
                                      return "Please enter username";
                                    }
                                    return null;
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
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        keyboardType: TextInputType.name,
                                        controller: getName,
                                        validator: (value) {
                                          if (value == "") {
                                            return "Please enter Your Name";
                                          }
                                          return null;
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
                                            hintText: 'Your Name...',
                                            labelText: 'Name',
                                            prefixIcon: Icon(
                                              Icons.person_outline,
                                              size: 30,
                                              color: Color.fromARGB(
                                                  255, 92, 11, 112),
                                            )),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 6,
                                    ),
                                    Column(
                                      children: [
                                        Text("|"),
                                        // Text("|"),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: TextFormField(
                                        keyboardType: TextInputType.name,
                                        controller: getSurname,
                                        validator: (value) {
                                          if (value == "") {
                                            return "Please enter Your Surname";
                                          }
                                          return null;
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
                                          hintText: 'Your Surname...',
                                          labelText: 'Surname',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    keyboardType: TextInputType.phone,
                                    controller: getPhoneNum,
                                    validator: (value) {
                                      if (value == "") {
                                        return "Please enter Your Telephone Number";
                                      }
                                      return null;
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
                                        hintText: 'Telephone Number',
                                        labelText: 'xxx-xxx-xxxx',
                                        prefixIcon: Icon(
                                          Icons.phone,
                                          size: 30,
                                          color:
                                              Color.fromARGB(255, 92, 11, 112),
                                        )),
                                  ),
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    controller: getPassword,
                                    validator: (value) {
                                      if (value == "") {
                                        return "Please enter Your Password";
                                      } else if (value!.length < 8) {
                                        return "Password must be at least 8 characters!";
                                      } else if (value != getConPass.text) {
                                        return "Password and Confirm Password must match";
                                      }
                                      return null;
                                    },
                                    obscureText: isPasswordVisible,
                                    keyboardType: TextInputType.text,
                                    autocorrect: false,
                                    decoration: InputDecoration(
                                        isDense: true,
                                        suffixIcon: IconButton(
                                          icon: isPasswordVisible
                                              ? Icon(Icons.visibility_off,
                                                  color: Color(0xfff833477))
                                              : Icon(Icons.visibility,
                                                  color: Color(0xfff833477)),
                                          onPressed: () => setState(() =>
                                              isPasswordVisible =
                                                  !isPasswordVisible),
                                        ),
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
                                          color:
                                              Color.fromARGB(255, 92, 11, 112),
                                        )),
                                    // obscureText: isPasswordVisible,
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    obscureText: isPasswordVisible2,
                                    keyboardType: TextInputType.text,
                                    controller: getConPass,
                                    validator: (value) {
                                      if (value == "") {
                                        return "Please enter Your Confirm Password";
                                      } else if (value!.length < 8) {
                                        return "Confirm Password must be at least 8 characters!";
                                      } else if (value != getPassword.text) {
                                        return "Password and Confirm Password must match";
                                      }
                                      return null;
                                    },

                                    autocorrect: false,
                                    decoration: InputDecoration(
                                        isDense: true,
                                        suffixIcon: IconButton(
                                          icon: isPasswordVisible2
                                              ? Icon(Icons.visibility_off,
                                                  color: Color(0xfff833477))
                                              : Icon(Icons.visibility,
                                                  color: Color(0xfff833477)),
                                          onPressed: () => setState(() =>
                                              isPasswordVisible2 =
                                                  !isPasswordVisible2),
                                        ),
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
                                        labelText: 'Confirm Password',
                                        prefixIcon: Icon(
                                          Icons.lock_outline,
                                          size: 30,
                                          color:
                                              Color.fromARGB(255, 92, 11, 112),
                                        )),
                                    // obscureText: isPasswordVisible2,
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 30,
                                    ),
                                    image2 != null
                                        ? Image.file(
                                            image2!,
                                            fit: BoxFit.cover,
                                            height: 40,
                                          )
                                        : Column(
                                            children: [
                                              Text(" Upload",
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 83, 82, 82),
                                                      // fontWeight: FontWeight.bold,
                                                      fontSize: 15)),
                                              Text(" Identification card",
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 83, 82, 82),
                                                      // fontWeight: FontWeight.bold,
                                                      fontSize: 15)),
                                            ],
                                          ),
                                    Spacer(),
                                    ElevatedButton(
                                      onPressed: () => {getImage2()},
                                      style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.fromLTRB(
                                              25, 15, 25, 15),
                                          backgroundColor: Color(0xfff8E70C9),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                          )),
                                      child: Text('Uplode',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              // fontWeight: FontWeight.bold,
                                              fontSize: 13)),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 30,
                                    ),
                                    image3 != null
                                        ? Image.file(
                                            image3!,
                                            // fit: BoxFit.cover,
                                            height: 40,
                                          )
                                        : Column(
                                            children: [
                                              Text("take a picture of ",
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 83, 82, 82),
                                                      // fontWeight: FontWeight.bold,
                                                      fontSize: 15)),
                                              Text("your straigth face",
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 83, 82, 82),
                                                      // fontWeight: FontWeight.bold,
                                                      fontSize: 15)),
                                            ],
                                          ),
                                    Spacer(),
                                    ElevatedButton(
                                      onPressed: () => {
                                        getImage3()
                                        // Navigator.push(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //         builder: (context) =>
                                        //             MainScreen()))
                                      },
                                      style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.fromLTRB(
                                              30, 15, 30, 15),
                                          primary: Color(0xfff8E70C9),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                          )),
                                      child: Icon(
                                        Icons.camera_enhance,
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 40,
                                ),
                                MaterialButton(
                                  onPressed: () async {
                                    if (formKey.currentState!.validate()) {
                                      if (image2 == null && image3 == null) {
                                        Fluttertoast.showToast(
                                            msg: 'กรุณายืนยันตัวตน');
                                      } else {
                                        if (isLoading) return;
                                        setState(() => isLoading = true);

                                        addRider();
                                      }
                                    }
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
                                    child: isLoading != false
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width: 20,
                                                height: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 15,
                                              ),
                                              Text("Please Wait . . .",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ))
                                            ],
                                          )
                                        : Text("Submit",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18)),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 60, vertical: 15),
                                  ),
                                ),
                                SizedBox(
                                  height: 35,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 100,
                )
              ])),
        ));
  }

  getRider() async {
    var url = Uri.parse(path + "/Rider");

    var response = await http.get(url);
    if (response.body.isNotEmpty) {
      listRider = riderFromJson(response.body);
    }
  }

  getVerify() async {
    var url = Uri.parse(path + "/VerifyRider");

    var response = await http.get(url);
    if (response.body.isNotEmpty) {
      listVerify = verifyFromJson(response.body);
    }
  }

  getRiderLog() async {
    var url = Uri.parse(path + "/RiderLog");

    var response = await http.get(url);
    if (response.body.isNotEmpty) {
      listRiderLog = riderLogFromJson(response.body);
    }
  }

  addRider() async {
    await create();

    bool isFound = false;
    if (!listRider.isNotEmpty) {
      for (var item in listRider) {
        if (item.name.toLowerCase() == getName.text.toLowerCase()) {
          isFound = true;
          break;
        }
      }
    }

    if (isFound) {
      Fluttertoast.showToast(msg: 'มีผู้ใช้นี้อยู่แล้ว');
    } else {
      var now = DateTime.now();
      String date = "${now.year}-${now.month}-${now.day}";
      String time = "${now.hour}:${now.minute}:${now.second}";

      String id = 'R';
      if (listRider.isNotEmpty) {
        int lastRiderID = 0;
        String tempRiderID = listRider[0].riderID;
        var tempRiderIDArr = tempRiderID.split('R');
        lastRiderID = int.parse(tempRiderIDArr[1]);

        for (var a in listRider) {
          if (a.riderID != tempRiderID) {
            String tempRiderID2 = a.riderID;
            var tempRiderIDArr2 = tempRiderID2.split('R');
            if (int.parse(tempRiderIDArr2[1]) > lastRiderID) {
              lastRiderID = int.parse(tempRiderIDArr2[1]);
            }
          }
        }
        id = "$id${(lastRiderID + 1).toString()}";
      } else {
        id = "${id}1";
      }

      String verifyID = 'V';
      if (listVerify.isNotEmpty) {
        int lastVerifyID = 0;
        String tempVerifyID = listVerify[0].verifyID;
        var tempVerifyIDArr = tempVerifyID.split('V');
        lastVerifyID = int.parse(tempVerifyIDArr[1]);

        for (var a in listVerify) {
          if (a.verifyID != tempVerifyID) {
            String tempRiderID2 = a.verifyID;
            var tempRiderIDArr2 = tempRiderID2.split('V');
            if (int.parse(tempRiderIDArr2[1]) > lastVerifyID) {
              lastVerifyID = int.parse(tempRiderIDArr2[1]);
            }
          }
        }
        verifyID = "$verifyID${(lastVerifyID + 1).toString()}";
      } else {
        verifyID = "${verifyID}1";
      }

      String logID = 'LR';
      if (listRiderLog.isNotEmpty) {
        int lastlogID = 0;
        String templogID = listRiderLog[0].logID;
        var templogIDArr = templogID.split('LR');
        lastlogID = int.parse(templogIDArr[1]);

        for (var a in listRiderLog) {
          if (a.logID != templogID) {
            String tempRiderLogID2 = a.logID;
            var tempRiderLogIDArr2 = tempRiderLogID2.split('LR');
            if (int.parse(tempRiderLogIDArr2[1]) > lastlogID) {
              lastlogID = int.parse(tempRiderLogIDArr2[1]);
            }
          }
        }
        logID = "$logID${(lastlogID + 1).toString()}";
      } else {
        logID = "${logID}1";
      }

      String verifyStatusID = "VS1";
      String adminID = "null";
      _imageurl = _imageurl.replaceAll('&', '%23');
      _imageurl2 = _imageurl2.replaceAll('&', '%23');
      _imageurl3 = _imageurl3.replaceAll('&', '%23');

      _imageurl = _imageurl.replaceAll('://', '%3A%2F%2F');
      _imageurl2 = _imageurl2.replaceAll('://', '%3A%2F%2F');
      _imageurl3 = _imageurl3.replaceAll('://', '%3A%2F%2F');

      _imageurl = _imageurl.replaceAll('/v0/b/', '%2Fv0%2Fb%2F');
      _imageurl2 = _imageurl2.replaceAll('/v0/b/', '%2Fv0%2Fb%2F');
      _imageurl3 = _imageurl3.replaceAll('/v0/b/', '%2Fv0%2Fb%2F');

      _imageurl = _imageurl.replaceAll('/o/', '%2Fo%2F');
      _imageurl2 = _imageurl2.replaceAll('/o/', '%2Fo%2F');
      _imageurl3 = _imageurl3.replaceAll('/o/', '%2Fo%2F');

      _imageurl = _imageurl.replaceAll('?', '%3F');
      _imageurl2 = _imageurl2.replaceAll('?', '%3F');
      _imageurl3 = _imageurl3.replaceAll('?', '%3F');

      _imageurl = _imageurl.replaceAll('=', '%3D');
      _imageurl2 = _imageurl2.replaceAll('=', '%3D');
      _imageurl3 = _imageurl3.replaceAll('=', '%3D');

      var url2 = Uri.parse(path +
          "/VerifyRider/Create?keyword1=$verifyID&keyword2=$verifyStatusID&keyword3=$adminID&keyword4=$_imageurl3&keyword5=$_imageurl2&keyword6=$date");
      var response = await http.post(url2);

      var url = Uri.parse(path +
          "/Rider/Create?keyword1=$id&keyword2=$verifyID&keyword3=${getUsername.text}&keyword4=${getPhoneNum.text}&keyword5=${getName.text}&keyword6=${getSurname.text}&keyword7=${getPassword.text}&keyword8=$_imageurl&keyword9=${getEmail.text}");
      await http.post(url);

      var url5 = Uri.parse(path +
          "/RiderLog/Create?keyword1=$logID&keyword2=$verifyID&keyword3=register&keyword4=null&keyword5=$date&keyword6=$time");
      await http.post(url5);

      var url3 = Uri.parse(path + "/WalletRider");
      var response3 = await http.get(url3);
      List<Wallet> listWallet = walletFromJson(response3.body);
      String walletID = 'WR';
      if (listWallet.isNotEmpty) {
        int lastChatID = 0;
        String tempchatID = listWallet[0].walletID;
        var tempchatIDArr = tempchatID.split('WR');
        lastChatID = int.parse(tempchatIDArr[1]);

        for (var a in listWallet) {
          if (a.walletID != tempchatID) {
            String tempchatID2 = a.walletID;
            var tempchatIDArr2 = tempchatID2.split('WR');
            if (int.parse(tempchatIDArr2[1]) > lastChatID) {
              lastChatID = int.parse(tempchatIDArr2[1]);
            }
          }
        }
        walletID = "$walletID${(lastChatID + 1).toString()}";
      } else {
        walletID = "${walletID}1";
      }

      int balance = 0;
      var url4 = Uri.parse(path +
          "/WalletRider/Create?keyword1=$walletID&keyword2=$id&keyword3=$balance");
      await http.post(url4);

      Fluttertoast.showToast(msg: 'ลงทะเบียนสำเร็จ');
      Navigator.of(context).pop();
    }
  }
}
