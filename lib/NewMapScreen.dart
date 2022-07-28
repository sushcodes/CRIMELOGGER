import 'dart:math';
import 'dart:math';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crimelogger/FetchData.dart';
import 'package:crimelogger/INSERTION.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class NewMapScreen extends StatefulWidget {

  Set<Marker> st={};
  Set<Marker> _mark = {};
  NewMapScreen.withSet(Set<Marker> l)
  {
    st=l;
    print("Set Consrcutro is called");
    _mark=l;
  }

  @override
  State<NewMapScreen> createState()
  {
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
  bool buildnow=false;
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
      mapController!.moveCamera(CameraUpdate.newLatLng(LatLng(lat, lon)));
      cl = Colors.green;
      UpdateUI();
    });
    print("Leaving Onmap");
  }

  void UpdateUI() async {
    print("Inside UPDATE UI");
    await getCurrentLocation(1);
    mapController!.moveCamera(CameraUpdate.newLatLng(LatLng(lat, lon)));
    setState(() {
      print("INSIDE SET STATE OF UPDATEUI");
      widget._mark=widget.st;
      widget._mark.add(Marker(
          markerId: const MarkerId("abcd"),
          position: LatLng(lat, lon),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
          infoWindow: InfoWindow(title: "YOUR LOCATION")));
      ready = true;
    });
  }

  void Refresh()
  async
  {
    print("INSIDE REFRESH");
    await getCurrentLocation(1);
    //ready=true;
    if (ready == true) {
 //     mapController!.moveCamera(CameraUpdate.newLatLng(LatLng(lat, lon)));
      UpdateUI();
    }
  }

  Future<int> getCurrentLocation(int x) async {
      Location location = Location();
      print("INSDE GETCURRENTLOCATION");
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
      setState(() {
         if (_locationData != null) {
           lon=_locationData!.longitude!;
           lat=_locationData!.latitude!;
}

      });
return 1;
      print("LEAVING GETCURRENTLOCATION");
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
              CameraPosition(target: LatLng(10, 10), zoom: 10),
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
