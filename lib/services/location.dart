import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:green_light/models/map.dart';
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
        var hasLocationPermission = await location.hasPermission();

        if (hasLocationPermission == PermissionStatus.granted) {
          // ignore: use_build_context_synchronously
          grantedPermissionMethod(
            context, 
            locationData,
            updatePosition: updatePosition);
        } else if (hasLocationPermission == PermissionStatus.denied) {
          var permissionGranted = await location.requestPermission();
          if (permissionGranted == PermissionStatus.granted) {
            // ignore: use_build_context_synchronously
            grantedPermissionMethod(
              context, 
              locationData, 
              updatePosition: updatePosition);
          } else if (permissionGranted == PermissionStatus.denied) {
            // ignore: use_build_context_synchronously
            serviceDisabledMethod(context);
          }
        }
      } on PlatformException catch(e) {
        debugPrint(e.code);
      }
    }

    void grantedPermissionMethod(
      BuildContext context,
      LocationData? locationData,
      {Function? updatePosition}
    ) async {
      var hasLocationServiceEnabled = await location.serviceEnabled();
      if (hasLocationServiceEnabled) {
        // ignore: use_build_context_synchronously
        serviceEnabledMethod(
          context, 
          locationData,
          updatePosition: updatePosition);
      } else {
        var serviceEnabled = await location.requestService();
        if (serviceEnabled) {
          // ignore: use_build_context_synchronously
          serviceEnabledMethod(
            context, 
            locationData, 
            updatePosition: updatePosition);
        } else {
          // ignore: use_build_context_synchronously
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
      // ignore: use_build_context_synchronously
      Provider.of<MapProvider>(context, listen: false).updateCurrentLocation(
        LatLng(locationData.latitude!.toDouble(), locationData.longitude!.toDouble())
      );
      updatePosition!(
        CameraPosition(
        target: LatLng(locationData.latitude!.toDouble(), locationData.longitude!.toDouble()),
        zoom: 18.0,
        ),
      );

      // ignore: use_build_context_synchronously
      if (Provider.of<MapProvider>(context, listen: false).currentLatLng != null) {
        // ignore: use_build_context_synchronously
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
        Provider.of<MapProvider>(context, listen: false).updateCurrentLocation(
          LatLng(event.latitude!.toDouble(), event.longitude!.toDouble())
        );
        locationData = event;
      });
    }
}