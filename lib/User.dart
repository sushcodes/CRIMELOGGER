
import 'package:crimelogger/FetchData.dart';
import 'package:crimelogger/MapScreen.dart';
import 'package:crimelogger/Welcome.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class UserScreen extends StatefulWidget {
  static const String id = 'UserScreen';

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  bool showSpinner = false;

  String email='hi';
  String password='hi';

  @override
  Widget build(BuildContext context) {
    print("BUILD USER IS CALLED");


    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Column(mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Flexible(
                child: Container(
                  height: 200.0,
                  child: Image.asset('assets/images/download.jpg'),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                },
                decoration: InputDecoration(hintText: 'Enter your email'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                },
                decoration: InputDecoration(hintText: 'Enter your password'),
              ),
              SizedBox(
                height: 24.0,
              ),
              ElevatedButton(
                  child: Text('Login',
                      style: TextStyle(  // Colors.lightBlueAccent
                          color: Colors.black, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(shadowColor: Colors.black,primary:  Colors.lightBlueAccent,
                      elevation: 10,padding: EdgeInsets.all(15),side:BorderSide(color:Colors.white24 ), shape:RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ) ),
                  onPressed: () async {
                    setState(() {
                      showSpinner = true;
                    });
                    try {
                      UserCredential? user = await  FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: email, password: password);

                      if (user != null)
                      {
                      //  Navigator.pushNamed(context, WelcomeScreen.id);
                        Navigator.pushReplacementNamed(context, WelcomeScreen.id);
                      }


                      setState(() {
                        showSpinner = false;
                      });
                    } catch (e) {
                      String s=e.toString();
                      showDialog(context: context,
                          builder: (BuildContext context) {
                            return AlertWidget(s);
                          });
                      print(e);
                      setState(() {
                        showSpinner = false;
                      });
                    }
                  }
              ),
              SizedBox(
                height: 24.0,
              ),
              ElevatedButton(
                  child: Text('Register',
                      style: TextStyle(  // Colors.lightBlueAccent
                          color: Colors.black, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(shadowColor: Colors.black,primary:  Colors.lightBlueAccent,
                      elevation: 10,padding: EdgeInsets.all(15),side:BorderSide(color:Colors.white24 ), shape:RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ) ),
                  onPressed: () async {
                    setState(() {
                      showSpinner = true;
                    });
                    try {
                      final newUser = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                          email: email, password: password);
                      if (newUser != null) {
                        //Navigator.pushNamed(context, WelcomeScreen.id);
                        Navigator.pushReplacementNamed(context, WelcomeScreen.id);
                      }

                      setState(() {
                        showSpinner = false;
                      });
                    } catch (e) {
                      String s=e.toString();
                      showDialog(context: context,
                          builder: (BuildContext context) {
                            return AlertWidget(s);
                          });
                      print(e);
                      setState(() {
                        showSpinner = false;
                      });
                    }
                  }
              ),
              SizedBox(
                height: 24.0,
              ),

            ],
          ),
        ),
      ),
    );
  }
}





class AlertWidget extends StatelessWidget {
  String? Error;
  AlertWidget(String text)
  {
    Error=text;
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      //title: Text('Alert'),
      content: Text('$Error'),
      actions: <Widget>[
        // usually buttons at the bottom of the dialog
        new ElevatedButton(
          child: Text("Close"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}