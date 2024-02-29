import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Bookedvenuesscreen extends StatefulWidget {
  @override
  _BookedvenuesscreenState createState() => _BookedvenuesscreenState();
}

class _BookedvenuesscreenState extends State<Bookedvenuesscreen> {
  //auth object
  final FirebaseAuth auth = FirebaseAuth.instance;
  late var userId;
  List<Map<String, dynamic>> venues = [];
  String searchLocation = "";
  //This method is called every time the user visits the screen
  @override
  void initState() {
    super.initState();
    //Get logged in user
    User? user = auth.currentUser;
    //assign the loggedin user unique ID to userId
    userId = user!.uid;
    //call getVenueDetails to fetch bookedvenues details
    getVenueDetails();
  }

// a method to make a phone call using the given phone number
  Future<void> _makePhoneCall(String phoneNumber) async {
    //create a Uri object
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
      // Get the bookedvenues for the current user.
      final currentUserVenues = data[userId];
      //no bookedvenue, skip.
      if (currentUserVenues == null) {
        return;
      }
      // Clear the venues list
      venues.clear();
      // Iterate through all bookedvenue IDs for the current user.
      for (var venueId in currentUserVenues.keys) {
        // Get the data for the current venue.
        final venue = currentUserVenues[venueId];
        // Extract and save various bookedvenue details to varibales.
        final venueLocation = venue["VenueLocation"];
        final venueName = venue["VenueName"];
        final venuePrice = venue["VenuePrice"];
        final venueCapacity = venue["VenueCapacity"];
        final venueEmail = venue["VenueEmail"];
        final venuePostCode = venue["VenuePostCode"];
        final venueTel = venue["VenueTel"];
        final venueDate = venue["BookedDate"];
        final customerTel = venue["CustomerTelNum"];
        final customerEmail = venue["CustomerEmail"];
        // Add the bookedvenue to the venues list.
        venues.add({
          "venueId": venueId,
          "venueLocation": venueLocation,
          "venueName": venueName,
          "venuePrice": venuePrice,
          "venueCapacity": venueCapacity,
          "venueEmail": venueEmail,
          "venuePostCode": venuePostCode,
          "venueTel": venueTel,
          "venueDate": venueDate,
          "customerTel": customerTel,
          "customerEmail": customerEmail,
        });
      }
      //setState(() {});
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
                        'You have booked ${venues[index]["venueName"]} ',
                        style: TextStyle(color: Colors.white)),
                    subtitle: Text(
                        '${venues[index]["venueLocation"]}, ${venues[index]["venuePostCode"]} \non ${venues[index]["venueDate"]}',
                        style: TextStyle(color: Colors.white)),
                    trailing: Text(
                        "Price paid: £${venues[index]["venuePrice"]}\nCapacity: ${venues[index]["venueCapacity"]}",
                        style: TextStyle(color: Colors.white)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () {
                          _makePhoneCall("${venues[index]["venueTel"]}");
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
                                "${venues[index]["venueEmail"]}");
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
