import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CompanyProfileProvider with ChangeNotifier {
  String _ceoFirstName = "";
  String _ceoLastName = "";
  String _barangay = "";
  String _locationOtherInformation = "";
  String _city = "";
  String _province = "";
  String _region = "";
  String _companyDescription = "";
  String _companySize = "";
  String _industry = "";
  String _companyWebsite = "";
  String _companyName = "";
  List<Map<String, dynamic>> _reviews = [];
  double _reviewStarsAverage = 0.0;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  double get reviewStarsAverage {
    return _reviewStarsAverage;
  }

  String get companyName => _companyName;
  String get ceoFirstName => _ceoFirstName;
  String get ceoLastName => _ceoLastName;
  String get locationOtherInformation => _locationOtherInformation;
  String get barangay => _barangay;
  String get city => _city;
  String get province => _province;
  String get region => _region;
  String get companyDescription => _companyDescription;
  String get companySize => _companySize;
  String get industry => _industry;
  String get companyWebsite => _companyWebsite;
  List<Map<String, dynamic>> get reviews => _reviews;

  Future<void> fetchCompanyDetails(String userId) async {
    try {
      final companyInfoSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('company_information')
          .limit(1)
          .get();

      if (companyInfoSnapshot.docs.isNotEmpty) {
        final companyData = companyInfoSnapshot.docs.first.data();

        _companyName = companyData['companyName'] ?? "";
        _ceoFirstName = companyData['ceoFirstName'] ?? "";
        _ceoLastName = companyData['ceoLastName'] ?? "";
        _locationOtherInformation =
            companyData['locationOtherInformation'] ?? "";
        _barangay = companyData['barangay'] ?? "";
        _city = companyData['city'] ?? "";
        _province = companyData['province'] ?? "";
        _region = companyData['region'] ?? "";
        _companyDescription = companyData['companyDescription'] ?? "";
        _companySize = companyData['companySize'] ?? "";
        _industry = companyData['industry'] ?? "";
        _companyWebsite = companyData['companyWebsite'] ?? "";

        notifyListeners();
      } else {
        throw Exception("No company information found.");
      }
    } catch (error) {
      debugPrint("Error fetching company details: $error");
      throw error;
    }
  }

  Future<void> fetchAllReviews(String userId) async {
    try {
      final reviewsSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('reviews')
          .orderBy('created_at', descending: true)
          .get();

      _reviews = reviewsSnapshot.docs.map((doc) {
        final reviewData = doc.data();
        return {
          'created_at': (reviewData['created_at'] as Timestamp).toDate(),
          'review_branch': reviewData['review_branch'] ?? "",
          'review_description': reviewData['review_description'] ?? "",
          'review_job_date':
              (reviewData['review_job_date'] as Timestamp).toDate(),
          'review_position': reviewData['review_position'] ?? "",
          // Ensure reviewStars is parsed as an int or double
          'review_stars': reviewData['review_stars'] is int
              ? reviewData['review_stars']
              : int.tryParse(reviewData['review_stars'].toString()) ?? 0,
          'review_summary': reviewData['review_summary'] ?? "",
        };
      }).toList();

      // Calculate the average rating
      if (_reviews.isNotEmpty) {
        _reviewStarsAverage = _reviews
                .map((review) => review['review_stars'] is int
                    ? review['review_stars'] as int
                    : (review['review_stars'] as double))
                .reduce((a, b) => a + b) /
            _reviews.length;
      }

      notifyListeners();
    } catch (error) {
      debugPrint("Error fetching reviews: $error");
      throw error;
    }
  }

  Future<void> addNewReview({
    required String userId,
    required String reviewBranch,
    required String reviewDescription,
    required DateTime reviewJobDateStart,
    required DateTime reviewJobDate,
    required String reviewPosition,
    required int reviewStars, // Ensure reviewStars is passed as an int
    required String reviewSummary,
  }) async {
    try {
      // Ensure that required fields are not empty
      if (reviewBranch.isEmpty ||
          reviewDescription.isEmpty ||
          reviewPosition.isEmpty ||
          reviewSummary.isEmpty) {
        throw Exception("Required fields cannot be empty.");
      }

      final reviewData = {
        'created_at': Timestamp.now(),
        'review_branch': reviewBranch,
        'review_description': reviewDescription,
        'review_job_date': Timestamp.fromDate(reviewJobDate),
        'review_position': reviewPosition,
        'review_stars':
            reviewStars, // This is passed as an int, so ensure Firestore stores it as such
        'review_summary': reviewSummary,
      };

      // Add review data to Firestore
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('reviews')
          .add(reviewData);

      // Update the reviews list in memory
      _reviews.add({
        ...reviewData,
        'created_at': DateTime.now(),
      });

      // Recalculate the average rating safely
      if (_reviews.isNotEmpty) {
        _reviewStarsAverage = _reviews
                .map((review) => review['review_stars'] as int)
                .reduce((a, b) => a + b) /
            _reviews.length;
      }

      // Notify listeners that the state has changed
      notifyListeners();
    } catch (e) {
      debugPrint("Error adding new review: $e");
      throw e; // Re-throw the error to be handled by the caller
    }
  }

  // Future<void> deleteAllReviewsForRecruiters() async {
  //   try {
  //     // Fetch all users from the Firestore collection
  //     final usersSnapshot = await _firestore.collection('users').get();

  //     // Loop through each user
  //     for (var userDoc in usersSnapshot.docs) {
  //       final userData = userDoc.data();
  //       final userId = userDoc.id;

  //       // Check if the user is a recruiter
  //       if (userData['role'] == 'recruiter') {
  //         // If the user is a recruiter, fetch all reviews for this user
  //         final reviewsSnapshot = await _firestore
  //             .collection('users')
  //             .doc(userId)
  //             .collection('reviews')
  //             .get();

  //         // Loop through the reviews and delete them
  //         for (var doc in reviewsSnapshot.docs) {
  //           await doc.reference.delete();
  //         }

  //         // Optionally clear the reviews list in memory (if it's being used)
  //         _reviews.clear();

  //         debugPrint('Deleted all reviews for recruiter: $userId');
  //       }
  //     }

  //     // Notify listeners that the state has changed
  //     notifyListeners();
  //   } catch (error) {
  //     debugPrint("Error deleting reviews: $error");
  //     throw error; // Re-throw the error to be handled by the caller
  //   }
  // }
}
