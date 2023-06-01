import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lawyers/utils/authentication.dart';
import 'package:lawyers/utils/constants.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var size, height, width;
  var paddingRatio = 0.05;
  GlobalKey _formKey = GlobalKey();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isSubmitted = false;

  bool isPasswordVisible = true;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;

    return Scaffold(
      body: Builder(builder: (context) {
        return Stack(children: [
          Image.asset("images/bg.jpg",
              fit: BoxFit.cover, width: width, height: height),
          Container(
            width: width,
            height: height,
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.7)),
          ),
          Container(
            padding: EdgeInsets.symmetric(
                vertical: 40, horizontal: width * paddingRatio),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Find A Lawyer",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  const Text(
                    "LOGIN",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 32,
                        color: Colors.blue,
                        fontWeight: FontWeight.w900),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    style: TextStyle(color: Colors.white),
                    controller: emailController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text(
                          "Email",
                          style: TextStyle(color: Colors.white),
                        ),
                        prefixIcon:
                            Icon(Icons.mail_outline, color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 2),
                            borderRadius: BorderRadius.circular(64))),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    style: TextStyle(color: Colors.white),
                    controller: passwordController,
                    obscureText: isPasswordVisible,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text(
                          "Password",
                          style: TextStyle(color: Colors.white),
                        ),
                        prefixIcon:
                            Icon(Icons.key_outlined, color: Colors.white),
                        suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                          child: Icon(
                            isPasswordVisible
                                ? Icons.remove_red_eye_outlined
                                : Icons.visibility_off,
                            color: Colors.white,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 2),
                            borderRadius: BorderRadius.circular(64))),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  DecoratedBox(
                      decoration: BoxDecoration(),
                      child: ElevatedButton(

                          //make color or elevated button transparent
                          onPressed: !isSubmitted
                              ? () {
                                  setState(() {
                                    isSubmitted = true;
                                  });

                                  AuthenticationHelper()
                                      .signIn(
                                          email: emailController.text,
                                          password: passwordController.text)
                                      .then((value) {
                                    if (value == null) {
                                      setState(() {
                                        isSubmitted = !isSubmitted;
                                      });
                                      // print(AuthenticationHelper().test)
                                      GoRouter.of(context).go("/home");
                                    } else {
                                      setState(() {
                                        isSubmitted = !isSubmitted;
                                      });
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(value,
                                            style: TextStyle(fontSize: 16)),
                                        duration: Duration(seconds: 5),
                                      ));
                                    }
                                  });
                                }
                              : null,
                          child: Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            padding: const EdgeInsets.only(
                              top: 18,
                              bottom: 18,
                            ),
                            child: const Text("Login"),
                          ))),
                  const SizedBox(
                    height: 16,
                  ),
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       flex: 1,
                  //       child: ElevatedButton(
                  //           onPressed: () {
                  //             AuthenticationHelper()
                  //                 .signIn(
                  //                     email: "ryanhenericojoachim@gmail.com",
                  //                     password: "Santana_2020")
                  //                 .then((value) {
                  //               if (value == null) {
                  //                 setState(() {
                  //                   isSubmitted = !isSubmitted;
                  //                 });
                  //                 // print(AuthenticationHelper().test)
                  //                 GoRouter.of(context).go("/home");
                  //               } else {
                  //                 setState(() {
                  //                   isSubmitted = !isSubmitted;
                  //                 });
                  //                 ScaffoldMessenger.of(context)
                  //                     .showSnackBar(SnackBar(
                  //                   content: Text(value,
                  //                       style: TextStyle(fontSize: 16)),
                  //                   duration: Duration(seconds: 5),
                  //                 ));
                  //               }
                  //             });
                  //           },
                  //           child: Text("Login As User")),
                  //     ),
                  //     SizedBox(width: 10),
                  //     Expanded(
                  //       flex: 1,
                  //       child: ElevatedButton(
                  //           onPressed: () {
                  //             AuthenticationHelper()
                  //                 .signIn(
                  //                     email: "lawyer1@email.com",
                  //                     password: "123456")
                  //                 .then((value) {
                  //               if (value == null) {
                  //                 setState(() {
                  //                   isSubmitted = !isSubmitted;
                  //                 });
                  //                 // print(AuthenticationHelper().test)
                  //                 GoRouter.of(context).go("/home");
                  //               } else {
                  //                 setState(() {
                  //                   isSubmitted = !isSubmitted;
                  //                 });
                  //                 ScaffoldMessenger.of(context)
                  //                     .showSnackBar(SnackBar(
                  //                   content: Text(value,
                  //                       style: TextStyle(fontSize: 16)),
                  //                   duration: Duration(seconds: 5),
                  //                 ));
                  //               }
                  //             });
                  //           },
                  //           child: Text("Login As Lawyer")),
                  //     ),
                  //     Expanded(
                  //       flex: 1,
                  //       child: ElevatedButton(
                  //           onPressed: () {
                  //             AuthenticationHelper()
                  //                 .signIn(
                  //                     email: "admintzapp@lawyers.com",
                  //                     password: "admin123")
                  //                 .then((value) {
                  //               if (value == null) {
                  //                 setState(() {
                  //                   isSubmitted = !isSubmitted;
                  //                 });
                  //                 // print(AuthenticationHelper().test)
                  //                 GoRouter.of(context).go("/home");
                  //               } else {
                  //                 setState(() {
                  //                   isSubmitted = !isSubmitted;
                  //                 });
                  //                 ScaffoldMessenger.of(context)
                  //                     .showSnackBar(SnackBar(
                  //                   content: Text(value,
                  //                       style: TextStyle(fontSize: 16)),
                  //                   duration: Duration(seconds: 5),
                  //                 ));
                  //               }
                  //             });
                  //           },
                  //           child: Text("Login As Admin")),
                  //     )
                  //   ],
                  // ),
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      GoRouter.of(context).go("/login/register");
                    },
                    child: const Text.rich(TextSpan(
                        text: "Not Registered? ",
                        style: TextStyle(color: Colors.white),
                        children: [
                          TextSpan(
                              text: "Register",
                              style: TextStyle(color: Colors.blue))
                        ])),
                  )
                ],
              ),
            ),
          )
        ]);
      }),
    );
  }
}
