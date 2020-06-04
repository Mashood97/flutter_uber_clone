import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uber_clone/utils/google_map_request.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeProvider with ChangeNotifier {
  static LatLng _initialPosition;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};

  final originTextEditingController = TextEditingController();
  final destinationTextEditingController = TextEditingController();
  GoogleMapsServices _googleMapsServices = GoogleMapsServices();

  LatLng _lastPosition = _initialPosition;

  //getters:
  LatLng get getInitialPosition => _initialPosition;
  LatLng get getLastPosition => _lastPosition;
  Set<Marker> get getAllMarkers => _markers;
  Set<Polyline> get getAllPolyLines => _polylines;

  HomeProvider() {
    getUserLocation();
  }

//get user location
  void getUserLocation() async {
    Position position = await Geolocator().getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    List<Placemark> placeMark = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    if (position != null) {
      _initialPosition = LatLng(position.latitude, position.longitude);
      originTextEditingController.text = placeMark[0].name;
    }
    notifyListeners();
  }

//send request to driver.
  void sendRequest(String intendedLocation) async {
    List<Placemark> placemark =
        await Geolocator().placemarkFromAddress(intendedLocation);
    double latitude = placemark[0].position.latitude;
    double longitude = placemark[0].position.longitude;
    LatLng destination = LatLng(latitude, longitude);
    String route = await _googleMapsServices.getRouteCoordinates(
        _initialPosition, destination);
    addMarker(destination, intendedLocation, route);
    notifyListeners();
    // createRoute(route);
  }

  //add marker and polylines to destination

  void addMarker(LatLng position, String address, String encodedPoly) {
    _markers.add(Marker(
      markerId: MarkerId(_lastPosition.toString()),
      position: position,
      infoWindow: InfoWindow(
        title: address,
        snippet: "destination",
      ),
      icon: BitmapDescriptor.defaultMarker,
    ));

    _polylines.add(
      Polyline(
          polylineId: PolylineId(_lastPosition.toString()),
          visible: true,
          color: Colors.black,
          width: 3,
          points: convertToLatLng(_decodePoly(encodedPoly))),
    );
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
