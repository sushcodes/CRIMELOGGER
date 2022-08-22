import 'package:crimelogger/EXTRA/FetchData.dart';
import 'package:crimelogger/ReportedCrimes.dart';
import 'package:crimelogger/Welcome.dart';
import 'package:flutter/material.dart';
import 'Testing.dart';
import 'package:firebase_core/firebase_core.dart';
import 'FirstSplash.dart';
import 'package:crimelogger/User.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo yo',
        initialRoute: FirstSplash.id,
        routes: {
          FirstSplash.id: (context) => FirstSplash(),
          Testing.id: (context) => Testing(),
          WelcomeScreen.id : (context) => WelcomeScreen(),
          UserScreen.id : (context) => UserScreen(),
          FetchData.id : (context) => FetchData(),
          ReportedCrimes.id : (context) => ReportedCrimes(),
        },
      home: SafeArea(
        // extendBodyBehindAppBar: true,
        child: FirstSplash(),
      ),
    );
  }
}






