import 'package:flutter/material.dart';
import 'package:huzzl_web/video%20call/call_screen.dart';
class HomeScreen extends StatelessWidget {
  final TextEditingController _channelController = TextEditingController();

  void startCall(BuildContext context) {
    final channel = _channelController.text;
    if (channel.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return CallScreen(channel: channel);
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Video Calling App"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                controller: _channelController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Enter channel name",
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                startCall(context);
              },
              child: const Text("Call"),
            ),
          ],
        ),
      ),
    );
  }
}
