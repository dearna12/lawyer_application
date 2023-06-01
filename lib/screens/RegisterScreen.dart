import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lawyers/utils/authentication.dart';
import 'package:lawyers/utils/constants.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var size, height, width;
  var paddingRatio = 0.05;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isSubmitted = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool checkbox = false;

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
              child: ListView(
                // mainAxisAlignment: MainAxisAlignment.center,
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
                    "REGISTER",
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
                    controller: nameController,
                    style: TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value == "") {
                        return "Enter your name";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text(
                          "Full name",
                          style: TextStyle(color: Colors.white),
                        ),
                        prefixIcon:
                            Icon(Icons.person_outline, color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 2),
                            borderRadius: BorderRadius.circular(64))),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: phoneController,
                    validator: (value) {
                      if (value == "") {
                        return "Enter your phone number";
                      }
                      return null;
                    },
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        prefix: Text(
                          "+255",
                          style: TextStyle(color: Colors.white),
                        ),
                        border: OutlineInputBorder(),
                        label: Text(
                          "Phone number",
                          style: TextStyle(color: Colors.white),
                        ),
                        prefixIcon:
                            Icon(Icons.phone_outlined, color: Colors.white),
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
                    validator: (value) {
                      if (value == "") {
                        return "Enter your phone number";
                      }
                      return null;
                    },
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
                    controller: passwordController,
                    validator: (value) {
                      if (value == "") {
                        return "Enter your phone password";
                      }
                      return null;
                    },
                    obscureText: isPasswordVisible,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text(
                          "Password",
                          style: TextStyle(color: Colors.white),
                        ),
                        prefixIcon: InkWell(
                            child:
                                Icon(Icons.key_outlined, color: Colors.white)),
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
                  StatefulBuilder(builder: (context, setState) {
                    return Container(
                      width: double.infinity,
                      alignment: Alignment.topLeft,
                      child: Row(
                        children: [
                          Checkbox(
                              checkColor: Colors.white,
                              value: checkbox,
                              //    validator: (value) {
                              //   if (value == "") {
                              //     return "Enter your phone number";
                              //   }
                              //   return null;
                              // },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(2.0)),
                              side: MaterialStateBorderSide.resolveWith(
                                  (states) => BorderSide(
                                      width: 1.0, color: Colors.white)),
                              onChanged: (change) {
                                setState(() {
                                  checkbox = change!;

                                  print(checkbox);
                                  print("print test");
                                });
                              }),
                          Text(
                            "I Agree to terms of service and privacy policy",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    );
                  }),
                  isSubmitted
                      ? checkbox != null
                          ? Text(
                              "You have to accept terms of service",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.red),
                            )
                          : Container()
                      : Container(),
                  DecoratedBox(
                      decoration: BoxDecoration(),
                      child: ElevatedButton(
                          onPressed: !isSubmitted
                              ? () {
                                  if (_formKey.currentState!.validate() &&
                                      checkbox != null) {
                                    setState(() {
                                      isSubmitted = true;
                                    });

                                    AuthenticationHelper()
                                        .signUp(
                                            // category: "none",
                                            // role: "1",
                                            // verified: true,
                                            // laywerDescription: "null",
                                            // laywerHospital: "null",
                                            // laywerName: "null",
                                            // laywerIsOpen: false,
                                            // laywerNumberOfPatient: "null",
                                            // laywerPicture: "null",
                                            // laywerRating: "null",
                                            // laywerSpecialty: "null",
                                            // laywerYearOfExperience: "null",
                                            phone: phoneController.text,
                                            name: nameController.text,
                                            category: "",
                                            role: 0,
                                            email: emailController.text,
                                            password: passwordController.text)
                                        .then((value) {
                                      if (value == null) {
                                        // print("user");
                                        // print(AuthenticationHelper().user)
                                        // print("user");
                                        setState(() {
                                          isSubmitted = false;
                                        });
                                        GoRouter.of(context).go("/home");
                                      } else {
                                        setState(() {
                                          isSubmitted = false;
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
                                }
                              : null,
                          child: Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            padding: const EdgeInsets.only(
                              top: 18,
                              bottom: 18,
                            ),
                            child: const Text("Register"),
                          ))),
                  const SizedBox(
                    height: 16,
                  ),
                  InkWell(
                    onTap: () {
                      GoRouter.of(context).go("/login/register");
                    },
                    child: const Text.rich(
                      TextSpan(
                          text: "Already Registered? ",
                          style: TextStyle(color: Colors.white),
                          children: [
                            TextSpan(
                                text: "Login",
                                style: TextStyle(color: Colors.blue))
                          ]),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 12),
                  InkWell(
                    onTap: () {
                      GoRouter.of(context).go("/login/register_lawyer");
                    },
                    child: const Text.rich(
                      TextSpan(
                          text: "Are you a Lawyer? ",
                          style: TextStyle(color: Colors.white),
                          children: [
                            TextSpan(
                                text: "Register Here",
                                style: TextStyle(color: Colors.blue))
                          ]),
                      textAlign: TextAlign.center,
                    ),
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
