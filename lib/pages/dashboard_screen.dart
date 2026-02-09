import 'package:fitmaxx/pages/activities_page.dart';
import 'package:fitmaxx/pages/progress_page.dart';
import 'package:fitmaxx/pages/workoutHub_page.dart';
import 'package:fitmaxx/pages/home_page.dart';
import 'package:fitmaxx/pages/mealDiary_page.dart';
import 'package:fitmaxx/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  // selected index for bottom navigation bar
  int _selectedIndex = 0;

  // list of pages for bottom navigation bar
  final List<Widget> _pages = const [
    HomePage(),
    MealdiaryPage(),
    WorkouthubPage(),
    ProgressPage(),
    SettingsPage(),
  ];

  // navigate to selected page
  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      // body of the page
      body: _pages[_selectedIndex],

      // bottom navigation bar
      bottomNavigationBar: Container(
        color: Theme.of(  context).colorScheme.primary,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
          child: GNav(
            gap: 6,
            backgroundColor: Theme.of(  context).colorScheme.primary,
            color: Theme.of(  context).colorScheme.inversePrimary,
            activeColor: Theme.of(  context).colorScheme.inversePrimary,
            tabBackgroundColor: Theme.of(  context).colorScheme.surface,
            padding: const EdgeInsets.all(16),
            
            selectedIndex: _selectedIndex,
            onTabChange: _navigateBottomBar,
          
            tabs: const [
              // dashboard page button
              GButton(
                icon: Icons.home,
                text: "Dash",
                ),   
          
              // meal diary page button
              GButton(
                icon: Icons.breakfast_dining,
                text: "Meals",
                ),
          
              // activity recorder button
              GButton(
                icon: Icons.play_arrow,
                text: "Record",
                ),
          
              // progress page button
              GButton(
                icon: Icons.sports_gymnastics,
                text: "Progress",
                ),
              
              // settings page button
              GButton(
                icon: Icons.settings,
                text: "Settings",
                ),
            ],
          ),
        ),
      )
    );
  }
}