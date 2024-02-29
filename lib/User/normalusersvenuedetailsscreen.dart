import 'dart:io';
import 'package:flutter/material.dart';
import '../ImageSlider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import '../photogalleryscreen.dart';
import '../imagepanoramascreen.dart';
import '../videoscreen.dart';
import 'package:intl/intl.dart';
import 'bookingscreen.dart';

class Normalusersvenuedetailsscreen extends StatelessWidget {
  final String normalUserId;
  final String venueOwnerId;
  final String venueId;
  List<String> venueDiningOptions = [];
  List<String> imageUrls = [];
  final String panoImage;
  final String venueCapacity;
  final String venueEmail;
  final String venueFacilities;
  List<String> venueFeatures = [];
  final String venueLocation;
  final String venueName;
  final String venueAbout;
  final String venuePostCode;
  final String venuePrice;
  final String venueServices;
  final String venueTel;
  List<String> venueDates = [];
  final String venueVideos;

  Normalusersvenuedetailsscreen(
      {required this.venueOwnerId,
      required this.normalUserId,
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
// A function to make a phone call using the given phone number
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: SingleChildScrollView(
        child: Column(
          children: [
            ImageSlider(imageUrls: imageUrls),
            Row(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Photogalleryscreen(
                                imageUrls: imageUrls,
                              )),
                    );
                  },
                  icon: Icon(size: 25, Icons.camera_alt),
                  label: Text("photos"),
                ),
                TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => VideoScreen(
                                videoUrl: venueVideos,
                              )),
                    );
                  },
                  icon: Icon(size: 25, Icons.play_circle),
                  label: Text("videos"),
                ),
                TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Imagepanoramascreen(
                                panoImageURL: panoImage,
                              )),
                    );
                  },
                  icon: Icon(size: 25, Icons.threesixty),
                  label: Text("360\u00B0 view"),
                ),
              ],
            ),
            //Text("Post ID: $postId"),
            SizedBox(height: 5),
            Row(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 10),
                Icon(
                    size: 14.0,
                    color: Color.fromARGB(255, 124, 124, 124),
                    Icons.location_on),
                Text(
                  venueLocation + ",",
                  style: GoogleFonts.notoSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                SizedBox(width: 5),
                Text(
                  venuePostCode,
                  style: GoogleFonts.notoSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 11),
                Icon(
                    size: 14.0,
                    color: Color.fromARGB(255, 124, 124, 124),
                    Icons.people_alt_outlined),
                SizedBox(width: 3),
                Text("300",
                    style: GoogleFonts.notoSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                    )),
                SizedBox(width: 5),
                Text("From £" + venuePrice,
                    style: GoogleFonts.openSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                    )),
              ],
            ),
            SizedBox(
              height: 13,
            ),
            Container(
                padding: EdgeInsets.only(left: 11),
                child: Row(
                  children: [
                    Text(
                      venueName,
                      style: GoogleFonts.catamaran(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ],
                )),
            SizedBox(
              height: 15,
            ),
            SizedBox(
              height: 1,
              width: 380,
              child: Container(color: Color.fromARGB(233, 212, 208, 208)),
            ),
            SizedBox(height: 20),
            Container(
                padding: EdgeInsets.only(left: 11),
                child: Row(
                  children: [
                    Text(
                      "About",
                      style: GoogleFonts.catamaran(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ],
                )),
            SizedBox(height: 5),
            Container(
              padding: EdgeInsets.only(left: 11, right: 3),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Text(
                      venueAbout,
                      maxLines: null,
                      style: GoogleFonts.notoSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5),
            Container(
                padding: EdgeInsets.only(left: 11),
                child: Row(
                  children: [
                    Text(
                      "Facilities and Capacity",
                      style: GoogleFonts.catamaran(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ],
                )),
            SizedBox(height: 5),
            Container(
              padding: EdgeInsets.only(left: 11, right: 3),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Text(
                      venueFacilities,
                      maxLines: null,
                      style: GoogleFonts.notoSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5),
            Container(
                width: double.infinity,
                padding: EdgeInsets.only(left: 11),
                child: Row(
                  children: [
                    Text(
                      "Services Offered",
                      style: GoogleFonts.catamaran(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal,
                      ),
                      //textWidthBasis: TextWidthBasis.longestLine,
                    ),
                  ],
                )),
            SizedBox(height: 5),
            Container(
              padding: EdgeInsets.only(left: 11, right: 3),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Text(
                      venueServices,
                      maxLines: null,
                      style: GoogleFonts.notoSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Container(
                padding: EdgeInsets.only(left: 11),
                child: Row(
                  children: [
                    Text(
                      "Venue Features:",
                      style: GoogleFonts.catamaran(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ],
                )),
            SizedBox(
              height: 5,
            ),
            Container(
              padding: EdgeInsets.only(left: 11),
              child: Column(
                children: [
                  for (int i = 0; i < venueFeatures.length; i++)
                    Row(
                      children: [
                        Icon(
                            size: 13.0,
                            color: Color.fromARGB(255, 84, 111, 80),
                            Icons.check_outlined),
                        SizedBox(
                          width: 3,
                        ),
                        Text(
                          venueFeatures[i],
                          style: GoogleFonts.notoSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 1,
              width: 370,
              child: Container(color: Color.fromARGB(233, 212, 208, 208)),
            ),
            SizedBox(height: 10),
            Container(
                padding: EdgeInsets.only(left: 11),
                child: Row(
                  children: [
                    Text(
                      "Dining Options:",
                      style: GoogleFonts.catamaran(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ],
                )),
            SizedBox(
              height: 5,
            ),
            Container(
              padding: EdgeInsets.only(left: 11),
              child: Column(
                children: [
                  for (int i = 0; i < venueDiningOptions.length; i++)
                    Row(
                      children: [
                        Icon(
                            size: 13.0,
                            color: Color.fromARGB(255, 84, 111, 80),
                            Icons.check_outlined),
                        SizedBox(
                          width: 3,
                        ),
                        Text(
                          venueDiningOptions[i],
                          style: GoogleFonts.notoSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 1,
              width: 370,
              child: Container(color: Color.fromARGB(233, 212, 208, 208)),
            ),
            SizedBox(height: 10),
            Container(
                padding: EdgeInsets.only(left: 11),
                child: Row(
                  children: [
                    Text(
                      "Available dates:",
                      style: GoogleFonts.catamaran(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ],
                )),
            SizedBox(
              height: 1,
            ),
            Container(
              padding: EdgeInsets.only(left: 11),
              child: Column(
                children: [
                  for (int i = 0; i < venueDates.length; i++)
                    Row(
                      children: [
                        Icon(
                            size: 13.0,
                            color: Color.fromARGB(255, 84, 111, 80),
                            Icons.calendar_today),
                        SizedBox(
                          width: 3,
                        ),
                        Text(
                          venueDates[i],
                          style: GoogleFonts.notoSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 50,
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                  decoration: BoxDecoration(
                    border:
                        Border(top: BorderSide(width: 0.5, color: Colors.grey)),
                    color: Colors.white,
                  ),
                  child: Visibility(
                    visible: venueDates.contains('No available dates')
                        ? false
                        : true,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: () {
                            _makePhoneCall(venueTel);
                          },
                          icon: Icon(Icons.phone_in_talk_rounded, size: 25),
                        ),
                        Container(
                          width: 330,
                          height: 40,
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          child: ElevatedButton(
                            child: Text("Book",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontFamily: "Helvetica")),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Bookingscreen(
                                    normalUserId: normalUserId,
                                    venueOwnerId: venueOwnerId,
                                    venueId: venueId,
                                    imageUrls: imageUrls,
                                    panoImage: panoImage,
                                    venueDiningOptions: venueDiningOptions,
                                    venueCapacity: venueCapacity,
                                    venueEmail: venueEmail,
                                    venueFacilities: venueFacilities,
                                    venueFeatures: venueFeatures,
                                    venueLocation: venueLocation,
                                    venueName: venueName,
                                    venueAbout: venueAbout,
                                    venuePostCode: venuePostCode,
                                    venuePrice: venuePrice,
                                    venueServices: venueServices,
                                    venueTel: venueTel,
                                    venueDates: venueDates,
                                    venueVideos: venueVideos,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
