import 'dart:math';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import 'package:crimelogger/EXTRA/FetchData.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart' as G;
import 'package:location/location.dart';
class MapPoint extends StatefulWidget {
  LatLng l = LatLng(10, 10);
  String desc = "GOOD";
  MapPoint.withCoordinates(GeoPoint ll, String d) {
    print("map point constructor");
    l = LatLng(ll.latitude, ll.longitude);
    desc = d;
    print("map point constructor leaving");
  }

  @override
  State<MapPoint> createState() => _MapPointState();
}

class _MapPointState extends State<MapPoint> {
  MapType mT = MapType.normal;
  Set<Marker> _mark = {};
  double lat = 10;
  double lon = 10;
  bool ready = false;
  Color cl = Colors.grey;
  String description = "HELLO";
  GoogleMapController? mapController;
  @override
  initState() {
    super.initState();
    description = widget.desc;
  }
  @override
  dispose() {
    mapController!.dispose(); // you need this
    super.dispose();
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    print("oNMAP IS CALLED");
    await getCurrentLocation(0);
    setState(() {
      mapController!.moveCamera(CameraUpdate.newLatLng(LatLng(lat, lon)));
      ready = true;
      cl = Colors.green;
      UpdateUI();
    });
  }

  void UpdateUI() {
    setState(() {
      _mark.clear();
      _mark.add(Marker(
          markerId: const MarkerId("abc"),
          position: LatLng(widget.l.latitude, widget.l.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: InfoWindow(title: "CRIME SCENE", snippet: description)));
      _mark.add(Marker(
          markerId: const MarkerId("abcc"),
          position: LatLng(lat, lon),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
          infoWindow: InfoWindow(title: "YOUR LOCATION")));
    });
  }


  Future<int> getCurrentLocation(int x) async {
    G.LocationPermission permission;
    bool _serviceEnabled = await Location().serviceEnabled();
    if (!_serviceEnabled) {
      bool _serviceEnabled = await Location().requestService();
    }
    permission = await G.Geolocator.checkPermission();
    if (permission == G.LocationPermission.denied) {
      permission = await G.Geolocator.requestPermission();
      if (permission == G.LocationPermission.denied) {
        permission = await G.Geolocator.requestPermission();
      }
    }

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
      try {
        p = await G.Geolocator.getCurrentPosition(
            desiredAccuracy: G.LocationAccuracy.high,
            forceAndroidLocationManager: true,
            timeLimit: Duration(seconds: 5));
      }
      catch (e) {
        print(e);
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

  void RefreshMap() async {
    await getCurrentLocation(1);
    UpdateUI();
    mapController!.moveCamera(CameraUpdate.newLatLng(LatLng(lat, lon)));
    ready=true;
  }

  void changeMap() {
    setState(() {
      mT = mT == MapType.normal ? MapType.satellite : MapType.normal;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("BUILD mappoint IS CALLED");
    return Column(
      children: [
        Expanded(
          child: Container(
            // or put height width factor ! but why?
            child: GoogleMap(
              myLocationEnabled: true,
              initialCameraPosition:
                  CameraPosition(target: LatLng(lat, lon), zoom: 10),
              mapType: mT,
              onMapCreated: _onMapCreated,
              markers: _mark,
              myLocationButtonEnabled: true,
              zoomControlsEnabled: true,
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
                onPressed: ()
                {
               RefreshMap();
                },
                backgroundColor: ready ? Colors.green : Colors.grey,
                child: const Icon(Icons.map, size: 10.0),
              ),
            )
          ],
        )
      ],
    );
  }
}
