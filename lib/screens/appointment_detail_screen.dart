import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:twilio_flutter/twilio_flutter.dart';

import '../utils/authentication.dart';

class AppointmentDetailScreen extends StatefulWidget {
  final item;
  AppointmentDetailScreen({Key? key, required this.item}) : super(key: key);

  @override
  State<AppointmentDetailScreen> createState() =>
      _AppointmentDetailScreenState();
}

class _AppointmentDetailScreenState extends State<AppointmentDetailScreen> {
  bool isSubmitted = false;
  bool isSuccessfully = false;
  String message = "";

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

  String categoryValue = "09:00AM - 10:00AM";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lawyer Details")),
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: ListView(children: [
          Container(
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10)),
              child: widget.item.get('lawyer_photo') == ""
                  ? ClipRRect(
                      child: Image.asset("assets/images/avatar.png",
                          fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(10))
                  : ClipRRect(
                      child: Image.network(widget.item.get("lawyer_photo"),
                          fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(10))),
          SizedBox(
            height: 16,
          ),
          FutureBuilder(
              future: db.collection("appointments").doc(widget.item.id).get(),
              builder: (context,
                  AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snap) {
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

                return Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(widget.item.get('user_name'),
                        style: Theme.of(context)
                            .textTheme
                            .headline5!
                            .copyWith(color: Colors.blue)),
                    SizedBox(
                      height: 16,
                    ),
                    Text("Date: ${widget.item.get('date')}",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Colors.black)),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                        "Time: ${widget.item.get('time') != null ? widget.item.get('time') : ''}",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Colors.black)),
                    SizedBox(
                      height: 16,
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                    ),
                    checkStatus(snap.data!.get('status')),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: ElevatedButton(
                              style:
                                  ElevatedButton.styleFrom(primary: Colors.red),
                              onPressed: snap.data!.get('status') == 0
                                  ? () {
                                      db
                                          .collection("appointments")
                                          .doc(widget.item.id)
                                          .update({"status": 1}).then((value) {
                                        twilioFlutter.sendSMS(
                                            toNumber:
                                                widget.item.get('user_number'),
                                            messageBody:
                                                'LAYWER APPOINMENT APP - Your appointment has been denied.');
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: ((context) {
                                          return AppointmentDetailScreen(
                                              item: widget.item);
                                        })));
                                      }).onError((error, stackTrace) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                              "There was an error. Try Again later"),
                                          backgroundColor: Colors.red,
                                        ));
                                      });
                                    }
                                  : null,
                              child: Text("Deny")),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          flex: 1,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.green),
                              onPressed: snap.data!.get('status') == 0
                                  ? () {
                                      db
                                          .collection("appointments")
                                          .doc(widget.item.id)
                                          .update({"status": 1}).then((value) {
                                        twilioFlutter.sendSMS(
                                            toNumber:
                                                widget.item.get('user_number'),
                                            messageBody:
                                                'LAYWER APPOINMENT APP - Your appointment has been accepted. You can contact the Lawyer through: ${widget.item.get('lawyer_number')}');
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: ((context) {
                                          return AppointmentDetailScreen(
                                              item: widget.item);
                                        })));
                                      }).onError((error, stackTrace) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                              "There was an error. Try Again later"),
                                          backgroundColor: Colors.red,
                                        ));
                                      });
                                    }
                                  : null,
                              child: Text("Accept")),
                        )
                      ],
                    ),
                  ],
                ));
              }),
        ]),
      ),
    );
  }

  Future<void> _showSelectDate(BuildContext context) async {
    var dateSelect = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020, 1),
        lastDate: DateTime(2040));
    if (dateSelect != null) {
      DateFormat dateFormat = DateFormat("yyyy-MM-dd");
      final selctedFormatedDate = dateFormat.format(dateSelect);
      setState(() {
        selectedBookingDateController.text = selctedFormatedDate;
      });
    }
    if (selectedBookingDateController.text != null) {
      // setState(() {
      //   dataFilter = true;
      // });
    }
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
