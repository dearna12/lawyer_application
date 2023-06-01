import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:flutter_laywer_app/constants.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:lawyers/utils/constants.dart';

import '../utils/authentication.dart';

class HomeScreenNavbar extends StatelessWidget {
  HomeScreenNavbar({Key? key, required this.scaffoldKey}) : super(key: key);

  final GlobalKey<ScaffoldState> scaffoldKey;

  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () {
            scaffoldKey.currentState!.openDrawer();
          },
          child: Container(
            height: 24,
            width: 24,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: Svg(
                  'assets/svg/icon-burger.svg',
                  size: Size(
                    24,
                    24,
                  ),
                ),
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            GoRouter.of(context).go("/home/profile");
          },
          child: FutureBuilder(
              future: db
                  .collection("users")
                  .doc(AuthenticationHelper().user.uid)
                  .get(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                      snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
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

                return Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(100)),
                    child: snapshot.data!.get('photo') == ""
                        ? Icon(Icons.person, size: 24)
                        : ClipRRect(
                            child: Image.network(snapshot.data!.get("photo")),
                            borderRadius: BorderRadius.circular(60)));
              }),
        )
      ],
    );
  }
}
