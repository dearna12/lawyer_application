import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lawyers/utils/AppRouter.dart';
import 'package:lawyers/utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        theme: ThemeData(primaryColor: Colors.blue),
        routerDelegate: AppRouter.router.routerDelegate,
        routeInformationParser: AppRouter.router.routeInformationParser,
        routeInformationProvider: AppRouter.router.routeInformationProvider,
        debugShowCheckedModeBanner: false);
  }
}
