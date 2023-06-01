import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lawyers/components/app_grid.dart';
import 'package:lawyers/components/custom_home_drawer.dart';
import 'package:lawyers/components/home_screen_navbar.dart';
import 'package:lawyers/components/top_laywers_list.dart';
import 'package:lawyers/utils/authentication.dart';
import 'package:lawyers/utils/constants.dart';
// import 'package:flutter_laywer_app/components/laywer_app_grid_menu.dart';
// import 'package:flutter_laywer_app/components/home_screen_navbar.dart';
// import 'package:flutter_laywer_app/components/top_laywers_list.dart';
// import 'package:flutter_laywer_app/constants.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _keyScaffold = GlobalKey();
  @override
  void initState() {
    super.initState();

    checkUser();
  }

  void checkUser() async {}

  @override
  Widget build(BuildContext context) {
    checkUser();

    return Scaffold(
      key: _keyScaffold,
      drawer: CustomHomeDrawer(),
      body: SafeArea(
        child: TopLaywersList(scaffoldKey: _keyScaffold),
      ),
    );
  }
}
