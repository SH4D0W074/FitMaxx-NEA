import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  String? uid;
  String? email;
  String? username;
  double? height;
  double? weight;
  int? age;
  int? targetCalories;
  double? consumedCalories;
  double? burnedCalories;

  UserModel({
    this.uid,
    this.email, 
    this.username,
    this.height,
    this.weight,
    this.age,
    this.targetCalories,
    this.consumedCalories,
    this.burnedCalories,
    });

  // Create a UserModel object from a Firestore document
  factory UserModel.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      email: data['email'],
      username: data['username'],
      height: data['height']?.toDouble(),
      weight: data['weight']?.toDouble(),
      age: data['age'],
      targetCalories: data['targetCalories'],
      consumedCalories: data['consumedCalories']?.toDouble(),
      burnedCalories: data['burnedCalories']?.toDouble(),
    );
  }

  // Convert UserModel object to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'username': username,
    };
  }
}