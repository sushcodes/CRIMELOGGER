import 'package:crimelogger/FetchData.dart';
import 'package:crimelogger/MapScreen.dart';
import 'package:crimelogger/Reported.dart';
import 'package:crimelogger/User.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
class WelcomeScreen extends StatefulWidget {
  static const String id = 'WelcomeScreen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  static const colorizeColors = [
    Colors.purple,
    Colors.blue,
    Colors.yellow,
    Colors.red,
  ];

  static const colorizeTextStyle = TextStyle(
    fontSize: 50.0,
    fontFamily: 'Horizon',
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(children: <Widget>[
              Flexible(
                child: Opacity(
                  opacity: 0.6,
                  child: Container(
                    child: Image.asset(
                      'assets/images/download.jpg',
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Opacity( opacity:0.7,
                  child: TypewriterAnimatedTextKit(
                    text: ['CRIME LOGGER'],
                    textStyle: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ]),
            SizedBox(
              height: 48.0,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, ReportedCrimes.id);
              },
              child: Text("CRIMES",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                  shadowColor: Colors.black,
                  primary: Colors.lightGreenAccent,
                  elevation: 10,
                  padding: EdgeInsets.all(15),
                  side: BorderSide(color: Colors.white24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  )),
            ),
            SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
              child: Text('STREAMING LIVE CRIME MAP',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.pushNamed(context, Testing.id);
              },
              style: ElevatedButton.styleFrom(
                  shadowColor: Colors.black,
                  primary: Colors.lightGreenAccent,
                  elevation: 10,
                  padding: EdgeInsets.all(15),
                  side: BorderSide(color: Colors.white24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  )),
            ),
            SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
              child: Text('SIGN OUT',
                  style: TextStyle(  // Colors.lightBlueAccent
                      color: Colors.black, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(shadowColor: Colors.black,primary:  Colors.lightGreenAccent,
                  elevation: 10,padding: EdgeInsets.all(15),side:BorderSide(color:Colors.white24 ), shape:RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ) ),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, UserScreen.id);
                //Navigator.pushNamed(context, FetchData.id);
              },),

          ],
        ),
      ),
    );
  }
}
