import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
// import 'package:flutter_laywer_app/components/top_laywers_card.dart';
// import 'package:flutter_laywer_app/models/laywer.dart';
import 'package:lawyers/components/top_laywers_card.dart';
import 'package:lawyers/models/lawyer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lawyers/utils/constants.dart';

import '../screens/lawyer_detail_screen.dart';

class LawyersScreen extends StatelessWidget {
  final List<Laywer>? lawyers;
  String? category;

  LawyersScreen({Key? key, this.lawyers, this.category}) : super(key: key);

  final db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lawyers")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          category != null
              ? Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: Text("${category!} laywers",
                      style: Theme.of(context)
                          .textTheme
                          .headline5!
                          .copyWith(color: Colors.blue)),
                )
              : Container(),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: category != null
                  ? db
                      .collection("users")
                      .where("verified", isEqualTo: 1)
                      .where("category", isEqualTo: category)
                      .snapshots()
                  : db
                      .collection("users")
                      .where("verified", isEqualTo: 1)
                      .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
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
                // var item = snapshotew ListTile(
                //         title: new Text(doc["Item$index.Name"]),
                //         subtitle: new Text(doc["Item$index.quantity"])))
                //     .toList();
                // listOfWidgets.add(item);.data!.docs
                //     .map((doc) => n
                return ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: ((context, index) {
                      var item = snapshot.data!.docs[index];
                      if (item.data().toString().contains('role') &&
                          item.get("role") == 1) {
                        return GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return LawyerDetailScreen(item: item);
                              }));
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 4),
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                              width: 100,
                                              height: 100,
                                              decoration: BoxDecoration(
                                                  color: Colors.grey.shade300,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: item.get('photo') == ""
                                                  ? ClipRRect(
                                                      child: Image.asset(
                                                          "assets/images/avatar.png",
                                                          width: 100,
                                                          height: 100,
                                                          fit: BoxFit.cover),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10))
                                                  : ClipRRect(
                                                      child: Image.network(
                                                          item.get("photo"),
                                                          width: 100,
                                                          height: 100,
                                                          fit: BoxFit.cover),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10))),
                                          SizedBox(
                                            width: 16,
                                          ),
                                          Expanded(
                                              child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(item.get('name'),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline5!
                                                      .copyWith(
                                                          color: Colors.blue)),
                                              Text(
                                                  "Specialization: ${item.get('category')}",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium!
                                                      .copyWith(
                                                          color: Colors.black)),
                                              Text(
                                                  "Years of Experience: ${item.get('years') != null ? item.get('years') : ''}",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium!
                                                      .copyWith(
                                                          color: Colors.black)),
                                              Text(
                                                  "Availability: ${item.get('availability') == "true" ? "available" : 'not available'}",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium!
                                                      .copyWith(
                                                          color: Colors.black)),
                                            ],
                                          ))
                                        ]),
                                  ),
                                ),
                              ),
                            ));
                      }
                      return Container();
                    }),
                    itemCount: snapshot.data!.docs.length);
              },
            ),
          ),
        ],
      ),
    );
  }
}
