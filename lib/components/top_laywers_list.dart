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
import 'package:lawyers/components/app_grid.dart';

import '../screens/lawyer_detail_screen.dart';
import 'home_screen_navbar.dart';

class TopLaywersList extends StatelessWidget {
  final List<Laywer>? lawyers;
  final GlobalKey<ScaffoldState> scaffoldKey;

  TopLaywersList({Key? key, required this.scaffoldKey, this.lawyers})
      : super(key: key);

  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream:
          db.collection("users").where("verified", isEqualTo: 1).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 18.0, horizontal: 18),
                            child: HomeScreenNavbar(scaffoldKey: scaffoldKey),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          RichText(
                            text: TextSpan(
                              style: Theme.of(context).textTheme.headline3,
                              children: <TextSpan>[
                                const TextSpan(
                                  text: 'Find ',
                                ),
                                TextSpan(
                                  text: 'a laywer',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline3!
                                      .copyWith(
                                        // color: kGreyColor900,
                                        color: kGreyColor900,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          const LaywerAppGridMenu(),
                          const SizedBox(
                            height: 24,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                // onTap: () {
                                //   AuthenticationHelper().signOut().then((value) {
                                //     GoRouter.of(context).go("/login");
                                //   });
                                //   // GoRouter.of(context).go("/")
                                // },
                                child: Text(
                                  'Top Laywers',
                                  style: Theme.of(context).textTheme.headline3,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  GoRouter.of(context).go("/home/lawyers");
                                },
                                child: Text(
                                  'View all',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                        color: kBlueColor,
                                      ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          LawyerCard(item: item),
                        ]),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: LawyerCard(item: item),
                );
              }
              return Container();
            }),
            itemCount: snapshot.data!.docs.length > 8
                ? 8
                : snapshot.data!.docs.length);
      },
    );
  }
}

class LawyerCard extends StatelessWidget {
  const LawyerCard({
    Key? key,
    required this.item,
  }) : super(key: key);

  final QueryDocumentSnapshot<Object?> item;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(10)),
                          child: item.get('photo') == ""
                              ? ClipRRect(
                                  child: Image.asset("assets/images/avatar.png",
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover),
                                  borderRadius: BorderRadius.circular(10))
                              : ClipRRect(
                                  child: Image.network(item.get("photo"),
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover),
                                  borderRadius: BorderRadius.circular(10))),
                      SizedBox(
                        width: 16,
                      ),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(item.get('name'),
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5!
                                  .copyWith(color: Colors.blue)),
                          Text("Specialization: ${item.get('category')}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: Colors.black)),
                          Text(
                              "Years of Experience: ${item.get('years') != null ? item.get('years') : ''}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: Colors.black)),
                          Text(
                              "Availability: ${item.get('availability') == "true" ? "available" : 'not available'}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: Colors.black)),
                        ],
                      ))
                    ]),
              ),
            ),
          ),
        ));
  }
}
