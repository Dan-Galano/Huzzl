import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart' as prefix;
import 'package:huzzl_web/views/recruiters/candidates_tab/models/candidate.dart';
import 'package:intl/intl.dart';
import 'package:emailjs/emailjs.dart' as emailjs;

class JobProviderCandidate extends ChangeNotifier {
  final List<Candidate> _candidates = [];
  List<Candidate> get candidates => _candidates;

  Future<String> fetchCurrentApplicationNotes(
      String userId, String jobPostId, String candidateId) async {
    try {
      final document = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('job_posts')
          .doc(jobPostId)
          .collection('candidates')
          .doc(candidateId)
          .get();

      if (document.exists) {
        return document.data()?['applicationNotes'] ??
            ''; // Return the notes, default to empty if not found
      }
    } catch (e) {
      print('Error fetching application notes: $e');
    }
    return ''; // Return an empty string if there's an error
  }

// Fetch candidates from Firebase Firestore
  Future<void> fetchCandidates(String jobPostId) async {
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
            applicationNotes: doc['applicationNotes']));
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
          "Can you create a acception/hired message for ${candidate.name}. Make it formal and pleasing. In a paragraph form. Just show the message no other information. Example: We're excited to welcome you! Your skills and enthusiasm truly impressed us, and we're confident you'll bring great value. Starting soon, we look forward to your contributions. Congratulations, and welcome aboard! Do not include anything like this [position], [company] like that.";
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

      countJobPosts();

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

      countJobPosts();

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

      countJobPosts();

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

  void contactedCandidate(
      String jobPostId, String id, String jobApplicationId) async {
    debugPrint("Moving to cantacted the candidateeee ...");
    // Update local candidate list
    for (var i = 0; i < _candidates.length; i++) {
      if (_candidates[i].id == id) {
        _candidates[i] = _candidates[i].copyWith(status: "Contacted");
        notifyListeners();
        break;
      }
    }

    debugPrint("Moving to cantacted done in local list");

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
          .update({'status': 'Contacted'}); // Field to update
      print("Candidate status updated to Contacted in candidate collection");

      await FirebaseFirestore.instance
          .collection('users') // Replace with the correct collection name
          .doc(id) // Candidate's document ID
          .collection("job_application")
          // .where('jobPostId', isEqualTo: jobPostId)
          .doc(jobApplicationId)
          .update({'status': 'Contacted'}); // Field to update
      print(
          "Candidate status updated to Contacted in job application collection");
    } catch (e) {
      print("Failed to update candidate status: $e");
    }
  }

  void hiringCandidate(
      String jobPostId, String id, String jobApplicationId) async {
    debugPrint("Hiringggg the candidateeee ...");
    // Update local candidate list
    for (var i = 0; i < _candidates.length; i++) {
      if (_candidates[i].id == id) {
        _candidates[i] = _candidates[i].copyWith(status: "Hired");
        notifyListeners();
        break;
      }
    }

    debugPrint("Moving to Hired done in local list");

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
          .update({
        'status': 'Hired',
        'hiredDate': DateTime.now(),
      }); // Field to update
      print("Candidate status updated to Hired in candidate collection");

      await FirebaseFirestore.instance
          .collection('users') // Replace with the correct collection name
          .doc(id) // Candidate's document ID
          .collection("job_application")
          // .where('jobPostId', isEqualTo: jobPostId)
          .doc(jobApplicationId)
          .update({'status': 'Hired'}); // Field to update
      print("Candidate status updated to Hired in job application collection");

      // fetchCandidate(jobPostId);
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

// Push notification to recruiter
  void pushNotificationToRecruiter(
    String jobPostId,
    String jobseekerId,
    String recruiterId,
  ) async {
    try {
      // Fetch jobseeker details
      DocumentSnapshot jobseekerSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(jobseekerId)
          .get();

      if (!jobseekerSnapshot.exists) {
        print('Jobseeker details not found.');
        return;
      }

      // Extract jobseeker details
      Map<String, dynamic> jobseekerData =
          jobseekerSnapshot.data() as Map<String, dynamic>;

      // Fetch job post details
      DocumentSnapshot jobPostSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(recruiterId)
          .collection('job_posts')
          .doc(jobPostId)
          .get();

      if (!jobPostSnapshot.exists) {
        print('Job post not found.');
        return;
      }

      // Extract job post details
      Map<String, dynamic> jobPostData =
          jobPostSnapshot.data() as Map<String, dynamic>;

      String currentJobTitles = "";
      String payRate = "";

      // Concatenate job titles
      if (jobseekerData['currentSelectedJobTitles'] != null) {
        for (var item in jobseekerData['currentSelectedJobTitles']) {
          currentJobTitles += "$item, ";
        }
        // Remove trailing comma and space
        if (currentJobTitles.isNotEmpty) {
          currentJobTitles =
              currentJobTitles.substring(0, currentJobTitles.length - 2);
        }
      }

      // Format pay rate
      Map<String, dynamic>? fetchedMap = jobseekerData['selectedPayRate'];
      if (fetchedMap != null) {
        int? minimum = fetchedMap['minimum'];
        int? maximum = fetchedMap['maximum'];
        String? rate = fetchedMap['rate'];

        if (minimum != null && maximum != null && rate != null) {
          payRate = "$minimum pesos - $maximum pesos $rate";
        }
      }

      String notifTitle = "New Job Application Received!";
      String message = """
You have a new application for your job posting: ${jobPostData['jobTitle']}.

Applicant Details:
Applicant name: ${jobseekerData['firstName']} ${jobseekerData['lastName']}
Applicant email: ${jobseekerData['email']}
Applicant phone number: ${jobseekerData['phoneNumber']}
Applicant current/experience job titles: $currentJobTitles
Applicant salary rate: $payRate


Please review their profile and application to assess their suitability for your job posting. This could be a great opportunity to connect with a qualified candidate!
""";

      // Push notification to the recruiter's notifications collection
      await FirebaseFirestore.instance
          .collection('users')
          .doc(recruiterId)
          .collection('notifications')
          .add({
        'recruiterId': recruiterId,
        'jobseekerId': jobseekerId,
        'jobPostId': jobPostId,
        'notifDate': DateTime.now(),
        'notifTitle': notifTitle,
        'notifMessage': message,
        'jobseekerName':
            "${jobseekerData['firstName']} ${jobseekerData['lastName']}",
        'jobTitle': jobPostData['jobTitle'] ?? 'Unknown',
        'status': 'not read',
      });

      print('Notification successfully added to recruiter!');
    } catch (e) {
      print('Error pushing notification to recruiter: $e');
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
      final candidatesCollection = jobPostsCollection
          .doc(jobPostId)
          .collection('candidates')
          .where('status', isEqualTo: 'Shortlisted');

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

  //PUSH NOTIFICATION INTO GMAIL
  void sendEmailNotification(
      String jobPostId, String jobseekerId, String typeOfNotif,
      {String? message}
      // String notifTitle,
      // String message,
      ) async {
    try {
      DocumentSnapshot jobSeekerSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(jobseekerId)
          .get();

      DocumentSnapshot jobPostSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(getCurrentUserId())
          .collection('job_posts')
          .doc(jobPostId)
          .get();

      if (jobSeekerSnapshot.exists && jobPostSnapshot.exists) {
        // Extract data from the fetched job post
        Map<String, dynamic> jobseekerData =
            jobSeekerSnapshot.data() as Map<String, dynamic>;

        Map<String, dynamic> jobPostData =
            jobPostSnapshot.data() as Map<String, dynamic>;

        String notifMessage = '';

        String name =
            "${jobseekerData['firstName']} ${jobseekerData['lastName']}";

        if (typeOfNotif == "Shortlisted") {
          notifMessage =
              "We are pleased to inform you that your application for the position of ${jobPostData['jobTitle']} on ${jobPostData['applicationDeadline']} has been shortlisted. Your qualifications and experience align well with what we are looking for, and we are excited to move forward with your application. Our team will be in touch soon with the next steps in the selection process. Thank you for your interest in joining our company, and we wish you the best of luck.";
        } else if (typeOfNotif == "Rejected") {
          if (message!.isEmpty) {
            notifMessage = "No name";
          } else {
            notifMessage = message;
          }
        } else if (typeOfNotif == "Hired") {
          if (message!.isEmpty) {
            notifMessage = "No name";
          } else {
            notifMessage = message;
          }
        } else if (typeOfNotif == "Interview") {
          if (message!.isEmpty) {
            notifMessage = "No name";
          } else {
            notifMessage = message;
          }
        }

        await emailjs.send(
          'service_stnt6vf',
          'template_ntgp3sj',
          {
            'to_email': '${jobseekerData["email"]}',
            'to_name': name,
            'from_name': 'HUZZL',
            'message': notifMessage,
          },
          const emailjs.Options(
              publicKey: '8AFjOEJFOSq0vgWdZ',
              privateKey: 'ucuViYA-GNRIC_KxDsOuG',
              limitRate: const emailjs.LimitRate(
                id: 'app',
                throttle: 10000,
              )),
        );
        print('SUCCESS!');
      }
    } catch (error) {
      if (error is emailjs.EmailJSResponseStatus) {
        print('ERROR... $error');
      }
      print(error.toString());
    }
  }

  //Activity logs
  Future<void> activityLogs({
    required String action,
    required String message,
  }) async {
    try {
      final userId = getCurrentUserId();

      // Fetch the user's first and last name from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (!userDoc.exists) {
        throw Exception("User document not found for userId: $userId");
      }

      final userData = userDoc.data() as Map<String, dynamic>;
      String firstName = userData['hiringManagerFirstName'] ?? "Unknown";
      String lastName = userData['hiringManagerLastName'] ?? "User";

      String userName = "$firstName $lastName";

      // Get the current date and time
      DateTime now = DateTime.now();
      String formattedDate =
          "${now.month}/${now.day}/${now.year} at ${now.hour}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? 'PM' : 'AM'}";

      // Prepare the activity log data
      Map<String, dynamic> logData = {
        "date": formattedDate,
        "user": userName,
        "action": action,
        "message": message,
      };

      // Reference to the Firestore collection
      CollectionReference activityLogCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('activityLogs');

      // Add the log to Firestore
      await activityLogCollection.add(logData);

      print("Activity log added successfully.");
    } catch (e) {
      print("Error adding activity log: $e");
    }
  }

  Future<List<Map<String, dynamic>>> fetchActivityLogs() async {
    try {
      // Query the user's activityLogs subcollection
      final userId = getCurrentUserId();
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('activityLogs')
          .orderBy('date',
              descending: true) // Order by date (most recent first)
          .get();

      // Map the results into a list of maps
      List<Map<String, dynamic>> activityLogs = snapshot.docs
          .map((doc) => {
                "id": doc.id,
                ...doc.data() as Map<String, dynamic>,
              })
          .toList();

      return activityLogs;
    } catch (e) {
      print("Error fetching activity logs: $e");
      return [];
    }
  }

  //Job Status Counts (Open, Pause, Close)
  int _openJobsCount = 0;
  int _pausedJobsCount = 0;
  int _closedJobsCount = 0;

  int get openJobsCount => _openJobsCount;
  int get pausedJobsCount => _pausedJobsCount;
  int get closedJobsCount => _closedJobsCount;

  Future<void> countJobPosts() async {
    try {
      QuerySnapshot jobPostsSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(getCurrentUserId())
          .collection('job_posts')
          .get();

      final jobPostsData = jobPostsSnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      // Get the current date
      final currentDate = DateTime.now();
      final DateFormat formatter = DateFormat('MMM d, yyyy'); // Date format

      // Separate jobs based on their status and deadline
      final openJobs = jobPostsData.where((jobPost) {
        final deadlineString = jobPost['applicationDeadline'];
        try {
          final deadlineDate = formatter.parse(deadlineString);
          return jobPost['status'] == 'open' &&
              deadlineDate.isAfter(currentDate);
        } catch (e) {
          print("Error parsing date for openJobs: $e");
          return false; // Exclude jobs with invalid or missing dates
        }
      }).toList();

      final pausedJobs = jobPostsData.where((jobPost) {
        final deadlineString = jobPost['applicationDeadline'];
        try {
          final deadlineDate = formatter.parse(deadlineString);
          return jobPost['status'] == 'paused' &&
              deadlineDate.isAfter(currentDate);
        } catch (e) {
          print("Error parsing date for pausedJobs: $e");
          return false; // Exclude jobs with invalid or missing dates
        }
      }).toList();

      final closedJobs = jobPostsData.where((jobPost) {
        final deadlineString = jobPost['applicationDeadline'];
        try {
          final deadlineDate = formatter.parse(deadlineString);
          return jobPost['status'] == 'closed' ||
              deadlineDate.isBefore(currentDate);
        } catch (e) {
          print("Error parsing date for closedJobs: $e");
          return true; // Count jobs with invalid or missing dates as closed
        }
      }).toList();

      // Update the counts in the state
      _openJobsCount = openJobs.length;
      _pausedJobsCount = pausedJobs.length;
      _closedJobsCount = closedJobs.length;

      notifyListeners();
    } catch (e) {
      print("Error fetching job count: $e");
    }
  }

  Future<void> updateNewApplicantGoal(String newGoal, String jobPostID) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(getCurrentUserId())
          .collection('job_posts')
          .doc(jobPostID)
          .update({
        'numberOfPeopleToHire': newGoal,
      });

      debugPrint("Updated successfully!");
    } catch (e) {
      debugPrint("Error in updating the numberOfApplicantToHire: $e");
    }
  }
}
