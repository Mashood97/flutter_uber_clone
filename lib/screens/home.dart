import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../provider/home_provider.dart';

class HomePage extends StatelessWidget {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Map(scaffoldKey),
      drawer: Drawer(),
    );
  }
}

class Map extends StatefulWidget {
  final scaffoldkey;
  Map(this.scaffoldkey);
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  GoogleMapController mapController;

  Widget getOriginTextField(var homeProv) {
    return Positioned(
      top: 70.0,
      right: 15.0,
      left: 15.0,
      child: Container(
        height: 50.0,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3.0),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.grey,
                offset: Offset(1.0, 5.0),
                blurRadius: 10,
                spreadRadius: 3)
          ],
        ),
        child: TextField(
          cursorColor: Colors.black,
          controller: homeProv.originTextEditingController,
          decoration: InputDecoration(
            icon: Container(
              margin: EdgeInsets.only(left: 20),
              width: 10,
              height: 10,
              child: GestureDetector(
                onTap: homeProv.getUserLocation,
                child: Icon(
                  Icons.location_on,
                  color: Colors.black,
                ),
              ),
            ),
            hintText: "pick up",
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(left: 15.0, top: 16.0),
          ),
        ),
      ),
    );
  }

  Widget getDestinationTextField(var homeProv) {
    return Positioned(
      top: 125.0,
      right: 15.0,
      left: 15.0,
      child: Container(
        height: 50.0,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3.0),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.grey,
                offset: Offset(1.0, 5.0),
                blurRadius: 10,
                spreadRadius: 3)
          ],
        ),
        child: TextField(
          cursorColor: Colors.black,
          controller: homeProv.destinationTextEditingController,
          textInputAction: TextInputAction.go,
          onSubmitted: (value) {
            // appState.sendRequest(value);
            homeProv
                .sendRequest(
                    value, homeProv.originTextEditingController.text.toString())
                .then((_) {
              getBottomSheet(homeProv);
            });
          },
          decoration: InputDecoration(
            icon: Container(
              margin: EdgeInsets.only(left: 20, top: 5),
              width: 10,
              height: 10,
              child: Icon(
                Icons.local_taxi,
                color: Colors.black,
              ),
            ),
            hintText: "Enter your destination",
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(left: 15.0, top: 16.0),
          ),
        ),
      ),
    );
  }

  Widget getTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(title),
    );
  }

  void getBottomSheet(var homeProv) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        builder: (ctx) => Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getTitle('Your Pick-Up Point:'),
                getTitle(homeProv.getStartAddress),
                getTitle('Your Destination Point:'),
                getTitle(homeProv.getEndAddress),
                getTitle('Duration of a trip'),
                getTitle(homeProv.getDurationTrip),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FlatButton(
                    color: Colors.black,
                    onPressed: () {},
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Confirm Ride',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    final homeProv = Provider.of<HomeProvider>(context);
    return homeProv.getInitialPosition == null
        ? Center(child: CircularProgressIndicator())
        : Stack(
            children: [
              GoogleMap(
                onMapCreated: onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: homeProv.getInitialPosition,
                  zoom: 12.0,
                ),
                myLocationEnabled: true,
                mapType: MapType.terrain,
                compassEnabled: true,
                markers: homeProv.getAllMarkers,
                onCameraMove: homeProv.moveCamera,
                polylines: homeProv.getAllPolyLines,
                // markers: Set.from(allMarkers),
                // polylines: _polyline,
              ),

              getOriginTextField(homeProv),
              getDestinationTextField(homeProv),
              Positioned(
                left: 10,
                top: 20,
                child: IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () => widget.scaffoldkey.currentState.openDrawer(),
                ),
              ),
//              Positioned(
//                bottom: 30,
//                left: 20,
//                child: homeProv.getStartAddress == null
//                    ? Text('')
//                    : homeProv.getEndAddress == null
//                        ? Text('')
//                        : homeProv.getDurationTrip == null
//                            ? Text('')
//                            : Column(
//                                children: [
//                                  Text(homeProv.getStartAddress),
//                                  Text(homeProv.getEndAddress),
//                                  Text(homeProv.getDurationTrip),
//                                ],
//                              ),
//              )
              // Positioned(
              //   top: 40,
              //   right: 10,
              //   child: FloatingActionButton(
              //     child: Icon(Icons.add_location),
              //     backgroundColor: Colors.black,
              //     onPressed: addMarker,
              //     tooltip: 'Add Marker',
              //   ),
              // )
            ],
          );
  }

  void onMapCreated(controller) {
    setState(() {
      mapController = controller;
      // mapController.setMapStyle(jsonEncode(mapStyle));
    });
  }
}
