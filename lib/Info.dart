import 'package:cloud_firestore/cloud_firestore.dart';

class Info
{
  GeoPoint? g;
  int? positivevotes;
  int? negativevotes;

  Info({required GeoPoint ll,required int positive,required int negative , })
  {
   g=ll;
   positivevotes=positive;
   negativevotes=negative;
  }


}


