import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:lawyers/utils/authentication.dart';
import 'package:lawyers/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomHomeDrawer extends StatelessWidget {
  final db = FirebaseFirestore.instance;

  CustomHomeDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 200,
            width: double.infinity,
            color: Colors.grey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FutureBuilder(
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

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(100)),
                              child: snapshot.data!.get('photo') == ""
                                  ? Icon(Icons.person, size: 24)
                                  : ClipRRect(
                                      child: Image.network(
                                          snapshot.data!.get("photo")),
                                      borderRadius: BorderRadius.circular(60))),
                          Text(snapshot.data!.get('name')),
                        ],
                      );
                    }),
                const SizedBox(height: 17),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Menu',
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(color: Colors.grey),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            width: double.infinity,
            height: 1,
            color: Colors.grey,
          ),
          FutureBuilder(
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
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    snapshot.data!.get("role") == 1
                        ? ListTile(
                            onTap: () {
                              GoRouter.of(context).go("/home/lawyers");
                            },
                            leading: const Icon(
                              Icons.notes,
                              color: Colors.grey,
                            ),
                            title: Text(
                              'Lawyers',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(color: Colors.grey),
                            ),
                          )
                        : Container(),
                    snapshot.data!.get("role") != 2
                        ? ListTile(
                            onTap: () {
                              GoRouter.of(context).go(
                                  snapshot.data!.get("role") == 1
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
                                  .copyWith(color: Colors.grey),
                            ),
                          )
                        : Container(),
                  ],
                );
              }),
          ListTile(
            onTap: () {
              Navigator.of(context).pop();
              FocusManager.instance.primaryFocus?.unfocus();
              AuthenticationHelper().signOut().then((value) => {
                    if (value == null) {GoRouter.of(context).go("/login")}
                  });
              // viewModel.logoutUser();
            },
            leading: const Padding(
              padding: EdgeInsets.only(left: 2),
              child: Icon(
                Icons.logout,
                color: Colors.grey,
              ),
            ),
            title: Text(
              'Logout',
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
