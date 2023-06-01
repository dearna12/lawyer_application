import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lawyers/components/custom_home_drawer.dart';
import 'package:lawyers/utils/authentication.dart';
import 'package:lawyers/utils/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var size, height, width;
  var paddingRatio = 0.068;
  final ImagePicker _picker = ImagePicker();
  Map<String, dynamic> userObject = {};

  final db = FirebaseFirestore.instance;
  File? _photo;
  // this variable used to store the future _fetchData function inorder to avoid loop on a future builder
  // late final Future? _fetchDataFuture;
  //image url variable
  String profileImageUrl = '';

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  var name = AuthenticationHelper().user.uid;
  // @override
  @override
  void initState() {
    super.initState();
    //initialize the variable with the future function
    // _fetchDataFuture = _fetchData();
    initValues();
  }

  void initValues() async {
    await db
        .collection("users")
        .doc(AuthenticationHelper().user.uid)
        .get()
        .then((snapshot) => {userObject = snapshot.data()!});
  }

  Future uploadFile() async {
    if (_photo == null) return;
    final fileName = basename(_photo!.path);
    final destination = '/';
    var temp = _photo!.path.split(".");
    var extension = temp[temp.length - 1];
    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child(name + "." + extension);
      var uploadTask = ref.putFile(_photo!);

      await uploadTask.whenComplete(() {
        ref.getDownloadURL().then((value) {
          db.collection("users").doc(name).update({'photo': value});
          setState(() {
            profileImageUrl = value;
          });
        });
      });
    } catch (e) {
      print('error occured while uploading image ' + e.toString());
    }
  }

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  // Future _fetchData() async {
  //   DocumentSnapshot user =
  //       await db.collection("users").doc(AuthenticationHelper().user.uid).get();
  //   Reference ref =
  //       firebase_storage.FirebaseStorage.instance.ref().child(user['photo']);
  //   ;
  //   ref.getDownloadURL().then((url) => setState(() {
  //         profileImageUrl = url;
  //       }));
  //   return user;
  // }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;

    return Scaffold(
      drawer: CustomHomeDrawer(),
      appBar: AppBar(title: Text("Your Profile")),
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: ListView(
          children: [
            FutureBuilder(
                future: db
                    .collection("users")
                    .doc(AuthenticationHelper().user.uid)
                    .get(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                        snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Text("loading...");
                    default:
                      if (snapshot.hasError) {
                        return Text("There was an error");
                      } else {
                        var item_data = snapshot.data;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                                child: Row(children: [
                              InkWell(
                                onTap: () {
                                  imgFromGallery();
                                },
                                child: Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                    child: profileImageUrl == ''
                                        ? snapshot.data!.get('photo') == ""
                                            ? Icon(Icons.person, size: 32)
                                            : ClipRRect(
                                                child: Image.network(snapshot
                                                    .data!
                                                    .get("photo")),
                                                borderRadius:
                                                    BorderRadius.circular(60))
                                        : ClipRRect(
                                            child:
                                                Image.network(profileImageUrl),
                                            borderRadius:
                                                BorderRadius.circular(60))),
                              ),
                              SizedBox(width: 20),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item_data!.get('name'),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6),
                                    Text(
                                      item_data!.get('role') == null
                                          ? "Unknown"
                                          : item_data['role'] == 1
                                              ? 'Lawyer Account'
                                              : item_data['role'] == 2
                                                  ? 'Admin Account'
                                                  : 'Customer Account',
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption!
                                          .copyWith(color: Colors.blue),
                                    )
                                  ])
                            ])),
                            SizedBox(height: 16),
                            item_data.get('role') == 1
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text("Lawyer Panel",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      FutureBuilder(
                                          future: db
                                              .collection("users")
                                              .doc(AuthenticationHelper()
                                                  .user
                                                  .uid)
                                              .get(),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<
                                                      DocumentSnapshot<
                                                          Map<String, dynamic>>>
                                                  snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return SpinKitDancingSquare(
                                                color: Colors.blueGrey,
                                                size: 50.0,
                                              );
                                            }
                                            if (!snapshot.hasData) {
                                              return Text("No Dat found");
                                            }
                                            if (snapshot.hasError) {
                                              return Text("There was an Error");
                                            }
                                            return ListTile(
                                              onTap: () {
                                                GoRouter.of(context).go(snapshot
                                                            .data!
                                                            .get("role") ==
                                                        1
                                                    ? "/home/appointments"
                                                    : "/home/client_appointments");
                                              },
                                              leading: const Icon(
                                                Icons.list,
                                                color: Colors.grey,
                                              ),
                                              title: Text(
                                                'Appointments',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6!
                                                    .copyWith(
                                                        color: Colors.grey),
                                              ),
                                            );
                                          }),
                                      customCard(
                                          context,
                                          "Update Info",
                                          Icons.edit,
                                          Colors.green.shade100,
                                          "/home/profile/edit"),
                                    ],
                                  )
                                : Container(),
                          ],
                        );
                      }
                  }
                }),
            Divider(),
            AuthenticationHelper().isAdmin
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Admin Panel",
                          style: Theme.of(context).textTheme.headline6),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        height: 100,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          // mainAxisSize: MainAxisSize.min,
                          children: [
                            customCard(context, "Users", Icons.person,
                                Colors.green.shade100, "/home/profile/users"),
                            customCard(
                                context,
                                "Lawyers",
                                Icons.school,
                                Colors.yellow.shade100,
                                "/home/profile/lawyers"),
                          ],
                        ),
                      ),
                    ],
                  )
                : Container(),
            SizedBox(height: 20),
            InkResponse(
              onTap: () {
                AuthenticationHelper()
                    .signOut()
                    .then((value) => {GoRouter.of(context).go("/login")});
              },
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.black),
                width: double.infinity,
                child: Row(
                  children: [
                    Spacer(),
                    Icon(Icons.logout, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      "Logout",
                      style: TextStyle(color: Colors.white),
                    ),
                    Spacer()
                  ],
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }

  Widget customCard(context, text, icon, color, route) {
    return InkWell(
      onTap: () {
        GoRouter.of(context).go(route);
      },
      child: Container(
        height: 100,
        width: 100,
        margin: EdgeInsets.only(right: 10),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              icon,
              color: Colors.grey.shade700,
              size: 48,
            ),
            Text(text)
          ],
        ),
      ),
    );
  }
}
