import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget editScreen() {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  return Scaffold(
    appBar: null,
    body: SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Enter Venue Name',
                //hintText: "Enter the name of the venue",
              ),
              validator: (input) {
                if (input!.isEmpty) {
                  return 'Please enter venue name';
                }

                return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Enter a description about the Venue',
                //hintText: "Enter the name of the venue",
              ),
              maxLines: 5,
              minLines: 3,
              validator: (input) {
                if (input!.isEmpty) {
                  return 'Please enter a description about the venue';
                }

                return null;
              },
            ),
            TextFormField(
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                labelText: 'Enter a description about facilities and capacity',
                // hintText: "Enter a value for additional field 1",
              ),
              maxLines: 5,
              minLines: 3,
              validator: (input) {
                if (input!.isEmpty) {
                  return 'Please enter a description about facilities and capacity';
                }

                return null;
              },
            ),
            SizedBox(height: 2),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Enter a description about services offered',
                //hintText: "Enter a value for additional field 2",
              ),
              maxLines: 5,
              minLines: 3,
              validator: (input) {
                if (input!.isEmpty) {
                  return 'Please enter a description about services offered';
                }

                return null;
              },
            ),
            SizedBox(height: 20),
            Text(
                "*Please Select all available dates for the venue, when you select a date click on ok. Click cancel when you have selected all the dates*"),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {},
              child: Text('select new dates'),
            ),
            SizedBox(height: 10),
            Text('available dates:'),
            SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Email',
              ),
              // keyboardType: TextInputType.number,
              validator: (input) {
                if (!input!.contains('@')) {
                  return 'Please enter an Email';
                }
                return null;
              },
            ),
            SizedBox(width: 20),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Tel:',
              ),
              keyboardType: TextInputType.number,
              validator: (input) {
                if (input!.isEmpty) {
                  return 'Please enter a phone number';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Price (\£)',
              ),
              keyboardType: TextInputType.number,
              validator: (input) {
                if (input!.isEmpty) {
                  return 'Please enter the price of the venue';
                }
                return null;
              },
            ),
            SizedBox(width: 20),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Capacity',
              ),
              keyboardType: TextInputType.number,
              validator: (input) {
                if (input!.isEmpty) {
                  return 'Please enter a capacity of the venue';
                }
                return null;
              },
            ),
            SizedBox(width: 20),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Location (City)',
              ),
              validator: (input) {
                if (input!.isEmpty) {
                  return 'Please enter the city of the venue';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'PostCode',
              ),
              validator: (input) {
                if (input!.isEmpty) {
                  return 'Please enter the post code of the venue';
                }
                return null;
              },
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              child: Text('Save Changes'),
              onPressed: () {
                _formKey.currentState!.validate();
              },
            ),
          ],
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('check if all widgets are rendered', (WidgetTester tester) async {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    // Build the VenueFormScreen widget
    await tester.pumpWidget(MaterialApp(home: editScreen()));
    // Find the form widget.
    expect(find.byType(Form), findsOneWidget);
    // Verify that all text field widgets are rendered correctly
    expect(
        find.widgetWithText(
            TextFormField, 'Enter a description about the Venue'),
        findsOneWidget);
    expect(
        find.widgetWithText(
            TextFormField, 'Enter a description about facilities and capacity'),
        findsOneWidget);
    expect(
        find.widgetWithText(
            TextFormField, 'Enter a description about services offered'),
        findsOneWidget);
    expect(
        find.text(
            '*Please Select all available dates for the venue, when you select a date click on ok. Click cancel when you have selected all the dates*'),
        findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'select new dates'),
        findsOneWidget);
    expect(find.text('available dates:'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Email'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Tel:'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Price (£)'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Capacity'), findsOneWidget);
    expect(
        find.widgetWithText(TextFormField, 'Location (City)'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'PostCode'), findsOneWidget);
  });
  testWidgets(
      'Submitting the form with valid values should show no validation errors',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: editScreen()));

    // Enter valid input and click the save button
    await tester.enterText(find.byType(TextFormField).first, 'My Venue');
    await tester.enterText(find.byType(TextFormField).at(1), 'Description');
    await tester.enterText(find.byType(TextFormField).at(2), 'Facilities');
    await tester.enterText(find.byType(TextFormField).at(3), 'Services');
    await tester.enterText(
        find.byType(TextFormField).at(4), 'example@venue.com');
    await tester.enterText(find.byType(TextFormField).at(5), '080050000');
    await tester.enterText(find.byType(TextFormField).at(6), '9000');
    await tester.enterText(find.byType(TextFormField).at(7), '500');
    await tester.enterText(find.byType(TextFormField).at(8), 'Manchester');
    await tester.enterText(find.byType(TextFormField).at(9), 'M12J8Y');
    await tester.ensureVisible(find.text('Save Changes'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save Changes'));
    await tester.pumpAndSettle();
    // Verify that the form validation is triggered and error messages are not show
    expect(find.text('Please enter venue name'), findsNothing);
  });
  testWidgets(
      'Submitting the form with empty values should show validation errors',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: editScreen()));
    // Enter invalid input and click the save button
    await tester.enterText(find.byType(TextFormField).first, '');
    await tester.ensureVisible(find.text('Save Changes'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save Changes'));
    await tester.pumpAndSettle();
    // Verify that the form validation is triggered and error messages are show
    expect(find.text('Please enter venue name'), findsOneWidget);
    expect(find.text('Please enter a description about the venue'),
        findsOneWidget);
  });
}
