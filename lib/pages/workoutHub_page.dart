import 'package:fitmaxx/pages/gpsRecorder_tab.dart';
import 'package:fitmaxx/pages/workoutLog_tab.dart';
import 'package:flutter/material.dart';
class WorkouthubPage extends StatelessWidget {
  const WorkouthubPage({super.key});

  @override
  Widget build(BuildContext context) {
    // default tab controller for workout log and gps recorder tabs
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primary,
        title:  SizedBox(
          // tab bar
          height: kToolbarHeight,
          child: TabBar(
            // styling for tab bar
            indicatorColor: Theme.of(context).colorScheme.secondary,
            labelColor: Theme.of(context).colorScheme.inversePrimary,
            unselectedLabelColor: Theme.of(context).colorScheme.secondary,
            labelPadding: const EdgeInsets.symmetric(horizontal: 24),
            // tabs for workout log and gps recorder
            tabs: [
              Tab(icon: Icon(Icons.fitness_center), text: 'W O R K O U T'),
              Tab(icon: Icon(Icons.map), text: 'G P S'),
            ],
          ),
        ),
      ),
      // tab bar view
        body: const TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            // Workout Log Tab
            WorkoutlogTab(),

            // GPS Recorder Tab
            GpsrecorderTab(),
          ],
        ),
      ),
    );
  }
}