import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget booking() {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  return Scaffold(
    backgroundColor: Color.fromARGB(237, 255, 255, 255),
    appBar: null,
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 66.0, vertical: 40),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.0),
              Text(
                'Full Name',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              Text(
                'Email',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              Text(
                'Telephone Number',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your telephone number';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16.0),
              Text(
                'Venue Date',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'Price',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the Venue price';
                  }
                  if (value != 5000) {
                    return 'The entered price does not match the Venue price';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16.0),
              Text(
                'Message (Optional)',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              TextFormField(),
              SizedBox(height: 28.0),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    _formKey.currentState!.validate();
                  },
                  child: Text('Book Venue'),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('check if all widgets are rendered', (WidgetTester tester) async {
    // Build the VenueFormScreen widget
    await tester.pumpWidget(MaterialApp(home: booking()));
    // Find the form widget.
    expect(find.byType(Form), findsOneWidget);
    expect(find.text('Full Name'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Telephone Number'), findsOneWidget);
    expect(find.text('Venue Date'), findsOneWidget);
    expect(find.text('Price'), findsOneWidget);
    expect(find.text('Message (Optional)'), findsOneWidget);
  });
  testWidgets(
      'Submitting the form with valid values should show no validation errors',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: booking()));

    // Enter valid input and click the save button
    await tester.enterText(find.byType(TextFormField).first, 'John Smith');
    await tester.enterText(
        find.byType(TextFormField).at(1), 'john@example.com');
    await tester.enterText(find.byType(TextFormField).at(2), '080050000');
    await tester.enterText(find.byType(TextFormField).at(3), '500');
    await tester.enterText(
        find.byType(TextFormField).at(4), 'hello this is my message');
    await tester.ensureVisible(find.text('Book Venue'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Book Venue'));
    await tester.pumpAndSettle();
    // Verify that the form validation is triggered and error messages are not show
    expect(find.text('Please enter your full name'), findsNothing);
  });
  testWidgets(
      'Submitting the form with empty values should show validation errors',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: booking()));
    // Enter invalid input and click the save button
    await tester.enterText(find.byType(TextFormField).first, '');
    await tester.ensureVisible(find.text('Book Venue'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Book Venue'));
    await tester.pumpAndSettle();
    // Verify that the form validation is triggered and error messages are show
    expect(find.text('Please enter your full name'), findsOneWidget);
    expect(find.text('Please enter your email'), findsOneWidget);
  });
}
