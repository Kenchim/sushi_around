import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:sushi_around/config.dart';
import 'dart:convert';


class getGooglemapsItemInfo{
  String? name;
  bool? openNow;
  List? photos;
  LatLng? latLng;
  String? address;
  String? openHour;
  String? phoneNumber;
  String? website;
  String? placeId;
  double? lat;
  double? lng;

  getGooglemapsItemInfo({
  this.name, this.openNow, this.photos, this.latLng, this.address,
  this.openHour, this.phoneNumber, this.website, this.placeId, this.lat, this.lng
});

  static Future<getGooglemapsItemInfo> placeInfoFromPlaceId(placeId) async {
    String url = "https://maps.googleapis.com/maps/api/place/details/json?fields=name%2Cphotos%2Cformatted_phone_number%2Copening_hours%2Cwebsite%2Cformatted_address%2Cgeometry&place_id=${placeId}&key=${API_KEY}";
    List shopInfoList = [];
    DateTime now = DateTime.now();
    try{
      var result = await get(Uri.parse(url));
      Map<String, dynamic> data = jsonDecode(result.body);

      getGooglemapsItemInfo shopInfo = getGooglemapsItemInfo(
        latLng: LatLng(data['result']['geometry']['location']["lat"],data['result']['geometry']['location']["lng"]),
        lat: data['result']['geometry']['location']["lat"],
        lng: data['result']['geometry']['location']["lng"],
        name: data['result']['name'] ?? "",
        openNow: data['result']['opening_hours'] != null ? data['result']['opening_hours']['open_now']: null,
        photos: data['result']['photos'] ?? [],
        address: data['result']['formatted_address'],
        website: data['result']['website'],
        phoneNumber: data['result']['formatted_phone_number'],
        openHour: data['result']['opening_hours'] != null ? data['result']['opening_hours']['weekday_text'][now.weekday - 1]: null,
        placeId: placeId,

      );
      return shopInfo;

    } catch(e) {
      print(e);
      print("えらーだ");
      return null!;
    }
  }
}