import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitmaxx/components/my_activity_card.dart';
import 'package:fitmaxx/controllers/live_tracker_controller.dart';
import 'package:fitmaxx/models/map/tracked_activity_model.dart';
import 'package:fitmaxx/services/map_services/activity_tracker_service.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ActivitiesPage extends StatefulWidget {
  const ActivitiesPage({super.key});

  @override
  State<ActivitiesPage> createState() => _ActivitiesPageState();
}

class _ActivitiesPageState extends State<ActivitiesPage> {
  @override
  Widget build(BuildContext context) {

    return Center(
      child: StreamBuilder(
        stream: ActivityTrackerService().watchActivities(FirebaseAuth.instance.currentUser!.uid), 
        builder: (context, snapshot) {
          
            // if we have data, get all ActivityList
            if (snapshot.hasData) {
            List<TrackedActivity> ActivityList = snapshot.data!;

            if (ActivityList.isEmpty) {
              return Text("No activities recorded yet.");
            }

            return ListView.builder(
              itemCount: ActivityList.length,
              itemBuilder: (context, index) {
                final data = ActivityList[index].toMap();

                return ListTile(
                  title: MyActivityCard(
                    activity: ActivityList[index],

                    childWidget: StreamBuilder(
                      stream: ActivityTrackerService().watchRoutePoints(FirebaseAuth.instance.currentUser!.uid, ActivityList[index].id), 
                      builder: (context, polySnap) {
                        if (polySnap.hasData) {
                          final routePoints = polySnap.data!;
                          final polylines = {
                            Polyline(
                              polylineId: PolylineId(ActivityList[index].id),
                              points: routePoints.map((p) => LatLng(p.lat, p.lng)).toList(),
                              color: Colors.blue,
                              width: 5,
                            ),
                          };
                          return _buildMap(ActivityList[index], polylines);
                        } else if (polySnap.hasError) {
                          return Text("Error loading route.");
                        } else {
                          return Text("Loading route...");
                        }
                      }
                    ), 
                  ),
                );
              },
            );
          } 
          else if (snapshot.hasError) {
            return Text("Error loading activities.");
          } 
          else {
            return Text("Loading activities...");
          }
        }
      ),
    );
  }
  Widget _buildMap(TrackedActivity activity, Set<Polyline> polylines) {
    final Completer<GoogleMapController> _mapController = Completer<GoogleMapController>();
    final markers = <Marker>{
      Marker(
        markerId: const MarkerId("me"),
        position: LatLng(activity.endLat ?? 0.0, activity.endLng ?? 0.0),
      ),
    };
    return GoogleMap(
      onMapCreated: (c) => _mapController.complete(c),
      initialCameraPosition: CameraPosition(
        target: LatLng(activity.endLat ?? 0.0, activity.endLng ?? 0.0),
        zoom: 16,
      ),
      markers: markers,
      polylines: polylines,
      myLocationButtonEnabled: true,
      myLocationEnabled: false, 
    );
  }
}