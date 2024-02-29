import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wedding_venue_booking/User/normaluserhomescreen.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';

class Bookingscreen extends StatefulWidget {
  late String normalUserId;
  late String venueOwnerId;
  late String venueId;
  List<String> venueDiningOptions = [];
  List<String> imageUrls = [];
  late String panoImage;
  late String venueCapacity;
  late String venueEmail;
  late String venueFacilities;
  List<String> venueFeatures = [];
  late String venueLocation;
  late String venueName;
  late String venueAbout;
  late String venuePostCode;
  late String venuePrice;
  late String venueServices;
  late String venueTel;
  List<String> venueDates = [];
  late String venueVideos;
  Bookingscreen(
      {required this.normalUserId,
      required this.venueOwnerId,
      required this.venueId,
      required this.imageUrls,
      required this.panoImage,
      required this.venueDiningOptions,
      required this.venueCapacity,
      required this.venueEmail,
      required this.venueFacilities,
      required this.venueFeatures,
      required this.venueLocation,
      required this.venueName,
      required this.venueAbout,
      required this.venuePostCode,
      required this.venuePrice,
      required this.venueServices,
      required this.venueTel,
      required this.venueDates,
      required this.venueVideos});

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<Bookingscreen> {
  final _formKey = GlobalKey<FormState>();
  late String _selectedDate;
  late String _fullName;
  late String _email;
  late String _phoneNumber;
  late String _message = "No message left";
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  @override
  void initState() {
    super.initState();
    //set first date to the dropboax
    _selectedDate = widget.venueDates.first;
  }

//This function is called when user submits the form
  void _submitBookingForm() {
    if (_formKey.currentState!.validate()) {
      // Remove selected date from venueDates list
      widget.venueDates.remove(_selectedDate);
      if (widget.venueDates.isNotEmpty) {
        // Store form deatils
        _storeFormDetails();
      } else {
        //No date is available so set venueDates to "No available dates" before saving it on the database
        widget.venueDates.add("No available dates");
        // Store form deatils
        _storeFormDetails();
      }
    }
  }

// This the function is used to store the form details entered by the user in the database
  Future<void> _storeFormDetails() async {
    // show a progress indicator while the data is being saved to the database
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: CircularProgressIndicator(),
      ),
    );
    await Future.delayed(Duration(seconds: 2)); // Simulate a delay to save data
    // store the form details to the database
    _database
        .ref()
        .child('bookedvenues')
        .child(widget.normalUserId)
        .child('${DateTime.now().millisecondsSinceEpoch}')
        .set({
      'VenueOwner': widget.venueOwnerId,
      'VenueID': widget.venueId,
      'VenueName': widget.venueName,
      'VenueAbout': widget.venueAbout,
      'VenueFacilities': widget.venueFacilities,
      'VenueServices': widget.venueServices,
      'VenueEmail': widget.venueEmail,
      'VenueTel': widget.venueTel,
      'VenuePrice': widget.venuePrice,
      'VenueCapacity': widget.venueCapacity,
      'VenueLocation': widget.venueLocation,
      'VenuePostCode': widget.venuePostCode,
      // 'timestamp': DateTime.now().millisecondsSinceEpoch,
      'ImageURLs': widget.imageUrls,
      'PanoImageURL': widget.panoImage,
      'VideoURL': widget.venueVideos,
      'FoodAndDrinks': widget.venueDiningOptions,
      'VenueFeatures': widget.venueFeatures,
      'VenueDates': widget.venueDates,
      'CustomerName': _fullName,
      'CustomerEmail': _email,
      'CustomerTelNum': _phoneNumber,
      'CustomerMessage': _message,
      'BookedDate': _selectedDate,
      //'userId': _user.uid,
    });
    // Update the 'VenueDates' value
    _database
        .ref()
        .child('venues')
        .child(widget.venueOwnerId)
        .child(widget.venueId)
        .update({'VenueDates': widget.venueDates});

    Navigator.pop(context); //Pop the progress indicator
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) => Normaluserhomescreen()),
    ); // Pop the form screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(237, 255, 255, 255),
      appBar: null,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 66.0, vertical: 40),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.0),
                Text(
                  'Full Name',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _fullName = value;
                  },
                ),
                SizedBox(height: 16.0),
                Text(
                  'Email',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _email = value;
                  },
                ),
                SizedBox(height: 16.0),
                Text(
                  'Telephone Number',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your telephone number';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _phoneNumber = value;
                  },
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16.0),
                Text(
                  'Venue Date',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                DropdownButtonFormField<String>(
                  value: _selectedDate,
                  onChanged: (value) {
                    setState(() {
                      _selectedDate = value!;
                    });
                  },
                  items: widget.venueDates.map((date) {
                    return DropdownMenuItem<String>(
                      value: date,
                      child: Text(date),
                    );
                  }).toList(),
                ),
                SizedBox(height: 16.0),
                Text(
                  'Price',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the Venue price';
                    }
                    if (value != widget.venuePrice) {
                      return 'The entered price does not match the Venue price';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16.0),
                Text(
                  'Message (Optional)',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                TextFormField(
                  onChanged: (value) {
                    _message = value;
                  },
                ),
                SizedBox(height: 28.0),
                Center(
                  child: ElevatedButton(
                    onPressed: _submitBookingForm,
                    child: Text('Book Venue'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
