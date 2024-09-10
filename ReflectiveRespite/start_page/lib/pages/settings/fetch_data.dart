import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//Fetching the name and the email from the database

class UserData {
  static String? name;
  static String? email;

  static Future<void> fetchUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        name = userData.get('name');
        email = userData.get('email');
      } else {
        throw Exception('User is not logged in');
      }
    } catch (e) {
      // Handle error as needed
      SnackBar(content: Text("Error $e"));
    }
  }
}
