import 'dart:typed_data';
import 'package:docx_to_text/docx_to_text.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:huzzl_web/views/job%20seekers/home/00%20home.dart';
import 'package:huzzl_web/views/job%20seekers/home/home_script.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _extractedText = '';
  String _selectedFileType = '';

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
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // nav
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  child: Image.asset('assets/images/huzzl.png', width: 80),
                ),
                Spacer(),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Home',
                        style: TextStyle(
                          color: Color(0xff373030),
                          fontFamily: 'Galano',
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Company Reviews',
                        style: TextStyle(
                          color: Color(0xff373030),
                          fontFamily: 'Galano',
                        ),
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Image.asset('assets/images/message-icon.png',
                          width: 20),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Image.asset(
                        'assets/images/notif-icon.png',
                        width: 20,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Image.asset(
                        'assets/images/user-icon.png',
                        width: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(
            thickness: 1,
            color: Colors.grey[400],
          ),
          // content
          Container(
            width: 800,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile section
                Padding(
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
                            "Eleanor Pena",
                            style: TextStyle(
                              fontFamily: 'Galano',
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "+63 908 123 4567",
                            style: TextStyle(
                                fontFamily: 'Galano',
                                fontWeight: FontWeight.w500,
                                color: Colors.grey),
                          ),
                          Text(
                            "eleanor.pena@gmail.com",
                            style: TextStyle(
                                fontFamily: 'Galano',
                                fontWeight: FontWeight.w500,
                                color: Colors.grey),
                          ),
                          Text(
                            "Urdaneta City, 2448",
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
                Divider(
                  thickness: 3,
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
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ResumeButton(
                            icon: Icons.upload_file,
                            title: "Upload Resume",
                            subtitle: "Attach your resume.",
                            onTap: _pickFile,
                          ),
                          ResumeButton(
                            icon: Icons.download,
                            title: "Download Resume Template",
                            subtitle: "sadasfadf",
                            onTap: () {
                              // Handle file download
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                // Job match improvement section
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Improve your job matches",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        ListTile(
                          title: Text("Qualifications"),
                          subtitle:
                              Text("Highlight your skills and experience."),
                          trailing: Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            // Navigate to qualifications screen
                          },
                        ),
                        Divider(),
                        ListTile(
                          title: Text("Job preferences"),
                          subtitle: Text(
                              "Save specific details like minimum desired pay and schedule."),
                          trailing: Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            // Navigate to job preferences screen
                          },
                        ),
                      ],
                    ),
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
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  ResumeButton({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 50, color: Colors.blue),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(subtitle),
            ],
          ),
        ],
      ),
    );
  }
}
