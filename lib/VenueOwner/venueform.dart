import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class VeneuFormScreen extends StatefulWidget {
  @override
  _VenueFormScreenState createState() => _VenueFormScreenState();
}

class _VenueFormScreenState extends State<VeneuFormScreen> {
  int _currentStep = 0;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  File? _video;
  File? _panoImage;
  late String _panoImageURL;
  List<String> _imageURLs = [];
  List<File> _images = [];
  List<String> _foodAndDrinks = [];
  List<String> _venueFeutures = [];
  late String _videoURL;
  String _venueName = '';
  String _venueAbout = '';
  String _venueFacilities = '';
  String _venueServices = '';
  late String _venueEmail;
  late String _venueTel;
  late String _venuePrice;
  late String _venueCapacity;
  late String _venueLocation;
  late String _venuePostCode;
  DateTimeRange selectedDate =
      DateTimeRange(start: DateTime.now(), end: DateTime(2055, 11, 01));
  List<String> pickedDates = [];
  bool _hasFoodOrDrinks = false;
  bool _hasVenueFeutures = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  late User _user;

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  //Get logged in user
  void _getUser() async {
    _user = (await _auth.currentUser)!;
  }

// Go to the next step in the stepper
  void _nextStep() {
    setState(() {
      _currentStep = _currentStep + 1;
    });
  }

//This function allows the user to select multiple images from the gallery
// using the image picker package and sets the selected images as _images.
  Future getImage() async {
    var images = await _picker.pickMultiImage();
    setState(() {
      if (images != null) {
        _images = images.map((image) => File(image.path)).toList();
        //print("Selected images: $_images");
      } else {
        // print('No images selected.');
      }
    });
  }

// This function allows the user to select a video from the gallery using
// the image picker package and sets the selected video as _video.
  Future getVideo() async {
    var video = await _picker.pickVideo(source: ImageSource.gallery);
    setState(() {
      if (video != null) {
        _video = File(video.path);
      } else {
        print('No video selected.');
      }
    });
  }

  // This function allows the user to select a an image from the gallery using
  // the image picker Package and sets the selected image as _panoImage.
  Future getPanoImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (image != null) {
        _panoImage = File(image.path);
        print("Selected pano image: $_panoImage");
      } else {
        print('No pano image selected.');
      }
    });
  }

//This function uplaods the selected images to the firebase storage
  Future<void> _uploadImages(List<File> images, File panoImage) async {
    List<String> imageURLs = [];
    for (var i = 0; i < images.length; i++) {
      Reference ref = _storage
          .ref()
          .child("images/${DateTime.now().millisecondsSinceEpoch}_$i");
      await ref.putFile(File(images[i].path));
      imageURLs.add(await ref.getDownloadURL());
    }
    //pano images
    Reference ref =
        _storage.ref().child("images/${DateTime.now().millisecondsSinceEpoch}");
    await ref.putFile(File(_panoImage!.path));
    _panoImageURL = await ref.getDownloadURL();

    _imageURLs = imageURLs;
  }

//This function uplaods the selected video to the firebase storage
  Future<void> _uploadVideo(File video) async {
    Reference ref =
        _storage.ref().child("videos/${DateTime.now().millisecondsSinceEpoch}");
    await ref.putFile(File(video.path));
    _videoURL = await ref.getDownloadURL();
  }

//This function stores form details
  Future<void> _storeFormDetails() async {
    //validate form data
    if (_formKey.currentState!.validate()) {
      //save form data
      _formKey.currentState!.save();
      if (_foodAndDrinks.isEmpty) {
        _foodAndDrinks = ["No food or drink included"];
      }
      if (_venueFeutures.isEmpty) {
        _venueFeutures = ["No venue feutures specified"];
      }
      //if images, a video, a date, and a pano image are selected, upload images and video and store the data to the database
      if (_images.isNotEmpty &&
          _video != null &&
          pickedDates.isNotEmpty &&
          _panoImage != null) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => Center(
            child: CircularProgressIndicator(),
          ),
        );
        await Future.delayed(
            Duration(seconds: 2)); // Simulate a delay to save data
        await _uploadImages(_images, _panoImage!);
        await _uploadVideo(_video!);
        _database
            .ref()
            .child('venues')
            .child(_user.uid)
            .child('${DateTime.now().millisecondsSinceEpoch}')
            .set({
          'VenueName': _venueName,
          'VenueAbout': _venueAbout,
          'VenueFacilities': _venueFacilities,
          'VenueServices': _venueServices,
          'VenueEmail': _venueEmail,
          'VenueTel': _venueTel,
          'VenuePrice': _venuePrice,
          'VenueCapacity': _venueCapacity,
          'VenueLocation': _venueLocation,
          'VenuePostCode': _venuePostCode,
          'ImageURLs': _imageURLs,
          'PanoImageURL': _panoImageURL,
          'VideoURL': _videoURL,
          'FoodAndDrinks': _foodAndDrinks,
          'VenueFeatures': _venueFeutures,
          'VenueDates': pickedDates
        });
        Navigator.pop(context); //Pop the progress indicator
        Navigator.pop(context); // Pop the form screen
      } else {
        // Show error message indicating that at least one photo, one pano phto, one video, and one available date
        Fluttertoast.showToast(
          msg:
              "Please select at least one photo, one pano photo, one video, and one available date.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    }
  }

//This function allows user to select multiple dates
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
        title: Text('Venue Form'),
      ),
      body: Container(
        child: Stepper(
          // Define a vertical Stepper widget
          type: StepperType.vertical,
          currentStep: _currentStep,
          // The action to be taken when the cancel button is clickedd
          onStepCancel: () {
            setState(() {
              // If the current step is greater than 0, decrease the step count by 1, otherwise, pop the context
              _currentStep > 0 ? _currentStep -= 1 : Navigator.pop(context);
            });
          },
          // The action to be taken when the continue button is clicked
          onStepContinue: _currentStep == 3 ? _storeFormDetails : _nextStep,
          // The action to be taken when a step is tapped
          onStepTapped: (step) {
            setState(() {
              // Set the current step to the step that was tapped
              _currentStep = step;
            });
          },
          // Define the steps in the Stepper widget
          steps: [
            //step 1
            Step(
              title: Text('Venue Info'),
              content: SafeArea(
                //height: 400,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
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
                        onSaved: (input) => _venueName = input!,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Enter a description about the Venue',
                        ),
                        maxLines: 5,
                        minLines: 3,
                        validator: (input) {
                          if (input!.isEmpty) {
                            return 'Please enter a description about the venue';
                          }

                          return null;
                        },
                        onSaved: (input) => _venueAbout = input!,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          labelText:
                              'Enter a description about facilities and capacity',
                        ),
                        maxLines: 5,
                        minLines: 3,
                        validator: (input) {
                          if (input!.isEmpty) {
                            return 'Please enter a description about facilities and capacity';
                          }

                          return null;
                        },
                        onSaved: (input) => _venueFacilities = input!,
                      ),
                      SizedBox(height: 2),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText:
                              'Enter a description about services offered',
                        ),
                        maxLines: 5,
                        minLines: 3,
                        validator: (input) {
                          if (input!.isEmpty) {
                            return 'Please enter a description about services offered';
                          }

                          return null;
                        },
                        onSaved: (input) => _venueServices = input!,
                      ),
                      SizedBox(height: 20),
                      Text(
                          "*Please Select all available dates for the venue, when you select a date click on ok. Click cancel when you have selected all the dates*"),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () => selectMultipleDates(context),
                        child: Text('Select date'),
                      ),
                      SizedBox(height: 20),
                      Text('Selected dates: ${pickedDates.join(', ')}'),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Email',
                              ),
                              validator: (input) {
                                if (!input!.contains('@')) {
                                  return 'Please enter an Email';
                                }
                                return null;
                              },
                              onSaved: (input) => _venueEmail = input!,
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: TextFormField(
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
                              onSaved: (input) => _venueTel = input!,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: TextFormField(
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
                              onSaved: (input) => _venuePrice = input!,
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: TextFormField(
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
                              onSaved: (input) => _venueCapacity = input!,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Location (City)',
                              ),
                              validator: (input) {
                                if (input!.isEmpty) {
                                  return 'Please enter the city of the venue';
                                }
                                return null;
                              },
                              onSaved: (input) => _venueLocation = input!,
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'PostCode',
                              ),
                              validator: (input) {
                                if (input!.isEmpty) {
                                  return 'Please enter the post code of the venue';
                                }
                                return null;
                              },
                              onSaved: (input) => _venuePostCode = input!,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            //step 2
            Step(
              title: Text('Images and Video'),
              content: Container(
                child: Column(
                  children: [
                    Container(
                      height: 300,
                      width: double.infinity,
                      child: _images.length > 0
                          ? GridView.builder(
                              itemCount: _images.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 8.0,
                                mainAxisSpacing: 8.0,
                              ),
                              itemBuilder: (context, index) {
                                return Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        image: DecorationImage(
                                          image: FileImage(_images[index]),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _images.removeAt(index);
                                          });
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(
                                            color: Colors.black45,
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          child: Icon(
                                            Icons.close,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            )
                          : Container(),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      child: Text('Add Image'),
                      onPressed: getImage,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      key: Key("panoButton"),
                      child: Text('Add Panoroma Image'),
                      onPressed: getPanoImage,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      child: Text('Add Video'),
                      onPressed: getVideo,
                    ),
                  ],
                ),
              ),
            ),
            //step 3
            Step(
              title: Text('Food and Drink'),
              content: SafeArea(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text("Does the venue offer food and drink?"),
                        Checkbox(
                          value: _hasFoodOrDrinks,
                          onChanged: (value) {
                            setState(() {
                              _hasFoodOrDrinks = value!;
                            });
                          },
                        ),
                      ],
                    ),
                    Visibility(
                      visible: _hasFoodOrDrinks,
                      child: Column(
                        children: [
                          ..._foodAndDrinks
                              .asMap()
                              .entries
                              .map((entry) => Container(
                                    padding: EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      initialValue: entry.value,
                                      decoration: InputDecoration(
                                        hintText: "Enter Food or Drink",
                                      ),
                                      onChanged: (input) {
                                        setState(() {
                                          _foodAndDrinks[entry.key] = input;
                                        });
                                      },
                                    ),
                                  )),
                          Container(
                            padding: EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              child: Text("Add food or drink"),
                              onPressed: () {
                                setState(() {
                                  _foodAndDrinks.add("");
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: !_hasFoodOrDrinks,
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        //child: Text("No"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //step 4
            Step(
              title: Text('Venue Features'),
              content: SafeArea(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text("Want to add features the venue has?"),
                        Checkbox(
                          value: _hasVenueFeutures,
                          onChanged: (value) {
                            setState(() {
                              _hasVenueFeutures = value!;
                            });
                          },
                        ),
                      ],
                    ),
                    Visibility(
                      visible: _hasVenueFeutures,
                      child: Column(
                        children: [
                          ..._venueFeutures
                              .asMap()
                              .entries
                              .map((entry) => Container(
                                    padding: EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      initialValue: entry.value,
                                      decoration: InputDecoration(
                                        // labelText:
                                        //     'Ingredient ${entry.key + 1}',
                                        hintText: "Enter venue feauture",
                                      ),
                                      onChanged: (input) {
                                        setState(() {
                                          _venueFeutures[entry.key] = input;
                                        });
                                      },
                                    ),
                                  )),
                          Container(
                            padding: EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              child: Text("Add venue feauture"),
                              onPressed: () {
                                setState(() {
                                  _venueFeutures.add("");
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: !_hasVenueFeutures,
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        //child: Text("No"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
