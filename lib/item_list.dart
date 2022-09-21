import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_platform_interface/src/types/location.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:sushi_around/config.dart';
import 'package:sushi_around/item_detail.dart';
import 'searching.dart';
import 'place_id.dart';
import 'place_info.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:io';


bool visible = true;
int numberOpenList = 0;


class ItemList extends StatefulWidget {

  const ItemList(this.currentPositionPosition, {Key? key}) : super(key: key);
  final LatLng currentPositionPosition;

  @override
  State<ItemList> createState() => _ItemListState(currentPositionPosition);
}


class _ItemListState extends State<ItemList> {
  LatLng currentPositionPosition;
  _ItemListState(this.currentPositionPosition);

  @override
  Widget build(BuildContext context) {
    final panelHightClosed = MediaQuery.of(context).size.height * 0.4;
    final panelHightOpened = MediaQuery.of(context).size.height * 0.8;
    final PanelController panelController =  PanelController();
    return Scaffold(
      // sliding up panel wraps an original body
      body: SlidingUpPanel(
        controller: panelController,
        minHeight: panelHightClosed,
        maxHeight: panelHightOpened,
        parallaxEnabled: true,
        parallaxOffset: 0.3,
        body: MapResultView(currentPositionPosition),
        color:Color(0xffFFF9E2), 
        panelBuilder: (scontroller) => PanelWidget(
          scontroller: scontroller,
          currentPositionPosition: currentPositionPosition,
          panelController: panelController,
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
    );
  }
}

class MapResultView extends StatefulWidget {
  const MapResultView(this.currentPositionPosition, {Key? key}) : super(key: key);
  final LatLng currentPositionPosition;
  @override
  State<MapResultView> createState() => _MapResultViewState(currentPositionPosition);
}

class _MapResultViewState extends State<MapResultView> {
  _MapResultViewState(this.currentPositionPosition);
  LatLng currentPositionPosition;
  late GoogleMapController gcontroller;
  BitmapDescriptor? customIconOpen;
  BitmapDescriptor? customIconClose;
  createMarkerOpen(context){
      if(customIconOpen == null){
        ImageConfiguration configuration = createLocalImageConfiguration(context);
        BitmapDescriptor.fromAssetImage(configuration, redIconFile())
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
        BitmapDescriptor.fromAssetImage(configuration, greyIconFile())
        .then((iconClosed){
          setState(() {
            customIconClose = iconClosed;
          });
        });
      }
    }
  
  Set<Marker>? _markers;
  @override
  void initState(){
    super.initState();
    _markers = Set.from([]);
  }

  greyIconFile() {
  if (Platform.isAndroid) {
    double mq = MediaQuery.of(context).devicePixelRatio;
    String dirName = ''; // default for 1.0x
    if (mq > 1.5 && mq < 2.5) {
      dirName = "2.0x/";
    } else if (mq >= 2.5) {
      dirName = "3.0x/";
    }
    return 'images/' + dirName + 'marker_grey.png';
  }
  // this is for iOS
  return 'images/marker_grey.png';
}
redIconFile() {
  if (Platform.isAndroid) {
    double mq = MediaQuery.of(context).devicePixelRatio;
    String dirName = ''; // default for 1.0x
    if (mq > 1.5 && mq < 2.5) {
      dirName = "2.0x/";
    } else if (mq >= 2.5) {
      dirName = "3.0x/";
    }
    return 'images/' + dirName + 'marker_red.png';
  }
  // this is for iOS
  return 'images/marker_red.png';
}

  @override
  Widget build(BuildContext context) {
  final mapHeigt = MediaQuery.of(context).size.height * 0.8;
  createMarkerClosed(context);
  createMarkerOpen(context);
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Container(
          height: mapHeigt,
          child: GoogleMap(
            markers: _markers!,
            initialCameraPosition: CameraPosition(target: currentPositionPosition,zoom: 14.4),
            onMapCreated: (GoogleMapController gcontroller) async {
              gcontroller = gcontroller;
                // get API and setState
              var placeId = await getGooglemapsPlaceId.placeIdFromCurrentPosition(currentPositionPosition.latitude, currentPositionPosition.longitude);
              for(var i = 0; i < placeId.length; i++){
                var _shopInfo = await getGooglemapsItemInfo.placeInfoFromPlaceId(placeId[i]);
                setState((){
                _markers!.add(Marker(
                    markerId: MarkerId("$i"),
                    icon: _shopInfo.openNow == true ? customIconOpen! : customIconClose!,
                    position: _shopInfo.latLng!,
                    infoWindow: InfoWindow(title: _shopInfo.name)
                    ));
                    }
                  );}
              },
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
          ),
        ),
      Padding(
        padding: const EdgeInsets.only(top:48, right:15.0),
        child: SizedBox(
          width: 36,
          height: 36,
          child: FloatingActionButton(
            backgroundColor: Color(0xffFFF9E2), 
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            elevation: 5,
            onPressed: (){
              //Navigator.pop(context);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>Searching()));
            }, 
            child: const Icon(Icons.refresh, color: Color(0xff333333),),
            ),
        ),
      )
      ]
    );
  }
}


class PanelWidget extends StatefulWidget {
  final ScrollController scontroller;
  final LatLng currentPositionPosition;
  final PanelController panelController;
  PanelWidget({Key? key, required this.scontroller, required this.currentPositionPosition, required this.panelController}) : super(key: key);
  
  @override
  State<PanelWidget> createState() => _PanelWidgetState(scontroller, currentPositionPosition, panelController);
  
}
class _PanelWidgetState extends State<PanelWidget> {
  _PanelWidgetState(this.scrollController, this.currentPositionPosition, this.panelController);
  final ScrollController scrollController;
  final PanelController panelController;
  final LatLng currentPositionPosition;
  late List<Map<String, dynamic>> shopInfo;
  late Future<List<getGooglemapsItemInfo>> shopInfoList;
  bool value = false;
  List openList = [];
  final AsyncMemoizer memoizer= AsyncMemoizer();
  late Future myFuture;



  Future<List<getGooglemapsItemInfo>> getShopInfo(LatLng currentPositionPosition) async {
    List<getGooglemapsItemInfo> _shopInfoList = [];
    List placeId = await getGooglemapsPlaceId.placeIdFromCurrentPosition(currentPositionPosition.latitude, currentPositionPosition.longitude);
      for(var i = 0; i < placeId.length; i++){
        final getGooglemapsItemInfo _shopInfo = await getGooglemapsItemInfo.placeInfoFromPlaceId(placeId[i]);
        _shopInfoList.add(_shopInfo);
        if(_shopInfo.openNow == true){
          openList.add(_shopInfo);
        }
    } 
    numberOpenList = openList.length;
    return _shopInfoList;
  }

  Widget buildCheckBox() => CheckboxListTile(
    contentPadding: EdgeInsets.all(0),
    controlAffinity: ListTileControlAffinity.leading,
    title: Text('only open now'),
    checkColor: Color(0xffffffff),
    activeColor: Color(0xff999999),
    value: value, 
    onChanged: (value){
      setState(() {
        this.value = value!;
        visible = !visible;
      });

  },
  );

  void togglePanel() => panelController.isPanelOpen
  ? panelController.close()
  : panelController.open();

  @override
  void initState() {
    // TODO: implement initState
    myFuture = getShopInfo(currentPositionPosition);
    super.initState();
  }

  @override
  Widget build(BuildContext context){ 
    return Expanded(
      child: Container(
        child: Column(
          children: [
            const SizedBox(height: 12,),
            GestureDetector(
              onTap: togglePanel,
              child: Container(
                width: 120,
                height: 6,
                decoration: BoxDecoration(
                  color: Color(0xffDDDDDD),
                  borderRadius: BorderRadius.circular(12)
                ),
              ),
            ),
            const SizedBox(height:16,),
            FutureBuilder(
            future: myFuture,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot){
              Widget childWidget;
              if(snapshot.hasData){
                List shopInfoList = snapshot.data;
                ListView(
                  controller: scrollController,
                  padding: EdgeInsets.zero,
                  children: [
                    SizedBox(height: 32,),
                    childWidget = buildAboutContent(shopInfoList, value, currentPositionPosition, buildCheckBox, context, scrollController),
                    SizedBox(height: 40,),
                  ],
              );
              } else if(snapshot.hasError){
                childWidget = buildDataError(context);
              } else {
                childWidget = buildShimmer(context);
              }
              return childWidget;
            }),]
        ),
      ),
    );
  }  
  }


  Widget buildAboutContent(shopInfoList, value, currentPostionPostion, buildCheckBox(), context, pcontroller) => Container(
    padding: EdgeInsets.symmetric(horizontal: 16),
    child: Column(
      children: [
        Container(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left:8.0),
              child:
               visible == true ?               
               shopInfoList.length == 20 ? const Text("More than 20 places around you!", style: TextStyle(fontSize: 24, )) 
               : Text("${shopInfoList.length} place around you!", style: const TextStyle(fontSize: 24, ),)
               : numberOpenList == 0 ? const Text("No place available now...", style: TextStyle(fontSize: 24, ),)
               : Text("$numberOpenList place available now!", style: const TextStyle(fontSize: 24, ),),
            )),
        ),
        Padding(
          padding: const EdgeInsets.only(left:0, top: 0),
          child: buildCheckBox()
        ),
        const Divider(
          thickness: 1,
          color: Color(0xff999999),
        ),
         Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: LimitedBox(
                maxHeight: MediaQuery.of(context).size.height * 0.63,
                child: ListView.builder(
                  controller: pcontroller,
                  padding: EdgeInsets.zero,
                  itemCount: shopInfoList.length,
                  itemBuilder: (context, index){
                    return 
                    shopInfoList[index].openNow == false || shopInfoList[index].openNow == null
                    ? Visibility(
                      visible: visible,
                      child: ItemListView(index, shopInfoList, context, currentPostionPostion),
                    )
                    : ItemListView(index, shopInfoList, context, currentPostionPostion);
                  }),
              ),
            ),
          ],
        ),
      ],
    ),
  );

  Column ItemListView(int index, shopInfoList, BuildContext context, currentPostionPostion) {
    return Column(
        children: [ 
          Container(
            width: double.infinity,
            child: Text(shopInfoList[index].name, textAlign: TextAlign.left,)),
          SizedBox(height: 8,),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: 
            GestureDetector(
              onTap: (){
                Navigator.push(context, 
                MaterialPageRoute(builder: ((context) => ItemDetail(shopInfoList[index], currentPostionPostion))));
                },
              child: Row(
                children: [
                  if(shopInfoList[index].photos != [])
                  for(var i=0; i < shopInfoList[index].photos.length;i++)
                  Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network("https://maps.googleapis.com/maps/api/place/photo?maxwidth=150&photo_reference=${shopInfoList[index].photos[i]["photo_reference"]}&key=${API_KEY}", height: 112, width: 144,fit: BoxFit.cover,
                            errorBuilder: ((context, error, stackTrace) {
                              return ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: 
                      const Image(
                        image: AssetImage("images/connection_error.png"),height: 112, width: 144,fit: BoxFit.cover,)
                      );
                            }),),
                    ),
                  ),
                  if(shopInfoList[index].photos.length <= 2)
                  for(var i=0; i < 3 - shopInfoList[index].photos.length;i++)
                  Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: 
                      const Image(
                        image: AssetImage("images/list_logogrey.png"),height: 112, width: 144,fit: BoxFit.cover,)
                      ),
                  ),
                ],
              ),
            ),
      ),
        const Divider(thickness: 1,),
        ],
      );
  }

Widget buildDataError(context) => Padding(
  padding: const EdgeInsets.symmetric(horizontal:16.0),
  child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left:8.0),
              child:
              const Text("Failed to load...", style: TextStyle(fontSize: 24, )),
            )),
        ),
        Padding(
          padding: const EdgeInsets.only(left:8, top: 8),
          child: Text("Please try again.", style: TextStyle(fontSize: 16),)
        ),
        Divider(height: 20,thickness: 1,color: Color(0xffcccccc),),
        for(var i=0; i < 2;i++)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[
            Shimmer.fromColors(
              baseColor: Color(0xffF0EFDB),
              highlightColor: Color(0xffE8E7D3),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: 14,
                  color: Colors.grey,
                  ),
              ),
            ),
        SizedBox(height: 8,),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for(var i=0; i < 3;i++)
              Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: Shimmer.fromColors(
                  baseColor: Color(0xffF0EFDB),
                  highlightColor: Color(0xffE8E7D3),
                  child: ClipRRect(borderRadius: BorderRadius.circular(8), child: Container(height: 112, width: 144,color: Colors.grey,))),
              ),
            ],
          ),
        ),
        Divider(thickness: 1,),
          ]
        ),
    ]
  ),
);
  
Widget buildShimmer(context) => Padding(
  padding: const EdgeInsets.symmetric(horizontal:16.0),
  child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Shimmer.fromColors(
          baseColor: Color(0xffF0EFDB),
          highlightColor: Color(0xffE8E7D3),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.7,
              height: 40,
              color: Colors.grey,
              ),
          ),
        ),
        SizedBox(height: 10,),
        Shimmer.fromColors(
          baseColor: Color(0xffF0EFDB),
          highlightColor: Color(0xffE8E7D3),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.45,
              height: 30,
              color: Colors.grey,
              ),
          ),
        ),
        Divider(height: 20,thickness: 1,color: Color(0xffcccccc),),
        for(var i=0; i < 2;i++)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[
            Shimmer.fromColors(
              baseColor: Color(0xffF0EFDB),
              highlightColor: Color(0xffE8E7D3),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: 14,
                  color: Colors.grey,
                  ),
              ),
            ),
        SizedBox(height: 8,),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for(var i=0; i < 3;i++)
              Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: Shimmer.fromColors(
                  baseColor: Color(0xffF0EFDB),
                  highlightColor: Color(0xffE8E7D3),
                  child: ClipRRect(borderRadius: BorderRadius.circular(8), child: Container(height: 112, width: 144,color: Colors.grey,))),
              ),
            ],
          ),
        ),
        Divider(thickness: 1,),
          ]
        ),
    ]
  ),
);