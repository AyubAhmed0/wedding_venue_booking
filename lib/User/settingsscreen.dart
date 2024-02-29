import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wedding_venue_booking/Auth/login.dart';

class Settingsscreen extends StatefulWidget {
  @override
  _SettingsscreenState createState() => _SettingsscreenState();
}

class _SettingsscreenState extends State<Settingsscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Card(
        margin: EdgeInsets.symmetric(vertical: 3.0, horizontal: 0),
        child: ListTile(
          leading: Icon(Icons.logout),
          title: Text('Logout'),
          onTap: () async {
            //sign out the user
            await FirebaseAuth.instance.signOut();
            //navigate to the login screen
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (route) => false);
          },
        ),
      ),
    );
  }
}
