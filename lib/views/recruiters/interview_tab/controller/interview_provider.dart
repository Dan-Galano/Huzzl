import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gap/gap.dart';
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
}
