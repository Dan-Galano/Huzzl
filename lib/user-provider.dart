import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String? _loggedInUserId; // Nullable user ID

  UserProvider([this._loggedInUserId]); // Optional parameter

  String? get loggedInUserId => _loggedInUserId; // Getter for user ID

  // Method to update loggedInUserId
  void setLoggedInUserId(String userId) {
    if (_loggedInUserId != userId) { // Check for change
      _loggedInUserId = userId;
      notifyListeners(); // Notify listeners only if there is a change
    }
  }
}
