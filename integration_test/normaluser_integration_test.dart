import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wedding_venue_booking/Auth/login.dart';
import 'package:wedding_venue_booking/User/normaluserhomescreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Login integration test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: LoginScreen()));
    await tester.pumpAndSettle();

    // Test login with valid email and password
    try {
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'tekahek118@wifame.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        "1234567",
      );
      await tester.tap(find.widgetWithText(ElevatedButton, 'Log In'));
      await tester.pumpAndSettle();
    } catch (e) {
      print('Exception thrown during login: $e');
    }
    await tester.pumpAndSettle();
    // Wait for Firebase authentication state to change
    await FirebaseAuth.instance
        .authStateChanges()
        .firstWhere((user) => user != null);

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is not logged in');
      } else {
        print('User is logged in');
      }
    });
  });
  testWidgets('normal user integration test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Normaluserhomescreen()));
    await tester.pumpAndSettle();
    await tester.tap(find.text('View More').first);
    await tester.pumpAndSettle();
    // Click on the book button
    await tester.tap(find.text('Book'));
    await tester.pumpAndSettle();
    final NavigatorState navigator = tester.state(find.byType(Navigator));
    navigator.pop();
    await tester.pump();
    navigator.pop();
    await tester.pump();
    await tester.pumpAndSettle();
    //click Booking nav item
    await tester.tap(find.text('Booking'));
    await tester.pumpAndSettle();
    //click settings nav
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    //click logout button
    await tester.tap(find.text('Logout'));
    await tester.pumpAndSettle();
  });
}
