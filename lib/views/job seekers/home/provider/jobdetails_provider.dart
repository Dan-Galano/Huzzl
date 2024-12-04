import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class JobDetailsProvider with ChangeNotifier {
  List<Map<String, dynamic>> _jobPosts = [];
  Map<String, dynamic>? _selectedJobPost;

  List<Map<String, dynamic>> get jobPosts {
    return [..._jobPosts];
  }

  Map<String, dynamic>? get selectedJobPost {
    return _selectedJobPost;
  }


  // Fetch a specific job post by jobPostID
  Future<void> fetchJobDetailsByJobID(String userId, String jobPostID) async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('job_posts')
          .doc(jobPostID)
          .get();

      if (docSnapshot.exists) {
        _selectedJobPost = {
          'jobTitle': docSnapshot['jobTitle'],
          'jobIndustry': docSnapshot['jobIndustry'],
          'jobDescription': docSnapshot['jobDescription'],
          'numberOfPeopleToHire': docSnapshot['numberOfPeopleToHire'],
          'jobPostLocation': docSnapshot['jobPostLocation'],
          'jobType': docSnapshot['jobType'],
          'skills': List<String>.from(docSnapshot['skills']),
          'payRate': docSnapshot['payRate'],
          'supplementalPay': docSnapshot['supplementalPay'],
          'isResumeRequired': docSnapshot['isResumeRequired'],
          'applicationDeadline': docSnapshot['applicationDeadline'],
          'preScreenQuestions': List<String>.from(docSnapshot['preScreenQuestions']),
          'responsibilities': List<String>.from(docSnapshot['responsibilities']),
          'status': docSnapshot['status'],
          'posted_at': docSnapshot['posted_at'],
          'posted_by': docSnapshot['posted_by'],
          'jobPostID': docSnapshot.id, // Document ID
        };
        notifyListeners();
      } else {
        print("Job post with ID $jobPostID not found.");
      }
    } catch (error) {
      print("Error fetching job details by jobPostID: $error");
      throw error;
    }
  }
}
