import 'dart:math';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import 'package:crimelogger/FetchData.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

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
    Location location = Location();

    // Check if location service is enable
    bool _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      bool _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return 1;
      }
    }

    // Check if permission is granted
    PermissionStatus _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return 1;
      }
    }

    final _locationData = await location.getLocation();
      if (_locationData != null) {
        lon = _locationData!.longitude!;
        lat = _locationData!.latitude!;
      }
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
