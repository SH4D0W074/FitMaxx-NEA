import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitmaxx/components/heat_map.dart';
import 'package:fitmaxx/services/heatmap_service.dart';
import 'package:flutter/material.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  
  DateTime _toDateTime(String yyyymmdd) {
    final parts = yyyymmdd.split('-');

    final yyyy = int.parse(parts[0]);
    final mm = int.parse(parts[1]);
    final dd = int.parse(parts[2]);

    return DateTime(yyyy, mm, dd);
  }

  int _toHeatLevel(int completedCount) {
    if (completedCount <= 0) return 0; // not included in dataset
    if (completedCount == 1) return 1;
    if (completedCount == 2) return 2;
    if (completedCount == 3) return 3;
    if (completedCount == 4) return 4;
    return 5; // 5+
  }
  
  
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //   'P R O G R E S S',
      //   style: Theme.of(context).textTheme.titleMedium?.copyWith(
      //   fontWeight: FontWeight.bold,
      //   fontSize: 18,
      // ),
      //   ),
      //   backgroundColor: Theme.of(context).colorScheme.primary,
      //   elevation: 0,
      //   centerTitle: true,
      // ),
      body: Container(
        child: StreamBuilder(
          stream: HeatmapService().watchWorkoutDays(FirebaseAuth.instance.currentUser!.uid), 
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final docs = snapshot.data?.docs ?? [];

              final Map<DateTime, int> datasets = {};
              for (final doc in docs) {
                final dateId = doc.id; // yyyymmdd
                final data = doc.data() ;

                final completedCount = (data["completedCount"] ?? 0) as int;
                final heatLevel = _toHeatLevel(completedCount);

                if (heatLevel > 0) {
                  datasets[_toDateTime(dateId)] = heatLevel;
                }
              }
              return MyHeatMap(datasets: datasets, startDateYYYYMMDD: "20260104");
            }
             
            else {
              return const Text("");
            }
          }
        ),
      ),
    );
  }
}