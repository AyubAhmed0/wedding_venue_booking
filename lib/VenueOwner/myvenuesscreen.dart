import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../ImageSlider.dart';
import 'venuedetailscreen.dart';
import 'package:google_fonts/google_fonts.dart';

class Myvenuesscreen extends StatefulWidget {
  @override
  _MyvenuesscreenState createState() => _MyvenuesscreenState();
}

class _MyvenuesscreenState extends State<Myvenuesscreen> {
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

  // This method fetches venues details from the Firebase Realtime Database.
  Future<void> getVenueDetails() async {
    // Set up a listener on the "venues" node in the Database.
    FirebaseDatabase.instance.ref("venues").onValue.listen((event) {
      // Create a map from the updated data in the "venues" node.
      final data = Map<String, dynamic>.from(
        event.snapshot.value as Map,
      );
      // Get the venues for the current user.
      final currentUserVenues = data[userId];
      //no venue, skip.
      if (currentUserVenues == null) {
        return;
      }
      // Clear the venues list
      venues.clear();
      // Iterate through all venue IDs for the current user.
      for (var venueId in currentUserVenues.keys) {
        // Get the data for the current venue.
        final venue = currentUserVenues[venueId];
        // Extract and save various venue details to varibales.
        final venueImagesList = venue["ImageURLs"] as List<dynamic>;
        final venueImages = venueImagesList.map((e) => e as String).toList();
        final venueDiningOptionsList = venue["FoodAndDrinks"] as List<dynamic>;
        final venueDiningOptions =
            venueDiningOptionsList.map((e) => e as String).toList();
        final venueFeaturesList = venue["VenueFeatures"] as List<dynamic>;
        final venueFeatures =
            venueFeaturesList.map((e) => e as String).toList();
        final PanoImageURL = venue["PanoImageURL"];
        final venueLocation = venue["VenueLocation"];
        final venueName = venue["VenueName"];
        final venueAbout = venue["VenueAbout"];
        final venuePrice = venue["VenuePrice"];
        final venueCapacity = venue["VenueCapacity"];
        final venueEmail = venue["VenueEmail"];
        final venueFacilities = venue["VenueFacilities"];
        final venuePostCode = venue["VenuePostCode"];
        final venueServices = venue["VenueServices"];
        final venueTel = venue["VenueTel"];
        final venueDatesList = venue["VenueDates"] as List<dynamic>;
        final venueDates = venueDatesList.map((e) => e as String).toList();
        final venueVideos = venue["VideoURL"];
        // Add the venue to the venues list.
        venues.add({
          "venueId": venueId,
          "venueImages": venueImages,
          "panoImageURL": PanoImageURL,
          "venueLocation": venueLocation,
          "venueName": venueName,
          "venueAbout": venueAbout,
          "venuePrice": venuePrice,
          "venueCapacity": venueCapacity,
          "venueDiningOptions": venueDiningOptions,
          "venueEmail": venueEmail,
          "venueFacilities": venueFacilities,
          "venueFeatures": venueFeatures,
          "venuePostCode": venuePostCode,
          "venueServices": venueServices,
          "venueTel": venueTel,
          "venueDates": venueDates,
          "venueVideos": venueVideos
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: SafeArea(
          child: Container(
        //height: 1050,
        margin: EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(children: [
          SizedBox(height: 16.0),
          TextField(
            decoration: InputDecoration(
              hintText: "London",
              enabledBorder: UnderlineInputBorder(
                //<-- SEE HERE
                borderSide:
                    BorderSide(color: Color.fromARGB(255, 134, 166, 126)),
              ),
              prefixIcon: Icon(Icons.location_on),
            ),
            onChanged: (value) {
              setState(() {
                searchLocation = value;
              });
            },
          ),
          SizedBox(height: 7.0),
          Expanded(
            child: ListView.builder(
              //set the number of cards to display as the number of venues
              itemCount: venues.length,
              itemBuilder: (BuildContext context, int index) {
                // check if a search location is entered and filter out any venues that don't match the location searched
                if (searchLocation.isNotEmpty &&
                    venues[index]["venueLocation"]
                            .toLowerCase()
                            .indexOf(searchLocation.toLowerCase()) ==
                        -1) {
                  return Container();
                }
                //if a search location is nott entered return all venues
                return Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: Color.fromARGB(247, 255, 255, 255),
                  child: Container(
                    height: 400,
                    width: double.infinity,
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            child: ImageSlider(
                                imageUrls: venues[index]["venueImages"]),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                            padding: EdgeInsets.only(left: 11),
                            child: Row(
                              children: [
                                Text(
                                  venues[index]["venueName"],
                                  style: GoogleFonts.openSans(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                              ],
                            )),
                        Container(
                          padding: EdgeInsets.only(left: 11),
                          child: Column(children: [
                            SizedBox(height: 10),
                            Row(children: [
                              Icon(
                                  size: 13.0,
                                  color: Color.fromARGB(255, 124, 124, 124),
                                  Icons.location_on),
                              Text(
                                venues[index]["venueLocation"],
                                style: GoogleFonts.notoSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w300,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            ]),
                          ]),
                        ),
                        Container(
                          padding:
                              EdgeInsets.only(left: 11.0, top: 5.0, bottom: 10),
                          child: Row(
                            children: [
                              Icon(
                                  size: 14.0,
                                  color: Color.fromARGB(255, 124, 124, 124),
                                  Icons.people_alt_outlined),
                              SizedBox(width: 3),
                              Text(venues[index]["venueCapacity"],
                                  style: GoogleFonts.notoSans(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                  )),
                              SizedBox(width: 5),
                              Text("From £" + venues[index]["venuePrice"],
                                  style: GoogleFonts.notoSans(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                  )),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 1,
                          width: 400,
                          child: Container(
                              color: Color.fromARGB(255, 226, 226, 226)),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: double.infinity,
                          height: 50,
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          child: ElevatedButton(
                            child: Text("View More",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontFamily: "Helvetica")),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Venuedetailscreen(
                                    uid: userId,
                                    venueId: venues[index]["venueId"],
                                    imageUrls: venues[index]["venueImages"],
                                    panoImage: venues[index]["panoImageURL"],
                                    venueDiningOptions: venues[index]
                                        ["venueDiningOptions"],
                                    venueCapacity: venues[index]
                                        ["venueCapacity"],
                                    venueEmail: venues[index]["venueEmail"],
                                    venueFacilities: venues[index]
                                        ["venueFacilities"],
                                    venueFeatures: venues[index]
                                        ["venueFeatures"],
                                    venueLocation: venues[index]
                                        ["venueLocation"],
                                    venueName: venues[index]["venueName"],
                                    venueAbout: venues[index]["venueAbout"],
                                    venuePostCode: venues[index]
                                        ["venuePostCode"],
                                    venuePrice: venues[index]["venuePrice"],
                                    venueServices: venues[index]
                                        ["venueServices"],
                                    venueTel: venues[index]["venueTel"],
                                    venueDates: venues[index]["venueDates"],
                                    venueVideos: venues[index]["venueVideos"],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ]),
      )),
    );
  }
}
