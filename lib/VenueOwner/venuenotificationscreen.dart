import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Venuenotificationscreen extends StatefulWidget {
  @override
  _VenuenotificationscreenState createState() =>
      _VenuenotificationscreenState();
}

class _VenuenotificationscreenState extends State<Venuenotificationscreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  late var userId;
  List<Map<String, dynamic>> venues = [];
  String searchLocation = "";
  @override
  void initState() {
    super.initState();
    User? user = auth.currentUser;
    userId = user!.uid;
    getVenueDetails();
  }

  // A function to make a phone call using the given phone number
  Future<void> _makePhoneCall(String phoneNumber) async {
    //Create a Uri object
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    // Launch the Uri
    await launchUrl(launchUri);
  }

// This method fetches bookedvenues details from the Firebase Realtime Database.
  Future<void> getVenueDetails() async {
    // Set up a listener on the "bookedvenues" node in the Database.
    FirebaseDatabase.instance.ref("bookedvenues").onValue.listen((event) {
      // Create a map from the updated data in the "bookedvenues" node.
      final data = Map<String, dynamic>.from(
        event.snapshot.value as Map,
      );
      // Clear the venues list
      venues.clear();
      // Iterate through all user IDs in the bookedvenues.
      for (var usersId in data.keys) {
        // print(usersId);
        // Get the bookedvenues.
        final usersVenues = data[usersId];
        // If there are no bookedvenues, skip.
        if (usersVenues == null) {
          continue;
        }
        // Iterate through all bookedvenue IDs for the bookedvenues.
        for (var venueId in usersVenues.keys) {
          // Get the data for the current bookedvenue.
          final venue = usersVenues[venueId];
          // If the bookedVenue belongs to the logged in user. save the bookedvenue details.
          if (venue["VenueOwner"] == userId) {
            final venueName = venue["VenueName"];
            final customerName = venue["CustomerName"];
            final customerMessage = venue["CustomerMessage"];
            final customerTel = venue["CustomerTelNum"];
            final customerEmail = venue["CustomerEmail"];
            final bookedDate = venue["BookedDate"];
            venues.add({
              "venueName": venueName,
              "customerName": customerName,
              "customerMessage": customerMessage,
              "customerTel": customerTel,
              "customerEmail": customerEmail,
              "bookedDate": bookedDate,
            });
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: ListView.builder(
        itemCount: venues.length,
        itemBuilder: (context, index) {
          return Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              color: Color.fromARGB(255, 134, 166, 126),
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 5),
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                        '${venues[index]["customerName"]} booked ${venues[index]["venueName"]} ',
                        style: TextStyle(color: Colors.white)),
                    subtitle: Text(
                        'on ${venues[index]["bookedDate"]} \nmessage: ${venues[index]["customerMessage"]}',
                        style: TextStyle(color: Colors.white)),
                    trailing: Text("Price paid: Yes",
                        style: TextStyle(color: Colors.white)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () {
                          _makePhoneCall("${venues[index]["customerTel"]}");
                        },
                        icon: Icon(Icons.phone_in_talk_rounded,
                            size: 25,
                            color: Color.fromARGB(255, 255, 254, 254)),
                      ),
                      //if (true) {};
                      Container(
                        width: 100,
                        height: 40,
                        //margin: EdgeInsets.symmetric(horizontal: 5.0),
                        child: IconButton(
                          onPressed: () async {
                            String email = Uri.encodeComponent(
                                "${venues[index]["customerEmail"]}");
                            Uri mail = Uri.parse("mailto:$email");
                            if (await launchUrl(mail)) {
                              //email app opened
                            } else {
                              //email app is not opened
                            }
                          },
                          icon: Icon(Icons.email_rounded,
                              size: 25,
                              color: Color.fromARGB(255, 255, 254, 254)),
                        ),
                      ),
                    ],
                  ),
                ],
              ));
        },
      ),
    );
  }
}
