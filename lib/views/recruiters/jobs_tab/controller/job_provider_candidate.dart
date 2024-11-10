import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart' as prefix;
import 'package:huzzl_web/views/recruiters/candidates_tab/models/candidate.dart';
import 'package:intl/intl.dart';

class JobProviderCandidate extends ChangeNotifier {
  final List<Candidate> _candidates = [
    Candidate(
      id: '1',
      name: 'Allen James Alvaro',
      profession: "Drummer/Guitarist",
      jobPostId: "FXZd9yEXNPFpKfwXQ401",
      companyAppliedTo: "Cong's Unbilibabol Basketbol",
      applicationDate: DateTime.now(),
      status: "For Review",
      dateLastInterviewed: DateTime.now(),
      dateRejected: DateTime.now(),
      interviewCount: 0,
    ),
    Candidate(
      id: '2',
      name: 'Patrick John Tomas',
      jobPostId: "FXZd9yEXNPFpKfwXQ401",
      profession: "Drummer/Back-up Vocalist",
      companyAppliedTo: "December Avenue",
      applicationDate: DateTime.now(),
      status: "For Review",
      dateLastInterviewed: DateTime.now(),
      dateRejected: DateTime.now(),
      interviewCount: 0,
    ),
    Candidate(
      id: '3',
      name: 'Monica Ave',
      profession: "Drummer/Back-up Vocalist",
      jobPostId: "FXZd9yEXNPFpKfwXQ401",
      companyAppliedTo: "Rouge",
      applicationDate: DateTime.now(),
      status: "Shortlisted",
      dateLastInterviewed: DateTime.now(),
      dateRejected: DateTime.now(),
      interviewCount: 0,
    ),
    Candidate(
      id: '4',
      name: 'John Doe',
      jobPostId: "INPFHCDYGbCNBfu6fePe",
      profession: "Drummer/Back-up Vocalist",
      companyAppliedTo: "Sugarry Sweet",
      applicationDate: DateTime.now(),
      status: "Contacted",
      dateLastInterviewed: DateTime.now(),
      dateRejected: DateTime.now(),
      interviewCount: 0,
    ),
    Candidate(
      id: '5',
      name: 'John Wick',
      profession: "Metal Drummer",
      jobPostId: "INPFHCDYGbCNBfu6fePe",
      companyAppliedTo: "Sugarry Sweet",
      applicationDate: DateTime.now(),
      status: "Contacted",
      dateLastInterviewed: DateTime.now(),
      dateRejected: DateTime.now(),
      interviewCount: 2,
    ),
    Candidate(
      id: '6',
      name: 'Spongebob Squarepants',
      profession: "Reggae Drummer",
      jobPostId: "Bg4V4DXlBUO8xB0rEWSn",
      companyAppliedTo: "Halo",
      applicationDate: DateTime.now(),
      status: "Shortlisted",
      dateLastInterviewed: DateTime.now(),
      dateRejected: DateTime.now(),
      interviewCount: 1,
    ),
    Candidate(
      id: '7',
      name: 'Jake Gyllenhaal',
      profession: "Pop Drummer",
      jobPostId: "Bg4V4DXlBUO8xB0rEWSn",
      companyAppliedTo: "Halo",
      applicationDate: DateTime.now(),
      status: "For Review",
      dateLastInterviewed: DateTime.now(),
      dateRejected: DateTime.now(),
      interviewCount: 1,
    ),
    Candidate(
      id: '8',
      name: 'John Mayer',
      profession: "Blues Drummer",
      jobPostId: "Bg4V4DXlBUO8xB0rEWSn",
      companyAppliedTo: "Gravity",
      applicationDate: DateTime.now(),
      status: "Contacted",
      dateLastInterviewed: DateTime.now(),
      dateRejected: DateTime.now(),
      interviewCount: 1,
    ),
    Candidate(
      id: '9',
      name: 'Mike Portnoy',
      profession: "Progressive Metal Drummer",
      jobPostId: "Bg4V4DXlBUO8xB0rEWSn",
      companyAppliedTo: "Dream Theater",
      applicationDate: DateTime.now(),
      status: "Hired",
      dateLastInterviewed: DateTime.now(),
      dateRejected: DateTime.now(),
      interviewCount: 1,
    ),
    Candidate(
      id: '10',
      name: 'Jame Belmoro',
      profession: "Simpleng Drummer",
      jobPostId: "Bg4V4DXlBUO8xB0rEWSn",
      companyAppliedTo: "The Smokers",
      applicationDate: DateTime.now(),
      status: "For Review",
      dateLastInterviewed: DateTime.now(),
      dateRejected: DateTime.now(),
      interviewCount: 1,
    ),
  ];
  List<Candidate> get candidates => _candidates;

  String _rejectMessage = "";

  String get rejectMessage => _rejectMessage;

  Future<String> generateRejectMessage(String candidateId) async {
    Candidate candidate = findDataOfCandidate(candidateId)!;

    await dotenv.load();
    String geminiAPIKey = dotenv.env['GEMINI_API_KEY']!;
    String geminiModel = dotenv.env['MODEL']!;

    final model = prefix.GenerativeModel(
      model: geminiModel,
      apiKey: geminiAPIKey,
    );

    var prompt =
        "Can you create a rejection message for ${candidate.name}. Make it formal and pleasing. In a paragraph form. Just show the message no other information. Example: We regret to inform you that we have selected other candidates whose qualifications more closely align with the position requirements. Do not include anything like this [position], [company] like that.";
    final response = await model.generateContent([prefix.Content.text(prompt)]);
    print(response.text);
    _rejectMessage = response.text!;
    notifyListeners();

    return response.text!;
  }

  void clearRejectMessage() {
    _rejectMessage = "";
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

  void rejectCandidate(String id) {
    for (var i = 0; i < _candidates.length; i++) {
      if (_candidates[i].id == id) {
        _candidates[i] = _candidates[i].copyWith(status: "Rejected");
        notifyListeners();
        break;
      }
    }
  }

  void shortlistCandidate(String id) {
    for (var i = 0; i < _candidates.length; i++) {
      if (_candidates[i].id == id) {
        _candidates[i] = _candidates[i].copyWith(status: "Shortlisted");
        notifyListeners();
        break;
      }
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
}
