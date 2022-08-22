import 'dart:math';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crimelogger/EXTRA/FetchData.dart';
import 'package:crimelogger/EXTRA/INSERTION.dart';
import 'package:crimelogger/NewMapScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';



class Testing extends StatefulWidget {
  static const String id = 'Testing';
  const Testing({Key? key}) : super(key: key);

  @override
  State<Testing> createState() => _TestingState();
}

class _TestingState extends State<Testing> {
  @override

  Widget build(BuildContext context) {
    return Container(
        child: StreamBuilder<QuerySnapshot>(
            stream:   FirebaseFirestore.instance.collection('DataLog').snapshots(),
            builder: (BuildContext buildContext,
                AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.lightBlueAccent,
                  ),
                );
              }
              List<GeoPoint> storedata = [];
              print(" BUILD TESTING IS CALLED");
              Set<Marker> mark={};
              QuerySnapshot? d = snapshot.data;
              int i = 0;
              if (d != null) {
                for (var CurrentData in d.docs) {
                  //for (int i = 1; i <= CurrentData['Count']; i++) {
                  //  var NegativeVotes = CurrentData['Negative Votes $i'];
                  // var PositiveVotes = CurrentData['Positive Votes $i'];
                  print("HELLO GUYS I M INSDIE FOR LOOP");
                  String Experience = CurrentData['Experience'];
                  // print(PositiveVotes);

                  GeoPoint g = CurrentData['LatLng'];
                 // storedata.add(g);
                  //}
                  mark.add(Marker(markerId: MarkerId(i.toString()),

                      position: LatLng(g.latitude, g.longitude),
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueRed),
                      infoWindow: InfoWindow(
                          title: "CRIME SCENE", snippet: Experience)
                  ));
                  i++;
                }
               // return MapScreen.withGeoPoint(storedata);
return NewMapScreen.withSet(mark);
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.lightBlueAccent,
                  ),
                );
              }
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.lightBlueAccent,
                ),
              );
            }
            ));
  }
}
