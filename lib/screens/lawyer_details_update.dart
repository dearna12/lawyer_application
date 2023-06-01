import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/authentication.dart';

class LawyerDetailsUpdate extends StatefulWidget {
  LawyerDetailsUpdate({Key? key}) : super(key: key);

  @override
  State<LawyerDetailsUpdate> createState() => _LawyerDetailsUpdateState();
}

class _LawyerDetailsUpdateState extends State<LawyerDetailsUpdate> {
  bool isEditable = false;

  final db = FirebaseFirestore.instance;

  TextEditingController yearController = TextEditingController();
  TextEditingController avaialabilityController = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  // TextEditingController storeNameController = TextEditingController();
  // TextEditingController storeNameController = TextEditingController();
  // TextEditingController storeLocationController = TextEditingController();

  Future futureStore() async {
    DocumentSnapshot doc =
        await db.collection("users").doc(AuthenticationHelper().user.uid).get();
    // print(doc['email']);
    // print("doc");
    final data = doc.data() as Map<String, dynamic>;
    // print(data);
    // print(jsonDecode(doc.toString()));
    return data;
  }

  GlobalKey _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lawyer Information")),
      body: Container(
        child: FutureBuilder(
            future: futureStore(),
            builder: (context, snapshot) {
              // print(snapshot);
              if (snapshot.hasError)
                return Text("There was an error -- ${snapshot.error}");
              if (!snapshot.hasData) return Text("No data found");

              // print("snapshot");

              final data = snapshot.data as Map<String, dynamic>;
              // print(data['email']);
              // print(snapshot.data['email']);
              // print(snapshot.data['email']);
              yearController.text = data['years'] == null ? '' : data['years'];
              aboutController.text = data['about'] == null ? '' : data['about'];
              avaialabilityController.text =
                  data['availability'] == null ? '' : data['availability'];

              return Form(
                key: _key,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Column(children: [
                    Row(
                      children: [
                        Spacer(),
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                isEditable = true;
                              });
                            },
                            child: Text("Edit Details"))
                      ],
                    ),
                    TextFormField(
                      controller: aboutController,
                      maxLines: 5,
                      enabled: isEditable,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(), label: Text("About")),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: yearController,
                      enabled: isEditable,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text("Years of Experience")),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    StatefulBuilder(builder: (context, setStateNew) {
                      return DropdownSearch<String>(
                        enabled: isEditable,

                        // popupBarrierColor: Colors.white,
                        popupProps: PopupProps.menu(
                          showSelectedItems: true,
                          menuProps: MenuProps(
                            backgroundColor: Colors.white,
                          ),
                        ),
                        items: ["true", "false"],

                        dropdownDecoratorProps: DropDownDecoratorProps(
                          dropdownSearchDecoration:
                              InputDecoration(labelText: "Availability"),
                        ),
                        // popupItemDisabled: (String s) => s.startsWith('I'),
                        onChanged: (data) {
                          setStateNew(() {
                            avaialabilityController.text = data!;
                          });
                        },
                        selectedItem: avaialabilityController.text,
                      );
                    }),
                    Spacer(),
                    ElevatedButton(
                        onPressed: isEditable
                            ? () {
                                db
                                    .collection("users")
                                    .doc(AuthenticationHelper().user!.uid)
                                    .update({
                                  'availability': avaialabilityController.text,
                                  'years': yearController.text,
                                  'about': aboutController.text
                                }).then((value) => {
                                          setState(() => {isEditable = false})
                                        });
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50), // NEW
                          // enabled: isEditable,
                        ),
                        child: Text("Update Details"))
                  ]),
                ),
              );
            }),
      ),
    );
  }
}
