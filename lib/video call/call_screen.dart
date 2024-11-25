import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';

class CallScreen extends StatefulWidget {
  String channel;
  CallScreen({required this.channel, super.key});

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  AgoraClient? client;

  @override
  void initState() {
    initAgora(widget.channel);
    super.initState();
  }

  void initAgora(String channelName) async {
    client = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
        appId: 'fa4f64b0779b49e59c862f99560dd735',
        channelName: channelName,
        username: "user",
      ),
    );
    await client!.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            AgoraVideoViewer(
              client: client!,
              layoutType: Layout.grid,
              enableHostControls: true,
            ),
            AgoraVideoButtons(
              client: client!,
              addScreenSharing: false,
            ),
          ],
        ),
      ),
    );
  }
}
