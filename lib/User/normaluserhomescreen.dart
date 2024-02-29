import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../ImageSlider.dart';
import 'normalusersvenuedetailsscreen.dart';
import 'settingsscreen.dart';
import 'bookedvenuesscreen.dart';

class Normaluserhomescreen extends StatefulWidget {
  @override
  _NormaluserhomescreenState createState() => _NormaluserhomescreenState();
}

class _NormaluserhomescreenState extends State<Normaluserhomescreen> {
  //auth object
  final FirebaseAuth auth = FirebaseAuth.instance;
  late var userId;
  //Stores all the venues
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
    //call getVenueDetails to fetch venues details
    getVenueDetails();
  }

// This method fetches venue details from the Firebase Realtime Database.
  Future<void> getVenueDetails() async {
    // Set up a listener on the "venues" node in the Database.
    FirebaseDatabase.instance.ref("venues").onValue.listen((event) {
      // Create a map from the updated data in the "venues" node.
      final data = Map<String, dynamic>.from(
        event.snapshot.value as Map,
      );
      // Clear the venues list
      venues.clear();
      // Iterate through all user IDs in the venues.
      for (var usersId in data.keys) {
        // Get the venues.
        final usersVenues = data[usersId];
        // If there are no venues, skip.
        if (usersVenues == null) {
          continue;
        }
        // Iterate through all venue IDs for the venues.
        for (var venueId in usersVenues.keys) {
          // Get the data for the current venue.
          final venue = usersVenues[venueId];
          // Extract and save various venue details to varibales.
          final venueImagesList = venue["ImageURLs"] as List<dynamic>;
          final venueImages = venueImagesList.map((e) => e as String).toList();
          final venueDiningOptionsList =
              venue["FoodAndDrinks"] as List<dynamic>;
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
          // Add the venue details to the venues list.
          venues.add({
            "venueOwner": usersId,
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
      }
      // Update the widget's state to reflect the changes in the venues list.
      setState(() {});
    });
  }

  int index = 0;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Love Locations',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w900)),
            automaticallyImplyLeading: false,
            elevation: 0.0,
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
                  icon: Icon(Icons.event_available), label: "Booking"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings), label: "Settings"),
            ],
          ),
          body: SafeArea(
              child: IndexedStack(
            index: index,
            children: [
              Container(
                //height: 1050,
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(children: [
                  SizedBox(height: 16.0),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "London",
                      enabledBorder: UnderlineInputBorder(
                        //<-- SEE HERE
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 134, 166, 126)),
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
                    // Create a ListView.builder to display a scrollable list of venue items.
                    child: ListView.builder(
                      // Set the number of items in the list to the length of the venues list.
                      itemCount: venues.length,
                      // Define the itemBuilder function to create and return the widgets representing the items in the list.
                      itemBuilder: (BuildContext context, int index) {
                        // Check if the searchLocation string is not empty and if the current venue's location
                        // does not contain the searchLocation string.
                        if (searchLocation.isNotEmpty &&
                            venues[index]["venueLocation"]
                                    .toLowerCase()
                                    .indexOf(searchLocation.toLowerCase()) ==
                                -1) {
                          // If the conditions are met, return an empty Container widget,
                          // hiding the current venue in the list since it doesn't match the search criteria.
                          return Container();
                        }
                        return Card(
                          //margin: EdgeInsets.all(10.0),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          color: Color.fromARGB(247, 255, 255, 255),
                          child: Container(
                            height: 400,
                            //color: Color.fromARGB(247, 255, 255, 255),
                            width: double.infinity,
                            child: Column(
                              children: [
                                Expanded(
                                  child: Container(
                                    //margin: EdgeInsets.only(top: 0, right: 2.0),
                                    //height: 400,
                                    child: ImageSlider(
                                        imageUrls: venues[index]
                                            ["venueImages"]),
                                  ),
                                  //flex: 1,
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
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w400,
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
                                          color: Color.fromARGB(
                                              255, 124, 124, 124),
                                          Icons.location_on),
                                      Text(
                                        venues[index]["venueLocation"],
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w300,
                                          fontStyle: FontStyle.normal,
                                        ),
                                      ),
                                    ]),
                                  ]),
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                      left: 11.0, top: 5.0, bottom: 10),
                                  child: Row(
                                    //mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Icon(
                                          size: 14.0,
                                          color: Color.fromARGB(
                                              255, 124, 124, 124),
                                          Icons.people_alt_outlined),
                                      SizedBox(width: 3),
                                      Text(venues[index]["venueCapacity"],
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w300,
                                            fontStyle: FontStyle.normal,
                                          )),
                                      SizedBox(width: 5),
                                      Text(
                                          "From £" +
                                              venues[index]["venuePrice"],
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w300,
                                            fontStyle: FontStyle.normal,
                                          )),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 1,
                                  width: 400,
                                  child: Container(
                                      color:
                                          Color.fromARGB(255, 226, 226, 226)),
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
                                          builder: (context) =>
                                              Normalusersvenuedetailsscreen(
                                            venueOwnerId: venues[index]
                                                ["venueOwner"],
                                            normalUserId: userId,
                                            venueId: venues[index]["venueId"],
                                            imageUrls: venues[index]
                                                ["venueImages"],
                                            panoImage: venues[index]
                                                ["panoImageURL"],
                                            venueDiningOptions: venues[index]
                                                ["venueDiningOptions"],
                                            venueCapacity: venues[index]
                                                ["venueCapacity"],
                                            venueEmail: venues[index]
                                                ["venueEmail"],
                                            venueFacilities: venues[index]
                                                ["venueFacilities"],
                                            venueFeatures: venues[index]
                                                ["venueFeatures"],
                                            venueLocation: venues[index]
                                                ["venueLocation"],
                                            venueName: venues[index]
                                                ["venueName"],
                                            venueAbout: venues[index]
                                                ["venueAbout"],
                                            venuePostCode: venues[index]
                                                ["venuePostCode"],
                                            venuePrice: venues[index]
                                                ["venuePrice"],
                                            venueServices: venues[index]
                                                ["venueServices"],
                                            venueTel: venues[index]["venueTel"],
                                            venueDates: venues[index]
                                                ["venueDates"],
                                            venueVideos: venues[index]
                                                ["venueVideos"],
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
              ),
              Bookedvenuesscreen(),
              Settingsscreen(),
            ],
          )),
        ));
  }
}
