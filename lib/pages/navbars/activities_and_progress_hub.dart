import 'package:fitmaxx/pages/progress_page.dart';
import 'package:fitmaxx/pages/activities_overview_page.dart';
import 'package:flutter/material.dart';
class ActivitiesAndProgressHub extends StatelessWidget {
  const ActivitiesAndProgressHub({super.key});

  @override
  Widget build(BuildContext context) {
    // default tab controller for progress and activities tabs
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
            // tabs for progress page and activities overview page
            tabs: [
              Tab(icon: Icon(Icons.bar_chart), text: 'P R O G R E S S'),
              Tab(icon: Icon(Icons.event_note), text: 'A C T I V I T I E S'),
            ],
          ),
        ),
      ),
      // tab bar view
        body: const TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            // Progress Tab
            ProgressPage(),

            // Activities overviewq Tab
            ActivitiesPage(),
          ],
        ),
      ),
    );
  }
}