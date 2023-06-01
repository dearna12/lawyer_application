import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lawyers/utils/authentication.dart';
import 'package:lawyers/utils/constants.dart';
import 'package:dropdown_search/dropdown_search.dart';

class LaywerRegisterScreen extends StatefulWidget {
  LaywerRegisterScreen({Key? key}) : super(key: key);

  @override
  State<LaywerRegisterScreen> createState() => _LaywerRegisterScreenState();
}

class _LaywerRegisterScreenState extends State<LaywerRegisterScreen> {
  var size, height, width;
  var paddingRatio = 0.05;
  GlobalKey _formKey = GlobalKey();

  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  // TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String? categoryValue = categories[0];

  bool isSubmitted = false;

  bool checkbox = false;

  bool isPasswordVisible = false;
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
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
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
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: DropdownSearch<String>(
                        
                        // popupBarrierColor: Colors.white,
                  
                        items: categories,
                        
                        popupProps: PopupProps.menu(
                          showSelectedItems: true,
                          menuProps: MenuProps(
                            backgroundColor: Colors.white,
                          ),
                        ),
                     

                        dropdownDecoratorProps: DropDownDecoratorProps(
                          dropdownSearchDecoration:
                              InputDecoration(labelText: "Category"),
                        ),
                        // popupItemDisabled: (String s) => s.startsWith('I'),
                        onChanged: (data) {
                          setState(() {
                            categoryValue = data;
                          });
                        },
                        selectedItem: categories[0],
                      ),
                    ),
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
                    controller: passwordController,
                    style: TextStyle(color: Colors.white),
                    obscureText: isPasswordVisible,
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
                  Container(
                    width: double.infinity,
                    alignment: Alignment.topLeft,
                    child: Row(
                      children: [
                        Checkbox(
                            checkColor: Colors.white,
                            value: checkbox,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2.0)),
                            side: MaterialStateBorderSide.resolveWith(
                                (states) => BorderSide(
                                    width: 1.0, color: Colors.white)),
                            onChanged: (change) {
                              setState(() {
                                checkbox = change!;
                              });
                            }),
                        Text(
                          "I Agree to terms of service and privacy policy",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                  DecoratedBox(
                      decoration: BoxDecoration(),
                      child: ElevatedButton(
                          onPressed: !isSubmitted
                              ? () {
                                  setState(() {
                                    isSubmitted = !isSubmitted;
                                  });
                                  AuthenticationHelper()
                                      .signUp(
                                          role: 1,
                                          category: categoryValue!,
                                          phone: phoneController.text,
                                          name: nameController.text,
                                          email: emailController.text
                                              .replaceAll(" ", ""),
                                          password: passwordController.text)
                                      .then((value) {
                                    setState(() {
                                      isSubmitted = !isSubmitted;
                                    });
                                    if (value == null) {
                                      GoRouter.of(context).go("/home");
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(value,
                                            style: TextStyle(fontSize: 16)),
                                        duration: Duration(seconds: 5),
                                      ));
                                    }
                                  }).onError((error, stackTrace) {
                                    setState(() {
                                      isSubmitted = !isSubmitted;
                                    });
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
                            child: const Text("Register"),
                          ))),
                  const SizedBox(
                    height: 16,
                  ),
                  InkWell(
                    onTap: () {
                      GoRouter.of(context).go("/login");
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
