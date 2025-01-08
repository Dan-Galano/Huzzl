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
            'review_stars': reviewData['review_stars'].toString(),
            'review_summary': reviewData['review_summary'] ?? "",
          };
        }).toList();

        // Calculate the average rating
        if (_reviews.isNotEmpty) {
          _reviewStarsAverage = _reviews
                  .map((review) => double.parse(review['review_stars']))
                  .reduce((a, b) => a + b) /
              _reviews.length;
        }

        notifyListeners();
      } catch (error) {
        debugPrint("Error fetching reviews: $error");
        throw error;
      }
    }


}
