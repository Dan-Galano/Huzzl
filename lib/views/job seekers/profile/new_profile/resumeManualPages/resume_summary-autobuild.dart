import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/user-provider.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/class/education_entry_model.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/class/experience_entry_model.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/providers/appstate.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/providers/resume_provider.dart';
import 'package:huzzl_web/views/job%20seekers/main_screen.dart';
import 'package:huzzl_web/views/job%20seekers/profile/new_profile/01%20profile_new.dart';
import 'package:huzzl_web/views/job%20seekers/profile/new_profile/resumeDialogs/editObjective.dart';
import 'package:huzzl_web/views/job%20seekers/profile/new_profile/resumeDialogs/editPersonalInfo.dart';
import 'package:huzzl_web/views/job%20seekers/profile/new_profile/resumeDialogs/editSkills.dart';
import 'package:huzzl_web/widgets/buttons/blue/bluefilled_circlebutton.dart';
import 'package:huzzl_web/widgets/loading_dialog.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:html' as html;

class ResumePageSummary2autoBuild extends StatefulWidget {
  final String title;
  final String subtitle;
  final VoidCallback previousPage;
  final bool inProfile;
  const ResumePageSummary2autoBuild({
    super.key,
    required this.title,
    required this.subtitle,
    required this.previousPage,
    this.inProfile = false,
  });

  @override
  _ResumePageSummary2autoBuildState createState() =>
      _ResumePageSummary2autoBuildState();
}

class _ResumePageSummary2autoBuildState
    extends State<ResumePageSummary2autoBuild> {
  String fname = '';
  String lname = '';
  String pnumber = '';
  String email = '';
  Map<String, dynamic> locationData = {};
  String objective = '';
  List<String> selectedSkills = [];
  List<EducationEntry> educationEntries = [];
  List<ExperienceEntry> experienceEntries = [];
  bool isExporting = false;
  final ScreenshotController _screenshotController = ScreenshotController();

  Future<void> _generateAndDownloadPdf(String fullName) async {
    setState(() {
      isExporting = true;
    });
    _showLoadingDialog(context);

    try {
      // Capture the widget as an image
      final Uint8List? imageBytes = await _screenshotController.capture();

      if (imageBytes == null) {
        print("Failed to capture screenshot.");
        EasyLoading.instance
          ..displayDuration = const Duration(milliseconds: 1500)
          ..indicatorType = EasyLoadingIndicatorType.fadingCircle
          ..loadingStyle = EasyLoadingStyle.custom
          ..backgroundColor = Color(0xFfd74a4a)
          ..textColor = Colors.white
          ..fontSize = 16.0
          ..indicatorColor = Colors.white
          ..maskColor = Colors.black.withOpacity(0.5)
          ..userInteractions = false
          ..dismissOnTap = true;
        EasyLoading.showToast(
          "⚠︎ Cannot export to PDF. Try again later.",
          dismissOnTap: true,
          toastPosition: EasyLoadingToastPosition.top,
          duration: Duration(seconds: 3),
        );
        Navigator.pop(context);
        return;
      }

      setState(() {
        isExporting = false;
      });

      // Create a PDF document
      final pdf = pw.Document();

      // Add the screenshot image to the PDF, aligned at the top, centered horizontally
      final image = pw.MemoryImage(imageBytes);
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.legal,
          build: (pw.Context context) => pw.Column(
            children: [
              pw.SizedBox(
                  height: 0), // No extra space above (or minimal if you want)
              pw.Image(image,
                  width: PdfPageFormat.legal.width *
                      0.95, // Center image horizontally
                  height: PdfPageFormat.legal.height *
                      0.65), // Adjust height to fit the page (optional)
            ],
          ),
        ),
      );

      // Save the PDF to Uint8List
      final Uint8List pdfBytes = await pdf.save();

      // Trigger download in Flutter Web
      final blob = html.Blob([pdfBytes], 'application/pdf');
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..target = 'blank'
        ..download = '${fullName}-huzzl-resume.pdf'
        ..click();
      html.Url.revokeObjectUrl(url);

      EasyLoading.instance
        ..displayDuration = const Duration(milliseconds: 1500)
        ..indicatorType = EasyLoadingIndicatorType.fadingCircle
        ..loadingStyle = EasyLoadingStyle.custom
        ..backgroundColor = Color.fromARGB(255, 31, 150, 61)
        ..textColor = Colors.white
        ..fontSize = 16.0
        ..indicatorColor = Colors.white
        ..maskColor = Colors.black.withOpacity(0.5)
        ..userInteractions = false
        ..dismissOnTap = true;
      EasyLoading.showToast(
        "✓ Your resume has been successfully downloaded!",
        dismissOnTap: true,
        toastPosition: EasyLoadingToastPosition.top,
        duration: Duration(seconds: 3),
      );
      Navigator.pop(context);
    } catch (e) {
      print("Error generating PDF: $e");
      EasyLoading.instance
        ..displayDuration = const Duration(milliseconds: 1500)
        ..indicatorType = EasyLoadingIndicatorType.fadingCircle
        ..loadingStyle = EasyLoadingStyle.custom
        ..backgroundColor = Color(0xFfd74a4a)
        ..textColor = Colors.white
        ..fontSize = 16.0
        ..indicatorColor = Colors.white
        ..maskColor = Colors.black.withOpacity(0.5)
        ..userInteractions = false
        ..dismissOnTap = true;
      EasyLoading.showToast(
        "⚠︎ Cannot export to PDF. Try again later.",
        dismissOnTap: true,
        toastPosition: EasyLoadingToastPosition.top,
        duration: Duration(seconds: 3),
      );
      Navigator.pop(context);
    }
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return const LoadingDialog(
          message: 'Loading, please wait...',
        );
      },
    );
  }

  void _submitResume() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    String? userId = userProvider.loggedInUserId;

    if (userId == null) {
      print('User not logged in!');
      return;
    }
    Map<String, dynamic> resumeData = {
      'uid': userId,
      'fname': fname,
      'lname': lname,
      'fullName': '$fname $lname',
      'pnumber': pnumber,
      'email': email,
      'location': locationData,
      'objective': objective,
      'skills': selectedSkills,
      'education': educationEntries.map((entry) => entry.toMap()).toList(),
      'experience': experienceEntries.map((entry) => entry.toMap()).toList(),
      'updatedAt': DateTime.now(),
    };

    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      CollectionReference usersRefResume =
          firestore.collection('users').doc(userId).collection('resume');

      QuerySnapshot existingResumes = await usersRefResume.get();

      if (existingResumes.docs.isEmpty) {
        DocumentReference newResumeDoc = await usersRefResume.add(resumeData);
      } else {
        await usersRefResume
            .doc(existingResumes.docs.first.id)
            .set(resumeData, SetOptions(merge: true));
      }

      print('resume saved successfully!');

      _showLoadingDialog(context);

      await Future.delayed(Duration(seconds: 3));

      final resumeProvider =
          Provider.of<ResumeProvider>(context, listen: false);
      resumeProvider.getResumeByJobSeekerId(userId!);

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => JobseekerMainScreen(
              uid: userId,
              selectedScreen: 4,
            ),
          ));
    } catch (e) {
      print('Error saving and resume: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    final resumeProvider = Provider.of<ResumeProvider>(context, listen: false);

    setState(() {
      fname = resumeProvider.fname ?? '';
      lname = resumeProvider.lname ?? '';
      pnumber = resumeProvider.pnumber ?? '';
      email = resumeProvider.email ?? '';
      locationData = resumeProvider.locationData ?? {};
      objective = resumeProvider.objective ?? '';
      selectedSkills = resumeProvider.selectedSkills ?? [];
      educationEntries = resumeProvider.educationEntries ?? [];
      experienceEntries = resumeProvider.experienceEntries ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 400.0),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 80.0),
                child: Consumer<ResumeProvider>(
                    builder: (context, resumeProvider, child) {
                  fname = resumeProvider.fname ?? '';
                  lname = resumeProvider.lname ?? '';
                  pnumber = resumeProvider.pnumber ?? '';
                  email = resumeProvider.email ?? '';
                  locationData = resumeProvider.locationData ?? {};
                  objective = resumeProvider.objective ?? '';
                  selectedSkills = resumeProvider.selectedSkills ?? [];
                  educationEntries = resumeProvider.educationEntries ?? [];
                  experienceEntries = resumeProvider.experienceEntries ?? [];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: widget.inProfile == true
                            ? MainAxisAlignment.spaceBetween
                            : MainAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: TextStyle(
                              fontSize: 24,
                              color: Color(0xff373030),
                              fontFamily: 'Galano',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          widget.inProfile == true
                              ? PopupMenuButton<String>(
                                  icon: Icon(
                                    Icons.more_vert,
                                    color:
                                        Colors.grey, // Icon for the menu button
                                  ),
                                  onSelected: (value) {
                                    if (value == 'remove_resume') {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            backgroundColor: Colors
                                                .white, // Set the background color to white
                                            title: const Text(
                                              'Delete Resume',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            content: const Text(
                                              'Are you sure you want to remove your resume? You can always set it up again later.',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop(
                                                      false); // Return false
                                                },
                                                child: const Text(
                                                  'Cancel',
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  final userProvider =
                                                      Provider.of<UserProvider>(
                                                          context,
                                                          listen: false);
                                                  String? userId = userProvider
                                                      .loggedInUserId;

                                                  // Show loading dialog while deleting resume
                                                  _showLoadingDialog(context);

                                                  // Wait for removeResume to complete
                                                  await resumeProvider
                                                      .removeResume(userId!);
                                                  setState(() {
                                                    fname =
                                                        resumeProvider.fname ??
                                                            '';
                                                    lname =
                                                        resumeProvider.lname ??
                                                            '';
                                                    pnumber = resumeProvider
                                                            .pnumber ??
                                                        '';
                                                    email =
                                                        resumeProvider.email ??
                                                            '';
                                                    locationData =
                                                        resumeProvider
                                                                .locationData ??
                                                            {};
                                                    objective = resumeProvider
                                                            .objective ??
                                                        '';
                                                    selectedSkills =
                                                        resumeProvider
                                                                .selectedSkills ??
                                                            [];
                                                    educationEntries =
                                                        resumeProvider
                                                                .educationEntries ??
                                                            [];
                                                    experienceEntries =
                                                        resumeProvider
                                                                .experienceEntries ??
                                                            [];
                                                  });

                                                  // Dismiss the loading dialog
                                                  Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            JobseekerMainScreen(
                                                          uid: userId,
                                                          selectedScreen: 4,
                                                        ),
                                                      ));

                                                  // Optionally, you can show a success message
                                                  EasyLoading.instance
                                                    ..displayDuration =
                                                        const Duration(
                                                            milliseconds: 1500)
                                                    ..indicatorType =
                                                        EasyLoadingIndicatorType
                                                            .fadingCircle
                                                    ..loadingStyle =
                                                        EasyLoadingStyle.custom
                                                    ..backgroundColor =
                                                        Color.fromARGB(
                                                            255, 31, 150, 61)
                                                    ..textColor = Colors.white
                                                    ..fontSize = 16.0
                                                    ..indicatorColor =
                                                        Colors.white
                                                    ..maskColor = Colors.black
                                                        .withOpacity(0.5)
                                                    ..userInteractions = false
                                                    ..dismissOnTap = true;
                                                  EasyLoading.showToast(
                                                    "✓ Your resume has been removed.",
                                                    dismissOnTap: true,
                                                    toastPosition:
                                                        EasyLoadingToastPosition
                                                            .top,
                                                    duration:
                                                        Duration(seconds: 3),
                                                  );
                                                },
                                                child: const Text(
                                                  'Delete',
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }
                                  },
                                  itemBuilder: (BuildContext context) => [
                                    PopupMenuItem<String>(
                                      value: 'remove_resume',
                                      child: Row(
                                        children: [
                                          Icon(Icons.delete,
                                              color: const Color.fromARGB(255,
                                                  138, 45, 38)), // Delete icon
                                          SizedBox(width: 8),
                                          Text(
                                            'Remove Resume',
                                            style: TextStyle(
                                                color: const Color.fromARGB(
                                                    255, 138, 45, 38)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              : SizedBox(),
                        ],
                      ),
                      Gap(10),
                      Text(
                        widget.subtitle,
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xff373030),
                          fontFamily: 'Galano',
                          fontWeight: FontWeight.w100,
                        ),
                      ),
                      Gap(40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              _generateAndDownloadPdf("${fname}_${lname}");
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.picture_as_pdf_rounded,
                                  size: 25,
                                  color: Colors.orange,
                                ),
                                Gap(5),
                                Text(
                                  'Export to PDF',
                                  style: TextStyle(
                                      color: Colors.orange, fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Gap(10),
                      Container(
                        padding: EdgeInsets.all(40),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 0.5),
                            borderRadius: BorderRadius.circular(30)),
                        child: Screenshot(
                          controller: _screenshotController,
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  Row(
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: CircleAvatar(
                                          radius: 80,
                                          backgroundColor: Colors.grey[700],
                                          foregroundColor: Colors.white,
                                          child: fname.isNotEmpty &&
                                                  lname.isNotEmpty
                                              ? Text("${fname[0]}${lname[0]}",
                                                  style: TextStyle(
                                                      fontSize: 50,
                                                      fontWeight:
                                                          FontWeight.bold))
                                              : Icon(
                                                  Icons.person,
                                                  size: 80,
                                                  color: Colors.white,
                                                ),
                                        ),
                                      ),
                                      Gap(50),
                                      fname.isNotEmpty ||
                                              lname.isNotEmpty ||
                                              pnumber.isNotEmpty ||
                                              email.isNotEmpty ||
                                              locationData.isNotEmpty
                                          ? Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start, // Align content to the start
                                                children: [
                                                  Row(
                                                    children: [
                                                      Flexible(
                                                        child: Text(
                                                          '${fname}',
                                                          style: TextStyle(
                                                            fontSize: 30,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Color(
                                                                0xff373030),
                                                            fontFamily:
                                                                'Galano',
                                                          ),
                                                          maxLines:
                                                              2, // Allow text to wrap to the next line if needed
                                                          overflow: TextOverflow
                                                              .visible,
                                                        ),
                                                      ),
                                                      Gap(5),
                                                      Flexible(
                                                        child: Text(
                                                          '${lname}',
                                                          style: TextStyle(
                                                            fontSize: 30,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Color(
                                                                0xff373030),
                                                            fontFamily:
                                                                'Galano',
                                                          ),
                                                          maxLines:
                                                              2, // Allow text to wrap to the next line if needed
                                                          overflow: TextOverflow
                                                              .visible,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Gap(5),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      '${pnumber}',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color:
                                                            Color(0xff373030),
                                                        fontFamily: 'Galano',
                                                      ),
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.visible,
                                                    ),
                                                  ),
                                                  Gap(5),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      '${email}',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color:
                                                            Color(0xff373030),
                                                        fontFamily: 'Galano',
                                                      ),
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.visible,
                                                    ),
                                                  ),
                                                  Gap(5),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      '${locationData['otherLocation'] ?? ''} '
                                                      '${locationData['barangayName'] != null ? locationData['barangayName'] + ', ' : ''}'
                                                      '${locationData['cityName'] != null ? locationData['cityName'] + ', ' : ''}'
                                                      '${locationData['provinceName'] != null ? locationData['provinceName'] + ', ' : ''}'
                                                      '${locationData['regionName'] ?? ''}',
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color:
                                                            Color(0xff373030),
                                                        fontFamily: 'Galano',
                                                      ),
                                                      maxLines:
                                                          3, // Allow wrapping onto multiple lines
                                                      overflow:
                                                          TextOverflow.visible,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.4,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.grey,
                                                  width: 0.5,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      50.0),
                                                  child: Text(
                                                    'Personal Information will appear here',
                                                    style: TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      fontSize: 16,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                    ],
                                  ),
                                  if (!isExporting)
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: IconButton(
                                        icon: Icon(Icons.edit),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return EditPersonalInfoDialog();
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: Divider(
                                  color: Colors.grey,
                                  thickness: 0.5,
                                ),
                              ),
                              Stack(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Gap(20),
                                            Text(
                                              'Objective',
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: Color(0xff373030),
                                                fontFamily: 'Galano',
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            Gap(10),
                                            objective.isNotEmpty
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            12.0),
                                                    child: Text(
                                                      objective,
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color:
                                                            Color(0xff373030),
                                                        fontFamily: 'Galano',
                                                        fontWeight:
                                                            FontWeight.w100,
                                                      ),
                                                    ),
                                                  )
                                                : Container(
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: Colors.grey,
                                                        width: 0.5,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                    child: Center(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(50),
                                                        child: Text(
                                                          'Objective will appear here',
                                                          style: TextStyle(
                                                            fontStyle: FontStyle
                                                                .italic,
                                                            fontSize: 16,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (!isExporting)
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: IconButton(
                                        icon: Icon(Icons.edit),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return EditObjectiveDialog();
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: Divider(
                                  color: Colors.grey,
                                  thickness: 0.5,
                                ),
                              ),
                              Stack(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Gap(20),
                                            Text(
                                              'Skills',
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: Color(0xff373030),
                                                fontFamily: 'Galano',
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            Gap(10),
                                            selectedSkills.isNotEmpty
                                                ? Wrap(
                                                    spacing: 8.0,
                                                    runSpacing: 8.0,
                                                    children: List.generate(
                                                      selectedSkills.length,
                                                      (index) => Card(
                                                        elevation: 0,
                                                        color: Colors.grey[200],
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(12.0),
                                                          child: Text(
                                                            selectedSkills[
                                                                index],
                                                            style: TextStyle(
                                                              fontSize: 16.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: Colors
                                                                  .black87,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : Container(
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: Colors.grey,
                                                        width: 0.5,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                    child: Center(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(50.0),
                                                        child: Text(
                                                          'Skills will appear here',
                                                          style: TextStyle(
                                                            fontStyle: FontStyle
                                                                .italic,
                                                            fontSize: 16,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (!isExporting)
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: IconButton(
                                        icon: Icon(Icons.edit),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return EditSkillsDialog();
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: Divider(
                                  color: Colors.grey,
                                  thickness: 0.5,
                                ),
                              ),
                              Stack(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Gap(20),
                                            Text(
                                              'Education',
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: Color(0xff373030),
                                                fontFamily: 'Galano',
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            Gap(10),
                                            educationEntries.isNotEmpty
                                                ? Column(
                                                    children: List.generate(
                                                      educationEntries.length,
                                                      (index) {
                                                        final entry =
                                                            educationEntries[
                                                                index];
                                                        String timePeriod = entry
                                                                .isPresent
                                                            ? (entry.fromSelectedMonth ==
                                                                        null ||
                                                                    entry.fromSelectedYear ==
                                                                        null
                                                                ? (entry.toSelectedMonth ==
                                                                        null
                                                                    ? '${entry.toSelectedYear}'
                                                                    : '${entry.toSelectedMonth} ${entry.toSelectedYear}')
                                                                : '${entry.fromSelectedMonth} ${entry.fromSelectedYear} to Present')
                                                            : (entry.fromSelectedMonth ==
                                                                        null ||
                                                                    entry.fromSelectedYear ==
                                                                        null
                                                                ? (entry.toSelectedMonth ==
                                                                        null
                                                                    ? '${entry.toSelectedYear}'
                                                                    : '${entry.toSelectedMonth} ${entry.toSelectedYear}')
                                                                : '${entry.fromSelectedMonth} ${entry.fromSelectedYear} to ${entry.toSelectedMonth} ${entry.toSelectedYear}');

                                                        return Row(
                                                          children: [
                                                            Expanded(
                                                              child: Card(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        bottom:
                                                                            20.0),
                                                                elevation: 0,
                                                                color: Colors
                                                                    .grey[100],
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                ),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          20.0),
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Text(
                                                                            entry.degree,
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 18.0,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.black87,
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            timePeriod,
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 14.0,
                                                                              fontStyle: FontStyle.italic,
                                                                              color: Colors.black87,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                          height:
                                                                              8.0),
                                                                      Row(
                                                                        children: [
                                                                          Icon(
                                                                              Icons.school_rounded,
                                                                              color: Colors.black54,
                                                                              size: 15),
                                                                          Gap(5),
                                                                          Text(
                                                                            entry.institutionName,
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 16.0,
                                                                              fontWeight: FontWeight.w500,
                                                                              color: Colors.black54,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                          height:
                                                                              4.0),
                                                                      if (entry
                                                                          .institutionAddress
                                                                          .trim()
                                                                          .isNotEmpty)
                                                                        Row(
                                                                          children: [
                                                                            Icon(Icons.location_on_rounded,
                                                                                color: Colors.black54,
                                                                                size: 15),
                                                                            Gap(5),
                                                                            Text(
                                                                              entry.institutionAddress,
                                                                              style: TextStyle(
                                                                                fontSize: 14.0,
                                                                                color: Colors.black54,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      SizedBox(
                                                                          height:
                                                                              8.0),
                                                                      SizedBox(
                                                                          height:
                                                                              8.0),
                                                                      if (entry
                                                                          .honorsOrAwards
                                                                          .trim()
                                                                          .isNotEmpty) ...[
                                                                        Text(
                                                                          "Honors and Awards",
                                                                          style:
                                                                              TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            fontSize:
                                                                                14.0,
                                                                            color:
                                                                                Colors.black54,
                                                                          ),
                                                                        ),
                                                                        Gap(10),
                                                                        Text(
                                                                          entry
                                                                              .honorsOrAwards,
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                14.0,
                                                                            color:
                                                                                Colors.black54,
                                                                          ),
                                                                        ),
                                                                      ]
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    ),
                                                  )
                                                : Container(
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: Colors.grey,
                                                        width: 0.5,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                    child: Center(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(50.0),
                                                        child: Text(
                                                          'Education will appear here',
                                                          style: TextStyle(
                                                            fontStyle: FontStyle
                                                                .italic,
                                                            fontSize: 16,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (!isExporting)
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: IconButton(
                                        icon: Icon(Icons.edit),
                                        onPressed: () {},
                                      ),
                                    ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: Divider(
                                  color: Colors.grey,
                                  thickness: 0.5,
                                ),
                              ),
                              Stack(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Gap(20),
                                            Text(
                                              'Work Experience',
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: Color(0xff373030),
                                                fontFamily: 'Galano',
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            Gap(10),
                                            experienceEntries.isNotEmpty
                                                ? Column(
                                                    children: List.generate(
                                                      experienceEntries.length,
                                                      (index) {
                                                        final entry =
                                                            experienceEntries[
                                                                index];
                                                        String timePeriod = entry
                                                                .isPresent
                                                            ? (entry.fromSelectedMonth ==
                                                                        null ||
                                                                    entry.fromSelectedYear ==
                                                                        null
                                                                ? (entry.toSelectedMonth ==
                                                                        null
                                                                    ? '${entry.toSelectedYear}'
                                                                    : '${entry.toSelectedMonth} ${entry.toSelectedYear}')
                                                                : '${entry.fromSelectedMonth} ${entry.fromSelectedYear} to Present')
                                                            : (entry.fromSelectedMonth ==
                                                                        null ||
                                                                    entry.fromSelectedYear ==
                                                                        null
                                                                ? (entry.toSelectedMonth ==
                                                                        null
                                                                    ? '${entry.toSelectedYear}'
                                                                    : '${entry.toSelectedMonth} ${entry.toSelectedYear}')
                                                                : '${entry.fromSelectedMonth} ${entry.fromSelectedYear} to ${entry.toSelectedMonth} ${entry.toSelectedYear}');

                                                        return Row(
                                                          children: [
                                                            Expanded(
                                                              child: Card(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        bottom:
                                                                            20.0),
                                                                elevation: 0,
                                                                color: Colors
                                                                    .grey[100],
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                ),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          20.0),
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Text(
                                                                            entry.jobTitle,
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 18.0,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.black87,
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            timePeriod,
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 14.0,
                                                                              fontStyle: FontStyle.italic,
                                                                              color: Colors.black87,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                          height:
                                                                              8.0),
                                                                      Row(
                                                                        children: [
                                                                          Icon(
                                                                              Icons.business_center_rounded,
                                                                              color: Colors.black54,
                                                                              size: 15),
                                                                          Gap(5),
                                                                          Text(
                                                                            entry.companyName,
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 16.0,
                                                                              fontWeight: FontWeight.w500,
                                                                              color: Colors.black54,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                          height:
                                                                              4.0),
                                                                      Row(
                                                                        children: [
                                                                          Icon(
                                                                              Icons.location_on_rounded,
                                                                              color: Colors.black54,
                                                                              size: 15),
                                                                          Gap(5),
                                                                          Text(
                                                                            entry.companyAddress,
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 14.0,
                                                                              color: Colors.black54,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                          height:
                                                                              8.0),
                                                                      SizedBox(
                                                                          height:
                                                                              8.0),
                                                                      if (entry
                                                                          .responsibilitiesAchievements
                                                                          .trim()
                                                                          .isNotEmpty) ...[
                                                                        Text(
                                                                          "Key Responsibilities and Achievements",
                                                                          style:
                                                                              TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            fontSize:
                                                                                14.0,
                                                                            color:
                                                                                Colors.black54,
                                                                          ),
                                                                        ),
                                                                        Gap(10),
                                                                        Text(
                                                                          entry
                                                                              .responsibilitiesAchievements,
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                14.0,
                                                                            color:
                                                                                Colors.black54,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    ),
                                                  )
                                                : Container(
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: Colors.grey,
                                                        width: 0.5,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                    child: Center(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(50.0),
                                                        child: Text(
                                                          'Work Experience will appear here',
                                                          style: TextStyle(
                                                            fontStyle: FontStyle
                                                                .italic,
                                                            fontSize: 16,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (!isExporting)
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: IconButton(
                                        icon: Icon(Icons.edit),
                                        onPressed: () {},
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 50),
                      widget.inProfile == true
                          ? SizedBox()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: SizedBox(
                                    width: 230,
                                    child: BlueFilledCircleButton(
                                      onPressed: _submitResume,
                                      text: 'Save and Continue',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                      SizedBox(height: 20),
                    ],
                  );
                }),
              ),
            ),
          ),
          Positioned(
            top: 60,
            left: 350,
            child: IconButton(
              icon: Image.asset(
                'assets/images/backbutton.png',
                width: 20,
                height: 20,
              ),
              onPressed: widget.previousPage,
            ),
          ),
        ],
      ),
    );
  }
}