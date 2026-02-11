import 'dart:async';

import 'package:fitmaxx/consts.dart' as consts;
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {

  Location _locationController = new Location();
  StreamSubscription<LocationData>? _locationSub;
  String GOOGLE_MAPS_API_KEY = consts.GOOGLE_MAPS_API_KEY;

  final Completer<GoogleMapController> _mapController = 
      Completer<GoogleMapController>();

  static const LatLng _pGooglePlex = LatLng(37.4223, -122.0848);
  static const LatLng _pApplePark = LatLng(37.3349, -122.0090);
  LatLng? _currentP = null;

  Map<PolylineId, Polyline> polylines = {};

  @override
  void initState() {
    super.initState();
    getLocationUpdates();
  }

  Future<void> getLocationUpdates() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _locationController.serviceEnabled();
    if (_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
    } 
    else {
      return;
    }

    _permissionGranted = await _locationController.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _locationController.requestPermission();
    }
    if (_permissionGranted != PermissionStatus.granted) {
      return;
    }

    
    

    _locationSub = _locationController.onLocationChanged.listen((LocationData currentLocation) {
      final lat = currentLocation.latitude;
      final lng = currentLocation.longitude;

      if (lat != null && lng != null) {
        if (!mounted) return; 
        setState(() {
          _currentP = LatLng(lat, lng);
        _cameraToPosition(_currentP!);
        });

        getPolylinePoints().then((coordinates) {
          generatePolylineFromPoints(coordinates);
        });
      }
    });
  }

  Future<void> _cameraToPosition(LatLng pos) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition _newCameraPosition = CameraPosition(target: pos, zoom: 13);

    await controller.animateCamera(CameraUpdate.newCameraPosition(_newCameraPosition));
  }

  Future<List<LatLng>> getPolylinePoints() async {
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: GOOGLE_MAPS_API_KEY,
      request: PolylineRequest(
        origin: PointLatLng(_pGooglePlex.latitude, _pGooglePlex.longitude),
        destination: PointLatLng(_pApplePark.latitude, _pApplePark.longitude),
        mode: TravelMode.walking,
      ),
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    else {
      print(result.errorMessage);
    }
    return polylineCoordinates;
  }
  
  void generatePolylineFromPoints(List<LatLng> polylineCoordinates) async {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.black,
      points: polylineCoordinates,
      width: 8,
    );
    setState(() {
      polylines[id] = polyline;
    });
  }

  @override
  void dispose() {
    _locationSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentP == null ? const Center(child: Text("Loading..."),) : 
      GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          _mapController.complete(controller);
        },
        initialCameraPosition: CameraPosition(
          target: _pGooglePlex,
          zoom: 13,
        ),
        markers: {
          Marker(
            markerId: MarkerId("_currentLocation"), 
            icon: BitmapDescriptor.defaultMarker, 
            position: _currentP!
          ),
          Marker(
            markerId: MarkerId("_sourceLocation"), 
            icon: BitmapDescriptor.defaultMarker, 
            position: _pGooglePlex
          ),
          Marker(
            markerId: MarkerId("_destinationLocation"), 
            icon: BitmapDescriptor.defaultMarker, 
            position: _pApplePark
          ),
        },
        polylines: Set<Polyline>.of(polylines.values),
      ),
    );
  }
}