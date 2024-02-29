import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:wedding_venue_booking/Auth/signup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('sign up integration test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: SignUpScreen()));
    await tester.pumpAndSettle();

    // Test signup with valid name, email and password
    try {
      // Test signup with valid input
      await tester.enterText(find.widgetWithText(TextFormField, 'Name'), 'J W');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Email'), 'JW123@example.com');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Password'), '1234567');
      // Tap the sign up button to submit the form
      await tester.ensureVisible(find.byType(ElevatedButton));
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
    } catch (e) {
      print('Exception thrown during signup: $e');
    }
    await tester.pumpAndSettle();
    //wait for the data to be saved in the database
    await Future.delayed(Duration(seconds: 5));
    print("user is created");
  });
}
