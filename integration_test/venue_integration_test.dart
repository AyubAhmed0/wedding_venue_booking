import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wedding_venue_booking/Auth/login.dart';
import 'package:wedding_venue_booking/VenueOwner/venuehomescreen.dart';

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
        'walita3378@bymercy.com',
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

    //expect(FirebaseAuth.instance.currentUser, isNotNull);

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });

    // // Test login with invalid email and password
    // await tester.enterText(find.byKey(Key('email_field')), 'invalid@test.com');
    // await tester.enterText(find.byKey(Key('password_field')), 'invalid_password');
    // await tester.tap(find.byKey(Key('login_button')));
    // await tester.pumpAndSettle();

    // expect(FirebaseAuth.instance.currentUser, isNull);
  });
  testWidgets('venue integration test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Venuehomescreen()));
    await tester.pumpAndSettle();
    //Click add venue button
    await tester.tap(find.widgetWithText(ElevatedButton, 'Add venue'));
    await tester.pumpAndSettle();
    //go back
    await tester.tap(find.byTooltip("Back"));
    await tester.pumpAndSettle();
    //Click on the Venues button
    await tester.tap(find.text('Venues'));
    await tester.pumpAndSettle();
    //click view more
    await tester.tap(find.text('View More').first);
    await tester.pumpAndSettle();
    //click edit button
    await tester.tap(find.byIcon(Icons.edit_outlined));
    //click the back button
    final NavigatorState navigator = tester.state(find.byType(Navigator));
    navigator.pop();
    await tester.pump();
    //click the back button
    navigator.pop();
    await tester.pump();
    await tester.pumpAndSettle();
    //click notification button
    await tester.tap(find.text('Notifications'));
    await tester.pumpAndSettle();
  });
}
