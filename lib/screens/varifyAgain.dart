import 'dart:io';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riderapp/models/api.dart';
import 'package:riderapp/screens/home.dart';
import 'package:riderapp/screens/login.dart';
import 'package:http/http.dart' as http;
//import 'package:riderapp/screens/preview_camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/Rider_models.dart';
import '../models/Verify_models.dart';

class VaerifyA extends StatefulWidget {
  const VaerifyA({super.key});

  @override
  State<VaerifyA> createState() => _VaerifyAState();
}

class _VaerifyAState extends State<VaerifyA> {
  String path = Api().path;
  String id = "";
  String idV = "";
  String status = 'VS1';
  String adminID = "null";
  UserRider rider = UserRider(
      riderID: 'riderID',
      verifyID: 'verifyID',
      username: 'username',
      password: 'password',
      phoneNum: 'phoneNum',
      name: 'name',
      surname: 'surname',
      profile: 'profile');
  File? image;
  File? image2;
  bool isLoading = false;
  String _imageurl = "";
  String _imageurl2 = "";
  List<UserRider> listRider = [];
  List<VerifyRider> listVerify = [];
  final getUsername = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final ImagePicker picker = ImagePicker();

  Future create() async {
    await FirebaseAuth.instance.signInAnonymously();
    _imageurl = await uploedImage(image!);
    _imageurl2 = await uploedImage2(image2!);
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
        .child("rider/ProfileA_" + getUsername.text);
    await reference.putFile(image);
    url = await reference.getDownloadURL();
    return url;
  }

  Future getImage2() async {
    try {
      final img = await picker.pickImage(source: ImageSource.camera);

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
        FirebaseStorage.instance.ref().child("rider/CardA_" + getUsername.text);
    await reference.putFile(image2);
    url = await reference.getDownloadURL();
    return url;
  }

  @override
  void initState() {
    getRider();
    // getVerify();
    // VerifyAgain();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Center(
        child: Form(
          key: formKey,
          child: Column(children: [
            SizedBox(
              height: 100,
            ),
            Text("Upload Identification card",
                style: TextStyle(
                    color: Color.fromARGB(255, 83, 82, 82),
                    // fontWeight: FontWeight.bold,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            image != null
                ? Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Image.file(
                        image!,
                        // fit: BoxFit.cover,
                        height: 100,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  )
                : Text("",
                    style: TextStyle(
                        color: Color.fromARGB(255, 83, 82, 82),
                        // fontWeight: FontWeight.bold,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(130, 0, 130, 0),
                child: ElevatedButton(
                  onPressed: () => {getImage()},
                  style: ElevatedButton.styleFrom(
                      // padding: EdgeInsets.fromLTRB(30, 15, 30, 15),
                      primary: Color.fromARGB(255, 164, 140, 211),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      )),
                  child: Center(
                    child: Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.image,
                          size: 20,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text("Upload",
                            style: TextStyle(
                                color: Color.fromARGB(255, 253, 253, 253),
                                // fontWeight: FontWeight.bold,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Text("take a picture of your straigth face",
                style: TextStyle(
                    color: Color.fromARGB(255, 83, 82, 82),
                    // fontWeight: FontWeight.bold,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            image2 != null
                ? Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Image.file(
                        image2!,
                        // fit: BoxFit.cover,
                        height: 100,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  )
                : Text("",
                    style: TextStyle(
                        color: Color.fromARGB(255, 83, 82, 82),
                        // fontWeight: FontWeight.bold,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(130, 0, 130, 0),
                child: ElevatedButton(
                  onPressed: () => {getImage2()},
                  style: ElevatedButton.styleFrom(
                      // padding: EdgeInsets.fromLTRB(30, 15, 30, 15),
                      primary: Color.fromARGB(255, 164, 140, 211),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      )),
                  child: Center(
                    child: Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.camera_enhance,
                          size: 20,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text("Upload",
                            style: TextStyle(
                                color: Color.fromARGB(255, 253, 253, 253),
                                // fontWeight: FontWeight.bold,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 100,
            ),
            MaterialButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  if (image == null && image2 == null) {
                    Fluttertoast.showToast(msg: 'กรุณายืนยันตัวตน');
                  } else {
                    if (isLoading) return;
                    setState(() => isLoading = true);

                    VerifyAgain();
                  }
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 221, 207, 6),
                      Color.fromARGB(255, 231, 134, 7),
                    ],
                  ),
                ),
                child: isLoading != false
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
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
                    : Text("          Submit           ",
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15),
              ),
            ),
          ]),
        ),
      ),
    ));
  }

  getRider() async {
    await Hive.initFlutter();
    await Hive.openBox('id');
    var idRider = await Hive.box('id');
    String ridarid = idRider.get(0);

    var url = Uri.parse(path + "/Rider");

    var response = await http.get(url);
    listRider = riderFromJson(response.body);
    for (var item in listRider) {
      if (item.riderID == ridarid) {
        setState(() {
          id = item.riderID;
          rider = item;
        });
        break;
      }
    }

    getVerify();
  }

  getVerify() async {
    var url = Uri.parse(path + "/VerifyRider");

    var response = await http.get(url);
    if (response.body.isNotEmpty) {
      listVerify = verifyFromJson(response.body);
    }
    for (var item in listVerify) {
      if (rider.verifyID == item.verifyID) {
        setState(() {
          idV = item.verifyID;
          // status = item.verifyStatusID;
        });
        break;
      }
    }
  }

  VerifyAgain() async {
    _imageurl = _imageurl.replaceAll('&', '%23');
    _imageurl2 = _imageurl2.replaceAll('&', '%23');

    _imageurl = _imageurl.replaceAll('://', '%3A%2F%2F');
    _imageurl2 = _imageurl2.replaceAll('://', '%3A%2F%2F');

    _imageurl = _imageurl.replaceAll('/v0/b/', '%2Fv0%2Fb%2F');
    _imageurl2 = _imageurl2.replaceAll('/v0/b/', '%2Fv0%2Fb%2F');

    _imageurl = _imageurl.replaceAll('/o/', '%2Fo%2F');
    _imageurl2 = _imageurl2.replaceAll('/o/', '%2Fo%2F');

    _imageurl = _imageurl.replaceAll('?', '%3F');
    _imageurl2 = _imageurl2.replaceAll('?', '%3F');

    _imageurl = _imageurl.replaceAll('=', '%3D');
    _imageurl2 = _imageurl2.replaceAll('=', '%3D');

    var url = Uri.parse(path +
        "/VerifyRider/UpdateImage?keyword1=$idV&keyword2=$_imageurl&keyword3=$_imageurl2");

    var res = await http.post(url);

    var url2 = Uri.parse(path +
        "/VerifyRider/UpdateStatus?keyword1=$idV&keyword2=$status&keyword3=$adminID");

    var res2 = await http.post(url2);
    print(url2);
    print(res2.statusCode);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ));
  }
}
