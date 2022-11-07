import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'google_authentication.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter-Auth"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ElevatedButton(
                onPressed: () => Authentication()
                    .signInWithGoogle()
                    .then((UserCredential user) =>
                        print("user is : ${user.user?.displayName}"))
                    .catchError((e) => print(e)),
                child: Text("Sign-In"),
              ),
              Padding(padding: EdgeInsets.all(5.0)),
              ElevatedButton(
                onPressed: null,
                child: Text("Sign Out"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
