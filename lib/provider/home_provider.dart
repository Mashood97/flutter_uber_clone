import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_uber_clone/utils/google_map_request.dart';
import 'package:flutter_uber_clone/utils/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

class HomeProvider with ChangeNotifier {
  static LatLng _initialPosition;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};

  String route, _durationTrip, _endAddress, _startAddress;
  final originTextEditingController = TextEditingController();
  final destinationTextEditingController = TextEditingController();
  GoogleMapsServices _googleMapsServices = GoogleMapsServices();

  LatLng _lastPosition = _initialPosition;
  int _AmountofATrip;

  int _PredictedAmountofATrip;
  GoogleMapController mapController;



  //getters:

  String get getEndAddress => _endAddress;

  String get getStartAddress => _startAddress;

  String get getDurationTrip => _durationTrip;

  int get getAmountOfTrip => _AmountofATrip;

  int get getPredictedAmountOfTrip => _PredictedAmountofATrip;

  LatLng get getInitialPosition => _initialPosition;

  LatLng get getLastPosition => _lastPosition;

  int farePerMin = 5;

  Set<Marker> get getAllMarkers => _markers;

  Set<Polyline> get getAllPolyLines => _polylines;

  HomeProvider() {
    getUserLocation();
  }

//get user location
  void getUserLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placeMark = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    if (position != null) {
      _initialPosition = LatLng(position.latitude, position.longitude);
      originTextEditingController.text = placeMark[0].name;
    }
    notifyListeners();
  }

//send request to driver.
  LatLng origin;

  Future<void> sendRequest(
      String intendedLocation, String originLocation) async {
    List<Placemark> placemark =
        await Geolocator().placemarkFromAddress(intendedLocation);

    double latitude = placemark[0].position.latitude;
    double longitude = placemark[0].position.longitude;

    LatLng destination = LatLng(latitude, longitude);

    if (originLocation != null) {
      try {
        List<Placemark> originplacemark =
            await Geolocator().placemarkFromAddress(originLocation);

        double originLatitude = originplacemark[0].position.latitude;
        double originLongitude = originplacemark[0].position.longitude;

        origin = LatLng(originLatitude, originLongitude);
        route =
            await _googleMapsServices.getRouteCoordinates(origin, destination);
        _endAddress =
            await _googleMapsServices.getEndAddress(origin, destination);
        _startAddress =
            await _googleMapsServices.getStartAddress(origin, destination);

        _durationTrip =
            await _googleMapsServices.getDurationOfATrip(origin, destination);
        print('Duration of a trip is: $_durationTrip');
      } catch (e) {
        route = await _googleMapsServices.getRouteCoordinates(
            _initialPosition, destination);
        _endAddress = await _googleMapsServices.getEndAddress(
            _initialPosition, destination);
        _startAddress = await _googleMapsServices.getStartAddress(
            _initialPosition, destination);
        _durationTrip = await _googleMapsServices.getDurationOfATrip(
            _initialPosition, destination);
        print('Duration of a trip is: $_durationTrip');
      }
    } else {
      //routes
      route = await _googleMapsServices.getRouteCoordinates(
          _initialPosition, destination);
      //end Address
      _endAddress = await _googleMapsServices.getEndAddress(
          _initialPosition, destination);
      //startAddress
      _startAddress = await _googleMapsServices.getStartAddress(
          _initialPosition, destination);
      _durationTrip = await _googleMapsServices.getDurationOfATrip(
          _initialPosition, destination);
      print('Duration of a trip is: $_durationTrip');
    }

    String x = _durationTrip.replaceAll('mins', '');
    print(x);
    _PredictedAmountofATrip = int.parse(x) * farePerMin;
    print('The endAddress is : $_endAddress');
    print('The amount pred is : $_PredictedAmountofATrip');
    print('The startAddress is : $_startAddress');

    addMarker(destination, intendedLocation);

    createRoute(route);
    notifyListeners();
    // createRoute(route);
  }

  Future<void> getAutoCompletePlaceTextField(BuildContext context) async {
    await SharedPref.init();
    String abc = SharedPref.getAuthData();
    // if (abc == null || abc.isEmpty) {
    //   return false;
    // }
    final extractedData = json.decode(abc) as Map<String, Object>;
    if (extractedData == null || extractedData.isEmpty) {
      return false;
    }

    print(extractedData['countryCodeName']);
    Prediction p = await PlacesAutocomplete.show(
      context: context,
      apiKey: 'AIzaSyBvOO0sBLjH3B9tylTfTJubczi-HuTHpZ0',
      language: "en",
      components: [
        Component(Component.country, extractedData['countryCodeName']),
      ],
    );
    print(p.structuredFormatting.mainText);
    destinationTextEditingController.text = p.structuredFormatting.mainText;
  }


  void onMapCreated(controller) {

      mapController = controller;
      notifyListeners();
      // mapController.setMapStyle(jsonEncode(mapStyle));

  }
  void createRoute(String route) async {
    _polylines.add(
      Polyline(
          polylineId: PolylineId(_lastPosition.toString()),
          visible: true,
          color: Colors.black,
          width: 3,
          points: convertToLatLng(_decodePoly(route))),
    );
    notifyListeners();
  }

  //add marker and polylines to destination

  void addMarker(LatLng position, String address) {
    _markers.add(Marker(
      markerId: MarkerId(_lastPosition.toString()),
      position: position,
      infoWindow: InfoWindow(
        title: address,
        snippet: "destination",
      ),
      icon: BitmapDescriptor.defaultMarker,
    ));

    notifyListeners();
  }

//move camera
  void moveCamera(CameraPosition position) {
    _lastPosition = position.target;
    notifyListeners();
  }

  //as direction api url returns polylines in encoded form so we get list
  //of lat lng so we first takeout the list of lat lng which is in (lat,lng) form within an array
  //so we use odd no algorithm to get lat and lng.
  List<LatLng> convertToLatLng(List points) {
    List<LatLng> result = <LatLng>[];
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }
    return result;
  }

  //here we convert the encoded polyline into decode polylines to get lat lng route

  List _decodePoly(String poly) {
    var list = poly.codeUnits;
    var lList = new List();
    int index = 0;
    int len = poly.length;
    int c = 0;
// repeating until all attributes are decoded
    do {
      var shift = 0;
      int result = 0;

      // for decoding value of one attribute
      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);
      /* if value is negetive then bitwise not the value */
      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);

/*adding to previous value as done in encoding */
    for (var i = 2; i < lList.length; i++) lList[i] += lList[i - 2];

    print(lList.toString());

    return lList;
  }
}
