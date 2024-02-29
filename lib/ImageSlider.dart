import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';

class ImageSlider extends StatelessWidget {
  final List<String> imageUrls;

  ImageSlider({required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250.0,
      // margin: EdgeInsets.all(.0),
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return Image.network(
            imageUrls[index],
            fit: BoxFit.fill,
          );
        },
        itemCount: imageUrls.length,
        pagination: const SwiperPagination(builder: SwiperPagination.dots),
      ),
    );
  }
}
