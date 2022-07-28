import 'package:crimelogger/User.dart';
import 'CustomIcon.dart';
import 'package:flutter/material.dart';
import 'MapScreen.dart';
class FirstSplash extends StatelessWidget {
  static const String id = 'FirstSplash';
  @override
  Widget build(BuildContext context) {
    //Future.delayed(Duration(seconds: 5),
            //(){
          //Navigator.push(context, MaterialPageRoute(builder: (context)=> UserScreen()));

            //  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> UserScreen()));
      //  }
   // );
    return SafeArea(
      child: Container(
          color: Colors.white,
          alignment: Alignment.center,
          child: GestureDetector(child: CustomIcon(size: 200, color: Colors.lightGreenAccent, str: 'a'),onTap: ()
            {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> UserScreen()));
              //Navigator.push(context, MaterialPageRoute(builder: (context)=> UserScreen()));
            },)),
    );
  }
}
class CONT extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: MapScreen(),
      height: MediaQuery.of(context).size.height * 0.9,
      width: MediaQuery.of(context).size.width * 1,
    );
  }
}