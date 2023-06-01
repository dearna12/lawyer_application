import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SnapshotState extends StatefulWidget {
  AsyncSnapshot<QuerySnapshot> snapshot;
  Widget childElement;

  SnapshotState({
    Key? key,
    required this.snapshot,
    required this.childElement,
  }) : super(key: key);

  @override
  State<SnapshotState> createState() => _SnapshotStateState();
}

class _SnapshotStateState extends State<SnapshotState> {
  @override
  Widget build(BuildContext context) {
    if (widget.snapshot.connectionState == ConnectionState.waiting) {
      return SpinKitDancingSquare(
        color: Colors.blueGrey,
        size: 50.0,
      );
    }
    if (!widget.snapshot.hasData) {
      return Text("No Dat found");
    }
    if (widget.snapshot.hasError) {
      return Text("There was an Error");
    }

    if (widget.snapshot.data!.docs.length < 1) {
      return Padding(
        padding: const EdgeInsets.all(28.0),
        child: Text("No data found"),
      );
    }
    return widget.childElement;
  }
}
