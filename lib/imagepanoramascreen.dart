import 'dart:io';
import 'package:flutter/material.dart';
import 'package:panorama/panorama.dart';

class Imagepanoramascreen extends StatelessWidget {
  final String panoImageURL;

  // Imagepanoramascreen({required this.imageUrls});
  Imagepanoramascreen({required this.panoImageURL});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Panorama(
          zoom: 1,
          animSpeed: 1.0,
          child: Image.network(panoImageURL),
        ),
      ),
    );
  }
}
