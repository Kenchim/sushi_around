import 'dart:async';
import 'dart:ffi';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sushi_around/item_list.dart';
import 'place_id.dart';

class Searching extends StatefulWidget {
  @override
  State<Searching> createState() => SearchingState();
}

class SearchingState extends State<Searching> {
  late GoogleMapController _controller;
  late LatLng currentPositionPosition;

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(35.681663145302956, 139.7659165341655),
    zoom: 1);

  late final CameraPosition currentPosition;
  Future<void> getCurrentPosition() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
      if(permission == LocationPermission.denied){
      return Future.error("Cannot get your current location");
    }
  }
  final Position _currentPosition = await Geolocator.getCurrentPosition();
  currentPosition = CameraPosition(target: LatLng(_currentPosition.latitude, _currentPosition.longitude), zoom: 15);
  currentPositionPosition = LatLng(_currentPosition.latitude, _currentPosition.longitude);
  }

  Set<Marker>? _markers;

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [

        Scaffold(
          body: GoogleMap(
            markers: _markers!,
            initialCameraPosition: _initialPosition,
            onMapCreated: (GoogleMapController controller) async {
              await getCurrentPosition();
              if(currentPosition != null){
                Timer(const Duration(seconds: 5), (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>
                ItemList(currentPositionPosition)));
              });
              }
              
              _controller = controller;
              _controller.animateCamera(CameraUpdate.newCameraPosition(currentPosition));
            },
            myLocationButtonEnabled: false,
            myLocationEnabled: true,
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.black.withOpacity(0.5),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: DefaultTextStyle(
              style: const TextStyle(
                fontSize: 16.0,
                color: Color(0xfff9f9f9),
                fontFamily: "Comfortaa",
                fontWeight: FontWeight.normal,
              ),
              child: AnimatedTextKit(
              animatedTexts: [
                FadeAnimatedText('Searching...'),
              ],
              repeatForever: true,
              ),
            ),
            ),
            SizedBox(height: 30, width: MediaQuery.of(context).size.width,)
          ]
        ),
        ],
    );
  }

}