import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'google_authentication.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              foregroundImage: NetworkImage(_auth.currentUser!.photoURL!),
            ),
            Text(
              FirebaseAuth.instance.currentUser!.displayName!,
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 25.0,
                  fontStyle: FontStyle.italic),
            ),
            Padding(padding: EdgeInsets.all(10.0)),
            Text(
              _auth.currentUser!.email!,
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 25.0,
                  fontStyle: FontStyle.italic),
            ),
            Padding(padding: EdgeInsets.all(7.0)),
            MaterialButton(
              onPressed: Authentication().signOut,
              color: Colors.teal,
              shape: RoundedRectangleBorder(),
              child: Text("Sign-Out"),
            ),
            MaterialButton(
              onPressed: () => Authentication().add(),
              child: Text("Add"),
              color: Colors.red,
              shape: RoundedRectangleBorder(),
            ),
            MaterialButton(
              onPressed: null,
              child: Text("Update"),
              color: Colors.green,
              shape: RoundedRectangleBorder(),
            ),
            MaterialButton(
              onPressed: null,
              child: Text("Delete"),
              color: Colors.orange,
              shape: RoundedRectangleBorder(),
            ),
            MaterialButton(
              onPressed: () => Navigator.pushNamed(context, "/userdetails"),
              child: Text("Fetch"),
              color: Colors.blue,
              shape: RoundedRectangleBorder(),
            ),
          ],
        ),
      ),
    );
  }
}
