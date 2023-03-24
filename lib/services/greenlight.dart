import 'package:green_light/services/distance.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class LocationGreenLight {
  static final LocationGreenLight _instance = LocationGreenLight._internal();

  factory LocationGreenLight(){
    return _instance;
  }

  LocationGreenLight._internal();
  Location location = Location();

  Future<LocationData?> fetchCurrentLocation() async {
    LocationData locationData;
    await location.changeSettings(accuracy: LocationAccuracy.high);
    try {
        var _hasLocationPermission = await location.hasPermission();
        if (_hasLocationPermission != PermissionStatus.granted) {
          var _permissionGranted = await location.requestPermission();
          if (_permissionGranted != PermissionStatus.granted) {
            throw new Exception("no permission");
        }

        var _hasLocationServiceEnabled = await location.serviceEnabled();
        if (!_hasLocationServiceEnabled) {
          var _serviceEnabled = await location.requestService();
          if (!_serviceEnabled) {
            throw new Exception("not enabled");
          }
        }

        locationData = await location.getLocation();
        if (locationData == null) {
          throw new Exception("null");
        }
        return locationData;
      }
    } catch(e) {
      print(e);
      rethrow;
    }
  }
}