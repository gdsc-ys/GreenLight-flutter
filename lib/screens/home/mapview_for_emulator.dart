import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:green_light/screens/home/rlcertificationview.dart';
import 'package:green_light/services/distance.dart';

// This file is just for emulators since getting location issue of our place.
// So we just set camera on our place.
// And ommitted current user location function.
// JUST FOR EMULATORS
class MapView extends StatefulWidget {
  const MapView({required this.showMarkers, super.key});

  final Future<Set<Marker>>? showMarkers;
  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {

  late GoogleMapController _mapController;
  List<Marker> _markers = [];
  String _mapStyle = "";
  final LatLng _center = const LatLng(37.561563, 126.937433);

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      rootBundle.loadString("assets/style/map_style.txt").then((value) => {
        _mapStyle = value
      });
    });
    _loadMarkers();
    _subscribeToMarkers();
  }

  void _onMapCreated(GoogleMapController controller) async {
    _mapController = controller;
    _mapController.setMapStyle(_mapStyle);
  }

  void _loadMarkers() async {
    final markersSnapshot = await FirebaseFirestore.instance
        .collection('greenlights')
        .get();

    BitmapDescriptor redLight= await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      "assets/images/redspot.png"
    );
    BitmapDescriptor greenLight= await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      "assets/images/greenspot.png"
    );

    final markers = markersSnapshot.docs
        .map((doc) => Marker(
              markerId: MarkerId(doc.id),
              position: LatLng(doc['lat'], doc['lng']),
              icon: doc['visit'] == 2 ? greenLight: redLight,
              onTap: doc['visit'] == 2 || calculateDistance(doc['lat'], doc['lng'], _center.latitude, _center.longitude) >= 0.05 ? () {} : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RLCertificationView(markerID: doc.id,)),
                );
              },
            ))
        .toList();

    setState(() {
      _markers = markers;
    });
  }

  void _subscribeToMarkers() async {

    BitmapDescriptor redLight= await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      "assets/images/redspot.png"
    );
    BitmapDescriptor greenLight= await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      "assets/images/greenspot.png"
    );
    FirebaseFirestore.instance
        .collection('greenlights')
        .snapshots()
        .listen((event) {
      final markers = event.docs
          .map((doc) => Marker(
                markerId: MarkerId(doc.id),
                position: LatLng(doc['lat'], doc['lng']),
                icon: doc['visit'] == 2 ? greenLight: redLight,
                onTap: doc['visit'] == 2 || calculateDistance(doc['lat'], doc['lng'], _center.latitude, _center.longitude) >= 0.05 ? () {} : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RLCertificationView(markerID: doc.id,)),
                  );
                }
              )
          )
          .toList();

      setState(() {
        _markers = markers;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        home: Scaffold(
          body: GoogleMap(
            myLocationEnabled: false,
            mapToolbarEnabled: false,
            compassEnabled: false,
            markers: Set.from(_markers),
            onMapCreated: _onMapCreated,
            zoomGesturesEnabled: false,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 16.0,
            ),
          ),
        ),
      ),
    );
  }
}