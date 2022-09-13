import 'package:google_maps_flutter/google_maps_flutter.dart';

class Information {
  String? name;
  bool? openNow;
  List? photos;
  LatLng? latLng;
  String? address;
  String? openHour;
  String? phoneNumber;
  String? url;

Information({
  this.name, this.openNow, this.photos, this.latLng, this.address,
  this.openHour, this.phoneNumber, this.url,
});
}