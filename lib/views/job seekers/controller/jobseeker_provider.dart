import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:huzzl_web/views/job%20seekers/my_jobs/model/applied_jobs.dart';

class JobseekerProvider extends ChangeNotifier {
  List<AppliedJobs> _listOfAppliedJobs = [];

  List<AppliedJobs> get listOfAppliedJobs => _listOfAppliedJobs;

  String getCurrentUserId() {
    return FirebaseAuth.instance.currentUser!.uid;
  }

  Future<List<AppliedJobs>> fetchAppliedJobs() async {
    try {
      final jobSeekerId = getCurrentUserId();
      // Clear the list to avoid duplication
      _listOfAppliedJobs.clear();

      // Fetch the sub-collection 'job_application' for the specific user
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(jobSeekerId)
          .collection('job_application')
          .get();

      // Convert the documents to AppliedJobs objects and add them to the list
      _listOfAppliedJobs = querySnapshot.docs
          .map((doc) => AppliedJobs.fromFirestore(doc))
          .toList();
      print("APPLIED DATA HERE: ${_listOfAppliedJobs.length}");

      return _listOfAppliedJobs;
    } catch (e) {
      print('Error fetching applied jobs: $e');
      return [];
    }
  }
}
