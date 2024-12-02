import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:huzzl_web/views/job%20seekers/home/job_provider.dart';
import 'package:provider/provider.dart';

class ApplicationProvider with ChangeNotifier {
  String? fullName;
  String? email;
  String? address;
  String? phoneNumber;
  List<String>? recruiterQuestionAnswer;

  final String uid;

  ApplicationProvider({required this.uid});

  // You can use a method to access the jobProvider when needed:
  JobProvider? getJobProvider(BuildContext context) {
    return Provider.of<JobProvider>(context, listen: false);
  }

  // Method to save review details or pag-apply
  Future<void> saveReviewDetails(
    BuildContext context,
    String jobId,
    String recruiterId,
    String jobTitle,
    List<String> preScreenAnswer,
  ) async {
    if (fullName == null ||
        email == null ||
        address == null ||
        phoneNumber == null) {
      // Ensure all fields are filled
      throw 'Please complete all fields before submitting.';
    }

    try {
      List<String> nameParts = fullName!.split(' ');

      // If there are at least two parts (first and last names), assign them accordingly
      String firstName = nameParts.isNotEmpty ? nameParts[0] : '';
      String lastName =
          nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
      DocumentReference jobApplicationRef = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('job_application')
          .add({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'address': address,
        'phoneNumber': phoneNumber,
        'applicationDate': DateTime.now(),
        'jobPostId': jobId,
        'recruiterId': recruiterId,
        'status': 'For Review',
        'dateRejected': null,
        'jobTitle': jobTitle,
        'preScreenAnswer': preScreenAnswer
      });

      print("Jobseeker applied");

      String jobApplicationDocId = jobApplicationRef.id;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(recruiterId)
          .collection('job_posts')
          .doc(jobId)
          .collection("candidates")
          .doc(getCurrentUserId())
          .set({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'address': address,
        'phoneNumber': phoneNumber,
        'applicationDate': DateTime.now(),
        'jobPostId': jobId,
        'recruiterId': recruiterId,
        'status': 'For Review',
        'dateRejected': null,
        'jobTitle': jobTitle,
        'jobApplicationDocId': jobApplicationDocId,
        'preScreenAnswer': preScreenAnswer
      });

      print("Jobseeker applied data put to the databaseeee!");

      notifyListeners(); // Notify listeners if needed
    } catch (e) {
      print(e);
      throw 'Error saving review details: $e';
    }
  }

  Future<void> saveReviewDetailsInRec(BuildContext context) async {
    if (fullName == null ||
        email == null ||
        address == null ||
        phoneNumber == null) {
      throw 'Please complete all fields before submitting.';
    }

    try {
      List<String> nameParts = fullName!.split(' ');
      String firstName = nameParts.isNotEmpty ? nameParts[0] : '';
      String lastName =
          nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
      final jobProvider = getJobProvider(context);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(jobProvider!.recruiterPosted) // Reference the user's document
          .collection('job_posts')
          .doc(
              jobProvider.jobpostId) // Reference the specific job post document
          .collection('jobseeker_applied') // New sub-collection
          .add({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'address': address,
        'phoneNumber': phoneNumber,
        'created_at': FieldValue.serverTimestamp(),
      });

      // Optional: Notify listeners if needed
      notifyListeners();
    } catch (e) {
      print(e);
      throw 'Error saving jobseeker application: $e';
    }
  }

  // Future<void> saveJobseekerApplication(
  //     BuildContext context, String userUid, String jobPostUid) async {
  //   if (fullName == null ||
  //       email == null ||
  //       address == null ||
  //       phoneNumber == null) {
  //     throw 'Please complete all fields before submitting.';
  //   }

  //   try {
  //     List<String> nameParts = fullName!.split(' ');
  //     String firstName = nameParts.isNotEmpty ? nameParts[0] : '';
  //     String lastName =
  //         nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

  //     await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(userUid) // Reference the user's document
  //         .collection('job_posts')
  //         .doc(jobPostUid) // Reference the specific job post document
  //         .collection('jobseeker_applied') // New sub-collection
  //         .add({
  //       'firstName': firstName,
  //       'lastName': lastName,
  //       'email': email,
  //       'address': address,
  //       'phoneNumber': phoneNumber,
  //       'created_at': FieldValue.serverTimestamp(),
  //     });

  //     // Optional: Notify listeners if needed
  //     notifyListeners();
  //   } catch (e) {
  //     throw 'Error saving jobseeker application: $e';
  //   }
  // }

  // Method to save question from recruiter
  Future<void> saveRecruiterQuestion(BuildContext context) async {
    if (recruiterQuestionAnswer == null || recruiterQuestionAnswer!.isEmpty) {
      throw 'Please answer the question from the recruiter.';
    }

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('job_application')
          .add({
        'recruiterQuestionAnswer': recruiterQuestionAnswer,
        'created_at': FieldValue.serverTimestamp(),
      });

      notifyListeners(); // Notify listeners if needed
    } catch (e) {
      throw 'Error saving recruiter question answer: $e';
    }
  }

  // Reset the provider's state (optional)
  void reset() {
    fullName = null;
    email = null;
    address = null;
    phoneNumber = null;
    recruiterQuestionAnswer = null;
    notifyListeners();
  }

  String getCurrentUserId() {
    return FirebaseAuth.instance.currentUser!.uid;
  }

  // Future<void> getJobPostDetails(String jobPostId, String recruiterId) async {
  //   try {
  //     await FirebaseFirestore.instance
  //         .collection("users")
  //         .doc(recruiterId)
  //         .collection('job_posts')
  //         .doc(jobPostId)
  //         .get();
  //     debugPrint("Fetch the jobpost details done!!");
  //   } catch (e) {
  //     debugPrint("Error in fetching the job post details: ${e.toString()}");
  //   }
  // }
}
