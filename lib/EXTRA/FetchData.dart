import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FetchData extends StatefulWidget {
  static const String id = 'FetchData';
  LatLng l=LatLng(10, 10);
  FetchData.withLatLng(LatLng? ll)
  {
    l=ll!;
  }
  FetchData()
  {

  }
  @override
  State<FetchData> createState() => _FetchDataState();
}

class _FetchDataState extends State<FetchData> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Container(
            child: ElevatedButton(
              child: Text('clickme'),
              onPressed: () async {
                int count = 0;

                User? user = await FirebaseAuth.instance.currentUser;
                print(user);
                if (user != null) {
                  try {
                    String s = await user.uid;
                    CollectionReference? users =
                    await FirebaseFirestore.instance.collection('LatLng');



                    DocumentReference dr = await FirebaseFirestore.instance
                        .collection('LatLng')
                        .doc(s);
                    var currentUser = await user.email;
                    await dr.get().then((DocumentSnapshot ds) {
                      print("HELLO Try LOOP");
                      if (ds.exists) {
                        print("Yo");
                        if ((ds.data() as Map<String, dynamic>)
                            .containsKey('Count')) count = ds['Count'];
                        print(count);
                      }
                    });

                    if ( count == 0) {
                      count = count + 1;
                      users.doc(s).set({
                        'Count': 1,
                        'Positive Votes $count': 10,
                        'Negative Votes $count': 18,
                        'isMe':true,
                        'Sender': currentUser,
                        'Experience $count': "BAD",
                        'Timestamp $count':Timestamp.now(),
                        'LatLng $count': GeoPoint(widget.l.latitude,widget.l.longitude),
                      });
                    } else {
                      count = count + 1;
                      print("Updating");
                      users.doc(s).update({
                        'Count': count,
                      });
                      print("settinG");
                      users.doc(s).update({
                        'Positive Votes $count': 10,
                        'isMe':true,
                        'Sender': currentUser,
                         'Experience $count': "BAD",
                        'Negative Votes $count': 18,
                        'Timestamp $count':Timestamp.now(),
                        'LatLng $count': GeoPoint(widget.l.latitude,widget.l.longitude),
                      });
                    }
                  } catch (e) {
                    print(e);
                  }
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

//  FirebaseFirestore.instance.collection('LatLng').get().then((QuerySnapshot querySnapshot) {
//           querySnapshot.docs.forEach((doc) {
//             count = doc["count"];});
//         });
