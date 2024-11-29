import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/controller/interview_provider.dart';
import 'package:provider/provider.dart';

class StartInterviewScreenJobseeker extends StatelessWidget {
  StartInterviewScreenJobseeker({super.key});

  @override
  Widget build(BuildContext context) {
    // final interviewProvider = Provider.of<InterviewProvider>(context);
    return Consumer<InterviewProvider>(
      builder: (context, interviewProvider, child) {
        return Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Align(
                    //   alignment: Alignment.centerLeft,
                    //   child: TextButton.icon(
                    //     onPressed: () {
                    //       interviewProvider.toggleStartInterview();
                    //     },
                    //     label: const Text(
                    //       "Back",
                    //       style: TextStyle(
                    //         color: Color(0xFFff9800),
                    //         fontFamily: 'Galano',
                    //       ),
                    //     ),
                    //     icon: const Icon(
                    //       Icons.arrow_back_ios_new_rounded,
                    //       color: Color(0xFFff9800),
                    //     ),
                    //   ),
                    // ),
                    const Gap(20),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.7,
                            // color: Colors.red,
                            child: interviewProvider.localUserJoined
                                ? AgoraVideoView(
                                    controller: VideoViewController(
                                      rtcEngine: interviewProvider.engine!,
                                      canvas: const VideoCanvas(uid: 0),
                                    ),
                                  )
                                : const Center(
                                    child: CircularProgressIndicator()),
                          ),
                        ),
                        const Gap(8),
                        Expanded(
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.7,
                            // color: Colors.blue,
                            child: interviewProvider.remoteUid != null
                                ? AgoraVideoView(
                                    controller: VideoViewController.remote(
                                      rtcEngine: interviewProvider.engine!,
                                      canvas: VideoCanvas(
                                          uid: interviewProvider.remoteUid),
                                      connection: RtcConnection(
                                          channelId: interviewProvider.channel),
                                    ),
                                  )
                                : const Center(
                                    child: Text(
                                      'Please wait for remote user to join',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                          ),
                        ),
                      ],
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
                            interviewProvider.endCall();
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
            ),
          ],
        );
      },
    );
  }
}
