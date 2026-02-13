import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../controllers/live_tracker_controller.dart';
import '../services/map_services/activity_tracker_service.dart';
import '../services/map_services/location_service_geolocator.dart';
import '../models/map/activity_type.dart'; 

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Completer<GoogleMapController> _mapController = Completer<GoogleMapController>();

  late final LiveTrackerController tracker;

  @override
  void initState() {
    super.initState();

    tracker = LiveTrackerController(
      locationService: LocationServiceGeolocator(),
      trackerService: ActivityTrackerService(),
    );

    tracker.addListener(_onTrackerChanged);

    // Get initial position so the map can show something
    Future.microtask(() async {
      try {
        await tracker.initCurrentLocation();
        if (!mounted) return;
        setState(() {});
      } catch (_) {}
    });
  }

  void _onTrackerChanged() async {
    if (!mounted) return;

    setState(() {});

    // only auto-follow camera when recording
    if (tracker.isRecording && tracker.currentLatLng != null && _mapController.isCompleted) {
      final c = await _mapController.future;
      await c.animateCamera(CameraUpdate.newLatLng(tracker.currentLatLng!));
    }
  }

  @override
  void dispose() {
    tracker.removeListener(_onTrackerChanged);
    tracker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    final current = tracker.currentLatLng;
    if (current == null) {
      return const Scaffold(body: Center(child: Text("Loading...")));
    }

    final markers = <Marker>{
      Marker(
        markerId: const MarkerId("me"),
        position: current,
      ),
    };

    final polylines = <Polyline>{};
    if (tracker.routePoints.length >= 2) {
      polylines.add(
        Polyline(
          polylineId: const PolylineId("live"),
          points: tracker.routePoints,
          width: 6,
        ),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              onMapCreated: (c) => _mapController.complete(c),
              initialCameraPosition: CameraPosition(
                target: current,
                zoom: 16,
              ),
              markers: markers,
              polylines: polylines,
              myLocationButtonEnabled: true,
              myLocationEnabled: false, 
            ),
          ),

          // Bottom control and stats panel
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(width: 0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Activity type selector
                Row(
                  children: [
                    const Text("Type: "),
                    const SizedBox(width: 8),
                    DropdownButton<TrackerActivityType>(
                      value: tracker.activityType,
                      items: TrackerActivityType.values
                          .map((t) => DropdownMenuItem(
                                value: t,
                                child: Text(t.name),
                              ))
                          .toList(),
                      onChanged: (t) {
                        if (t != null) tracker.setActivityType(t);
                      },
                    ),
                    const Spacer(),
                    Text("${tracker.distanceKmText} km"),
                  ],
                ),

                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Time: ${tracker.elapsedText}"),
                    Text("Pace: ${tracker.paceText}"),
                  ],
                ),

                const SizedBox(height: 10),

                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    ElevatedButton.icon(
                      onPressed: (!tracker.isRecording && !tracker.isPaused && user != null)
                          ? () => tracker.start(uid: user.uid)
                          : null,
                      icon: const Icon(Icons.play_arrow),
                      label: const Text("Start"),
                    ),
                    ElevatedButton.icon(
                      onPressed: (tracker.isRecording) ? () => tracker.pause(auto: false) : null,
                      icon: const Icon(Icons.pause),
                      label: const Text("Pause"),
                    ),
                    ElevatedButton.icon(
                      onPressed: (tracker.isPaused && user != null)
                          ? () => tracker.resume(uid: user.uid)
                          : null,
                      icon: const Icon(Icons.play_circle),
                      label: Text(tracker.isAutoPaused ? "Resume (auto)" : "Resume"),
                    ),
                    ElevatedButton.icon(
                      onPressed: ((tracker.isRecording || tracker.isPaused) && user != null)
                          ? () => tracker.stopAndSave(uid: user.uid)
                          : null,
                      icon: const Icon(Icons.stop),
                      label: const Text("Stop + Save"),
                    ),
                    TextButton(
                      onPressed: () => tracker.resetLocal(),
                      child: const Text("Reset"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
