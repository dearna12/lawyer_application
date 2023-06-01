import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthenticationHelper {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  get user => _auth.currentUser;
  get userRole => null;
  set userRole(user) {
    return userRole;
  }

  get isAdmin => _auth.currentUser!.email == "admintzapp@lawyers.com";

  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  //SIGN UP METHOD
  Future signUp(
      {required String email,
      required String name,
      // required String street,
      required int role,
      required String category,
      required String phone,
      required String password}) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final currentUser = result.user!;

      users.doc(currentUser.uid).set({
        "name": name,
        "phone": "+255" + phone,
        "role": role,
        "photo": "",
        "category": category,
        "about": "",
        "photo": "",
        "uid": currentUser.uid,
        "verified": 0,
        "years": null,
        "availability": "true",
        "email": email.replaceAll(" ", ""),
      }).then((documentReference) {
        // print("success");
        // return true;
        // Navigator.pushNamed(context, productRoute);
        // print(documentReference!.documentID);
        // clearForm();
      }).catchError((e) {
        return e;
      });

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //SIGN IN METHOD
  Future signIn({required String email, required String password}) async {
    QuerySnapshot lists = await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email.replaceAll(" ", ""))
        .get();

    if (lists.docs.length < 1) {
      return "User not found";
    }

    try {
      await _auth.signInWithEmailAndPassword(
          email: email.replaceAll(" ", ""), password: password);

      DocumentSnapshot<Map<String, dynamic>> user_ = await FirebaseFirestore
          .instance
          .collection("users")
          .doc(AuthenticationHelper().user.uid)
          .get();

      userRole = user_['role'];

      // if (user['role'] != 0) {
      //   GoRouter.of(context).go("/home/profile");
      // }

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //SIGN OUT METHOD
  Future signOut() async {
    await _auth.signOut();

    print('signout');
  }
}
