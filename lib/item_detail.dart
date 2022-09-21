import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sushi_around/config.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';

class ItemDetail extends StatefulWidget {
  const ItemDetail(this.shopInfoList, this.currentPositionPosition, {Key? key}) : super(key: key);
  final shopInfoList;
  final LatLng currentPositionPosition;

  @override
  State<ItemDetail> createState() => _ItemDetailState(shopInfoList, currentPositionPosition);
}

class _ItemDetailState extends State<ItemDetail> {
  final shopInfoList;
  _ItemDetailState(this.shopInfoList, this.currentPositionPosition);
  LatLng currentPositionPosition;
  late GoogleMapController _controller;
  BitmapDescriptor? customIconOpen;
  BitmapDescriptor? customIconClose;
  createMarkerOpen(context){
      if(customIconOpen == null){
        ImageConfiguration configuration = createLocalImageConfiguration(context);
        BitmapDescriptor.fromAssetImage(configuration, "images/marker_red.png")
        .then((iconOpen){
          setState(() {
            customIconOpen = iconOpen;
          });
        });
      }
    }
    createMarkerClosed(context){
      if(customIconOpen == null){
        ImageConfiguration configuration = createLocalImageConfiguration(context);
        BitmapDescriptor.fromAssetImage(configuration, "images/marker_grey.png")
        .then((iconClosed){
          setState(() {
            customIconClose = iconClosed;
          });
        });
      }
    }
  
  @override
  Widget build(BuildContext context) {
    createMarkerClosed(context);
    createMarkerOpen(context);
    final _mapHeigt = MediaQuery.of(context).size.height * 0.3;
    final Set<Marker> _marker = {
      Marker(
        markerId: const MarkerId("0"),
        position: shopInfoList.latLng,
        icon: shopInfoList.openNow == true ? customIconOpen! : customIconClose!
        )
    };
    double distance = Geolocator.distanceBetween(
                                      currentPositionPosition.latitude, 
                                      currentPositionPosition.longitude, 
                                      shopInfoList.lat, 
                                      shopInfoList.lng);

    return Scaffold(
      backgroundColor: Color(0xffFFF9E2),
      appBar: AppBar(
        title: Text("Information"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: _mapHeigt,
              child : GoogleMap(
                markers: _marker,
                initialCameraPosition: CameraPosition(target: currentPositionPosition,zoom: 14.4),
                onMapCreated: (GoogleMapController controller){
                  _controller = controller;
                },
                myLocationEnabled: true,
          ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Text("${shopInfoList.name}", style: TextStyle(fontSize: 24),),
                  ),
                  SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:4.0),
                    child: 
                    
                    shopInfoList.openNow == true
                      ? Container(
                        decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color:Color(0xffFF7368),
                      ),
                        padding: EdgeInsets.symmetric(horizontal:8, vertical: 3),
                        child: Text("open now !", style: TextStyle(color:Colors.white),))
                      : Container(
                        decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color:Color(0xff999999),
                      ),
                        padding: EdgeInsets.symmetric(horizontal:8, vertical: 3),
                        child: Text("closed now", style: TextStyle(color:Colors.white),)),
                    ),
                  SizedBox(height: 8),
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Color(0xffD6D6D6),
                      ),
                      borderRadius: BorderRadius.circular(6)
                    ),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal:14.0, vertical: 10),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 4,bottom: 4.0),
                              child: Row(children: [
                                Icon(Icons.directions_walk, color: Color(0xff999999),size: 28,),
                                SizedBox(width: 4),
                                Padding(
                                  padding: const EdgeInsets.only(top:4.0,),
                                  child: Text(
                                    "${distance.toStringAsFixed(0)}m from you",style: TextStyle(fontSize: 24),),
                                )
                              ],),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical:4.0),
                              child: Row(children: [
                                Icon(Icons.place, color: Color(0xff999999),),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text("${shopInfoList.address}")),
                              ],),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical:4.0),
                              child: Row(children: [
                                Icon(Icons.access_time, color: Color(0xff999999),),
                                SizedBox(width: 8),
                                shopInfoList.openHour == null
                                ? Text("---")
                                : Expanded(
                                    child: Text("${shopInfoList.openHour}"))
                              ],),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical:4.0),
                              child: Row(children: [
                                Icon(Icons.phone, color: Color(0xff999999),),
                                SizedBox(width: 8),
                                shopInfoList.phoneNumber == null 
                                ? Text("---") 
                                : GestureDetector(
                                  child: Text("${shopInfoList.phoneNumber}",
                                  style: TextStyle(decoration: TextDecoration.underline)),
                                  onTap: () async {
                                    final phoneNumberUri = Uri(
                                      scheme: 'tel',
                                      path: shopInfoList.phoneNumber,
                                    );
                                    if(await canLaunchUrl(phoneNumberUri)){
                                      await launchUrl(phoneNumberUri);
                                    }
                                  },)
                              ],),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical:4.0),
                              child: Row(children: [
                                Icon(Icons.public, color: Color(0xff999999),),
                                SizedBox(width: 8),
                                shopInfoList.website == null 
                                ? Text("---") 
                                : Expanded(child: GestureDetector(
                                  onTap: () async {
                                    final Uri websiteUrl = Uri.parse(shopInfoList.website);
                                    if(await canLaunchUrl(websiteUrl)){
                                      await launchUrl(websiteUrl);
                                    }
                                  },
                                  child: Text("${shopInfoList.website}", 
                                  style: TextStyle(decoration: TextDecoration.underline),)))
                              ],),
                            )
                          ],
                        ),
                      ),
                    )
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)
                          ),
                          primary: Color(0xff2A92F2),
                          elevation: 3
                        ),
                        onPressed: (){MapUtils.openMap(shopInfoList.placeId);}, 
                        child: const Text("open with Google Maps",style: TextStyle(color: Color(0xfff0f0f0)),)),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  SizedBox(height: 16,),
                  for(var i=0; i < shopInfoList.photos.length;i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network("https://maps.googleapis.com/maps/api/place/photo?maxwidth=300&photo_reference=${shopInfoList.photos[i]["photo_reference"]}&key=${API_KEY}",width: MediaQuery.of(context).size.width,fit: BoxFit.cover,
                      errorBuilder: ((context, error, stackTrace) {
                              return ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: 
                      const Image(
                        image: AssetImage("images/connection_error.png"), width:double.infinity,fit: BoxFit.cover,)
                      );
                            }))),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

  }
}


class MapUtils {
  MapUtils._();
  static Future<void> openMap(placeId) async {
    Uri googleUrl = Uri(
    scheme: 'https',
    host: 'www.google.com',
    path: '/maps/search/',
    queryParameters: {'api': '1', 'query': 'Google', 'query_place_id': '$placeId'});
    if (await canLaunchUrl(googleUrl)) {
      await launchUrl(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }
}

