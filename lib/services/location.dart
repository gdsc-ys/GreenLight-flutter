import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:green_light/models/map.dart';
import 'package:green_light/services/distance.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';


class LocationService {
  static final LocationService _instance = LocationService._internal();

  factory LocationService(){
    return _instance;
  }

  LocationService._internal();
  Location location = Location();

  Future<void> fetchCurrentLocation(
    BuildContext context, 
    {Function? updatePosition}
    ) async {
      LocationData? locationData;
      await location.changeSettings(accuracy: LocationAccuracy.high);
      try {
        var _hasLocationPermission = await location.hasPermission();

        if (_hasLocationPermission == PermissionStatus.granted) {
          grantedPermissionMethod(
            context, 
            locationData,
            updatePosition: updatePosition);
        } else if (_hasLocationPermission == PermissionStatus.denied) {
          var _permissionGranted = await location.requestPermission();
          if (_permissionGranted == PermissionStatus.granted) {
            grantedPermissionMethod(
              context, 
              locationData, 
              updatePosition: updatePosition);
          } else if (_permissionGranted == PermissionStatus.denied) {
            serviceDisabledMethod(context);
          }
        }
      } on PlatformException catch(e) {
        debugPrint("${e.code}");
      }
    }

    void grantedPermissionMethod(
      BuildContext context,
      LocationData? locationData,
      {Function? updatePosition}
    ) async {
      var _hasLocationServiceEnabled = await location.serviceEnabled();
      if (_hasLocationServiceEnabled) {
        serviceEnabledMethod(
          context, 
          locationData,
          updatePosition: updatePosition);
      } else {
        var _serviceEnabled = await location.requestService();
        if (_serviceEnabled) {
          serviceEnabledMethod(
            context, 
            locationData, 
            updatePosition: updatePosition);
        } else {
          serviceDisabledMethod(context);
        }
      }
    }

    void serviceEnabledMethod(
      BuildContext context,
      LocationData? locationData,
      {Function? updatePosition}
    ) async {
      locationData = await location.getLocation();
      Provider.of<MapProvider>(context, listen: false).updateCurrentLocation(
        LatLng(locationData.latitude!.toDouble(), locationData.longitude!.toDouble())
      );
      updatePosition!(
        CameraPosition(
        target: LatLng(locationData.latitude!.toDouble(), locationData.longitude!.toDouble()),
        zoom: 18.0,
        ),
      );

      if (Provider.of<MapProvider>(context, listen: false).currentLatLng != null) {
        _getLocationUpdates(context, locationData);       
      }
    }

    void serviceDisabledMethod(BuildContext context) {
      debugPrint("Disable Permission");
    }

    Future<void> _getLocationUpdates(
      BuildContext context,
      LocationData locationData,
    ) async {
      location.onLocationChanged.listen((event) {
        final distance = calculateDistance(
          event.latitude,  
          event.longitude,
          locationData.latitude,
          locationData.longitude
        );
        Provider.of<MapProvider>(context, listen: false).updateCurrentLocation(
          LatLng(event.latitude!.toDouble(), event.longitude!.toDouble())
        );
        locationData = event;
      });
    }
}