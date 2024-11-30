import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import 'package:huzzl_web/views/recruiters/interview_tab/calendar_ui/interview_model.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/controller/interview_provider.dart';
import 'package:huzzl_web/views/recruiters/jobs_tab/controller/job_provider_candidate.dart';

class StartInterviewScreen extends StatefulWidget {
  final InterviewEvent interviewDetails;

  StartInterviewScreen({
    super.key,
    required this.interviewDetails,
  });

  @override
  _StartInterviewScreenState createState() => _StartInterviewScreenState();
}

class _StartInterviewScreenState extends State<StartInterviewScreen> {
  late Timer _timer;
  int _elapsedSeconds = 0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedSeconds++;
      });
    });
  }

  String _formatTime(int seconds) {
    final int minutes = seconds ~/ 60;
    final int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var jobCandidateProvider = Provider.of<JobProviderCandidate>(context);
    return Consumer<InterviewProvider>(
      builder: (context, interviewProvider, child) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.7,
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    interviewProvider.localUserJoined
                                        ? AgoraVideoView(
                                            controller: VideoViewController(
                                              rtcEngine:
                                                  interviewProvider.engine!,
                                              canvas: const VideoCanvas(uid: 0),
                                            ),
                                          )
                                        : const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                    Positioned(
                                      bottom: 10,
                                      child: Text(
                                        'Admin',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          backgroundColor: Colors.black54,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Gap(8),
                        Expanded(
                          child: Column(
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.7,
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    interviewProvider.remoteUid != null
                                        ? AgoraVideoView(
                                            controller:
                                                VideoViewController.remote(
                                              rtcEngine:
                                                  interviewProvider.engine!,
                                              canvas: VideoCanvas(
                                                  uid: interviewProvider
                                                      .remoteUid),
                                              connection: RtcConnection(
                                                  channelId: interviewProvider
                                                      .channel),
                                            ),
                                          )
                                        : const Center(
                                            child: Text(
                                              'Please wait for remote user to join',
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                    Positioned(
                                      bottom: 10,
                                      child: Text(
                                        widget.interviewDetails.applicant!,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          backgroundColor: Colors.black54,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Gap(20),
                    Text(
                      'Interview Duration: ${_formatTime(_elapsedSeconds)}',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const Gap(20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            interviewProvider.toggleMute();
                          },
                          icon: Icon(
                            interviewProvider.isMuted
                                ? Icons.mic_off
                                : Icons.mic,
                          ),
                          iconSize: 35,
                        ),
                        const Gap(20),
                        IconButton(
                          onPressed: () {
                            interviewProvider.toggleCamera();
                          },
                          icon: Icon(
                            interviewProvider.isCameraOff
                                ? Icons.videocam_off
                                : Icons.camera_alt_outlined,
                          ),
                          iconSize: 35,
                        ),
                        const Gap(20),
                        IconButton(
                          onPressed: () {
                            interviewProvider.endCall(widget.interviewDetails);
                          },
                          icon: Icon(
                            Icons.call,
                            weight: 3,
                          ),
                          iconSize: 40,
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
