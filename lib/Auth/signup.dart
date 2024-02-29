import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:wedding_venue_booking/Auth/login.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _keyForm = GlobalKey<
      FormState>(); //key for the form - identfies form widget and access it's state
  bool _isVenueOwner = false;
  late String _name;
  late String _userEmail;
  late String _userPassword;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            backgroundColor: Color.fromARGB(255, 253, 254, 255),
            appBar: null,
            body: Stack(
              children: <Widget>[
                new Container(
                  decoration: new BoxDecoration(
                      image: new DecorationImage(
                          fit: BoxFit.fill,
                          colorFilter: ColorFilter.mode(
                              Colors.green.withOpacity(0.1), BlendMode.dstATop),
                          image: new AssetImage("assets/images/bg.jpeg"))),
                ),
                SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 60.0),
                        child: Center(
                          child: Container(
                              width: 300,
                              height: 250,
                              child: Image.asset(
                                'assets/images/logo.png',
                                height: 100,
                                width: 100,
                                fit: BoxFit.fill,
                              )),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 0),
                        child: Column(
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()),
                                );
                              },
                              child: Text(
                                "Already Registered? Login Here",
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Form(
                        key:
                            _keyForm, //_keyForm is used as key for the form widget
                        child: Column(
                          children: [
                            Center(
                              child: Container(
                                width: 300,
                                child: Column(children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 20),
                                    child: TextFormField(
                                      //validate name text field
                                      validator: (input) {
                                        if (input!.isEmpty) {
                                          return 'Please enter your name';
                                        }
                                        return null;
                                      },
                                      // save the name to the _name variable
                                      onSaved: (input) => _name = input!,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        labelText: 'Name',
                                        hintText: 'Enter your your name',
                                        prefixIcon: Icon(Icons.account_circle),
                                        suffixIcon: Icon(Icons.check),
                                      ),
                                      style: TextStyle(fontSize: 16.0),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: TextFormField(
                                      validator: (input) {
                                        if (!input!.contains('@')) {
                                          return 'Please enter a valid email';
                                        }
                                        return null;
                                      },
                                      onSaved: (input) => _userEmail = input!,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        labelText: 'Email',
                                        hintText: 'Enter your your Email',
                                        prefixIcon: Icon(Icons.email),
                                        suffixIcon: Icon(Icons.check),
                                      ),
                                      style: TextStyle(fontSize: 16.0),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: TextFormField(
                                      validator: (input) {
                                        if (input != null && input.length < 6) {
                                          return 'Password must be at least 6 characters';
                                        }
                                        return null;
                                      },
                                      onSaved: (input) =>
                                          _userPassword = input!,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        labelText: 'Password',
                                        hintText: 'Enter a password',
                                        prefixIcon: Icon(Icons.lock),
                                        suffixIcon: Icon(Icons.check),
                                      ),
                                      obscureText: true,
                                    ),
                                  ),
                                  CheckboxListTile(
                                    title: const Text('Are you a venue owner?'),
                                    value: _isVenueOwner,
                                    onChanged: (value) {
                                      setState(() {
                                        _isVenueOwner = value!;
                                      });
                                    },
                                  ),
                                  SizedBox(
                                    width: 300,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        //validate form data
                                        if (_keyForm.currentState!.validate()) {
                                          // save form data
                                          _keyForm.currentState!.save();
                                          try {
                                            // create a new user in firebase auth
                                            final authResult = await FirebaseAuth
                                                .instance
                                                .createUserWithEmailAndPassword(
                                              email: _userEmail,
                                              password: _userPassword,
                                            );
                                            final user = authResult.user;
                                            // Send email verification to the new user
                                            await user?.sendEmailVerification();
                                            // check user role whether they are a venue or a normal user and store it in role
                                            final role = _isVenueOwner
                                                ? 'admin'
                                                : 'normaluser';
                                            // Store new user data in the Database
                                            await FirebaseDatabase.instance
                                                .ref()
                                                .child("users")
                                                .child(user!.uid)
                                                .set({
                                              'name': _name,
                                              'email': _userEmail,
                                              'role': role,
                                            });
                                            // if user is created, navigate to the login screen
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      LoginScreen()),
                                            );
                                          } catch (e) {
                                            var errorCode = e.hashCode;
                                            print(e);
                                            //if any error occurs during the user creation, show an error dialog
                                            if (1 == 1) {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: Text('Error'),
                                                    content: Text(
                                                        'Email already in use'),
                                                    actions: [
                                                      TextButton(
                                                        child: Text('Ok'),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            }
                                          }
                                        }
                                      },
                                      child: Text('Sign Up'),
                                    ),
                                  ),
                                ]),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )));
  }
}
