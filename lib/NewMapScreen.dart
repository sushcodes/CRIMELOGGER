import 'dart:math';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crimelogger/EXTRA/FetchData.dart';
import 'package:crimelogger/EXTRA/INSERTION.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart' as G;
import 'package:location/location.dart';

class NewMapScreen extends StatefulWidget {
  Set<Marker> st = {};
  Set<Marker> _mark = {};
  NewMapScreen.withSet(Set<Marker> l) {
    st = l;
    print("Set Consrcutro is called");

    _mark.clear();
    _mark = l;
  }

  @override
  State<NewMapScreen> createState() {
    print("Create State is called");
    return _NewMapScreenState();
  }
}

class _NewMapScreenState extends State<NewMapScreen> {
  MapType mT = MapType.normal;

  double lat = 20;
  double lon = 20;
  bool ready = false;
  Color cl = Colors.grey;
  GoogleMapController? mapController;
  bool buildnow = false;
  void initState() {
    print("Inside Init State");
    super.initState();
    //getCurrentLocation(1);
    //Refresh();
    print("Leaving Init State");
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    print("INSIDE ONMAP");
    mapController = controller;
    print("CONTROLLER IS CALLED");
    //await getCurrentLocation(0);
    //ready=true;
    setState(() {
      // this set state doesnt wait for UI .
      mapController!.moveCamera(CameraUpdate.newLatLng(LatLng(lat, lon)));
      UpdateUI();
    });
    print("Leaving Onmap");
  }

  void UpdateUI() async {
    print("Inside UPDATE UI");
    int? i = await getCurrentLocation(1);
    setState(() {
      print("INSIDE SET STATE OF UPDATEUI");
      widget._mark = widget.st;
      widget._mark.add(Marker(
          markerId: MarkerId("abcd"),
          position: LatLng(lat, lon),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
          infoWindow: InfoWindow(title: "YOUR LOCATION")));
      ready = true;
      // mapController!.moveCamera(CameraUpdate.newLatLng(LatLng(lat, lon)));
      mapController!.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(lat, lon), zoom: 10)));
      if (i == null)
        cl = Colors.redAccent;
      else if (i == 1) {
        cl = Colors.purpleAccent;
      } else
        cl = Colors.green;
    });

    await Future.delayed(Duration(seconds: 5), () {
      setState(() {
        cl = Colors.brown;
      });
    });
  }

  void Refresh() {
    print("INSIDE REFRESH");
    //await getCurrentLocation(1);
    // if (ready == true) {
    mapController!.moveCamera(CameraUpdate.newLatLng(LatLng(lat, lon)));
    UpdateUI();
    // }
  }

  Future<int> getCurrentLocation(int x) async {
    G.LocationPermission permission;
    bool _serviceEnabled = await Location().serviceEnabled();
    if (!_serviceEnabled) {
      bool _serviceEnabled = await Location().requestService();
      setState(() {
        cl = Colors.lightBlue;
      });
    }
    permission = await G.Geolocator.checkPermission();
    if (permission == G.LocationPermission.denied) {
      permission = await G.Geolocator.requestPermission();
      if (permission == G.LocationPermission.denied) {
        permission = await G.Geolocator.requestPermission();
      }
    }
    setState(() {
      cl = Colors.tealAccent;
    });
    if (permission == G.LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      permission = await G.Geolocator.requestPermission();
    }
    setState(() {
      cl = Colors.purple;
    });
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    G.Position? p=null;
    try {
      p = await G.Geolocator.getCurrentPosition(
          desiredAccuracy: G.LocationAccuracy.high,
          timeLimit: Duration(seconds: 7));
      setState(() {
        cl = Colors.black;
      });
    }
    catch(e) {
      setState(() {
        cl = Colors.yellow;
      });
      try {
        p = await G.Geolocator.getCurrentPosition(
            desiredAccuracy: G.LocationAccuracy.high,
            forceAndroidLocationManager: true,
            timeLimit: Duration(seconds: 5));
      }
      catch (e) {
        print(e);
        setState(() {
          cl = Colors.white;
        });
      }
    }

    if (p != null) {
      lat = p.latitude;
      lon = p.longitude;
      return 2;
    }
    print("LEAVING GETCURRENTLOCATION");
    return 1;
  }

  void changeMap() {
    setState(() {
      mT = mT == MapType.normal ? MapType.satellite : MapType.normal;
    });
  }

  void onPressed(LatLng l) {
    print(l.longitude);
    print(l.latitude);
    Timestamp t = Timestamp.now();
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
                      MaterialPageRoute(
                          builder: (context) =>
                          new Insertion.withValues(l, t)));
                },
              ),
            ),
          );
        });
  }

// note in stream only build method is called
  Widget build(BuildContext context) {
    print("BUILD mapbuild IS CALLED");
    // UpdateUI();
    return Column(
      children: [
        Expanded(
          //
          child: Container(
            // or put height width factor ! but why?
            child: GoogleMap(
              myLocationEnabled: true,
              initialCameraPosition:
              CameraPosition(target: LatLng(lat, lon), zoom: 1),
              mapType: mT,
              onMapCreated: _onMapCreated,
              markers: widget._mark,
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
// as soon as onmap created is
