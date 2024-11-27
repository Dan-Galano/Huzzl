import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:huzzl_web/views/job%20seekers/my_jobs/model/applied_jobs.dart';
import 'package:huzzl_web/views/job%20seekers/my_jobs/model/notification.dart';
import 'package:intl/intl.dart';

class JobseekerProvider extends ChangeNotifier {
  List<AppliedJobs> _listOfAppliedJobs = [];
  List<NotificationModel> _notificationList = [];

  List<AppliedJobs> get listOfAppliedJobs => _listOfAppliedJobs;
  List<NotificationModel> get notificationList => _notificationList;

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

  Future<List<NotificationModel>> fetchNotification() async {
    try {
      final jobSeekerId = getCurrentUserId();
      _notificationList.clear();
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(jobSeekerId)
          .collection('notifications')
          .orderBy('notifDate', descending: true)
          .get();

      _notificationList = querySnapshot.docs
          .map((doc) => NotificationModel.fromFirestore(doc))
          .toList();
      print("Notification DATA HERE: ${_notificationList.length}");
      print("Notif title: ${_notificationList[0].jobTitle}");

      return _notificationList;
    } catch (e) {
      print('Error fetching notifications jobs: $e');
      return [];
    }
  }

  String formatDate(DateTime date) {
    return DateFormat('MMMM dd, yyyy').format(date);
  }

  void viewNotification(NotificationModel notif) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(notif.jobseekerId)
        .collection("notifications")
        .doc(notif.notificationId)
        .update({
      'status': 'read',
    });
    debugPrint("Updated status: nabasa na");
  }
}
