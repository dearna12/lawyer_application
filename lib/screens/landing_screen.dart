import 'package:flutter/material.dart';
import 'package:lawyers/utils/constants.dart';

class LandingScreen extends StatefulWidget {
  LandingScreen({Key? key}) : super(key: key);

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  var size, height, width;
  var paddingRatio = 0.05;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;

    return Scaffold(
      body: Stack(children: [
        Image.asset("images/bg.jpg",
            fit: BoxFit.cover, width: width, height: height),
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.7)),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: width * paddingRatio),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'images/logo.png',
                width: 100,
              ),
              const Text(
                "Find A Lawyer",
                style: TextStyle(fontSize: 32, color: Colors.white),
              ),
              const SizedBox(
                height: 6,
              ),
              const Text(
                "\"Law services on your fingertips\"",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              SizedBox(
                height: 16,
              ),
              DecoratedBox(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue, width: 2),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: const <BoxShadow>[
                        BoxShadow(
                            color: Color.fromRGBO(
                                0, 0, 0, 0.3), //shadow for button
                            blurRadius: 5) //blur radius of shadow
                      ]),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.transparent,
                        onSurface: Colors.transparent,
                        shadowColor: Colors.transparent,
                        //make color or elevated button transparent
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, loginRoute);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        padding: EdgeInsets.only(
                          top: 18,
                          bottom: 18,
                        ),
                        child: Text(
                          "Login",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ))),
              SizedBox(
                height: 8,
              ),
              DecoratedBox(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Colors.blue,
                        Colors.blue.shade300,
                        //add more colors
                      ]),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: const <BoxShadow>[
                        BoxShadow(
                            color: Color.fromRGBO(
                                0, 0, 0, 0.3), //shadow for button
                            blurRadius: 5) //blur radius of shadow
                      ]),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.transparent,
                        onSurface: Colors.transparent,
                        shadowColor: Colors.transparent,
                        //make color or elevated button transparent
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, registerRoute);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        padding: EdgeInsets.only(
                          top: 18,
                          bottom: 18,
                        ),
                        child: Text("Register"),
                      ))),
            ],
          ),
        )
      ]),
    );
  }
}
