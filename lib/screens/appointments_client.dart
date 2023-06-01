import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lawyers/components/snapshot_state.dart';
import 'package:app_popup_menu/app_popup_menu.dart';
import 'package:lawyers/utils/authentication.dart';

class AppointmentsClientScreen extends StatefulWidget {
  AppointmentsClientScreen({Key? key}) : super(key: key);

  @override
  State<AppointmentsClientScreen> createState() =>
      _AppointmentsClientScreenState();
}

class _AppointmentsClientScreenState extends State<AppointmentsClientScreen> {
  final db = FirebaseFirestore.instance;

  // final whoIs = "";

  @override
  void initState() {
    super.initState();
    // checkUser();
  }

  // void checkUser(){
  //   if(AuthenticationHelper().user.)
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Appointments")),
        body: StreamBuilder<QuerySnapshot>(
            stream: db
                .collection("appointments")
                .where("user_requested",
                    isEqualTo: AuthenticationHelper().user.uid)
                .snapshots(),
            builder: ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
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

              if (snapshot.data!.docs.length < 1) {
                return Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: Text("No data found"),
                );
              }

              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12),
                child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var item = snapshot.data!.docs[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 6.0),
                        child: Card(
                          child: Container(
                            padding: EdgeInsets.all(6),
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                          color: Colors.grey.shade300,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: item.get('lawyer_photo') == ""
                                          ? ClipRRect(
                                              child: Image.asset(
                                                  "assets/images/avatar.png",
                                                  width: 60,
                                                  height: 60,
                                                  fit: BoxFit.cover),
                                              borderRadius:
                                                  BorderRadius.circular(10))
                                          : ClipRRect(
                                              child: Image.network(
                                                  item.get("lawyer_photo"),
                                                  width: 60,
                                                  height: 60,
                                                  fit: BoxFit.cover),
                                              borderRadius:
                                                  BorderRadius.circular(10))),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  FutureBuilder(
                                      future: db
                                          .collection("users")
                                          .doc(item.get("user_requested"))
                                          .get(),
                                      builder: (context,
                                          AsyncSnapshot<
                                                  DocumentSnapshot<
                                                      Map<String, dynamic>>>
                                              snap) {
                                        if (snap.connectionState ==
                                            ConnectionState.waiting) {
                                          return SpinKitDancingSquare(
                                            color: Colors.blueGrey,
                                            size: 50.0,
                                          );
                                        }
                                        if (!snap.hasData) {
                                          return Text("No Dat found");
                                        }
                                        if (snap.hasError) {
                                          return Text("There was an Error");
                                        }

                                        return Expanded(
                                            child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(item.get('lawyer_name'),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline5!
                                                    .copyWith(
                                                        color: Colors.blue)),
                                            Text("Date: ${item.get('date')}",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium!
                                                    .copyWith(
                                                        color: Colors.black)),
                                            Text(
                                                "Time: ${item.get('time') != null ? item.get('time') : ''}",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium!
                                                    .copyWith(
                                                        color: Colors.black)),
                                            checkStatus(item.get('status')),
                                          ],
                                        ));
                                      }),
                                  SizedBox(
                                    width: 40,
                                    child: AppPopupMenu(
                                      menuItems: const [
                                        PopupMenuItem(
                                          value: 1,
                                          child: Text('Delete'),
                                        ),
                                      ],
                                      // initialValue: 2,
                                      onSelected: (int value) {
                                        // print("selected");
                                        // print(item.id);
                                        if (value == 1) {
                                          db
                                              .collection("appointments")
                                              .doc(
                                                  snapshot.data!.docs[index].id)
                                              .delete();
                                        }
                                      },
                                      icon: Icon(Icons.more_vert_outlined),
                                    ),
                                  ),
                                ]),
                          ),
                        ),
                      );
                    }),
              );
            })));
  }

  Widget checkStatus(status) {
    var text = "";
    Color color = Colors.grey;
    switch (status) {
      case 0:
        text = "pending";
        color = Colors.grey;

        break;
      case 1:
        text = "accepted";
        color = Colors.green;
        break;

      case -1:
        text = "denied";
        color = Colors.red;
        break;

      default:
        text = "pending";
        color = Colors.grey;
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          alignment: Alignment.center,
          child: Text("status: $text",
              style: TextStyle(fontSize: 12, color: Colors.white)),
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(12)),
          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        ),
      ],
    );
  }
}
