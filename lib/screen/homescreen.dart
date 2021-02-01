import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uber/places_api/fetch_url.dart';


class HomeScreen extends StatefulWidget {
  static const String id = 'home';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double bottomPaddingMap = 0.0;

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  Completer<GoogleMapController> _controllerMap = Completer();
  GoogleMapController mapController;
  static final CameraPosition _cameraPosition = CameraPosition(
      target: LatLng(30.784451 , 30.997881),
       zoom: 14.0
  );
  Position currentPosition ;
  var geoLocator = Geolocator();

  void locationPosition() async{
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;
    LatLng latlngPosition = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition = CameraPosition(target: latlngPosition , zoom: 14.0);
    mapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    // String address = await FetchUrl.searchCoordinateAddress(position);
    // print('address :' +address);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('uber app'),
      ),
      drawer: Container(
        width: 225.0,
        color: Colors.white,
        child: ListView(
          children: [
            Container(
              child: DrawerHeader(
                decoration: BoxDecoration(color: Colors.white),
                  child:Row(
                    children: [
                      Image.asset('images/usericon.png',width: 65.0,height: 65.0,),
                      SizedBox(width: 15.0,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Profile Name',style: TextStyle(fontSize: 16.0),),
                          SizedBox(height: 5.0,),
                          Text('Visit Profile',style: TextStyle(fontSize: 16.0),)
                        ],
                      )
                    ],
                  )
              ),
            ),
            Divider(color: Colors.grey[300],height: 3,thickness: 1.0,),
               SizedBox(height: 12.0,),
            ListTile(
              leading: Icon(Icons.history),
              title: Text('History',style: TextStyle(fontSize: 15.0),),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Visit Profile',style: TextStyle(fontSize: 15.0),),
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('About',style: TextStyle(fontSize: 15.0),),
            )
          ],
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
              initialCameraPosition:_cameraPosition,
            mapType:  MapType.normal,
            myLocationButtonEnabled: true,
             zoomGesturesEnabled: true,
             zoomControlsEnabled: true,
             myLocationEnabled: true,
             padding: EdgeInsets.only(bottom: bottomPaddingMap),
             onMapCreated:(GoogleMapController controller) {
                _controllerMap.complete(controller);
                mapController = controller;
                setState(() {
                  bottomPaddingMap = 300.0;
                });
                locationPosition();
             },
          ),
          Positioned(
            top: 45.0,
            left: 20.0,
            child: GestureDetector(
              onTap: (){
                scaffoldKey.currentState.openDrawer();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black,
                      offset: Offset(0.7,0.7),
                      blurRadius: 6.0,
                      spreadRadius: 0.5
                    )
                  ]
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.menu,color: Colors.black,),
                  radius: 20.0,
                ),
              ),
            ),
          ),
          Positioned(
              left: 0.0,
              right: 0.0,
              bottom: 0.0,
              child: Container(
                height: 300,
                decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.only(topLeft: Radius.circular(18.0),
                topRight: Radius.circular(18.0),
                ),
                  boxShadow: [
                     BoxShadow(color: Colors.black,offset:Offset (0.7,0.7),blurRadius: 16.0,spreadRadius: 0.5)
                  ]
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 6.0,),
                      Text('HI there,',style: TextStyle(fontSize: 15.0,color: Colors.black),),
                      Text('where to?' ,style: TextStyle(fontSize: 20.0,color: Colors.black),),
                      SizedBox(height: 20.0,),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5.0),
                        boxShadow: [
                          BoxShadow(color: Colors.grey[500],offset:Offset (0.7,0.7),blurRadius: 16.0,spreadRadius: 0.5)
                        ]
                    ),
                      child: Row(
                        children: [
                          Icon(Icons.search , color: Colors.blueAccent,),
                          SizedBox(width: 10.0,),
                          Text('Search here')
                        ],
                      ),
                    ),
                      SizedBox(height: 20.0,),
                      Row(
                        children: [
                          Icon(Icons.home , color: Colors.grey,),
                          SizedBox(width: 10.0,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Add Home',style: TextStyle(color: Colors.black,fontSize: 15.0),),
                              SizedBox(width: 4.0,),
                              Text('your living home address' , style: TextStyle(color: Colors.black45 , fontSize: 12.0),)
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 20.0,),
                      Divider(color: Colors.grey[300],height: 3,thickness: 1.0,),
                      SizedBox(height: 20.0,),
                      Row(
                         children: [
                           Icon(Icons.work , color: Colors.grey,),
                           SizedBox(width: 10.0,),
                           Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               Text('Add Work', style :TextStyle(color: Colors.black,fontSize: 15.0)),
                               SizedBox(width: 4.0,),
                               Text('your office address' , style: TextStyle(color: Colors.black45 , fontSize: 12.0),)
                             ],
                           )
                         ],
                      ),
                    ],
                  ),
                ),

              )
          ),
        ],
      ),
    );
  }
}
