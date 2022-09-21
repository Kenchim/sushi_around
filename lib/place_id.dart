import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:sushi_around/config.dart';

class getGooglemapsPlaceId{
  static Future<List> placeIdFromCurrentPosition(double lat, double lng) async {
    String url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?keyword=sushi&location=${lat}%2C${lng}&radius=300&type=restaurant&key=${API_KEY}";
    List placeIdList = [];
    try{
      var result = await get(Uri.parse(url));
      Map<String, dynamic> data = jsonDecode(result.body);
      for(var i = 0; i < data['results'].length; i++){
        var item = data["results"][i]["place_id"];
        placeIdList.add(item);
      }
      return placeIdList;
    } catch(e){
      print(e);
      return null!;
    }
  }
  }