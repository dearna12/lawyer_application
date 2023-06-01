import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lawyers/utils/constants.dart';
import 'package:intl/intl.dart';
import 'package:lawyers/models/lawyer.dart';
import 'package:lawyers/utils/authentication.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class MakeAppointment extends StatefulWidget {
  final Laywer lawyer;
  const MakeAppointment({Key? key, required this.lawyer}) : super(key: key);

  @override
  State<MakeAppointment> createState() => _MakeAppointmentState();
}

class _MakeAppointmentState extends State<MakeAppointment> {
  String _selectedDate = '';
  final db = FirebaseFirestore.instance;
  final _makeAppointmentFormKey = GlobalKey<FormState>();

  TextEditingController subjectController = TextEditingController();
  var size, height, width;
  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is DateTime) {
        var month = int.parse(DateFormat('MM').format(args.value).toString());
        var day = int.parse(DateFormat('dd').format(args.value).toString());
        var year = int.parse(DateFormat('yyyy').format(args.value).toString());
        var month_now =
            int.parse(DateFormat('MM').format(DateTime.now()).toString());
        var day_now =
            int.parse(DateFormat('dd').format(DateTime.now()).toString());
        var year_now =
            int.parse(DateFormat('yyyy').format(DateTime.now()).toString());
        if (year_now == year) {
          if (month_now <= month) {
            if (day_now > day) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content:
                    const Text("Invalid Date Selection Please choose again "),
                duration: Duration(seconds: 1),
              ));
            } else {
              //we can use the default time without format it so that we can be able to format it later
              // _selectedDate = args.value.toString();
              _selectedDate = DateFormat('dd/MM/yyyy').format(args.value);
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content:  Text(
                  "Invalid Date Selection Choose Current Month Or Later "),
              duration: Duration(seconds: 2),
            ));
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                "Invalid Date Selection Please Choose Current Year Or Later"),
            duration: Duration(seconds: 3),
          ));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Colors.black,
          child: Stack(
            children: [
              // lawyer.laywerPicture!= "null"?Image.network(lawyer.laywerPicture`):
              Image.asset("images/bg.jpg",
                  fit: BoxFit.cover, width: width, height: height),
              SafeArea(
                child: Container(
                    margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
                    child: Form(
                      key: _makeAppointmentFormKey,
                      child: TextFormField(
                        validator: (value) => value == null || value.isEmpty
                            ? 'The subject is required'
                            : null,
                        style: TextStyle(color: Colors.white),
                        controller: subjectController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            label: Text(
                              "Subject",
                              style: TextStyle(color: Colors.white),
                            ),
                            prefixIcon:
                                Icon(Icons.subject, color: Colors.white),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 2),
                                borderRadius: BorderRadius.circular(64))),
                      ),
                    )),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height / 2 - 180,
                left: 10,
                child: Text(
                  "Select The Of Day Appointment",
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height / 2 - 130,
                left: MediaQuery.of(context).size.width / 2 - 100,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Selected date: ',
                        style: Theme.of(context)
                            .textTheme
                            .headline6!
                            .copyWith(color: Colors.black),
                      ),
                      Text(_selectedDate,
                          style: Theme.of(context)
                              .textTheme
                              .caption!
                              .copyWith(color: Colors.white))
                    ]),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height / 2 - 100,
                child: SfDateRangePicker(
                  todayHighlightColor: Colors.white,
                  onSelectionChanged: _onSelectionChanged,
                  selectionMode: DateRangePickerSelectionMode.single,
                  initialSelectedDate: DateTime.now(),
                ),
              ),

              Positioned(
                  bottom: 10,
                  left: MediaQuery.of(context).size.width / 2,
                  child: ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(kGreenColor)),
                    onPressed: () {
                      if (_makeAppointmentFormKey.currentState!.validate()) {
                        final appointment = <String, String>{
                          "with_id": AuthenticationHelper().user.uid,
                          "user_id": widget.lawyer.uid,
                          "subject": subjectController.text,
                          "date": _selectedDate
                        };
                        db
                            .collection("appointments")
                            .add(appointment)
                            .then((documentSnapshot) => {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content:
                                        Text("Appointment Made successfully"),
                                    duration: Duration(seconds: 5),
                                  )),
                                })
                            .catchError((e) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text(
                                "There is a problem encountered while try to arrange the appointment please try again "),
                            duration: Duration(seconds: 5),
                          ));
                          print("Fail to make appointment: $e");
                        });
                      }
                    },
                    child: Text("Book Appointment"),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
