import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

void main() => runApp(VideoCall());

class VideoCall extends StatefulWidget {
  const VideoCall({super.key});

  @override
  State<VideoCall> createState() => _VideoCallState();
}

class _VideoCallState extends State<VideoCall> {
  final _localRenderer = new RTCVideoRenderer();

  @override
  void initState() {
    initRenderers();
    _getUserMedia();
    // TODO: implement initState
    super.initState();
  }

  initRenderers() async {
    await _localRenderer.initialize();
  }

  _getUserMedia() async {
    final Map<String, dynamic> mediaConstraints = {
      'audio': false,
      'video': {
        'facingMode': 'user',
      }
    };
    MediaStream stream = await mediaDevices.getUserMedia(mediaConstraints);
    _localRenderer.srcObject = stream;
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Hello"),
        ),
        body: Container(
          child: Stack(
            children: [
              Positioned(
                top: 0.0,
                right: 0.0,
                left: 0.0,
                bottom: 0.0,
                child: Container(
                  child: RTCVideoView(_localRenderer),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
