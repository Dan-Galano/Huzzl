import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: VideoCallPage(),
    );
  }
}

class VideoCallPage extends StatefulWidget {
  @override
  _VideoCallPageState createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage> {
  late RTCVideoRenderer _localRenderer;
  late RTCVideoRenderer _remoteRenderer;
  MediaStream? _localStream;
  MediaStream? _remoteStream;
  RTCPeerConnection? _peerConnection;
  bool _isInCall = false;

  @override
  void initState() {
    super.initState();
    _localRenderer = RTCVideoRenderer();
    _remoteRenderer = RTCVideoRenderer();
    _initialize();
  }

  Future<void> _initialize() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();

    // Request the local stream (camera)
    _localStream = await navigator.mediaDevices.getUserMedia({
      'audio': true,
      'video': {
        'facingMode': 'user',
        'width': {'ideal': 1280},
        'height': {'ideal': 720}
      }
    });

    _localRenderer.srcObject = _localStream;

    setState(() {});
  }

  // Handle incoming offer (Peer 2 joins the call)
  Future<void> _joinCall(RTCSessionDescription offer) async {
    // Initialize the peer connection
    _peerConnection = await createPeerConnection({
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'}
      ]
    });

    // Add local stream to the peer connection (Peer 2's camera)
    _peerConnection!.addStream(_localStream!);

    // Set the remote description (the offer received from Peer 1)
    await _peerConnection!.setRemoteDescription(offer);

    // Create an answer for Peer 1
    RTCSessionDescription answer = await _peerConnection!.createAnswer({
      'offerToReceiveVideo': 1,
      'offerToReceiveAudio': 1,
    });

    // Set the local description (answer) and send it back to Peer 1
    await _peerConnection!.setLocalDescription(answer);

    // Signaling: Send the answer to Peer 1
    // sendAnswerToSignalingServer(answer); // Implement your signaling mechanism

    // Handle remote stream (Peer 1's camera)
    _peerConnection!.onAddStream = (stream) {
      setState(() {
        _remoteStream = stream;
        _remoteRenderer.srcObject = stream;
      });
    };

    // Handle ICE candidates from Peer 1
    _peerConnection!.onIceCandidate = (RTCIceCandidate candidate) {
      // sendIceCandidateToSignalingServer(candidate); // Implement ICE candidate exchange
    };
  }

  // Start the video call (Peer 1 creates the offer)
  Future<void> _createOffer() async {
    _peerConnection = await createPeerConnection({
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'}
      ]
    });

    // Add local stream to the peer connection
    _peerConnection!.addStream(_localStream!);

    // Create an offer
    RTCSessionDescription offer = await _peerConnection!.createOffer({
      'offerToReceiveVideo': 1,
      'offerToReceiveAudio': 1,
    });

    await _peerConnection!.setLocalDescription(offer);

    // Send the offer to Peer 2 (via signaling)
    // sendOfferToSignalingServer(offer);

    // Handle remote stream (Peer 2's camera)
    _peerConnection!.onAddStream = (stream) {
      setState(() {
        _remoteStream = stream;
        _remoteRenderer.srcObject = stream;
      });
    };

    // Handle ICE candidates from Peer 2
    _peerConnection!.onIceCandidate = (RTCIceCandidate candidate) {
      // sendIceCandidateToSignalingServer(candidate); // Implement ICE candidate exchange
    };
  }

  // Handle ICE candidates
  void _handleIceCandidate(RTCIceCandidate candidate) async {
    await _peerConnection!.addCandidate(candidate);
  }

  // End the video call
  void _endCall() async {
    await _peerConnection?.close();
    _localStream?.dispose();
    _remoteRenderer.srcObject = null;
    setState(() {
      _isInCall = false;
    });
  }

  @override
  void dispose() {
    _localStream?.dispose();
    _remoteRenderer.dispose();
    _localRenderer.dispose();
    _peerConnection?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flutter WebRTC Video Call')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Local video view (Peer 1's or Peer 2's camera)
            Container(
              width: 300,
              height: 200,
              child: _localStream != null
                  ? RTCVideoView(_localRenderer)
                  : CircularProgressIndicator(),
            ),
            SizedBox(height: 20),
            // Remote video view (Peer 2's or Peer 1's camera)
            Container(
              width: 300,
              height: 200,
              child: _remoteStream != null
                  ? RTCVideoView(_remoteRenderer)
                  : CircularProgressIndicator(),
            ),
            SizedBox(height: 20),
            // Start/End Call Button
            !_isInCall
                ? ElevatedButton(
                    onPressed: _createOffer,
                    child: Text('Start Call (Offer)'),
                  )
                : ElevatedButton(
                    onPressed: _endCall,
                    child: Text('End Call'),
                  ),
            // Join Call Button (for Peer 2)
            ElevatedButton(
              onPressed: () {
                // Assuming you received an offer from Peer 1
                // Example: RTCSessionDescription offer = receivedOfferFromSignalingServer;
                _joinCall(RTCSessionDescription('offer_sdp', 'offer_type'));
              },
              child: Text('Join Call (Answer)'),
            ),
          ],
        ),
      ),
    );
  }
}
