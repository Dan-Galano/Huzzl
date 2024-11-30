import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docx_to_text/docx_to_text.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:huzzl_web/views/job%20seekers/home/00%20home.dart';
import 'package:huzzl_web/views/job%20seekers/home/home_script.dart';
import 'package:huzzl_web/views/job%20seekers/main_screen.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart'; 

class ProfileScreen extends StatefulWidget {
  final String uid;
  ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _extractedText = '';
  String _selectedFileType = '';

  String _userFullName = "";
  String _userPhone = "";
  String _userEmail = "";
  String _address = "";

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      if (userDoc.exists) {
        var userData = userDoc.data() as Map<String, dynamic>;
        setState(() {
          _userFullName = (userData['firstName'] ?? '') +
              " " +
              (userData['lastName'] ?? '').trim();
          _userPhone = userData['phoneNumber'] ??
              'No phone provided'; // Adjust field names as needed
          _userEmail = userData['email'] ??
              'No email provided'; // Adjust field names as needed
          _address =
              '${userData['location']['barangay']}, ${userData['location']['city']}, ${userData['location']['province']}, ${userData['location']['region']} ${userData['location']['otherLocation'] ?? ''}';
        });
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'docx', 'txt'],
    );

    if (result != null && result.files.isNotEmpty) {
      final Uint8List? fileBytes = result.files.single.bytes;
      final String? fileName = result.files.single.name;

      if (fileBytes != null && fileName != null) {
        if (fileName.endsWith('.pdf')) {
          _selectedFileType = 'PDF';
          _extractFromPdf(fileBytes);
        } else if (fileName.endsWith('.docx')) {
          _selectedFileType = 'DOCX';
          _extractFromDocx(fileBytes);
        } else if (fileName.endsWith('.txt')) {
          _selectedFileType = 'TXT';
          _extractFromTxt(fileBytes);
        }
      } else {
        setState(() {
          _extractedText = 'Unable to read file data';
        });
      }
    } else {
      setState(() {
        _extractedText = 'No file selected';
      });
    }
  }

  void _extractFromTxt(Uint8List fileBytes) async {
    try {
      String extractedText = String.fromCharCodes(fileBytes);

      setState(() {
        _extractedText = extractedText;
        print("EXTRACTED TEXT: ${_extractedText}");
        _navigateToHomeScreen();
      });
    } catch (e) {
      setState(() {
        _extractedText = 'Error during TXT extraction: $e';
      });
    }
  }

  void _extractFromPdf(Uint8List fileBytes) async {
    try {
      PdfDocument document = PdfDocument(inputBytes: fileBytes);
      PdfTextExtractor extractor = PdfTextExtractor(document);
      String extractedText = extractor.extractText();

      document.dispose();

      setState(() {
        _extractedText = extractedText;
        print("EXTRACTED TEXT: ${_extractedText}");
        _navigateToHomeScreen();
      });
    } catch (e) {
      setState(() {
        _extractedText = 'Error during PDF extraction: $e';
      });
    }
  }

  void _extractFromDocx(Uint8List fileBytes) async {
    try {
      String text = await docxToText(fileBytes);

      setState(() {
        _extractedText = text;
        print("EXTRACTED TEXT: ${_extractedText}");
        _navigateToHomeScreen();
      });
    } catch (e) {
      setState(() {
        _extractedText = 'Error during DOCX extraction: $e';
      });
    }
  }

  void _navigateToHomeScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => JobSeekerHomeScreen(
          resumeText: _extractedText,
          uid: widget.uid,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // nav
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
            child: Row(),
          ),
          // content
          Container(
            width: 800,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile section
                ListTile(
                  onTap: () {
                    // show Contact Information screen
                    // JobseekerMainScreenState? mainScreenState = context
                    //     .findAncestorStateOfType<JobseekerMainScreenState>();
                    // mainScreenState?.switchScreen(5);
                  },
                  title: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 55,
                          // backgroundImage: AssetImage('assets/pic.jpeg'),
                        ),
                        SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _userFullName,
                              style: TextStyle(
                                fontFamily: 'Galano',
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff202855),
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              _userPhone,
                              style: TextStyle(
                                  fontFamily: 'Galano',
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey),
                            ),
                            Text(
                              _userEmail,
                              style: TextStyle(
                                  fontFamily: 'Galano',
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey),
                            ),
                            Text(
                              _address,
                              style: TextStyle(
                                  fontFamily: 'Galano',
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  thickness: 2,
                  color: Color(0xff6297ff),
                ),
                // SizedBox(height: 10),
                // Resume section
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Resume",
                        style: TextStyle(
                          fontFamily: 'Galano',
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff202855),
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color(0xffACACAC),
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.all(16),
                              margin: EdgeInsets.only(right: 8),
                              child: ResumeButton(
                                imageAsset: 'assets/images/upload.png',
                                title: "Upload Resume",
                                subtitle: "Attach your resume.",
                                onTap: _pickFile,
                                titleStyle: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Galano',
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff202855),
                                ),
                                subtitleStyle: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Galano',
                                  color: Colors.grey.shade600,
                                ),
                                rightIconAsset:
                                    'assets/images/upload_arrow.png', // Right-side icon
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color(0xffACACAC),
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.all(16),
                              margin: EdgeInsets.only(left: 8),
                              child: ResumeButton(
                                imageAsset: 'assets/images/download.png',
                                title: "Download Resume Template",
                                subtitle: "Download a sample resume template.",
                                onTap: () {
                                  // Handle file download
                                },
                                titleStyle: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Galano',
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff202855),
                                ),
                                subtitleStyle: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Galano',
                                  color: Colors.grey.shade600,
                                ),
                                rightIconAsset:
                                    'assets/images/download_arrow.png', // Right-side icon
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Job match improvement section
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Improve your job matches",
                        style: TextStyle(
                          fontFamily: 'Galano',
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff202855),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Color(0xffACACAC),
                              width: 2.0,
                            ),
                            top: BorderSide(
                              color: Color(0xffACACAC),
                              width: 2.0,
                            ),
                          ),
                        ),
                        child: ListTile(
                          title: Text(
                            "Qualifications",
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Galano',
                              fontWeight: FontWeight.w700,
                              color: Color(0xff202855),
                            ),
                          ),
                          subtitle: Text(
                            "Highlight your skills and experience.",
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'Galano',
                            ),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            // Navigate to qualifications screen
                            // JobseekerMainScreenState? mainScreenState =
                            //     context.findAncestorStateOfType<
                            //         JobseekerMainScreenState>();
                            // mainScreenState?.switchScreen(6);
                          },
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Color(0xffACACAC),
                              width: 2.0,
                            ),
                          ),
                        ),
                        child: ListTile(
                          title: Text(
                            "Job preferences",
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Galano',
                              fontWeight: FontWeight.w700,
                              color: Color(0xff202855),
                            ),
                          ),
                          subtitle: Text(
                            "Save specific details like minimum desired pay and schedule.",
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'Galano',
                            ),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            // Navigate to job preferences screen
                            // JobseekerMainScreenState? mainScreenState =
                            //     context.findAncestorStateOfType<
                            //         JobseekerMainScreenState>();
                            // mainScreenState?.switchScreen(7);
                          },
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
    );
  }
}

class ResumeButton extends StatelessWidget {
  final String imageAsset;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final String? rightIconAsset; // New optional icon on the right side

  ResumeButton({
    required this.imageAsset,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.titleStyle,
    this.subtitleStyle,
    this.rightIconAsset, // Optional right icon asset
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Image.asset(
            imageAsset,
            width: 50,
            height: 50,
            color: Colors.blue,
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: titleStyle ??
                    TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
              ),
              Text(
                subtitle,
                style: subtitleStyle ??
                    TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
              ),
            ],
          ),
          Spacer(), // Push the right icon to the right side
          if (rightIconAsset != null) // Only show if rightIconAsset is provided
            Image.asset(
              rightIconAsset!,
              width: 24, // Customize the size of the right icon
              height: 24,
            ),
        ],
      ),
    );
  }
}
