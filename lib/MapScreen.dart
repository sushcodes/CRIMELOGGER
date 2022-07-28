import 'dart:math';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crimelogger/FetchData.dart';
import 'package:crimelogger/INSERTION.dart';
import 'package:crimelogger/NewMapScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatefulWidget {
  static const String id = 'MapScreen';
  List<GeoPoint>? ll;
  bool list=false;

  MapScreen.withGeoPoint(List<GeoPoint>? l) {
    if (l != null) {
      ll = l;
      print(l.length);
    }

    print("CONSTRUCTOR OF MAPSCEEN ROOT IS CALLED");
  }

  MapScreen() {
    print("HELLO");
  }

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  MapType mT = MapType.normal;
  Set<Marker> _mark = {};
  double lat = 20;
  double lon = 20;
  bool ready = false;
  Color cl = Colors.grey;
  GoogleMapController? mapController;
  @override
  void initState() {
    super.initState();
    print("CONSTRUCTOR OF CHILD MAPSCREEN IS CALLED");
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {

    mapController = controller;
    print("CONTROLLER IS CALLED");
    await getCurrentLocation(0);
    setState(() {
      mapController!.moveCamera(CameraUpdate.newLatLng(LatLng(lat, lon)));
      ready = true;
      cl = Colors.green;
      UpdateUI();
    });
  }

  void UpdateUI() async {
    setState(() {
      Set<Marker> m = {};
      m.add(Marker(
          markerId: const MarkerId("abc"),
          position: LatLng(lat, lon),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
          infoWindow: const InfoWindow(title: "YOUR LOCATION")));

      if (widget.ll != null)
        for (int i = 0; i < widget.ll!.length; i++) {
          LatLng po = LatLng(widget.ll!.elementAt(i).latitude,
              widget.ll!.elementAt(i).longitude);

          m.add(Marker(onTap: ()
              {

              },
              markerId: MarkerId(i.toString()),
              position: po,
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueRed),
              infoWindow: const InfoWindow(title: "CRIME")));
        }
      _mark = m;
    });
  }

  void Refresh()
  async
  {
    await getCurrentLocation(1);
    if (ready == true) {
      mapController!.moveCamera(CameraUpdate.newLatLng(LatLng(lat, lon)));
      UpdateUI();
    }
  }

  Future<int> getCurrentLocation(int x) async {
    LocationPermission permission;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      //print("DENIED");
      return x;
    }
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best,
          forceAndroidLocationManager: true);
      lat = position.latitude;
      lon = position.longitude;
    } catch (e) {}
    return x;
  }

  void changeMap() {
    setState(() {
      mT = mT == MapType.normal ? MapType.satellite : MapType.normal;
    });
  }

  void onPressed(LatLng l) {
    print(l.longitude);
    print(l.latitude);
    Timestamp t=Timestamp.now();
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: 100,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                child: Text('Report Crime'),
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => new Insertion.withValues(l, t))
                  );

                },
              ),
            ),
          );
        });
  }

// note in stream only build method is called
  Widget build(BuildContext context) {
    print("BUILD IS CALLED");
    UpdateUI();
    return Column(
      children: [
        Expanded(
          //
          child: Container(
            // or put height width factor ! but why?
            child: GoogleMap(
              myLocationEnabled: true,
              initialCameraPosition:
              CameraPosition(target: LatLng(10, 10), zoom: 10),
              mapType: mT,
              onMapCreated: _onMapCreated,
              markers: _mark,
              myLocationButtonEnabled: true,
              zoomControlsEnabled: true,
              onTap: onPressed,
              onLongPress: onPressed,
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: FloatingActionButton(
                onPressed: changeMap,
                backgroundColor: Colors.green,
                child: const Icon(Icons.map, size: 10.0),
              ),
            ),
            Expanded(
                child: FloatingActionButton(
                  onPressed: Refresh,
                  backgroundColor: cl,
                  child: const Icon(Icons.add_circle_outline, size: 10),
                )),
          ],
        )
      ],
    );
  }
}

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
