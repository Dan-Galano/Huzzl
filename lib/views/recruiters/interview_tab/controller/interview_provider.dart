import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docx_to_text/docx_to_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:huzzl_web/views/job%20seekers/interview_screen/job_seeker_interview.dart';
import 'package:huzzl_web/views/job%20seekers/my_jobs/model/notification.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/models/candidate.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/calendar_ui/interview_model.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/views/evaluation_candidate_model.dart';
import 'package:huzzl_web/views/recruiters/jobs_tab/controller/job_provider_candidate.dart';
import 'package:huzzl_web/widgets/buttons/blue/bluefilled_boxbutton.dart';
import 'package:huzzl_web/widgets/buttons/gray/grayfilled_boxbutton.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class InterviewProvider extends ChangeNotifier {
  final BuildContext context;
  InterviewProvider(this.context);

  InterviewEvent? _interviewDetails;
  InterviewEvent? get interviewDetails => _interviewDetails;

  bool _startInterview = false;

  bool get startInterview => _startInterview;

  //Show evaluation screen
  bool _showEvalScreen = false;
  bool get showEvalScreen => _showEvalScreen;

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

  void toggleShowEvaluation() {
    // _startInterview = !_startInterview;
    _showEvalScreen = !_showEvalScreen;
    notifyListeners();
  }

  void startInterviewFunction(BuildContext context, String userType,
      {InterviewEvent? e}) async {
    await dotenv.load();
    if (userType == 'recruiter') {
      showConfirmationToStartInterview(context, e!);
    } else {
      showConfirmationToJoinInterview(context);
    }
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
  Future<void> endCall(InterviewEvent e) async {
    await _engine?.leaveChannel();
    _remoteUid = null;
    _localUserJoined = false;
    _startInterview = false;
    _showEvalScreen = true;
    updateInterviewStatusToDone(e);
    notifyListeners();
  }

  Future<void> endCallForJobseeker() async {
    await _engine?.leaveChannel();
    _remoteUid = null;
    _localUserJoined = false;
    // _showEvalScreen = true;
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

  void showConfirmationToStartInterview(
      BuildContext context, InterviewEvent e) {
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
                            final jobCandidateProvider =
                                Provider.of<JobProviderCandidate>(context,
                                    listen: false);

                            debugPrint(
                                "Detailes to be pass into contacted Function: jobpostId : ${e.jobPostId}, jobseekerid ${e.jobseekerId}, jobapplicationid : ${e.jobApplicationDocId}");

                            //Error
                            jobCandidateProvider.contactedCandidate(
                              e.jobPostId!,
                              e.jobseekerId!,
                              e.jobApplicationDocId!,
                            );

                            debugPrint("Finished updatinggggggggggggggggg");

                            updateInterviewStatus(e);

                            debugPrint("Interview status starteeedd");
                            _startInterview = !_startInterview;
                            _interviewDetails = e;
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

  void showConfirmationToJoinInterview(
    BuildContext context,
  ) {
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
                            "Join interview?",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Galano',
                            ),
                          ),
                          Text(
                            "Are you sure you want to join the interview?",
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
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) {
                                return StartInterviewScreenJobseeker();
                              },
                            ));
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

  void saveInterview(
    InterviewEvent e,
    String jobseekerId,
    String jobPostId,
    String candidateId,
    String jobApplicationId,
    String profession,
  ) async {
    final recruiterId = getCurrentUserId();
    var uuid = Uuid();

    var interviewId = uuid.v4();

    // Default value for location if it's null
    final location = e.location ?? 'No Location';

    // Convert TimeOfDay to string representation
    final startTimeString = e.startTime != null
        ? '${e.startTime!.hour.toString().padLeft(2, '0')}:${e.startTime!.minute.toString().padLeft(2, '0')}'
        : '00:00';

    final endTimeString = e.endTime != null
        ? '${e.endTime!.hour.toString().padLeft(2, '0')}:${e.endTime!.minute.toString().padLeft(2, '0')}'
        : '00:00';

    try {
      // Save to recruiter's job posts
      await FirebaseFirestore.instance
          .collection("users")
          .doc(recruiterId)
          .collection('job_posts')
          .doc(jobPostId)
          .collection('interviews')
          .doc(interviewId)
          .set({
        'interviewId': interviewId,
        'applicant': e.applicant,
        'title': e.title,
        'type': e.type,
        'interviewers': e.interviewers,
        'date': e.date,
        'startTime': startTimeString,
        'endTime': endTimeString,
        'notes': e.notes,
        'location': location,
        'recruiterId': recruiterId,
        'jobseekerId': jobseekerId,
        'jobPostId': jobPostId,
        'profession': profession,
        'status': 'not started',
        'jobApplicationId': jobApplicationId,
      });

      // Save to jobseeker's interview schedule
      await FirebaseFirestore.instance
          .collection('users')
          .doc(jobseekerId)
          .collection('interviewSched')
          .doc(interviewId)
          .set({
        'interviewId': interviewId,
        'applicant': e.applicant,
        'title': e.title,
        'type': e.type,
        'interviewers': e.interviewers,
        'date': e.date,
        'startTime': startTimeString,
        'endTime': endTimeString,
        'notes': e.notes,
        'location': location,
        'recruiterId': recruiterId,
        'jobseekerId': jobseekerId,
        'jobPostId': jobPostId,
        'profession': profession,
        'status': 'not started',
        'jobApplicationId': jobApplicationId,
      });

      // Update job application status
      await FirebaseFirestore.instance
          .collection('users')
          .doc(jobseekerId)
          .collection("job_application")
          .doc(jobApplicationId)
          .update({'status': 'For Interview'});

      debugPrint('Interview and status updates successfully saved.');
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
          _events.add(InterviewEvent(
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
            status: data['status'] as String?,
            profession: data['profession'],
            interviewId: data['interviewId'],
            jobPostId: data['jobPostId'],
            jobseekerId: data['jobseekerId'],
            jobApplicationDocId: data['jobApplicationId'],
          ));
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

  //TODAYSSS INTERVIEWWW HEREEE
  List<InterviewEvent> _todaysInterviewList = [];
  List<InterviewEvent> get todaysInterviewList => _todaysInterviewList;

  Future<void> fetchTodaysInterview() async {
    // Clear existing events to avoid duplicates
    _todaysInterviewList.clear();

    // Get today's date
    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);
    final todayEnd = todayStart
        .add(const Duration(days: 1))
        .subtract(const Duration(seconds: 1));

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

      try {
        // Fetch interviews scheduled for today
        QuerySnapshot interviewsSnapshot = await interviewsCollection
            .where('status', isEqualTo: 'not started')
            .where('date',
                isGreaterThanOrEqualTo: Timestamp.fromDate(todayStart))
            .where('date', isLessThanOrEqualTo: Timestamp.fromDate(todayEnd))
            .get();

        for (var interviewDoc in interviewsSnapshot.docs) {
          final data = interviewDoc.data() as Map<String, dynamic>;

          // final interviewId = interviewDoc.id;

          // Parse startTime and endTime from "HH:mm" strings
          final startTime = data['startTime'] != null
              ? _parseTimeOfDay(data['startTime'] as String)
              : null;

          final endTime = data['endTime'] != null
              ? _parseTimeOfDay(data['endTime'] as String)
              : null;

          // Convert Firestore document to InterviewEvent and add to _todaysInterviewList
          _todaysInterviewList.add(
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
              location: data['location'] ?? 'no location',
              status: data['status'] as String?,
              profession: data['profession'],
              jobPostId: data['jobPostId'],
              interviewId: data['interviewId'],
              jobseekerId: data['jobseekerId'],
              jobApplicationDocId: data['jobApplicationId'],
            ),
          );
        }
        print('Today\'s interviews fetched: ${interviewsSnapshot.docs.length}');
      } catch (e) {
        print('Error fetching today\'s interviews: $e');
      }
    }
  }

  //HEREEE FETCH THE UPCOMING INTERVIEWS
  List<InterviewEvent> _upcomingInterviewList = [];
  List<InterviewEvent> get upcomingInterviewList => _upcomingInterviewList;

  Future<void> fetchUpcomingInterviews() async {
    // Clear existing events to avoid duplicates
    _upcomingInterviewList.clear();

    // Get today's date
    final today = DateTime.now();
    final todayEnd = DateTime(today.year, today.month, today.day)
        .add(const Duration(days: 1))
        .subtract(const Duration(seconds: 1));

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

      try {
        // Fetch interviews scheduled for upcoming days
        QuerySnapshot interviewsSnapshot = await interviewsCollection
            .where('status', isEqualTo: 'not started')
            .where('date', isGreaterThan: Timestamp.fromDate(todayEnd))
            .get();

        for (var interviewDoc in interviewsSnapshot.docs) {
          final data = interviewDoc.data() as Map<String, dynamic>;

          // Parse startTime and endTime from "HH:mm" strings
          final startTime = data['startTime'] != null
              ? _parseTimeOfDay(data['startTime'] as String)
              : null;

          final endTime = data['endTime'] != null
              ? _parseTimeOfDay(data['endTime'] as String)
              : null;

          // Convert Firestore document to InterviewEvent and add to _todaysInterviewList
          _upcomingInterviewList.add(
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
              location: data['location'] ?? 'no location',
              status: data['status'] as String?,
              profession: data['profession'],
              jobPostId: data['jobPostId'],
              interviewId: data['interviewId'],
              jobseekerId: data['jobseekerId'],
              jobApplicationDocId: data['jobApplicationId'],
            ),
          );
        }
        print('Upcoming interviews fetched: ${interviewsSnapshot.docs.length}');
      } catch (e) {
        print('Error fetching upcoming interviews: $e');
      }
    }
  }

  //HERE: FETCH THE PAST IONTERVIEWS
  List<InterviewEvent> _pastInterviews = [];
  List<InterviewEvent> get pastInterviews => _pastInterviews;

  Future<void> fetchPastInterviews() async {
    // Clear existing past interviews to avoid duplicates
    _pastInterviews.clear();

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

      try {
        // Fetch interviews with a status of "done"
        QuerySnapshot interviewsSnapshot =
            await interviewsCollection.where('status', isEqualTo: 'done').get();

        for (var interviewDoc in interviewsSnapshot.docs) {
          final data = interviewDoc.data() as Map<String, dynamic>;

          // Parse startTime and endTime from "HH:mm" strings
          final startTime = data['startTime'] != null
              ? _parseTimeOfDay(data['startTime'] as String)
              : null;

          final endTime = data['endTime'] != null
              ? _parseTimeOfDay(data['endTime'] as String)
              : null;

          // Convert Firestore document to InterviewEvent and add to _pastInterviews
          _pastInterviews.add(
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
              location: data['location'] ?? 'no location',
              status: data['status'] as String?,
              profession: data['profession'],
              jobPostId: data['jobPostId'],
              interviewId: data['interviewId'],
              jobseekerId: data['jobseekerId'],
              jobApplicationDocId: data['jobApplicationId'],
            ),
          );
        }
        print('Past interviews fetched: ${interviewsSnapshot.docs.length}');
      } catch (e) {
        print('Error fetching past interviews: $e');
      }
    }
  }

  void updateInterviewStatus(InterviewEvent e) {
    final recruiterId = getCurrentUserId();

    debugPrint(
        "Interview Event status: ${e.applicant}, ${e.jobPostId} ${e.interviewId} ${e.jobseekerId}");

    try {
      // Update the interview status for the recruiter
      FirebaseFirestore.instance
          .collection('users')
          .doc(recruiterId)
          .collection('job_posts')
          .doc(e.jobPostId)
          .collection('interviews')
          .doc(e.interviewId)
          .update({
        'status': 'started',
      }).then((_) {
        print('Recruiter interview status updated to started');
      }).catchError((error) {
        print('Error updating recruiter interview status: $error');
      });

      // Update the interview status for the jobseeker
      FirebaseFirestore.instance
          .collection('users')
          .doc(e.jobseekerId)
          .collection('interviewSched')
          .doc(e.interviewId)
          .update({
        'status': 'started',
      }).then((_) {
        print('Jobseeker interview status updated to started');
      }).catchError((error) {
        print('Error updating jobseeker interview status: $error');
      });
    } catch (e) {
      print('Error updating interview status: $e');
    }
  }

  void updateInterviewStatusToDone(InterviewEvent e) {
    final recruiterId = getCurrentUserId();

    debugPrint(
        "Interview Event status: ${e.applicant}, ${e.jobPostId} ${e.interviewId} ${e.jobseekerId}");

    try {
      // Update the interview status for the recruiter
      FirebaseFirestore.instance
          .collection('users')
          .doc(recruiterId)
          .collection('job_posts')
          .doc(e.jobPostId)
          .collection('interviews')
          .doc(e.interviewId)
          .update({
        'status': 'done',
      }).then((_) {
        print('Recruiter interview status updated to done');
      }).catchError((error) {
        print('Error updating recruiter interview status: $error');
      });

      // Update the interview status for the jobseeker
      FirebaseFirestore.instance
          .collection('users')
          .doc(e.jobseekerId)
          .collection('interviewSched')
          .doc(e.interviewId)
          .update({
        'status': 'started',
      }).then((_) {
        print('Jobseeker interview status updated to dont');
      }).catchError((error) {
        print('Error updating jobseeker interview status: $error');
      });
    } catch (e) {
      print('Error updating interview status: $e');
    }
  }

  Future<void> saveInterviewEvaluation(
    InterviewEvent e,
    String evaluation,
    String totalPoints,
    String topEvaluationArea,
    String comment,
  ) async {
    final recruiterId = getCurrentUserId();

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(recruiterId)
          .collection('job_posts')
          .doc(e.jobPostId)
          .collection('interviews')
          .doc(e.interviewId)
          .collection('evaluation')
          .add({
        'jobPostId': e.jobPostId,
        'interviewId': e.interviewId,
        'jobApplicationId': e.jobApplicationDocId,
        'jobseekerId': e.jobseekerId,
        'applicant': e.applicant,
        'evaluation': evaluation,
        'totalPoints': totalPoints,
        'topEvaluationArea': topEvaluationArea,
        'comment': comment,
        'evaluationDate': FieldValue.serverTimestamp(),
      });

      debugPrint("Saved the evaluation successfully");
    } catch (e, stackTrace) {
      debugPrint("Error in saving evaluation: $e");
      debugPrint("Stack trace: $stackTrace");
    }
  }

  Future<EvaluatedCandidateModel?> fetchEvaluationForJobseeker(
    String jobPostId,
    String jobApplicationId,
  ) async {
    try {
      final recruiterId = getCurrentUserId();
      // Step 1: Get all interviews under the job post
      final interviewsSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(recruiterId)
          .collection('job_posts')
          .doc(jobPostId)
          .collection('interviews')
          .get();

      // Step 2: Find the interview where jobApplicationId matches
      for (final interviewDoc in interviewsSnapshot.docs) {
        if (interviewDoc['jobApplicationId'] == jobApplicationId) {
          final interviewId = interviewDoc.id;

          // Step 3: Fetch the evaluation sub-collection for the matching interview
          final evaluationSnapshot = await FirebaseFirestore.instance
              .collection('users')
              .doc(recruiterId)
              .collection('job_posts')
              .doc(jobPostId)
              .collection('interviews')
              .doc(interviewId)
              .collection('evaluation')
              .get();

          // Step 4: If evaluation documents exist, map the first one to the model
          if (evaluationSnapshot.docs.isNotEmpty) {
            final evaluationDoc = evaluationSnapshot.docs.first;

            return EvaluatedCandidateModel(
              jobPostId: evaluationDoc['jobPostId'] as String?,
              interviewId: evaluationDoc['interviewId'] as String?,
              jobApplicationId: evaluationDoc['jobApplicationId'] as String?,
              jobseekerId: evaluationDoc['jobseekerId'] as String?,
              applicant: evaluationDoc['applicant'] as String,
              evaluation: evaluationDoc['evaluation'] as String,
              totalPoints: evaluationDoc['totalPoints'] as String,
              topEvaluationArea: evaluationDoc['topEvaluationArea'] as String,
              comment: evaluationDoc['comment'] as String,
              evaluationDate:
                  (evaluationDoc['evaluationDate'] as Timestamp?)?.toDate(),
            );
          }
        }
      }

      // If no matching interview or evaluation is found
      debugPrint("No evaluation found for jobApplicationId: $jobApplicationId");
      return null;
    } catch (e, stackTrace) {
      // Handle any errors
      debugPrint("Error fetching evaluation: $e");
      debugPrint("Stack trace: $stackTrace");
      return null; // Return null on failure
    }
  }

  //Fetch all the shortlisted candidates and show in the pending tab in interview:\
  List<Candidate> _shortListedCandidateDisplayInPending = [];
  List<Candidate> get shortListedCandidateDisplayInPending =>
      _shortListedCandidateDisplayInPending;

  Future<void> fetchShortlistedCandidateToDisplayInPendingTab() async {
    try {
      final userId = getCurrentUserId();

      // Fetch all job posts for the specific user
      final jobPostsQuery = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('job_posts')
          .get();

      // Clear the list before adding new data
      _shortListedCandidateDisplayInPending.clear();

      for (var jobPostDoc in jobPostsQuery.docs) {
        String jobPostId = jobPostDoc.id;

        // Fetch shortlisted candidates for each job post
        final candidatesQuery = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('job_posts')
            .doc(jobPostId)
            .collection('candidates')
            .where('status', isEqualTo: 'Shortlisted')
            .get();

        for (var candidateDoc in candidatesQuery.docs) {
          Map<String, dynamic> candidateData = candidateDoc.data();
          String candidateId = candidateDoc.id;

          // Create a Candidate object from the Firestore data
          Candidate candidate = Candidate(
            id: candidateId,
            jobPostId: jobPostId,
            companyAppliedTo: userId,
            email: candidateData['email'],
            name: "${candidateData['firstName']} ${candidateData['lastName']}",
            profession: candidateData['jobTitle'],
            status: candidateData['status'],
            applicationDate:
                (candidateData['applicationDate'] as Timestamp).toDate(),
            dateLastInterviewed:
                (candidateData['applicationDate'] as Timestamp).toDate(),
            dateRejected:
                (candidateData['applicationDate'] as Timestamp).toDate(),
            interviewCount: 0,
            jobApplicationDocId: candidateData['jobApplicationDocId'],
          );

          // Add the candidate to the local list
          _shortListedCandidateDisplayInPending.add(candidate);
        }
      }

      debugPrint("Fetchingggg shortlisted candidate!");
    } catch (e) {
      print('Error fetching shortlisted candidates for user: $e');
    }
  }

  List<NotificationModel> _notificationList = [];
  List<NotificationModel> get notificationList => _notificationList;

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

  void viewNotification(NotificationModel notif) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(notif.recruiterId)
        .collection("notifications")
        .doc(notif.notificationId)
        .update({
      'status': 'read',
    });
    debugPrint("Updated status: nabasa na");
  }

  String _subscriptionType = "";
  String get subscriptionType => _subscriptionType;

  void fetchSubscriptionType() async {
    try {
      var recruiterId = getCurrentUserId();
      if (recruiterId == null || recruiterId.isEmpty) {
        throw Exception("Invalid recruiter ID");
      }

      final docSnapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(recruiterId)
          .get();

      if (docSnapshot.exists) {
        _subscriptionType = docSnapshot.data()?["subscriptionType"];
        debugPrint("Fetching subscription type");
      } else {
        throw Exception("Document does not exist");
      }

      notifyListeners();
    } catch (e) {
      // Handle errors (e.g., log them or show a message to the user)
      print("Error fetching subscription type: $e");
    }
  }
}
