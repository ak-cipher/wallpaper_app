import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterdemo/firebase_sign_app/demouser.dart';

class UserDetails extends StatefulWidget {
  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  Stream<List<DemoUser>> FetchDetails() {
    return FirebaseFirestore.instance.collection("mydata").snapshots().map(
        (usersnapshot) => usersnapshot.docs
            .map((demouser) => DemoUser.FromJson(demouser.data()))
            .toList());
  }

  Widget buildUser(DemoUser user) {
    return ListTile(
      leading: CircleAvatar(child: Text("${user.name[0]}")),
      title: Text(user.name),
      subtitle: Text(user.Location),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("UserDetails"),
        centerTitle: true,
      ),
      body: StreamBuilder<List<DemoUser>>(
        stream: FetchDetails(),
        builder: (context, snapshot) {
          print(snapshot);
          if (snapshot.hasError) {
            return Text("Something went wrong ${snapshot.error}");
          } else if (snapshot.hasData) {
            final user = snapshot.data!;
            return ListView(
              children: user.map(buildUser).toList(),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
