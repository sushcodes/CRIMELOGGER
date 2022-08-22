import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crimelogger/EXTRA/FetchData.dart';
import 'package:crimelogger/ReportedCrimes.dart';
import 'package:crimelogger/Welcome.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../Testing.dart';
import 'package:firebase_core/firebase_core.dart';
import '../FirstSplash.dart';
import 'package:crimelogger/User.dart';
import '../MapPoint.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Insertion extends StatefulWidget {
 //   Map<int,String>={1:JANUARY};
  LatLng ll = LatLng(10, 10);
  Timestamp? timestamp;
  int? Month;
  int? day;
  int? time;
  String? Location;
  Insertion.withValues(LatLng l, Timestamp t) {
    ll = l;
    timestamp = t;
    Month = t.toDate().month;
    day = t.toDate().day;
    time = t.toDate().hour;
  }

  compute() async {
    print("INSIDE COMPUTE");
    List<Placemark> placemarks =
        await placemarkFromCoordinates(ll.latitude,ll.longitude);
    country = placemarks.last.country;
    locality = placemarks.last.locality;
    administrativearea = placemarks.last.administrativeArea;
    Location = country! + " " + locality! + " " + administrativearea!;
    print(Location);
    print("END COMPUTE");
  }

  String? country = "";
  String? locality = "";
  String? administrativearea = "";

  @override
  State<Insertion> createState() => _InsertionState();
}

class _InsertionState extends State<Insertion> {

  initState()
  {
    super.initState();
    setState(() {
      widget.compute();
    });
  }
  bool showSpinner=false;
  String input = "";
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
          child: Scaffold(
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 10,),
              Expanded(

                child: TextField(
                    decoration: InputDecoration(hintText: "ENTER DESCRIPTION"),
                    onChanged: (value) {
                      input = value;
                    }),
              ),
             ElevatedButton(
                  onPressed: () async {
                    setState(()
                        {
                          showSpinner=true;
                        }
                    );
                    CollectionReference? cr =
                        await FirebaseFirestore.instance.collection('DataLog');
                    User? user = await FirebaseAuth.instance.currentUser;
                    String uid = await user!.uid;
                    var currentUser = await user.email;
//await widget.compute();
print("INSIDE ADDER");
print(widget.ll.longitude);
                    cr
                        .add({
                          'LatLng': GeoPoint(widget.ll.latitude,
                              widget.ll.longitude), // John Doe
                          'Sender': currentUser, // Stokes and Sons
                          'Experience': input, // 42
                          'TimeStamp': Timestamp.now(),
                          'Location': widget.Location
                        })
                        .then((value) => print("User Added"))
                        .catchError(
                            (error) => print("Failed to add user: $error"));
                    setState(()
                    {
                      showSpinner=true;
                    }
                    );
                    Navigator.pop(context);
                  },
                  child: Text('CLICK TO SUBMIT')) ],
          ),
        ),
      )),
    );
  }
}
