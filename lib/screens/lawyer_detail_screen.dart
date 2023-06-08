import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:twilio_flutter/twilio_flutter.dart';

import '../utils/authentication.dart';

class LawyerDetailScreen extends StatefulWidget {
  final item;

  LawyerDetailScreen({Key? key, required this.item}) : super(key: key);

  @override
  State<LawyerDetailScreen> createState() => _LawyerDetailScreenState();
}

class _LawyerDetailScreenState extends State<LawyerDetailScreen> {
  bool isSubmitted = false;
  bool isSuccessfully = false;
  String message = "";
  var appointments = [];

  final db = FirebaseFirestore.instance;

  TextEditingController selectedBookingDateController = TextEditingController();
  TextEditingController selectedBookingDateController2 =
      TextEditingController();

  TwilioFlutter twilioFlutter = TwilioFlutter(
      accountSid:
          'AC654dd3a61b0d9fd1826ac251752995cb', // replace *** with Account SID
      authToken:
          'd94431e5df6dac77262a2f007e0d934f', // replace xxx with Auth Token
      twilioNumber: '+18573746722' // replace .... with Twilio Number
      );

  // String categoryValue = "09:00AM - 10:00AM";
  String categoryValue = "";

  List<String> allTimes = [
    "09:00 AM - 10:00 AM",
    "10:00 AM - 11:00 AM",
    "11:00 AM - 12:00 AM",
    "12:00 AM - 13:00 PM",
    "02:00 PM - 03:00 PM",
    "03:00 PM - 04:00 PM"
  ];

  List<String> _availableTimes = [];

  Map<String, List<String>> appointmentMap = {};

  getLaywerAppointments() async {
    await db
        .collection("appointments")
        .where("lawyer", isEqualTo: widget.item.get('uid'))
        .get()
        .then((appoints) {
      for (int i = 0; i < appoints.docs.length; i++) {
        // add data to list you want to return.
        // print(appoints.docs[i].data());
        print("the extracted appointments");
        addAppointment(
            appoints.docs[i].data()['date'], appoints.docs[i].data()['time']);
        // print(appoints.docs[i].data()['date']);
        // appointments[appoints.docs[i].data()['date']].add(appoints.docs[i].data()['time']);
      }
    });

    print(appointmentMap);
  }

  void addAppointment(String date, String appointment) {
    if (appointmentMap.containsKey(date)) {
      // Date already exists, append the appointment
      appointmentMap[date]!.add(appointment);
    } else {
      // Date doesn't exist, create a new list and add the appointment
      appointmentMap[date] = [appointment];
    }
  }

  @override
  Widget build(BuildContext context) {
    getLaywerAppointments();
    return Scaffold(
      appBar: AppBar(title: Text("Lawyer Details")),
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: ListView(children: [
          widget.item.get('photo') == ""
              ? ClipRRect(
                  child: Image.asset("assets/images/avatar.png",
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(10))
              : ClipRRect(
                  child: Image.network(widget.item.get("photo"),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(10)),
          SizedBox(
            height: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.item.get('name'),
                  style: Theme.of(context)
                      .textTheme
                      .headline5!
                      .copyWith(color: Colors.blue)),
              SizedBox(
                height: 20,
              ),
              Text("Specialization: ${widget.item.get('category')}",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Colors.black)),
              SizedBox(
                height: 10,
              ),
              Text(
                  "Years of Experience: ${widget.item.get('years') != null ? widget.item.get('years') : ''}",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Colors.black)),
              SizedBox(
                height: 10,
              ),
              Text(
                  "Availability: ${widget.item.get('availability') == 'true' ? "available" : 'not available'}",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Colors.black)),
              SizedBox(
                height: 10,
              ),
              FutureBuilder(
                  future: db
                      .collection("users")
                      .doc(AuthenticationHelper().user.uid)
                      .get(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                          snap) {
                    if (snap.connectionState == ConnectionState.waiting) {
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
                    if (snap.hasData) {
                      print("Data of lawyer");
                      print(snap.data?.data());
                    }
                    return ElevatedButton(
                        onPressed: widget.item.get('availability') == 'true' &&
                                !AuthenticationHelper().isAdmin
                            ? !isSubmitted
                                ? AuthenticationHelper().user.uid !=
                                        widget.item.id
                                    ? () async {
                                        // setState(() {
                                        //   isSubmitted = !isSubmitted;
                                        // });

                                        var result = await showDialog<bool>(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                            title: Text('Request Appointment'),
                                            content: StatefulBuilder(  // You need this, notice the parameters below:
                                                builder: (BuildContext context, StateSetter setState) {
                                                return Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    TextFormField(
                                                        onTap: () =>
                                                            _showSelectDate(
                                                                context,setState),
                                                        keyboardType:
                                                            TextInputType.none,
                                                        controller:
                                                            selectedBookingDateController,
                                                        decoration: InputDecoration(
                                                            label: Text("Date"))),
                                                    Container(
                                                      child: DropdownSearch<String>(
                                                        items: _availableTimes,

                                                        popupProps: PopupProps.menu(
                                                          showSelectedItems: true,
                                                          menuProps: MenuProps(
                                                            backgroundColor:
                                                                Colors.white,
                                                          ),
                                                        ),

                                                        dropdownDecoratorProps:
                                                            DropDownDecoratorProps(
                                                          dropdownSearchDecoration:
                                                              InputDecoration(
                                                                  labelText:
                                                                      "Time"),
                                                        ),
                                                        // popupItemDisabled: (String s) => s.startsWith('I'),
                                                        onChanged: (data) {
                                                          setState(() {
                                                            categoryValue = data!;
                                                          });
                                                        },
                                                        selectedItem: categoryValue,
                                                      ),
                                                    )
                                                  ],
                                                );
                                              }
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  // setState(() {
                                                  //   isSubmitted = !isSubmitted;
                                                  // });
                                                  setState(() {
                                                    isSuccessfully = true;
                                                  });
                                                  Navigator.pop(context, false);
                                                },
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  bool hasItems = false;
                                                  // performFilter();

                                                  // QuerySnapshot data = await db.collection("appointments").where("user_requested", )

                                                  QuerySnapshot lists = await db
                                                      .collection(
                                                          "appointments")
                                                      .where("user_requested",
                                                          isEqualTo:
                                                              AuthenticationHelper()
                                                                  .user
                                                                  .uid)
                                                      .where("status",
                                                          isEqualTo: 1)
                                                      .where("lawyer",
                                                          isEqualTo:
                                                              widget.item.id)
                                                      .where("time",
                                                          isEqualTo:
                                                              categoryValue)
                                                      .where("date",
                                                          isEqualTo:
                                                              selectedBookingDateController
                                                                  .text)
                                                      .get();
                                                  QuerySnapshot lists2 = await db
                                                      .collection(
                                                          "appointments")
                                                      .where("user_requested",
                                                          isEqualTo:
                                                              AuthenticationHelper()
                                                                  .user
                                                                  .uid)
                                                      .where("lawyer",
                                                          isEqualTo:
                                                              widget.item.id)
                                                      .where("status",
                                                          isEqualTo: 0)
                                                      .get();

                                                  if (lists.docs.length > 0) {
                                                    hasItems = true;
                                                    setState(() {
                                                      isSuccessfully = false;
                                                      message =
                                                          "Already booked on that time";
                                                    });
                                                    Navigator.pop(
                                                        context, false);
                                                  }
                                                  if (lists2.docs.length > 0) {
                                                    hasItems = true;
                                                    setState(() {
                                                      isSuccessfully = false;
                                                      message =
                                                          "You already booked";
                                                    });
                                                    Navigator.pop(
                                                        context, false);
                                                  }

                                                  if (selectedBookingDateController
                                                          .text ==
                                                      "") {
                                                    // hasItems = true;
                                                    setState(() {
                                                      isSuccessfully = false;
                                                      message =
                                                          "Did not request, no date selected";
                                                    });
                                                    Navigator.pop(
                                                        context, false);
                                                  }

                                                  if (!hasItems) {
                                                    db
                                                        .collection(
                                                            "appointments")
                                                        .add({
                                                      "user_requested":
                                                          AuthenticationHelper()
                                                              .user
                                                              .uid,
                                                      "lawyer": widget.item.id,
                                                      "date":
                                                          selectedBookingDateController
                                                              .text,
                                                      "time": categoryValue,
                                                      "lawyer_name": widget.item
                                                          .get("name"),
                                                      "user_number": snap.data!
                                                          .get("phone"),
                                                      "user_name": snap.data!
                                                          .get("name"),
                                                      "lawyer_number": widget
                                                          .item
                                                          .get("phone"),
                                                      "lawyer_photo": widget
                                                          .item
                                                          .get("photo"),
                                                      "status": 0,
                                                      "datetime": FieldValue
                                                          .serverTimestamp()
                                                    }).then((value) {
                                                      setState(() {
                                                        isSuccessfully = true;
                                                      });
                                                      twilioFlutter.sendSMS(
                                                          toNumber: widget.item
                                                              .get("phone"),
                                                          messageBody:
                                                              'LAYWER APPOINMENT APP - You have new appointment requested on the system');
                                                      Navigator.pop(
                                                          context, true);
                                                    }).onError((error,
                                                            stackTrace) {
                                                      setState(() {
                                                        isSuccessfully = false;
                                                      });
                                                      Navigator.pop(
                                                          context, false);
                                                    });
                                                  }
                                                },
                                                child: const Text('OK'),
                                              ),
                                            ],
                                          ),
                                        );
                                        if (isSuccessfully) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "Appointment Requested")));
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text(message),
                                            backgroundColor: Colors.red,
                                          ));
                                        }
                                      }
                                    : null
                                : null
                            : null,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50), // NEW
                          // enabled: isSubmitted,
                        ),
                        child: Text("Request Appointment"));
                  })
            ],
          )
        ]),
      ),
    );
  }

  Future<void> _showSelectDate(BuildContext context, stateSetter) async {
    var dateSelect = await showDatePicker(
        context: context,
        initialDate: DateTime.now().add(Duration(days: 1)),
        // firstDate: DateTime(2020, 1),
        firstDate: DateTime.now().add(Duration(days: 1)),
        lastDate: DateTime(2040));
    if (dateSelect != null) {
      DateFormat dateFormat = DateFormat("yyyy-MM-dd");
      final selctedFormatedDate = dateFormat.format(dateSelect);
      selectedBookingDateController.text = selctedFormatedDate;

      _availableTimes = List.from(allTimes);
      if (appointmentMap.containsKey(selctedFormatedDate)) {
        print("remove items");
        _availableTimes.removeWhere((element) =>
            appointmentMap[selctedFormatedDate]!.contains(element));
      }
      stateSetter(() {});
    }
    if (selectedBookingDateController.text != null) {
      // setState(() {
      //   dataFilter = true;
      // });
    }
  }
}
