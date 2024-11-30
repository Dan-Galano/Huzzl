import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProvider extends ChangeNotifier {
  String? _loggedInUserId; // Nullable user ID
  User? _user; // Nullable User

  // Constructor with optional userId and user
  UserProvider([this._loggedInUserId, this._user]);

  String? get loggedInUserId => _loggedInUserId; // Getter for user ID
  User? get user => _user; // Getter for User

  // Method to update loggedInUserId
  void setLoggedInUserId(String userId) {
    if (_loggedInUserId != userId) {
      _loggedInUserId = userId;
      notifyListeners(); // Notify listeners only if there is a change
    }
  }

  // Method to update user
  void setUser(User user) {
    if (_user?.uid != user.uid) {
      _user = user;
      _loggedInUserId = user.uid; // Automatically set the user ID
      notifyListeners(); // Notify listeners only if there is a change
    }
  }

  // Method to clear the user session (logout)
  void clearUser() {
    _loggedInUserId = null;
    _user = null;
    notifyListeners();
  }
}
