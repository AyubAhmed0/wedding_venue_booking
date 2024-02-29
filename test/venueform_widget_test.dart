import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget stepper() {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  return Scaffold(
    body: Stepper(
      // Define a vertical Stepper widget
      type: StepperType.vertical,
      currentStep: 0,
      // the action to be taken when the cancel button is clickedd
      onStepCancel: () {},
      onStepContinue: () {
        _formKey.currentState!.validate();
      },
      // the action to be taken when a step is tapped
      onStepTapped: (step) {},
      steps: [
        //step 1
        Step(
          title: Text('Venue Info'),
          content: SafeArea(
            //height: 400,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Enter Venue Name'),
                    validator: (input) {
                      if (input!.isEmpty) {
                        return 'Please enter venue name';
                      }

                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Enter a description about the Venue'),
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
                      labelText:
                          'Enter a description about facilities and capacity',
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
                    child: Text('Select date'),
                  ),
                  SizedBox(height: 20),
                  Text('Selected dates: '),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        width: 100,
                        child: TextFormField(
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
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: TextFormField(
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
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        width: 100,
                        child: TextFormField(
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
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        // width: MediaQuery.of(context).size.width * 0.3,
                        child: TextFormField(
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
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        width: 100,
                        child: TextFormField(
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
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        // width: MediaQuery.of(context).size.width * 0.3,
                        child: TextFormField(
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
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

void main() {
  testWidgets('Verify that the Stepper widget is rendered correctly',
      (WidgetTester tester) async {
    // Build the VenueFormScreen widget
    await tester.pumpWidget(MaterialApp(home: stepper()));

    // Verify that the Stepper widget is rendered correctly
    expect(find.text('Venue Info'), findsOneWidget);
    expect(find.text('Enter Venue Name'), findsOneWidget);
    expect(find.text('Enter a description about the Venue'), findsOneWidget);
    expect(find.text('Selected dates: '), findsOneWidget);
  });

  testWidgets(
      'Verify that the form validation is triggered and error messages are show with invalid inputs',
      (WidgetTester tester) async {
    // Build the VenueFormScreen widget
    await tester.pumpWidget(MaterialApp(home: stepper()));

    // Verify that the Stepper widget is rendered correctly
    expect(find.text('Venue Info'), findsOneWidget);
    expect(find.text('Enter Venue Name'), findsOneWidget);
    expect(find.text('Enter a description about the Venue'), findsOneWidget);
    expect(find.text('Selected dates: '), findsOneWidget);

    // Enter invalid input and try to continue to the next step
    await tester.enterText(find.byType(TextFormField).first, '');
    //await tester.enterText(find.byType(TextFormField).first, '');
    await tester.ensureVisible(find.text('CONTINUE'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('CONTINUE'));
    await tester.pumpAndSettle();
    // Verify that the form validation is triggered and error messages are show
    expect(find.text('Please enter venue name'), findsOneWidget);
    expect(find.text('Please enter a description about the venue'),
        findsOneWidget);
  });

  testWidgets(
      'Verify that the form validation is triggered and error messages are not show with valid inputs',
      (WidgetTester tester) async {
    // Build the VenueFormScreen widget
    await tester.pumpWidget(MaterialApp(home: stepper()));

    // Enter valid input and continue to the next step
    await tester.enterText(find.byType(TextFormField).first, 'My Venue');
    await tester.enterText(find.byType(TextFormField).at(1), 'Description');
    await tester.enterText(find.byType(TextFormField).at(2), 'Facilities');
    await tester.enterText(find.byType(TextFormField).at(3), 'Services');
    await tester.ensureVisible(find.text('CONTINUE'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('CONTINUE'));
    await tester.pumpAndSettle();
    // Verify that the form validation is triggered and error messages are not show
    expect(find.text('Please enter venue name'), findsNothing);
  });
}
