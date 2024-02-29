import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wedding_venue_booking/Auth/login.dart';
import 'package:wedding_venue_booking/Auth/signup.dart';

void main() {
  testWidgets('Check if widgets exist', (WidgetTester tester) async {
    // build the SignUpScreen widget.
    await tester.pumpWidget(MaterialApp(home: LoginScreen()));
    // Find the image widget.
    expect(find.byType(Image), findsOneWidget);
    // Find the 'Not Registered? Register Here' TextButton widget.
    expect(find.widgetWithText(TextButton, 'Not Registered? Register Here'),
        findsOneWidget);
    // Find the form widget.
    expect(find.byType(Form), findsOneWidget);
    // Find the Email text field widget.
    expect(find.widgetWithText(TextFormField, 'Email'), findsOneWidget);
    // Find the Password text field widget.
    expect(find.widgetWithText(TextFormField, 'Password'), findsOneWidget);
    // Find the login button widget.
    expect(find.widgetWithText(ElevatedButton, 'Log In'), findsOneWidget);
    // Find the 'FORGOT PASSWORD' TextButton widget.
    expect(find.widgetWithText(TextButton, 'FORGOT PASSWORD'), findsOneWidget);
  });
  testWidgets(
      'Submitting the form with empty values should show validation errors',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: LoginScreen()));

    // Tap the login button to submit the form
    await tester.ensureVisible(find.byType(ElevatedButton));
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();
    // verify that validation errors are shown
    expect(find.text('Please enter a valid email'), findsOneWidget);
    expect(find.text('Password must be at least 6 characters'), findsOneWidget);
  });
  testWidgets(
      'login screen redirects to Signup screen when Not Registered? Register Here is pressed',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: LoginScreen()));
    // Find the Not Registered? Register Here button and tap it
    await tester.ensureVisible(
        find.widgetWithText(TextButton, 'Not Registered? Register Here'));
    await tester
        .tap(find.widgetWithText(TextButton, 'Not Registered? Register Here'));
    await tester.pumpAndSettle();
    // Verify that the navigation happened and the signup screen is displayed
    expect(find.byType(SignUpScreen), findsOneWidget);
  });
}
