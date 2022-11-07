import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'home_page.dart';
import 'login_page.dart';
import 'demouser.dart';

class Authentication {
  Widget handleAuthState() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            print(" printing snapshot : ${snapshot}");
            print("Home Page is called");
            return HomePage();
          } else {
            print("Login Page is called");
            return LoginPage();
          }
        });
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount =
        await GoogleSignIn(scopes: <String>["email"]).signIn();

    final GoogleSignInAuthentication googleAuth =
        await googleSignInAccount!.authentication;

    final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  //data

  Future add() async {
    String id = "User";
    final DocumentReference collectionReference =
        FirebaseFirestore.instance.collection("mydata").doc(id);
    Map<String, String> add_data = Map<String, String>();
    add_data = {
      'name': 'Akash Verma',
      'Location': 'Delhi',
    };

    await collectionReference
        .set(add_data)
        .whenComplete(() => print("Data Added"))
        .catchError((e) => print(e));
  }

  signOut() {
    FirebaseAuth.instance.signOut();
  }
}
