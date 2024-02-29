import 'dart:io';
import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:wedding_venue_booking/Auth/signup.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final List<Map<String, String>> _cards = [
    {
      'title': 'Welcome',
      'subtitle':
          'LoveLocations is number #1 wedding venue booking application',
      'image': 'assets/images/bg.jpeg',
    },
    {
      'title': 'Discover',
      'subtitle': 'Discover wedding venues near you with just a few clicks',
      'image': 'assets/images/onboarding2.jpg',
    },
    {
      'title': 'Book',
      'subtitle': 'Book a wedding venue through the app with just a few clicks',
      'image': 'assets/images/onboarding3.jpg',
    },
    {
      'title': 'List',
      'subtitle': 'If you are a venue you can list your venue easly on the app',
      'image': 'assets/images/onboarding4.jpg',
    },
  ];

  int _currentIndex = 0;

  void _onIndexChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  //Next card
  void _goToNextCard() {
    if (_currentIndex < _cards.length - 1) {
      _swiperController.next();
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SignUpScreen()),
      );
    }
  }

//Skip cards
  void _skipToSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignUpScreen()),
    );
  }

  final SwiperController _swiperController = SwiperController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 10,
            child: Swiper(
              controller: _swiperController,
              itemCount: _cards.length,
              onIndexChanged: _onIndexChanged,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 10.0),
                      Text(
                        _cards[index]['title']!,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        _cards[index]['subtitle']!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      SizedBox(height: 15.0),
                      Image.asset(
                        _cards[index]['image']!,
                        height: 500.0,
                        width: 500.0,
                      ),
                      SizedBox(height: 10.0),
                    ],
                  ),
                );
              },
              pagination: const SwiperPagination(
                  builder: DotSwiperPaginationBuilder(
                activeColor: Color.fromARGB(255, 134, 166, 126),
                color: Colors.black,
                activeSize: 15.0,
              )),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: _skipToSignUp,
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _goToNextCard,
                    icon: _currentIndex == _cards.length - 1
                        ? Icon(Icons.check, size: 32.0)
                        : Icon(Icons.arrow_forward_ios, size: 32.0),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
