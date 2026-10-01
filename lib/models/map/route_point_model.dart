import 'package:cloud_firestore/cloud_firestore.dart';

class RoutePoint {
  final double lat;
  final double lng;
  final DateTime? t;
  final double? speed;
  final double? accuracy;

  RoutePoint({
    required this.lat,
    required this.lng,
    this.t,
    this.speed,
    this.accuracy,
  });

  Map<String, dynamic> toMap() {
    return {
      'lat': lat,
      'lng': lng,
      't': FieldValue.serverTimestamp(),
      'speed': speed,
      'accuracy': accuracy,
    };
  }

  static RoutePoint fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return RoutePoint(
      lat: (data['lat'] as num).toDouble(),
      lng: (data['lng'] as num).toDouble(),
      t: (data['t'] as Timestamp?)?.toDate(),
      speed: (data['speed'] as num?)?.toDouble(),
      accuracy: (data['accuracy'] as num?)?.toDouble(),
    );
  }
}
