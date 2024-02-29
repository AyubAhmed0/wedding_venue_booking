import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'Venuehomescreen.dart';
import 'package:intl/intl.dart';

class EditVenueScreen extends StatefulWidget {
  final String uid;
  late String venueId;
  List<String> venueDiningOptions = [];
  List<String> imageUrls = [];
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
  EditVenueScreen(
      {required this.uid,
      required this.venueId,
      required this.imageUrls,
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
  _EditVenueScreenState createState() => _EditVenueScreenState();
}

class _EditVenueScreenState extends State<EditVenueScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  DateTimeRange selectedDate =
      DateTimeRange(start: DateTime.now(), end: DateTime(2055, 11, 01));
  List<String> pickedDates = [];

  void initState() {
    super.initState();
    pickedDates = widget.venueDates;
  }

//This function stores form details
  Future<void> _storeFormDetails() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      _database
          .ref()
          .child('venues')
          .child(widget.uid)
          .child(widget.venueId)
          .update({
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
        'VenueDates': pickedDates
      });
    }
  }

  // This function allows user to select multiple dates
  Future<void> selectMultipleDates(BuildContext context) async {
    final List<DateTime> selectedDates = <DateTime>[];
    DateTime currentDate = DateTime.now();
    while (true) {
      final DateTime? selectedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2100),
      );
      if (selectedDate == null) {
        break; // User has canceled the selection
      } else {
        selectedDates.add(selectedDate);
        currentDate = selectedDate;
      }
    }
    setState(() {
      pickedDates = selectedDates
          .map((date) => DateFormat('yyyy-MM-dd').format(date))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Screen'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                initialValue: widget.venueName,
                decoration: InputDecoration(
                  labelText: 'Enter Venue Name',
                  //hintText: "Enter the name of the venue",
                ),
                validator: (input) {
                  if (input!.isEmpty) {
                    return 'Please enter venue name';
                  }

                  return null;
                },
                onSaved: (input) => widget.venueName = input!,
              ),
              TextFormField(
                initialValue: widget.venueAbout,
                decoration: InputDecoration(
                  labelText: 'Enter a description about the Venue',
                  //hintText: "Enter the name of the venue",
                ),
                maxLines: 5,
                minLines: 3,
                validator: (input) {
                  if (input!.isEmpty) {
                    return 'Please enter a description about the venue';
                  }

                  return null;
                },
                onSaved: (input) => widget.venueAbout = input!,
              ),
              TextFormField(
                initialValue: widget.venueFacilities,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  labelText:
                      'Enter a description about facilities and capacity',
                  // hintText: "Enter a value for additional field 1",
                ),
                maxLines: 5,
                minLines: 3,
                validator: (input) {
                  if (input!.isEmpty) {
                    return 'Please enter a description about facilities and capacity';
                  }

                  return null;
                },
                onSaved: (input) => widget.venueFacilities = input!,
              ),
              SizedBox(height: 2),
              TextFormField(
                initialValue: widget.venueServices,
                decoration: InputDecoration(
                  labelText: 'Enter a description about services offered',
                ),
                maxLines: 5,
                minLines: 3,
                validator: (input) {
                  if (input!.isEmpty) {
                    return 'Please enter a description about services offered';
                  }

                  return null;
                },
                onSaved: (input) => widget.venueServices = input!,
              ),
              SizedBox(height: 20),
              Text(
                  "*Please Select all available dates for the venue, when you select a date click on ok. Click cancel when you have selected all the dates*"),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => selectMultipleDates(context),
                child: Text('select new dates'),
              ),
              SizedBox(height: 10),
              Text('available dates: ${pickedDates.join(', ')}'),
              SizedBox(height: 10),
              TextFormField(
                initialValue: widget.venueEmail,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
                validator: (input) {
                  if (!input!.contains('@')) {
                    return 'Please enter an Email';
                  }
                  return null;
                },
                onSaved: (input) => widget.venueEmail = input!,
              ),
              SizedBox(width: 20),
              TextFormField(
                initialValue: widget.venueTel,
                decoration: InputDecoration(
                  labelText: 'Tel:',
                ),
                keyboardType: TextInputType.number,
                validator: (input) {
                  if (input!.isEmpty) {
                    return 'Please enter a phone number';
                  }
                  return null;
                },
                onSaved: (input) => widget.venueTel = input!,
              ),
              TextFormField(
                initialValue: widget.venuePrice,
                decoration: InputDecoration(
                  labelText: 'Price (\£)',
                ),
                keyboardType: TextInputType.number,
                validator: (input) {
                  if (input!.isEmpty) {
                    return 'Please enter the price of the venue';
                  }
                  return null;
                },
                onSaved: (input) => widget.venuePrice = input!,
              ),
              SizedBox(width: 20),
              TextFormField(
                initialValue: widget.venueCapacity,
                decoration: InputDecoration(
                  labelText: 'Capacity',
                ),
                keyboardType: TextInputType.number,
                validator: (input) {
                  if (input!.isEmpty) {
                    return 'Please enter a capacity of the venue';
                  }
                  return null;
                },
                onSaved: (input) => widget.venueCapacity = input!,
              ),
              SizedBox(width: 20),
              TextFormField(
                initialValue: widget.venueLocation,
                decoration: InputDecoration(
                  labelText: 'Location (City)',
                ),
                validator: (input) {
                  if (input!.isEmpty) {
                    return 'Please enter the city of the venue';
                  }
                  return null;
                },
                onSaved: (input) => widget.venueLocation = input!,
              ),
              TextFormField(
                initialValue: widget.venuePostCode,
                decoration: InputDecoration(
                  labelText: 'PostCode',
                ),
                validator: (input) {
                  if (input!.isEmpty) {
                    return 'Please enter the post code of the venue';
                  }
                  return null;
                },
                onSaved: (input) => widget.venuePostCode = input!,
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                child: Text('Save Changes'),
                onPressed: () {
                  _storeFormDetails();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => Venuehomescreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
