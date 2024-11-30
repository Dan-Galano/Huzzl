import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/user-provider.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/class/education_entry_model.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/class/experience_entry_model.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/providers/appstate.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/providers/resume_provider.dart';
import 'package:huzzl_web/views/job%20seekers/main_screen.dart';
import 'package:huzzl_web/widgets/buttons/blue/bluefilled_circlebutton.dart';
import 'package:huzzl_web/widgets/loading_dialog.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

class ResumePageSummary extends StatefulWidget {
  final VoidCallback nextPage;
  final VoidCallback previousPage;
  final Function(Map<String, dynamic>) onSaveResumeSetup;
  final Map<String, dynamic>? currentResumeOption;
  final int noOfPages;
  final int noOfResumePages;
  const ResumePageSummary({
    super.key,
    required this.nextPage,
    required this.previousPage,
    required this.onSaveResumeSetup,
    required this.currentResumeOption,
    required this.noOfPages,
    required this.noOfResumePages,
  });

  @override
  _ResumePageSummaryState createState() => _ResumePageSummaryState();
}

class _ResumePageSummaryState extends State<ResumePageSummary> {
  String fname = '';
  String lname = '';
  String pnumber = '';
  String email = '';
  Map<String, dynamic> locationData = {};
  String objective = '';
  List<String> selectedSkills = [];
  List<EducationEntry> educationEntries = [];
  List<ExperienceEntry> experienceEntries = [];

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
    final appState = Provider.of<AppState>(context, listen: false);
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
    };

    Map<String, dynamic> jobPreferences = {
      'selectedLocation': appState.selectedLocation,
      'selectedPayRate': appState.selectedPayRate,
      'currentSelectedJobTitles': appState.currentSelectedJobTitles,
      'uid': userId,
    };

    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      CollectionReference usersRef =
          firestore.collection('users').doc(userId).collection('resume');

      QuerySnapshot existingResumes = await usersRef.get();

      await usersRef.doc(userId).set(jobPreferences, SetOptions(merge: true));
      print('Job preferences saved successfully!');

      if (existingResumes.docs.isEmpty) {
        DocumentReference newResumeDoc = await usersRef.add(resumeData);
        await newResumeDoc.update(
            {'resumeDocId': newResumeDoc.id, 'updatedAt': Timestamp.now()});
        print('Resume created successfully!');
      } else {
        await usersRef
            .doc(existingResumes.docs.first.id)
            .set(resumeData, SetOptions(merge: true));
        print('Resume merged successfully!');
      }

      print('resume saved successfully!');

      _showLoadingDialog(context);

      await Future.delayed(Duration(seconds: 3));

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) => JobseekerMainScreen(uid: userId)),
      );
    } catch (e) {
      print('Error saving job preferences and resume: $e');
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 40),
                    Row(
                      children: [
                        Expanded(
                          child: LinearPercentIndicator(
                            animation: true,
                            animationDuration: 300,
                            animateFromLastPercent: true,
                            barRadius: Radius.circular(20),
                            lineHeight: 10,
                            percent:
                                widget.noOfResumePages / widget.noOfResumePages,
                            backgroundColor: Colors.orange.withOpacity(0.4),
                            progressColor: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 40),
                    Text(
                      'Review your Huzzl resume',
                      style: TextStyle(
                        fontSize: 24,
                        color: Color(0xff373030),
                        fontFamily: 'Galano',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      "Review and finalize the details of your Huzzl resume before submission.",
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xff373030),
                        fontFamily: 'Galano',
                        fontWeight: FontWeight.w100,
                      ),
                    ),
                    Gap(40),
                    Container(
                      padding: EdgeInsets.all(40),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 0.5),
                          borderRadius: BorderRadius.circular(30)),
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
                                                  fontWeight: FontWeight.bold))
                                          : Icon(
                                              Icons.person,
                                              size: 80,
                                              color: Colors.white,
                                            ),
                                    ),
                                  ),
                                  Gap(50),
                                  fname.isNotEmpty &&
                                          lname.isNotEmpty &&
                                          pnumber.isNotEmpty &&
                                          email.isNotEmpty &&
                                          locationData.isNotEmpty
                                      ? Expanded(
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    '${fname}',
                                                    style: TextStyle(
                                                      fontSize: 30,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color(0xff373030),
                                                      fontFamily: 'Galano',
                                                    ),
                                                  ),
                                                  Gap(5),
                                                  Text(
                                                    '${lname}',
                                                    style: TextStyle(
                                                      fontSize: 30,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color(0xff373030),
                                                      fontFamily: 'Galano',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Gap(5),
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  '${pnumber}',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Color(0xff373030),
                                                    fontFamily: 'Galano',
                                                  ),
                                                ),
                                              ),
                                              Gap(5),
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  '${email}',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Color(0xff373030),
                                                    fontFamily: 'Galano',
                                                  ),
                                                ),
                                              ),
                                              Gap(5),
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  '${locationData['otherLocation'] ?? ''} '
                                                  '${locationData['barangayName'] != null ? locationData['barangayName'] + ', ' : ''}'
                                                  '${locationData['cityName'] != null ? locationData['cityName'] + ', ' : ''}'
                                                  '${locationData['provinceName'] != null ? locationData['provinceName'] + ', ' : ''}'
                                                  '${locationData['regionName'] ?? ''}',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Color(0xff373030),
                                                    fontFamily: 'Galano',
                                                  ),
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
                                              padding:
                                                  const EdgeInsets.all(50.0),
                                              child: Text(
                                                'Personal Information will appear here',
                                                style: TextStyle(
                                                  fontStyle: FontStyle.italic,
                                                  fontSize: 16,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                ],
                              ),
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
                                                    const EdgeInsets.all(12.0),
                                                child: Text(
                                                  objective,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Color(0xff373030),
                                                    fontFamily: 'Galano',
                                                    fontWeight: FontWeight.w100,
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
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Center(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            50),
                                                    child: Text(
                                                      'Objective will appear here',
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
                                  ),
                                ],
                              ),
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
                                                spacing:
                                                    8.0, // Horizontal space between the cards
                                                runSpacing:
                                                    8.0, // Vertical space between the cards
                                                children: List.generate(
                                                  selectedSkills.length,
                                                  (index) => Card(
                                                    elevation: 0,
                                                    color: Colors.grey[200],
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              12.0),
                                                      child: Text(
                                                        selectedSkills[index],
                                                        style: TextStyle(
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.black87,
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
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Center(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            50.0),
                                                    child: Text(
                                                      'Skills will appear here',
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
                                  ),
                                ],
                              ),
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
                                                        educationEntries[index];
                                                    String timePeriod = entry
                                                            .isPresent
                                                        ? '${entry.fromSelectedMonth} ${entry.fromSelectedYear} to Present'
                                                        : '${entry.fromSelectedMonth} ${entry.fromSelectedYear} to ${entry.toSelectedMonth} ${entry.toSelectedYear}';

                                                    return Row(
                                                      children: [
                                                        Expanded(
                                                          child: Card(
                                                            margin:
                                                                EdgeInsets.only(
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
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Text(
                                                                        entry
                                                                            .degree,
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              18.0,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          color:
                                                                              Colors.black87,
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        timePeriod,
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              14.0,
                                                                          fontStyle:
                                                                              FontStyle.italic,
                                                                          color:
                                                                              Colors.black87,
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
                                                                          Icons
                                                                              .school_rounded,
                                                                          color: Colors
                                                                              .black54,
                                                                          size:
                                                                              15),
                                                                      Gap(5),
                                                                      Text(
                                                                        entry
                                                                            .institutionName,
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              16.0,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          color:
                                                                              Colors.black54,
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
                                                                          Icons
                                                                              .location_on_rounded,
                                                                          color: Colors
                                                                              .black54,
                                                                          size:
                                                                              15),
                                                                      Gap(5),
                                                                      Text(
                                                                        entry
                                                                            .institutionAddress,
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              14.0,
                                                                          color:
                                                                              Colors.black54,
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
                                                                        color: Colors
                                                                            .black54,
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
                                                                        color: Colors
                                                                            .black54,
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
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Center(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            50.0),
                                                    child: Text(
                                                      'Education will appear here',
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
                                  ),
                                ],
                              ),
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
                                                        ? '${entry.fromSelectedMonth} ${entry.fromSelectedYear} to Present'
                                                        : '${entry.fromSelectedMonth} ${entry.fromSelectedYear} to ${entry.toSelectedMonth} ${entry.toSelectedYear}';

                                                    return Row(
                                                      children: [
                                                        Expanded(
                                                          child: Card(
                                                            margin:
                                                                EdgeInsets.only(
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
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Text(
                                                                        entry
                                                                            .jobTitle,
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              18.0,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          color:
                                                                              Colors.black87,
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        timePeriod,
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              14.0,
                                                                          fontStyle:
                                                                              FontStyle.italic,
                                                                          color:
                                                                              Colors.black54,
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
                                                                          Icons
                                                                              .business_center_rounded,
                                                                          color: Colors
                                                                              .black54,
                                                                          size:
                                                                              15),
                                                                      Gap(5),
                                                                      Text(
                                                                        entry
                                                                            .companyName,
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              16.0,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          color:
                                                                              Colors.black54,
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
                                                                          Icons
                                                                              .location_on_rounded,
                                                                          color: Colors
                                                                              .black54,
                                                                          size:
                                                                              15),
                                                                      Gap(5),
                                                                      Text(
                                                                        entry
                                                                            .companyAddress,
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              14.0,
                                                                          color:
                                                                              Colors.black54,
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
                                                                        color: Colors
                                                                            .black54,
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
                                                                        color: Colors
                                                                            .black54,
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
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Center(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            50.0),
                                                    child: Text(
                                                      'Work Experience will appear here',
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
                                  ),
                                ],
                              ),
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
                    SizedBox(height: 50),
                    Row(
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
                ),
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
