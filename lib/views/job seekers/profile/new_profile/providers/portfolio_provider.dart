import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PortfolioProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _portfolioFileName;
  String? get portfolioFileName => _portfolioFileName;

  // Fetch portfolio file name from Firestore based on the user ID
  Future<void> fetchPortfolio(String userId) async {
    try {
      // Get the user's document from Firestore
      DocumentSnapshot docSnapshot =
          await _firestore.collection('users').doc(userId).get();

      // Check if the document exists and fetch the portfolioFileName
      if (docSnapshot.exists) {
        _portfolioFileName = docSnapshot['portfolioFileName'];
      } else {
        _portfolioFileName = null; // No portfolio file name available
      }

      // Notify listeners that the data has been updated
      notifyListeners();
    } catch (e) {
      print('Error fetching portfolio file name: $e');
      _portfolioFileName = null;
      notifyListeners(); // Notify listeners even if there is an error
    }
  }

  // Update portfolio file name in Firestore
  Future<bool> updatePortfolio(
      String userId, String newFileName) async {
    try {
      // Update the portfolioFileName field in Firestore
      await _firestore.collection('users').doc(userId).set(
        {'portfolioFileName': newFileName},
        SetOptions(merge: true), // Merge to avoid overwriting other fields
      );

      // Update the local portfolioFileName state
      _portfolioFileName = newFileName;

      // Notify listeners that the data has been updated
      notifyListeners();

      return true; // Success
    } catch (e) {
      print('Error updating portfolio file name: $e');
      return false; // Failure
    }
  }

  Future<bool> deletePortfolio(String userId) async {
    try {
      // Update the portfolioFileName field in Firestore
      await _firestore.collection('users').doc(userId).update({
        'portfolioFileName':
            FieldValue.delete(), // Deletes only the specified field
      });

      // Update the local portfolioFileName state
      _portfolioFileName = null;

      // Notify listeners that the data has been updated
      notifyListeners();

      return true; // Success
    } catch (e) {
      print('Error updating portfolio file name: $e');
      return false; // Failure
    }
  }
}
