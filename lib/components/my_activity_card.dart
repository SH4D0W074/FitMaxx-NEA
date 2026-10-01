import 'package:fitmaxx/components/my_delete_button.dart';
import 'package:flutter/material.dart';
import 'package:fitmaxx/models/map/tracked_activity_model.dart';

class MyActivityCard extends StatelessWidget {

  final TrackedActivity activity;
  final Widget childWidget;
  final Widget deleteButton;

  const MyActivityCard({super.key, required this.activity, required this.childWidget, required this.deleteButton});

  
  String getDay(DateTime dateTime) {
    final d = dateTime.toLocal();
    return '${d.year}-'
          '${d.month.toString().padLeft(2, '0')}-'
          '${d.day.toString().padLeft(2, '0')}';
  }

  int getAverageSpeed(TrackedActivity activity) {
    if (activity.distanceMeters > 0 && activity.durationSeconds > 0) {
      return ((activity.distanceMeters / activity.durationSeconds) ).round(); 
    }
    return 0;
  }

  double getDurationInHours(TrackedActivity activity) {
    if (activity.durationSeconds > 0) {
      return (activity.durationSeconds / 3600); // Convert seconds to hours
    }
    return 0;
  }

  double getDistanceInKm(TrackedActivity activity) {
    if (activity.distanceMeters > 0) {
      return (activity.distanceMeters / 1000); // Convert meters to kilometers
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
           
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0), 
                  alignment: Alignment.centerLeft,
                  child: Text(
                    activity.activityName.toString(),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                deleteButton,
              ],
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 2.0),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          activity.type.name.toString().toUpperCase(),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ),
                        SizedBox(width: 10),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 4.0),
                        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 2.0),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          activity.endedAt != null ? getDay(activity.endedAt!) : 'No timestamp',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          ),
                        )
                    ],
                  ),

                  Wrap(
                    alignment: WrapAlignment.start,
                    spacing: 15,
                    runSpacing: 3,
                    children: [
                      Text("Avg Speed: ${getAverageSpeed(activity)}m/s"),
                      SizedBox(width: 10),
                      Text("Duration: ${getDurationInHours(activity).toStringAsFixed(2)}h"),
                      SizedBox(width: 10),
                      Text("Distance: ${getDistanceInKm(activity).toStringAsFixed(2)}km"),
                    ]
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 140,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(3),
                ),
                child: childWidget,
              ),
            ),
          ],
        ),
      ),
    );
  }
}