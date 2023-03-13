import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:green_light/screens/home/cameraview.dart';
import 'package:green_light/services/location.dart';
import 'package:green_light/services/permission.dart';
import 'package:permission_handler/permission_handler.dart';


class MapView extends StatefulWidget {
  const MapView({required this.showMarkers, super.key});

  final Future<Set<Marker>>? showMarkers;
  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {

  Set<Marker> _showMarkers = {};

  late GoogleMapController _mapController;

  String _mapStyle = "";

  final LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) async {
    _mapController = controller;
    _mapController.setMapStyle(_mapStyle);
  }


  @override
  void initState() {
    super.initState();

    widget.showMarkers?.then((value) {
      setState(() {
        _showMarkers = value;
      });
    });

    SchedulerBinding.instance.addPostFrameCallback((_) {
      rootBundle.loadString("assets/style/map_style.txt").then((value) => {
        _mapStyle = value
      });
      _getUserLocation(context);
    });
  }

  Future<void> _getUserLocation(BuildContext context) async {
    PermissionUtils.requestPermission(Permission.location, context,
      isOpenSettings: true, permissionGrant: () async {
        print("already granted");
        await LocationService().fetchCurrentLocation(context, updatePosition: updateCameraPosition);
      },
      permissionDenied: () {
        Fluttertoast.showToast(
          msg: 'Please grant the required permission from settings to access this feature.',
          backgroundColor: Colors.grey,
        );
    });
  }

  void updateCameraPosition(CameraPosition cameraPosition) {
    _mapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: GoogleMap(
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          mapToolbarEnabled: false,
          markers: _showMarkers,
          onMapCreated: _onMapCreated,
          zoomGesturesEnabled: false,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 18.0,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: 'cameraBtn',
          backgroundColor: const Color(0xff5DC86C),
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CameraView(),
              ),
            );
          },
          // onPressed: () async {
          //   await availableCameras().then((value) => Navigator.push(context,
          //       MaterialPageRoute(builder: (_) => CameraPage(cameras: value))));
          // },
        ),
      ),
    );
  }
}