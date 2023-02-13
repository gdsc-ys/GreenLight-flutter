import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';


class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {

  Set<Marker> _showMarkers = {};

  late GoogleMapController _mapController;

  final LatLng _center = const LatLng(45.521563, -122.677433);

  String _mapStyle = "";

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _mapController.setMapStyle(_mapStyle);
  }

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      rootBundle.loadString("assets/style/map_style.txt").then((value) => {
        _mapStyle = value
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: GoogleMap(
          myLocationEnabled: true,
          mapToolbarEnabled: true,
          markers: _showMarkers,
          onMapCreated: _onMapCreated,
          // zoomGesturesEnabled: false,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 18.0,
          ),
        ),
      ),
    );
  }
}