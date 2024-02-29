import 'dart:io';
import 'package:flutter/material.dart';

class Photogalleryscreen extends StatelessWidget {
  final List<String> imageUrls;

  Photogalleryscreen({required this.imageUrls});

  void _showFullScreenImage(BuildContext context, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenImageScreen(imageUrl: imageUrls[index]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Photo Gallery"),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: List.generate(imageUrls.length, (index) {
          return GestureDetector(
            onTap: () => _showFullScreenImage(context, index),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(width: 1.0, color: Colors.black12),
              ),
              child: Image.network(
                imageUrls[index],
                fit: BoxFit.cover,
              ),
            ),
          );
        }),
      ),
    );
  }
}

class FullScreenImageScreen extends StatelessWidget {
  final String imageUrl;

  FullScreenImageScreen({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
