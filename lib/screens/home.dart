import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../provider/home_provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Map(),
    );
  }
}

class Map extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  GoogleMapController mapController;

  @override
  void initState() {
    super.initState();
    // Provider.of<HomeProvider>(context).getUserLocation();
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
                // onCameraMove: moveCamera,
                polylines: homeProv.getAllPolyLines,
                // markers: Set.from(allMarkers),
                // polylines: _polyline,
              ),
              Positioned(
                top: 50.0,
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
              ),

              Positioned(
                top: 105.0,
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
                      homeProv.sendRequest(value,
                          homeProv.originTextEditingController.text.toString());
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
                      hintText: "destination",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 15.0, top: 16.0),
                    ),
                  ),
                ),
              ),

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
