import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wedding_venue_booking/Auth/login.dart';
import 'package:wedding_venue_booking/VenueOwner/venueform.dart';
import 'myvenuesscreen.dart';
import 'venuenotificationscreen.dart';

class Venuehomescreen extends StatefulWidget {
  @override
  _VenuehomescreenState createState() => _VenuehomescreenState();
}

class _VenuehomescreenState extends State<Venuehomescreen> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Venue Owner',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w900)),
            automaticallyImplyLeading: false,
            elevation: 0.0,
            actions: <Widget>[
              PopupMenuButton(
                padding: EdgeInsets.all(0.0),
                constraints: BoxConstraints.expand(width: 100, height: 50),
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                        value: "logout",
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              Icon(
                                Icons.logout,
                                size: 20,
                                color: Colors.black45,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Logout',
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500),
                              ),
                            ])
                          ],
                        )),
                  ];
                },
                onSelected: (value) async {
                  if (value == "logout") {
                    //Sign out the logged in user
                    await FirebaseAuth.instance.signOut();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  }
                },
              ),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: index,
            onTap: (int newIndex) {
              setState(() {
                index = newIndex;
              });
            },
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(
                icon: Icon(Icons.inventory),
                label: "Venues",
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.notifications), label: "Notifications"),
            ],
          ),
          body: SafeArea(
            child: IndexedStack(
              index: index,
              children: [
                Container(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Hello,",
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Do you want to add a venue?",
                                style: TextStyle(color: Colors.grey.shade700),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            VeneuFormScreen()),
                                  );
                                },
                                child: Text("Add venue"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                //Show Myvenuesscreen screen when click on Venues nav button
                Myvenuesscreen(),
                //Show Venuenotificationscreen screen when click on Notifications nav button
                Venuenotificationscreen(),
              ],
            ),
          ),
        ));
  }
}
