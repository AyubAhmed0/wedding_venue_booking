import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:wedding_venue_booking/Auth/signup.dart';
import 'package:wedding_venue_booking/VenueOwner/venuehomescreen.dart';
import 'package:wedding_venue_booking/User/normaluserhomescreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _email, _password;
  void _showForgotPasswordDialog() {
    final _formKey = GlobalKey<FormState>();
    late String _email2;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Forgot Password?'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Please enter your email address';
                    }
                    return null;
                  },
                  onSaved: (value) => _email2 = value!,
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  child: Text('Submit'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      sendPasswordResetEmail(_email2);
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void sendPasswordResetEmail(String email) async {
    try {
      //send a password reset email to the given email address.
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } catch (error) {
      //print error
      print(error);
    }
  }

  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            backgroundColor: Color.fromARGB(255, 255, 255, 255),
            appBar: null,
            body: Stack(
              children: <Widget>[
                new Container(
                  decoration: new BoxDecoration(
                      image: new DecorationImage(
                          fit: BoxFit.fill,
                          colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.1), BlendMode.dstATop),
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
                        padding: EdgeInsets.only(bottom: 0, top: 0),
                        child: Column(
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignUpScreen()),
                                );
                              },
                              child: Text(
                                'Not Registered? Register Here',
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Form(
                        key:
                            _formKey, //_keyForm is used as key for the form widget
                        child: Column(
                          children: [
                            Center(
                              child: Container(
                                width: 300,
                                child: Column(children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: TextFormField(
                                      validator: (input) =>
                                          !input!.contains('@')
                                              ? 'Please enter a valid email'
                                              : null,
                                      onSaved: (input) => _email = input!,
                                      //decoration: InputDecoration(labelText: 'Email'),

                                      // input!.isEmpty ? 'Please enter your name' : null,
                                      // save the name to the _name variable
                                      //   onSaved: (input) => _name = input!,
                                      decoration: InputDecoration(
                                        labelText: 'Email',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        //labelText: 'Email',
                                        hintText: 'Enter your your email',
                                        prefixIcon: Icon(Icons.account_circle),
                                        suffixIcon: Icon(Icons.check),
                                      ),
                                      style: TextStyle(fontSize: 16.0),
                                      //autofocus: true,
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(top: 10, bottom: 10),
                                    //padding: EdgeInsets.only(bottom: 10),
                                    child: TextFormField(
                                      validator: (input) => input!.length < 6
                                          ? 'Password must be at least 6 characters'
                                          : null,
                                      onSaved: (input) => _password = input!,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        labelText: 'Password',
                                        hintText: 'Enter your your Password',
                                        prefixIcon: Icon(Icons.lock),
                                        suffixIcon: Icon(Icons.check),
                                      ),
                                      style: TextStyle(fontSize: 16.0),
                                      obscureText: true,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 300,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        // validate user input
                                        if (_formKey.currentState!.validate()) {
                                          // save the form data
                                          _formKey.currentState!.save();
                                          // sign in the user
                                          FirebaseAuth.instance
                                              .signInWithEmailAndPassword(
                                                  email: _email,
                                                  password: _password)
                                              .then((userCredential) async {
                                            if (userCredential.user != null) {
                                              // if the user is signed in, check if their email has been verified
                                              final user = userCredential.user;
                                              if (!user!.emailVerified) {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    // show an error if the email has not been verified
                                                    return AlertDialog(
                                                      title:
                                                          Text('verify email'),
                                                      content: Text(
                                                          'please verify email before logging in'),
                                                      actions: [
                                                        TextButton(
                                                          child: Text('Ok'),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );

                                                // Send a verification email to the user
                                                await user
                                                    .sendEmailVerification();
                                                return;
                                              }
                                              // If the email has been verified, get the user role from the database
                                              FirebaseDatabase.instance
                                                  .ref()
                                                  .child("users")
                                                  .child(user.uid)
                                                  .onValue
                                                  .listen((event) {
                                                var role = event.snapshot.value
                                                    ?.toString();
                                                // If the user is a venue, direct them to the Venue home screen
                                                if (role!.contains('admin')) {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              Venuehomescreen()));
                                                } else {
                                                  // If the user's role is normal user, direct them to the Normal user home screen
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              Normaluserhomescreen()));
                                                }
                                              });
                                            }
                                          }).catchError((error) {
                                            //If the login fails, shown an error message
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: Text('Error'),
                                                  content: Text('no login'),
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
                                          });
                                        }
                                      },
                                      child: Text('Log In'),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 110,
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      _showForgotPasswordDialog();
                                    },
                                    child: Text(
                                      'FORGOT PASSWORD',
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 134, 166, 126),
                                          fontSize: 15),
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
