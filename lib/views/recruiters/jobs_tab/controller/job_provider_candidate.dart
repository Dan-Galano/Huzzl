import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart' as prefix;
import 'package:huzzl_web/views/recruiters/candidates_tab/models/candidate.dart';
import 'package:intl/intl.dart';

class JobProviderCandidate extends ChangeNotifier {
  final List<Candidate> _candidates = [
    // Candidate(
    //   id: '1',
    //   name: 'Allen James Alvaro',
    //   profession: "Architect",
    //   jobPostId: "FXZd9yEXNPFpKfwXQ401",
    //   companyAppliedTo: "Alvaro Co.",
    //   applicationDate: DateTime.now(),
    //   status: "For Review",
    //   dateLastInterviewed: DateTime.now(),
    //   dateRejected: DateTime.now(),
    //   interviewCount: 0,
    // ),
    // Candidate(
    //   id: '2',
    //   name: 'Patrick John Tomas',
    //   jobPostId: "FXZd9yEXNPFpKfwXQ401",
    //   profession: "Mechanical Engineer",
    //   companyAppliedTo: "EcoShpere Enterprises",
    //   applicationDate: DateTime.now(),
    //   status: "For Review",
    //   dateLastInterviewed: DateTime.now(),
    //   dateRejected: DateTime.now(),
    //   interviewCount: 0,
    // ),
    // Candidate(
    //   id: '3',
    //   name: 'Monica Ave',
    //   profession: "Data Scientist",
    //   jobPostId: "FXZd9yEXNPFpKfwXQ401",
    //   companyAppliedTo: "Pinnacle Dynamics",
    //   applicationDate: DateTime.now(),
    //   status: "Shortlisted",
    //   dateLastInterviewed: DateTime.now(),
    //   dateRejected: DateTime.now(),
    //   interviewCount: 0,
    // ),
    // Candidate(
    //   id: '4',
    //   name: 'John Luna',
    //   jobPostId: "INPFHCDYGbCNBfu6fePe",
    //   profession: "Digital Marketing Specialist",
    //   companyAppliedTo: "CoreVision Analytics",
    //   applicationDate: DateTime.now(),
    //   status: "Contacted",
    //   dateLastInterviewed: DateTime.now(),
    //   dateRejected: DateTime.now(),
    //   interviewCount: 0,
    // ),
    // Candidate(
    //   id: '5',
    //   name: 'Liora Artanez',
    //   profession: "Journalist",
    //   jobPostId: "INPFHCDYGbCNBfu6fePe",
    //   companyAppliedTo: "NovaVista Consulting",
    //   applicationDate: DateTime.now(),
    //   status: "Contacted",
    //   dateLastInterviewed: DateTime.now(),
    //   dateRejected: DateTime.now(),
    //   interviewCount: 2,
    // ),
    // Candidate(
    //   id: '6',
    //   name: 'Selara Nyverne',
    //   profession: "Graphic Designer",
    //   jobPostId: "Bg4V4DXlBUO8xB0rEWSn",
    //   companyAppliedTo: "BrightTrail Ventures",
    //   applicationDate: DateTime.now(),
    //   status: "Shortlisted",
    //   dateLastInterviewed: DateTime.now(),
    //   dateRejected: DateTime.now(),
    //   interviewCount: 1,
    // ),
    // Candidate(
    //   id: '7',
    //   name: 'Jake Gyllenhaal',
    //   profession: "Electrician",
    //   jobPostId: "Bg4V4DXlBUO8xB0rEWSn",
    //   companyAppliedTo: "Halo",
    //   applicationDate: DateTime.now(),
    //   status: "For Review",
    //   dateLastInterviewed: DateTime.now(),
    //   dateRejected: DateTime.now(),
    //   interviewCount: 1,
    // ),
    // Candidate(
    //   id: '8',
    //   name: 'John Mayer',
    //   profession: "Guitarist",
    //   jobPostId: "Bg4V4DXlBUO8xB0rEWSn",
    //   companyAppliedTo: "Gravity",
    //   applicationDate: DateTime.now(),
    //   status: "Contacted",
    //   dateLastInterviewed: DateTime.now(),
    //   dateRejected: DateTime.now(),
    //   interviewCount: 1,
    // ),
    // Candidate(
    //   id: '9',
    //   name: 'Mike Portnoy',
    //   profession: "Psychologist",
    //   jobPostId: "Bg4V4DXlBUO8xB0rEWSn",
    //   companyAppliedTo: "EcoFusion Technologies",
    //   applicationDate: DateTime.now(),
    //   status: "Hired",
    //   dateLastInterviewed: DateTime.now(),
    //   dateRejected: DateTime.now(),
    //   interviewCount: 1,
    // ),
    // Candidate(
    //   id: '10',
    //   name: 'Jame Belmoro',
    //   profession: "Producer",
    //   jobPostId: "Bg4V4DXlBUO8xB0rEWSn",
    //   companyAppliedTo: "Zenith Entertainment Studios",
    //   applicationDate: DateTime.now(),
    //   status: "For Review",
    //   dateLastInterviewed: DateTime.now(),
    //   dateRejected: DateTime.now(),
    //   interviewCount: 1,
    // ),
  ];
  List<Candidate> get candidates => _candidates;

// Fetch candidates from Firebase Firestore
  Future<void> fetchCandidate(String jobPostId) async {
    try {
      // Reference to the Firestore collection where candidates are stored
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(getCurrentUserId())
          .collection("job_posts")
          .doc(jobPostId)
          .collection('candidates')
          .get();

      // Clear the current list before adding new candidates
      _candidates.clear();

      // Loop through each document and map it to a Candidate object
      for (var doc in querySnapshot.docs) {
        _candidates.add(Candidate(
          id: doc.id,
          name: "${doc['firstName']} ${doc['lastName']}",
          email: doc['email'],
          profession: doc['jobTitle'],
          companyAppliedTo: doc['jobTitle'],
          jobPostId: doc['jobPostId'],
          applicationDate: (doc['applicationDate'] as Timestamp).toDate(),
          dateLastInterviewed: (doc['applicationDate'] as Timestamp).toDate(),
          interviewCount: 0,
          dateRejected: (doc['applicationDate'] as Timestamp).toDate(),
          status: doc['status'],
          jobApplicationDocId: doc['jobApplicationDocId'],
        ));
      }
      notifyListeners();
      print("List post: ${_candidates}");
      // You can call notifyListeners() here if you are using a ChangeNotifier provider
    } catch (e) {
      print('Error fetching candidates: $e');
    }
  }

  String getCurrentUserId() {
    return FirebaseAuth.instance.currentUser!.uid;
  }

  String _rejectMessage = "";
  String _hireMessage = "";

  String get rejectMessage => _rejectMessage;
  String get hireMessage => _hireMessage;

  Future<void> generateMessage(String candidateId, String typeOfMessage) async {
    Candidate candidate = findDataOfCandidate(candidateId)!;

    await dotenv.load();
    String geminiAPIKey = dotenv.env['GEMINI_API_KEY']!;
    String geminiModel = dotenv.env['MODEL']!;

    final model = prefix.GenerativeModel(
      model: geminiModel,
      apiKey: geminiAPIKey,
    );

    var prompt = "";

    if (typeOfMessage == "Reject") {
      prompt =
          "Can you create a rejection message for ${candidate.name}. Make it formal and pleasing. In a paragraph form. Just show the message no other information. Example: We regret to inform you that we have selected other candidates whose qualifications more closely align with the position requirements. Do not include anything like this [position], [company] like that.";
    } else if (typeOfMessage == "Hire") {
      prompt =
          "Can you create a acception/hired message for ${candidate.name}. Make it formal and pleasing. In a paragraph form. Just show the message no other information. Example: We're excited to welcome you to [Company Name] as our new [Job Title]! Your skills and enthusiasm truly impressed us, and we're confident you'll bring great value to our team. Starting on [Proposed Start Date], we look forward to your contributions. Congratulations, and welcome aboard!";
    }
    final response = await model.generateContent([prefix.Content.text(prompt)]);
    print(response.text);
    if (typeOfMessage == "Reject") {
      _rejectMessage = response.text!;
    } else if (typeOfMessage == "Hire") {
      _hireMessage = response.text!;
    }

    notifyListeners();

    // return response.text!;
  }

  void clearMessage(String typeOfMessage) {
    if (typeOfMessage == "Reject") {
      _rejectMessage = "";
    } else {
      _hireMessage = "";
    }
    notifyListeners();
  }

  Future<void> closeJobPost(String userDoc, String jobPostDoc) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userDoc)
          .collection('job_posts')
          .doc(jobPostDoc)
          .update({
        "status": "closed",
      });
      print("Sub-collection document updated successfully!");
      notifyListeners();
    } catch (e) {
      print("Error updating sub-collection document: $e");
    }
  }

  Future<void> pauseJobPost(String userDoc, String jobPostDoc) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userDoc)
          .collection('job_posts')
          .doc(jobPostDoc)
          .update({
        "status": "paused",
      });
      print("Sub-collection document updated successfully!");
      notifyListeners();
    } catch (e) {
      print("Error updating sub-collection document: $e");
    }
  }

  Future<void> reOpenJobPost(String userDoc, String jobPostDoc) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userDoc)
          .collection('job_posts')
          .doc(jobPostDoc)
          .update({
        "status": "open",
      });
      print("Sub-collection document updated successfully!");
      notifyListeners();
    } catch (e) {
      print("Error updating sub-collection document: $e");
    }
  }

  void rejectCandidate(
      String jobPostId, String id, String jobApplicationId) async {
    debugPrint("Rejecting candidate ....");
    for (var i = 0; i < _candidates.length; i++) {
      if (_candidates[i].id == id) {
        _candidates[i] = _candidates[i].copyWith(status: "Rejected");
        notifyListeners();
        break;
      }
    }

    debugPrint("Rejected candidate in local list");

    // Update candidate status in Firestore
    try {
      await FirebaseFirestore.instance
          .collection('users') // Replace with the correct collection name
          .doc(getCurrentUserId()) // Candidate's document ID
          .collection("job_posts")
          .doc(jobPostId)
          .collection("candidates")
          .doc(id)
          .update({'status': 'Rejected'}); // Field to update
      print("Candidate status Rejected in candidate collection");

      await FirebaseFirestore.instance
          .collection('users') // Replace with the correct collection name
          .doc(id) // Candidate's document ID
          .collection("job_application")
          // .where('jobPostId', isEqualTo: jobPostId)
          .doc(jobApplicationId)
          .update({'status': 'Rejected'}); // Field to update
      print(
          "Candidate status Rejectedddddddddddddddddddddddddddddddddd in job application");
    } catch (e) {
      print("Failed to update candidate status: $e");
    }
  }

  // void shortlistCandidate(String id) {
  //   for (var i = 0; i < _candidates.length; i++) {
  //     if (_candidates[i].id == id) {
  //       _candidates[i] = _candidates[i].copyWith(status: "Shortlisted");
  //       notifyListeners();
  //       break;
  //     }
  //   }
  // }

  void shortlistCandidate(
      String jobPostId, String id, String jobApplicationId) async {
    debugPrint("Shorlisting candidateeee ...");
    // Update local candidate list
    for (var i = 0; i < _candidates.length; i++) {
      if (_candidates[i].id == id) {
        _candidates[i] = _candidates[i].copyWith(status: "Shortlisted");
        notifyListeners();
        break;
      }
    }

    debugPrint("Shortlisting company done in local list");

    // Update candidate status in Firestore
    try {
      //Update the candidate collection
      await FirebaseFirestore.instance
          .collection('users') // Replace with the correct collection name
          .doc(getCurrentUserId()) // Candidate's document ID
          .collection("job_posts")
          .doc(jobPostId)
          .collection("candidates")
          .doc(id)
          .update({'status': 'Shortlisted'}); // Field to update
      print("Candidate status updated to Shortlisted in candidate collection");

      await FirebaseFirestore.instance
          .collection('users') // Replace with the correct collection name
          .doc(id) // Candidate's document ID
          .collection("job_application")
          // .where('jobPostId', isEqualTo: jobPostId)
          .doc(jobApplicationId)
          .update({'status': 'Shortlisted'}); // Field to update
      print(
          "Candidate status updated to Shortlisted in job application collection");
    } catch (e) {
      print("Failed to update candidate status: $e");
    }
  }

  void pushNotificationToJobseeker(
    String jobPostId,
    String jobseekerId,
    String notifTitle,
    String message,
  ) async {
    try {
      // Fetch the job post details
      DocumentSnapshot jobPostSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(getCurrentUserId())
          .collection('job_posts')
          .doc(jobPostId)
          .get();

      if (jobPostSnapshot.exists) {
        // Extract data from the fetched job post
        Map<String, dynamic> jobPostData =
            jobPostSnapshot.data() as Map<String, dynamic>;

        // Add necessary data to the second collection
        await FirebaseFirestore.instance
            .collection('users')
            .doc(jobseekerId)
            .collection('notifications')
            .add({
          'recruiterId': getCurrentUserId(),
          'jobseekerId': jobseekerId,
          'jobpostId': jobPostId,
          'notifDate': DateTime.now(),
          'notifTitle': notifTitle,
          'notifMessage': message,
          'jobTitle': jobPostData['jobTitle'],
          'status': 'not read',
        });

        print('Notification successfully added!');
      } else {
        print('Job post does not exist.');
      }
    } catch (e) {
      print('Error fetching job post details or adding notification: $e');
    }
  }

  void moveBackCandidateForReview(String id) {
    for (var i = 0; i < _candidates.length; i++) {
      if (_candidates[i].id == id) {
        _candidates[i] = _candidates[i].copyWith(status: "For Review");
        notifyListeners();
        break;
      }
    }
  }

  Candidate? findDataOfCandidate(String candidateId) {
    for (var candidate in _candidates) {
      if (candidateId == candidate.id) {
        return candidate;
      }
    }
    notifyListeners();
    return null;
  }

  String formatApplicationDate(DateTime applicationDate) {
    String formattedDate =
        DateFormat("dd MMMM yyyy, h:mma").format(applicationDate);
    return formattedDate.toLowerCase();
  }

  Future<String> getCurrentUserName() async {
    final userId = getCurrentUserId();
    // Fetch the document using the current user's ID
    // return userId;
    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    // Extract the first name and last name fields
    String firstName = doc['hiringManagerFirstName'] ?? '';
    String lastName = doc['hiringManagerLastName'] ?? '';

    // Concatenate the names and return the result
    print("NAMEEEEE: $firstName $lastName");
    return '$firstName $lastName';
  }

  void forInterviewCandidate(String candidateId) {
    for (var i = 0; i < _candidates.length; i++) {
      if (_candidates[i].id == candidateId) {
        _candidates[i] = _candidates[i].copyWith(status: "For Interview");
        notifyListeners();
        break;
      }
    }
    debugPrint("Candidate $candidateId is for interview");
  }

  List<Candidate> _allCandidatesForCalendar = [];
  List<Candidate> get allCandidatesForCalendar => _allCandidatesForCalendar;

    Future<List<Candidate>> fetchAllCandidatesForCalendar() async {
    final userId = getCurrentUserId();
    List<Candidate> candidatesForCalendar = [];

    // Reference to the users collection with filter for recruiters
    final jobPostsCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('job_posts');

    // Fetch all job posts
    QuerySnapshot jobPostsSnapshot = await jobPostsCollection.get();

    // Iterate over each job post
    for (var jobPostDoc in jobPostsSnapshot.docs) {
      final jobPostId = jobPostDoc.id;

      // Reference to the candidates subcollection within each job post
      final candidatesCollection =
          jobPostsCollection.doc(jobPostId).collection('candidates').where('status', isEqualTo: 'Shortlisted');

      // Fetch candidates for the current job post
      QuerySnapshot candidatesSnapshot = await candidatesCollection.get();

      // Iterate over candidates and map them to the Candidate model
      for (var candidateDoc in candidatesSnapshot.docs) {
        final data = candidateDoc.data() as Map<String, dynamic>;

        // Create a Candidate object
        Candidate candidate = Candidate(
          id: candidateDoc.id,
          jobPostId: jobPostId,
          email: data['email'] ?? '',
          name: "${data['firstName']} ${data['lastName']}" ?? '',
          profession: data['jobTitle'] ?? '',
          companyAppliedTo: data['recruiterId'] ?? '',
          applicationDate: (data['applicationDate'] as Timestamp).toDate(),
          dateLastInterviewed: data['dateLastInterviewed'] != null
              ? (data['dateLastInterviewed'] as Timestamp).toDate()
              : null,
          interviewCount: data['interviewCount'] != null
              ? data['interviewCount'] as int
              : null,
          dateRejected: data['dateRejected'] != null
              ? (data['dateRejected'] as Timestamp).toDate()
              : null,
          status: data['status'] ?? '',
          jobApplicationDocId: data['jobApplicationDocId'],
        );

        // Add to the temporary list
        candidatesForCalendar.add(candidate);
      }
    }

    debugPrint("Fetch all candidates in all job posts within this recruiter");

    return candidatesForCalendar;
  }
}
