import 'MapPoint.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class ReportedCrimes extends StatefulWidget {
  static const String id = 'ReportedCrimes';
  @override
  State<ReportedCrimes> createState() => _ReportedCrimesState();
}

class _ReportedCrimesState extends State<ReportedCrimes> {
  final TextController = TextEditingController();
  var currentUser;
  String? Description;

  void initState() {
    // TODO: implement initState
    // currentUser = FirebaseAuth.instance.currentUser;
    // if (currentUser == null) {
    //  Navigator.pop(context);
    //}
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: DataStream(),
        ),
      ),
    );
  }
}

class DataStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      // .orderBy('Timestamp',descending: false)
      stream: FirebaseFirestore.instance
          .collection('DataLog')
          .orderBy('TimeStamp')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        if (snapshot.hasError) print(snapshot.error);
        final snap = snapshot.data;

        List<Showcase> bigList = [];
        bigList.clear();
        List lt = snap!.docs;
        // print(lt);
        try {
          print("INSIDE TRY CATCH");
          for (var data in snap.docs.reversed) {
            // for (int i = 1; i <= data['Count']; i++) {
            //print("INSDIER");
            final experience = data['Experience'];
            final sender = data['Sender'];
            var currentUser = FirebaseAuth.instance.currentUser!.email;
            GeoPoint l = GeoPoint(data['LatLng'].latitude,data['LatLng'].longitude);
            Timestamp? t = data['TimeStamp'];
            //print(experience);
            print('INSIDE FOR LOOP MAKING showcase objects'+Timestamp.now().toDate().toString());
            var littleElement = new Showcase(
                Sender: sender,
                Experience: experience,
                g: l,
                isMe: currentUser == sender,
                Timest: t);
            bigList.add(littleElement);
            // }
          }
          print('FOR LOOP COMPLETE'+Timestamp.now().toDate().toString());

          return ListView(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: bigList,
          );
        } catch (e) {
          print(e);
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
      },
    );
  }
}

class Showcase extends StatefulWidget {
  String? country = "";
  String? locality = "";
  String? administrativearea = "";
   String? Sender;
   String? Experience;
   bool? isMe;
   GeoPoint? g;
 Timestamp? Timest;
  Showcase({this.Sender, this.Experience, this.isMe, this.g, this.Timest})
  {
    print("SHowcase CONSTRUCTOR IS CALLED"+Timestamp.now().toDate().toString());

    print("SHowcase CONSTRUCTOR exit"+Timestamp.now().toDate().toString());
  }
  Future<void> compute() async {
    print("INSIDE COMPUTE"+Timestamp.now().toDate().toString());
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          g!.latitude, g!.longitude, localeIdentifier: "en");
      print("placemarks received"+Timestamp.now().toDate().toString());
      print(placemarks);
      country = placemarks.last.country;
      locality = placemarks.last.locality;
      administrativearea = placemarks.last.administrativeArea;
      print("leaving compute"+Timestamp.now().toDate().toString());
    }
    catch (e) {
      print(e);
    }
  }
  @override
  State<Showcase> createState() {
    print("createState is called"+Timestamp.now().toDate().toString());
    return _ShowcaseState();
  }
}

class _ShowcaseState extends State<Showcase> {
  void update()
 async{   print("Update is CALLED"+Timestamp.now().toDate().toString());
 List<Placemark> placemarks = await placemarkFromCoordinates(
     widget.g!.latitude, widget.g!.longitude, localeIdentifier: "en");
 print("placemarks received in update"+Timestamp.now().toDate().toString());
       setState((){
         print("set State invoked"+Timestamp.now().toDate().toString());
         widget.country = placemarks.last.country;
         widget.locality = placemarks.last.locality;
         widget.administrativearea = placemarks.last.administrativeArea;
         print("Set State Closingin"+Timestamp.now().toDate().toString());
       });
 print("Update exiting"+Timestamp.now().toDate().toString());
  }
  void initState() {
    print("INIT STATE IS CALLED"+Timestamp.now().toDate().toString());
    super.initState();
    update();
   // Future.delayed(Duration(seconds: 10),
      //  (){
       //   print("INIT FUTURE DELAYED IS CALLED"+Timestamp.now().toDate().toString());
      // setState((){widget.compute();});
        //  print("INIT FUTURE DELAYED IS EXIT"+Timestamp.now().toDate().toString());
   // });
  }
  @override
  Widget build(BuildContext context) {
    print("Build is called"+Timestamp.now().toDate().toString());
    return Container(
      color: Colors.white,
      child: ElevatedButton(
        onPressed: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MapPoint.withCoordinates(
                      widget.g!, widget.Experience!)));
        },
        style: ElevatedButton.styleFrom(
            shadowColor: Colors.black,
            primary: Colors.lightBlueAccent,
            elevation: 30,
            padding: EdgeInsets.only(top: 10,bottom: 10),
            side: BorderSide(color: Colors.white),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            )),
        child: Container(margin: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(padding: EdgeInsets.only(top: 10),
                child: Text(
                  '${widget.Experience}',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
              SizedBox(height: 5),
              Container(padding: EdgeInsets.only(top: 10),
                child: Text('${widget.Timest!.toDate().toString().substring(0,10)}     ${widget.Timest!.toDate().toString().substring(10,16)} ',
                    style: TextStyle(color: Colors.black, fontSize: 20)),
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Text(widget.country!,
                      style: TextStyle(color: Colors.black, fontSize: 20)),
                  SizedBox(width: 5,),
                  Text(widget.locality!,
                      style: TextStyle(color: Colors.black, fontSize: 20)),
                ],
              ),
              SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }
}
//Material(
//             borderRadius: isMe!
//                 ? BorderRadius.only(
//                 topLeft: Radius.circular(30.0),
//                 bottomLeft: Radius.circular(30.0),
//                 bottomRight: Radius.circular(30.0))
//                 : BorderRadius.only(
//               bottomLeft: Radius.circular(30.0),
//               bottomRight: Radius.circular(30.0),
//               topRight: Radius.circular(30.0),
//             ),
//             elevation: 5.0,
//             color: isMe! ? Colors.lightGreenAccent : Colors.white,
//             child: Padding(
//               padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
//               child: Text(
//                 Experience!,
//                 style: TextStyle(
//                   color: isMe! ? Colors.white : Colors.black54,
//                   fontSize: 15.0,
//                 ),
//               )
//               ,
//             ),
//           ),
