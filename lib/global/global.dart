import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? sharedPreferences;
FirebaseAuth firebaseAuth = FirebaseAuth.instance;

Position? position;
List<Placemark>? placeMarks;
String completeAddress="";

String perParcelDeliveryAmount="";
String previousEarnings = ""; //it is seller old total earnings
String previousRiderEarnings = ""; //it is rider old total earnings

// double perParcelDeliveryAmount= 0;
// double previousEarnings = 0; //it is seller old total earnings
// double previousRiderEarnings = 0; //it is rider old total earnings