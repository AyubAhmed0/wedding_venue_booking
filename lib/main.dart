import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'onboardingscreen.dart';
import 'package:wedding_venue_booking/Auth/login.dart';

int? initScreen;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  initScreen = (await prefs.getInt("initScreen"));
  await prefs.setInt("initScreen", 1);
  //print('initScreen ${initScreen}');
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MaterialColor appColour = MaterialColor(
    Color.fromARGB(255, 134, 166, 126).value,
    <int, Color>{
      50: Color.fromRGBO(255, 134, 166, 0.1),
      100: Color.fromRGBO(255, 134, 166, 0.2),
      200: Color.fromRGBO(0255, 134, 166, 0.3),
      300: Color.fromRGBO(255, 134, 166, 0.4),
      400: Color.fromRGBO(255, 134, 166, 0.5),
      500: Color.fromRGBO(255, 134, 166, 0.6),
      600: Color.fromRGBO(255, 134, 166, 0.7),
      700: Color.fromRGBO(255, 134, 166, 0.8),
      800: Color.fromRGBO(0255, 134, 166, 0.9),
      900: Color.fromRGBO(255, 134, 166, 1),
    },
  );
  // This widget is the root of your application. Try running the application with "flutter run".
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'LoveLocations',
        theme: ThemeData(
          primarySwatch: appColour,
          appBarTheme:
              AppBarTheme(backgroundColor: Color.fromARGB(255, 134, 166, 126)),
        ),
        //show onboarding screen if the user is a new user else show login screen
        home: initScreen != null ? LoginScreen() : OnboardingScreen()
        // home: OnboardingScreen(),
        );
  }
}
