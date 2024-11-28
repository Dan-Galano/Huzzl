import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/calendar_ui/interview_model.dart';
import 'package:huzzl_web/widgets/buttons/blue/bluefilled_boxbutton.dart';
import 'package:huzzl_web/widgets/buttons/gray/grayfilled_boxbutton.dart';
import 'package:permission_handler/permission_handler.dart';

class InterviewProvider extends ChangeNotifier {
  bool _startInterview = false;

  bool get startInterview => _startInterview;

  //Here: important variable
  int? _remoteUid;
  bool _localUserJoined = false;
  RtcEngine? _engine;

  String? _appId;
  String? _token;
  String? _channel;

  int? get remoteUid => _remoteUid;
  bool get localUserJoined => _localUserJoined;
  RtcEngine? get engine => _engine;
  String? get channel => _channel;

  bool _isMuted = false;
  bool _isCameraOff = false;

  bool get isMuted => _isMuted;
  bool get isCameraOff => _isCameraOff;

  void toggleStartInterview() {
    _startInterview = !_startInterview;
    notifyListeners();
  }

  void startInterviewFunction(BuildContext context) async {
    await dotenv.load();
    showConfirmationToStartInterview(context);
  }

  //initialized agora
  Future<void> initAgora() async {
    await dotenv.load();
    _appId = dotenv.env['AGORA_APP_ID']!;
    _token = dotenv.env['AGORA_TOKEN']!;
    _channel = dotenv.env['AGORA_CHANNEL']!;

    await [Permission.microphone, Permission.camera].request();

    //create the engine
    _engine = createAgoraRtcEngine();
    await _engine!.initialize(RtcEngineContext(
      appId: _appId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));

    _engine!.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("local user ${connection.localUid} joined");
          _localUserJoined = true;
          notifyListeners();
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("remote user $remoteUid joined");
          _remoteUid = remoteUid;
          notifyListeners();
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          debugPrint("remote user $remoteUid left channel");
          _remoteUid = null;
          notifyListeners();
        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          debugPrint(
              '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
        },
      ),
    );

    await _engine!.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine!.enableVideo();
    await _engine!.startPreview();

    await _engine!.joinChannel(
      token: _token!,
      channelId: _channel!,
      uid: 0,
      options: const ChannelMediaOptions(),
    );

    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();

    _dispose();
    notifyListeners();
  }

  Future<void> _dispose() async {
    await _engine!.leaveChannel();
    await _engine!.release();
    notifyListeners();
  }

  // End the call
  Future<void> endCall() async {
    await _engine?.leaveChannel();
    _remoteUid = null;
    _localUserJoined = false;
    notifyListeners();
  }

// Toggle mute status
  void toggleMute() {
    _isMuted = !_isMuted;
    _engine?.muteLocalAudioStream(_isMuted);
    notifyListeners();
  }

// Toggle camera on/off
  void toggleCamera() {
    _isCameraOff = !_isCameraOff;
    _engine?.muteLocalVideoStream(_isCameraOff);
    notifyListeners();
  }

  void showConfirmationToStartInterview(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            width: 600, // Set a specific width
            height: 250, // Set a specific height
            child: Card(
              color: Colors.white, // Set the card color to white
              elevation: 4, // Optional elevation for shadow effect
              margin: EdgeInsets.zero, // Remove default margin
              child: Padding(
                padding:
                    const EdgeInsets.all(20), // Add padding inside the card
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Top right close button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10), // Spacing
                    // Centered content
                    const Center(
                      child: Column(
                        children: const [
                          Text(
                            "Start interview?",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Galano',
                            ),
                          ),
                          Text(
                            "Are you sure you want to start the interview for this candidate?",
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'Galano',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30), // Spacing
                    // Button centered below text
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        BlueFilledBoxButton(
                          onPressed: () {
                            _startInterview = !_startInterview;
                            initAgora();
                            notifyListeners();
                            Navigator.of(context).pop();
                          },
                          text: "Yes",
                          width: 180,
                        ),
                        GrayFilledBoxButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          text: "No",
                          width: 180,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String getCurrentUserId() {
    return FirebaseAuth.instance.currentUser!.uid;
  }

  //HERE TO SAVE THE INTERVIEW SCHEDULEEEEEE
  List<InterviewEvent> _events = [];
  List<InterviewEvent> get events => _events;

  // void saveInterview(
  //     InterviewEvent e, String jobseekerId, String jobPostId) async {
  //   final recruiterId = getCurrentUserId();

  //   // Default value for location if it's null
  //   final location = e.location ?? 'No Location';

  //   debugPrint("TO BE SAVED TO DB:\n"
  //       "Recruiter ID: $recruiterId\n"
  //       "Jobseeker ID: $jobseekerId\n"
  //       "Job Post ID: $jobPostId\n"
  //       "Interview Details:\n"
  //       "- Applicant: ${e.applicant}\n"
  //       "- Title: ${e.title}\n"
  //       "- Type: ${e.type}\n"
  //       "- Interviewers: ${e.interviewers}\n"
  //       "- Date: ${e.date}\n"
  //       "- Start Time: ${e.startTime}\n"
  //       "- End Time: ${e.endTime}\n"
  //       "- Notes: ${e.notes}\n"
  //       "- Location: $location");

  //   try {
  //     // Save interview to recruiter's collection
  //     await FirebaseFirestore.instance
  //         .collection("users")
  //         .doc(recruiterId)
  //         .collection('job_posts')
  //         .doc(jobPostId)
  //         .collection('interviews')
  //         .add({
  //       'applicant': e.applicant,
  //       'title': e.title,
  //       'type': e.type,
  //       'interviewers': e.interviewers,
  //       'date': e.date,
  //       'startTime': e.startTime,
  //       'endTime': e.endTime,
  //       'notes': e.notes,
  //       'location': location, // Handle null or empty location
  //       'recruiterId': recruiterId,
  //       'jobseekerId': jobseekerId,
  //       'jobPostId': jobPostId,
  //     });

  //     debugPrint('Interview schedule has been saved IN RECRUITER');

  //     // Save interview to jobseeker's collection
  //     await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(jobseekerId)
  //         .collection('interviewSched')
  //         .add({
  //       'applicant': e.applicant,
  //       'title': e.title,
  //       'type': e.type,
  //       'interviewers': e.interviewers,
  //       'date': e.date,
  //       'startTime': e.startTime as String,
  //       'endTime': e.endTime,
  //       'notes': e.notes,
  //       'location': location, // Handle null or empty location
  //       'recruiterId': recruiterId,
  //       'jobseekerId': jobseekerId,
  //       'jobPostId': jobPostId,
  //     });

  //     debugPrint('Interview schedule has been saved IN JOBSEEKER');

  //     // Optionally fetch interviews for debugging purposes
  //     await fetchInterviews(recruiterId, jobPostId);
  //   } catch (e) {
  //     debugPrint("Error in saving the interview: $e");
  //   }
  // }

  void saveInterview(InterviewEvent e, String jobseekerId, String jobPostId,
      String candidateId, String jobApplicationId) async {
    final recruiterId = getCurrentUserId();

    // Default value for location if it's null
    final location = e.location ?? 'No Location';

    // Convert TimeOfDay to string representation
    final startTimeString = e.startTime != null
        ? '${e.startTime!.hour.toString().padLeft(2, '0')}:${e.startTime!.minute.toString().padLeft(2, '0')}'
        : null;

    final endTimeString = e.endTime != null
        ? '${e.endTime!.hour.toString().padLeft(2, '0')}:${e.endTime!.minute.toString().padLeft(2, '0')}'
        : null;

    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(recruiterId)
          .collection('job_posts')
          .doc(jobPostId)
          .collection('interviews')
          .add({
        'applicant': e.applicant,
        'title': e.title,
        'type': e.type,
        'interviewers': e.interviewers,
        'date': e.date,
        'startTime': startTimeString, // Storing as string
        'endTime': endTimeString, // Storing as string
        'notes': e.notes,
        'location': location,
        'recruiterId': recruiterId,
        'jobseekerId': jobseekerId,
        'jobPostId': jobPostId,
      });

      debugPrint('Interview schedule has been saved.');

      // Save interview to jobseeker's collection
      await FirebaseFirestore.instance
          .collection('users')
          .doc(jobseekerId)
          .collection('interviewSched')
          .add({
        'applicant': e.applicant,
        'title': e.title,
        'type': e.type,
        'interviewers': e.interviewers,
        'date': e.date,
        'startTime': startTimeString,
        'endTime': endTimeString,
        'notes': e.notes,
        'location': location, // Handle null or empty location
        'recruiterId': recruiterId,
        'jobseekerId': jobseekerId,
        'jobPostId': jobPostId,
      });

      debugPrint('Interview schedule has been saved IN JOBSEEKER');

      await FirebaseFirestore.instance
          .collection('users') // Replace with the correct collection name
          .doc(jobseekerId) // Candidate's document ID
          .collection("job_application")
          // .where('jobPostId', isEqualTo: jobPostId)
          .doc(jobApplicationId)
          .update({'status': 'For Interview'}); // Field to update
      print(
          "Candidate status updated to For Interview in job application collection");

      await fetchAllInterviews();
    } catch (e) {
      debugPrint("Error in saving the interview: $e");
    }
  }

  // Future<void> fetchInterviews(String recruiterId, String jobPostId) async {
  //   try {
  //     // Fetch interviews from Firestore
  //     final querySnapshot = await FirebaseFirestore.instance
  //         .collection("users")
  //         .doc(recruiterId)
  //         .collection('job_posts')
  //         .doc(jobPostId)
  //         .collection('interviews')
  //         .get();

  //     // Clear the local list before adding new data
  //     _events.clear();

  //     // Map Firestore documents to InterviewEvent objects
  //     for (var doc in querySnapshot.docs) {
  //       final data = doc.data();

  //       _events.add(
  //         InterviewEvent(
  //           applicant: data['applicant'] as String?,
  //           title: data['title'] as String?,
  //           type: data['type'] as String?,
  //           interviewers: (data['interviewers'] as List<dynamic>?)
  //               ?.map((e) => e as String)
  //               .toList(),
  //           date: (data['date'] != null)
  //               ? (data['date'] as Timestamp).toDate()
  //               : null,
  //           startTime: _convertToTimeOfDay(data['startTime']),
  //           endTime: _convertToTimeOfDay(data['endTime']),
  //           notes: data['notes'] as String?,
  //           location: data['location'] as String?,
  //         ),
  //       );
  //     }

  //     debugPrint("Interviews fetched successfully: $_events");
  //   } catch (error) {
  //     debugPrint("Error fetching interviews: $error");
  //   }
  // }

// Function to fetch all interviews for a specific recruiter
  Future<void> fetchAllInterviews() async {
    // Clear existing events to avoid duplicates
    _events.clear();

    // Reference to the recruiter user
    final usersCollection =
        FirebaseFirestore.instance.collection('users').doc(getCurrentUserId());

    // Fetch the recruiter's job posts
    final jobPostsCollection = usersCollection.collection('job_posts');
    QuerySnapshot jobPostsSnapshot = await jobPostsCollection.get();

    for (var jobPostDoc in jobPostsSnapshot.docs) {
      // Reference to the interviews sub-collection for each job post
      final interviewsCollection =
          jobPostsCollection.doc(jobPostDoc.id).collection('interviews');

      // Fetch all interviews
      try {
        QuerySnapshot interviewsSnapshot = await interviewsCollection.get();
        for (var interviewDoc in interviewsSnapshot.docs) {
          final data = interviewDoc.data() as Map<String, dynamic>;

          // Parse startTime and endTime from "HH:mm" strings
          final startTime = data['startTime'] != null
              ? _parseTimeOfDay(data['startTime'] as String)
              : null;

          final endTime = data['endTime'] != null
              ? _parseTimeOfDay(data['endTime'] as String)
              : null;

          // Convert Firestore document to InterviewEvent and add to _events
          _events.add(
            InterviewEvent(
              applicant: data['applicant'] as String?,
              title: data['title'] as String?,
              type: data['type'] as String?,
              interviewers: (data['interviewers'] as List<dynamic>?)
                  ?.map((e) => e.toString())
                  .toList(),
              date: (data['date'] != null)
                  ? (data['date'] as Timestamp).toDate()
                  : null,
              startTime: startTime,
              endTime: endTime,
              notes: data['notes'] as String?,
              location: data['location'] as String?,
            ),
          );
        }
        print('Interviews fetched: ${interviewsSnapshot.docs.length}');
      } catch (e) {
        print('Error fetching interviews: $e');
      }
    }
  }

  /// Helper function to parse "HH:mm" string to TimeOfDay
  TimeOfDay _parseTimeOfDay(String timeString) {
    final parts = timeString.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }

// Helper function to convert a Firestore time string to TimeOfDay
  TimeOfDay? _convertToTimeOfDay(String? time) {
    if (time == null) return null;
    final parts = time.split(":");
    if (parts.length == 2) {
      final hour = int.tryParse(parts[0]);
      final minute = int.tryParse(parts[1]);
      if (hour != null && minute != null) {
        return TimeOfDay(hour: hour, minute: minute);
      }
    }
    return null;
  }
}
