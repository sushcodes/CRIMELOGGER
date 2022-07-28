import 'package:flutter/material.dart';
class CustomIcon extends StatelessWidget {
  Color? color;
  double? size;
  String? iconname;
  CustomIcon({Color? color, double? size, String? str}) {
    this.color = color;
    this.size = size;
    iconname = str;
  }
  Widget build(BuildContext context) {
    return Text(
      iconname.toString(),
      style: TextStyle(color: color, fontSize: size, fontFamily: 'orilla'),
    );
  }
}