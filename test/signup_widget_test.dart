import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wedding_venue_booking/Auth/signup.dart';
import 'package:wedding_venue_booking/Auth/login.dart';

void main() {
  testWidgets('Check if all widgets exist', (WidgetTester tester) async {
    // build the SignUpScreen widget.
    await tester.pumpWidget(MaterialApp(home: SignUpScreen()));
    // Find the image widget.
    expect(find.byType(Image), findsOneWidget);
    // Find the form widget.
    expect(find.byType(Form), findsOneWidget);
    // Find the 'Already Registered? Login Here' TextButton widget.
    expect(find.widgetWithText(TextButton, 'Already Registered? Login Here'),
        findsOneWidget);
    // Find the Name text field widget.
    expect(find.widgetWithText(TextFormField, 'Name'), findsOneWidget);
    // Find the Email text field widget.
    expect(find.widgetWithText(TextFormField, 'Email'), findsOneWidget);
    // Find the Password text field widget.
    expect(find.widgetWithText(TextFormField, 'Password'), findsOneWidget);
    // Find the "Are you a venue owner?" checkbox widget.
    expect(find.widgetWithText(CheckboxListTile, 'Are you a venue owner?'),
        findsOneWidget);
    // Find the Sign Up button widget.
    expect(find.widgetWithText(ElevatedButton, 'Sign Up'), findsOneWidget);
  });
  testWidgets(
      'Submitting the form with empty values should show validation errors',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: SignUpScreen()));

    // Tap the sign up button to submit the form
    await tester.ensureVisible(find.byType(ElevatedButton));
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();
    // verify that validation errors are shown
    expect(find.text('Please enter your name'), findsOneWidget);
    expect(find.text('Please enter a valid email'), findsOneWidget);
    expect(find.text('Password must be at least 6 characters'), findsOneWidget);
  });
  testWidgets(
      'Signup screen redirects to login screen when Already Registered? Login Here is pressed',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: SignUpScreen()));
    // Find the Already Registered? Login Here button and tap it
    await tester.ensureVisible(
        find.widgetWithText(TextButton, 'Already Registered? Login Here'));
    await tester
        .tap(find.widgetWithText(TextButton, 'Already Registered? Login Here'));
    await tester.pumpAndSettle();
    // Verify that the navigation happened and the Login screen is displayed
    expect(find.byType(LoginScreen), findsOneWidget);
  });
}
