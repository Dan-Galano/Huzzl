import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/class/education_entry_model.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/class/experience_entry_model.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/providers/resume_provider.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/widgets/open_in_newtab.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ResumeView extends StatefulWidget {
  final String jobPostId;
  final String jobSeekerId;
  final String jobApplication;

  ResumeView({
    Key? key,
    required this.jobPostId,
    required this.jobSeekerId,
    required this.jobApplication,
  }) : super(key: key);

  @override
  State<ResumeView> createState() => _ResumeViewState();
}

class _ResumeViewState extends State<ResumeView> {
  String fname = '';
  String lname = '';
  String pnumber = '';
  String email = '';
  Map<String, dynamic> locationData = {};
  String objective = '';
  List<String> selectedSkills = [];
  List<EducationEntry> educationEntries = [];
  List<ExperienceEntry> experienceEntries = [];
  // late PdfViewerController _pdfViewerController;
  @override
  void initState() {
    super.initState();
    _loadResumeData();
  }

  Future<void> _loadResumeData() async {
    final resumeProvider = Provider.of<ResumeProvider>(context, listen: false);
    await resumeProvider.getResumeByJobSeekerId(widget.jobSeekerId);

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
    return SingleChildScrollView(
      child: Container(
        // margin: const EdgeInsets.symmetric(horizontal: 400.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                                child: fname.isNotEmpty && lname.isNotEmpty
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
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xff373030),
                                                fontFamily: 'Galano',
                                              ),
                                            ),
                                            Gap(5),
                                            Text(
                                              '${lname}',
                                              style: TextStyle(
                                                fontSize: 30,
                                                fontWeight: FontWeight.bold,
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
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 0.5,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(50.0),
                                        child: Text(
                                          'No Personal Information Provided',
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
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                          padding: const EdgeInsets.all(12.0),
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
                                              padding: const EdgeInsets.all(50),
                                              child: Text(
                                                'No Objective Provided',
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
                            ),
                          ],
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
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(12.0),
                                                child: Text(
                                                  selectedSkills[index],
                                                  style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.w500,
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
                                                  const EdgeInsets.all(50.0),
                                              child: Text(
                                                'No Skills Provided',
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
                            ),
                          ],
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
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                                      margin: EdgeInsets.only(
                                                          bottom: 20.0),
                                                      elevation: 0,
                                                      color: Colors.grey[100],
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(20.0),
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
                                                                  entry.degree,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        18.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .black87,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  timePeriod,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        14.0,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .italic,
                                                                    color: Colors
                                                                        .black87,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                                height: 8.0),
                                                            Row(
                                                              children: [
                                                                Icon(
                                                                    Icons
                                                                        .school_rounded,
                                                                    color: Colors
                                                                        .black54,
                                                                    size: 15),
                                                                Gap(5),
                                                                Text(
                                                                  entry
                                                                      .institutionName,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        16.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Colors
                                                                        .black54,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                                height: 4.0),
                                                            Row(
                                                              children: [
                                                                Icon(
                                                                    Icons
                                                                        .location_on_rounded,
                                                                    color: Colors
                                                                        .black54,
                                                                    size: 15),
                                                                Gap(5),
                                                                Text(
                                                                  entry
                                                                      .institutionAddress,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        14.0,
                                                                    color: Colors
                                                                        .black54,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                                height: 8.0),
                                                            SizedBox(
                                                                height: 8.0),
                                                            if (entry
                                                                .honorsOrAwards
                                                                .trim()
                                                                .isNotEmpty) ...[
                                                              Text(
                                                                "Honors and Awards",
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
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
                                                  const EdgeInsets.all(50.0),
                                              child: Text(
                                                ' No Education Provided',
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
                            ),
                          ],
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
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                                  experienceEntries[index];
                                              String timePeriod = entry
                                                      .isPresent
                                                  ? '${entry.fromSelectedMonth} ${entry.fromSelectedYear} to Present'
                                                  : '${entry.fromSelectedMonth} ${entry.fromSelectedYear} to ${entry.toSelectedMonth} ${entry.toSelectedYear}';

                                              return Row(
                                                children: [
                                                  Expanded(
                                                    child: Card(
                                                      margin: EdgeInsets.only(
                                                          bottom: 20.0),
                                                      elevation: 0,
                                                      color: Colors.grey[100],
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(20.0),
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
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .black87,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  timePeriod,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        14.0,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .italic,
                                                                    color: Colors
                                                                        .black54,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                                height: 8.0),
                                                            Row(
                                                              children: [
                                                                Icon(
                                                                    Icons
                                                                        .business_center_rounded,
                                                                    color: Colors
                                                                        .black54,
                                                                    size: 15),
                                                                Gap(5),
                                                                Text(
                                                                  entry
                                                                      .companyName,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        16.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Colors
                                                                        .black54,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                                height: 4.0),
                                                            Row(
                                                              children: [
                                                                Icon(
                                                                    Icons
                                                                        .location_on_rounded,
                                                                    color: Colors
                                                                        .black54,
                                                                    size: 15),
                                                                Gap(5),
                                                                Text(
                                                                  entry
                                                                      .companyAddress,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        14.0,
                                                                    color: Colors
                                                                        .black54,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                                height: 8.0),
                                                            SizedBox(
                                                                height: 8.0),
                                                            if (entry
                                                                .responsibilitiesAchievements
                                                                .trim()
                                                                .isNotEmpty) ...[
                                                              Text(
                                                                "Key Responsibilities and Achievements",
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
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
                                                  const EdgeInsets.all(50.0),
                                              child: Text(
                                                'No Work Experience Provided',
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
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



//draft

// Column(
//       crossAxisAlignment: CrossAxisAlignment.end,
//       children: [
//         TextButton(
//           onPressed: () => openPdfInNewTab('assets/pdf/myResume.pdf'),
//           child: Text(
//             "Open Resume in New Tab",
//             style: TextStyle(
//               color: Color(0xFFff9800),
//             ),
//           ),
//         ),
//         Container(
//           child: ConstrainedBox(
//             constraints: const BoxConstraints(
//               maxHeight: 900,
//               maxWidth: 800,
//             ),
//             child: SfPdfViewer.asset(
//               'assets/pdf/myResume.pdf',
//               controller: _pdfViewerController,
//               initialZoomLevel: 1.0,
//               canShowScrollHead: true,
//               canShowScrollStatus: true,
//               onDocumentLoaded: (details) => print('Document loaded'),
//               onDocumentLoadFailed: (details) =>
//                   print('Document failed to load'),
//             ),
//           ),
//         ),
//         Divider(
//           thickness: 2,
//           color: Color(0xFFff9800),
//           height: 60,
//         ),
//       ],
//     );