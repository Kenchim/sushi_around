import 'dart:async';
import 'dart:ffi';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sushi_around/item_list.dart';
import 'package:url_launcher/url_launcher.dart';
import 'home.dart';
import 'place_id.dart';
import 'package:permission_handler/permission_handler.dart';
bool startSearchingmsg = false;
bool startSearching = false;
bool settingsPopup = false;

// checkPermission() async {
//   LocationPermission initPermission = await Geolocator.checkPermission();
//   if(initPermission == LocationPermission.always || initPermission == LocationPermission.whileInUse){
//     print("はろー");
//     warningVisible = false;
//     print(warningVisible);
//   } else{
//    print("はろーdaaaaaa");
//     warningVisible = true;
//   }
//   return warningVisible;
// }

class Searching extends StatefulWidget {
  Searching(bool warningVisible);

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
      setState(() {
        settingsPopup = false;
        print("${permission}はろー１");
      });
      if(permission == LocationPermission.denied){
      setState(() {
        settingsPopup = true;
        print("はろー2");
      });
      return Future.error("Cannot get your current location");
    }
  }
  if (permission == LocationPermission.deniedForever) {
    setState(() {
        settingsPopup = true;
        print("はろー3");
      });
    return Future.error(
      'Location permissions are permanently denied, we cannot request permissions.');
  } print("はろー4");
  startSearchingmsg = true;
  final Position _currentPosition = await Geolocator.getCurrentPosition();
  currentPosition = CameraPosition(target: LatLng(_currentPosition.latitude, _currentPosition.longitude), zoom: 15);
  currentPositionPosition = LatLng(_currentPosition.latitude, _currentPosition.longitude);
  }

  Set<Marker>? _markers;

  @override
  void initState(){
    super.initState();
    //checkPermission();
    _markers = Set.from([]);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [

        Scaffold(
          body: warningVisible == true ? Container()
          : GoogleMap(
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
        Visibility(
          visible: warningVisible,
          child: Center(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.50,
              width: MediaQuery.of(context).size.width * 0.86,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color:Color(0xffFFF9E2),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(40, 40, 40, 12),
                      child: Text("Please choose the setting of your device location on following popup.",
                      style: TextStyle(
                        fontFamily: "Comfortaa",
                        height: 1.4,
                        decoration: TextDecoration.none,
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 18),),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(40, 0, 40, 20),
                      child: Text("Sushi Around collects location data to enable identification of nearby sushi spots.",
                      style: TextStyle(
                        fontFamily: "Comfortaa",
                        height: 1.4,
                        decoration: TextDecoration.none,
                        color: Color(0xff666666),
                        fontWeight: FontWeight.normal,
                        fontSize: 14),),
                    ),
                    Image(image: AssetImage("images/logo_pd.png"),width: 90,),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical:24.0),
                      child: Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:Color(0xffFF7D33),
                            foregroundColor: Colors.white, 
                          ),
                          child: Text('OK',style: TextStyle(fontFamily: "Comfortaa", fontSize: 16),),
                          onPressed: () {
                            setState(() {
                              warningVisible = false;
                              startSearching = true;
                            });
                          },
                          ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: GestureDetector(
                          onTap: () async {
                            final Uri websiteUrl = Uri.parse("https://sushi-tech.com/privacy-sushiaround/");
                            if(await canLaunchUrl(websiteUrl)){
                              await launchUrl(websiteUrl);
                            }
                          },
                          child: Text("Privacy Policy", 
                          style: TextStyle(
                            fontFamily: "Comfortaa",
                            fontSize: 16,
                            color: Color(0xffd8d8d8d),
                            decoration: TextDecoration.underline,
                            decorationThickness: 1,
                            decorationStyle: TextDecorationStyle.solid,
                            decorationColor:Color(0xff666666), ),)),
                    ),
                    
                  ],
                ),
              ),
            ),
          ),
        ),
        Visibility(
          visible: settingsPopup,
          child: Center(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.36,
              width: MediaQuery.of(context).size.width * 0.86,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color:Color(0xffFFF9E2),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(40, 40, 40, 12),
                      child: Text("To enjoy this app, you need to allow this device to collect location data.",
                      style: TextStyle(
                        fontFamily: "Comfortaa",
                        height: 1.4,
                        decoration: TextDecoration.none,
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 18),),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical:24.0),
                      child: Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:Color(0xffFF7D33),
                            foregroundColor: Colors.white, 
                          ),
                          child: Text('Go to Settings',style: TextStyle(fontFamily: "Comfortaa", fontSize: 16),),
                          onPressed: () {
                            setState(() {
                              settingsPopup = true;
                            });
                            AppSettings.openAppSettings();
                            SystemNavigator.pop();
                            } 
                          ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: GestureDetector(
                          onTap: () async {
                            final Uri websiteUrl = Uri.parse("https://sushi-tech.com/privacy-sushiaround/");
                            if(await canLaunchUrl(websiteUrl)){
                              await launchUrl(websiteUrl);
                            }
                          },
                          child: Text("Privacy Policy", 
                          style: TextStyle(
                            fontFamily: "Comfortaa",
                            fontSize: 16,
                            color: Color(0xffd8d8d8d),
                            decoration: TextDecoration.underline,
                            decorationThickness: 1,
                            decorationStyle: TextDecorationStyle.solid,
                            decorationColor:Color(0xff666666), ),)),
                    ),
                    
                  ],
                ),
              ),
            ),
          ),
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
              child: 
              visible == true ? Container()
              : startSearchingmsg == false ? Container()
              : AnimatedTextKit(
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
