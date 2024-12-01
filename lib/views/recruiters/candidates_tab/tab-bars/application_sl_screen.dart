import 'package:drop_down_search_field/drop_down_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/recruiters/branches_tab/widgets/customDropdown.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/models/candidate.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/widgets/views/application_view.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/widgets/dialogs/moveback_confirmation_dialog.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/widgets/dialogs/rejection_dialog.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/widgets/views/resume_view.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/widgets/skillchip.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/widgets/tabbar_inside.dart';
import 'package:huzzl_web/views/recruiters/home/00%20home.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/calendar_ui/applicant_model.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/calendar_ui/interview_model.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/controller/interview_provider.dart';
import 'package:huzzl_web/views/recruiters/jobs_tab/controller/job_provider_candidate.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class SlApplicationScreen extends StatefulWidget {
  final VoidCallback onBack;
  final String candidateId;
  final Candidate candidate;
  SlApplicationScreen({
    Key? key,
    required this.onBack,
    required this.candidateId,
    required this.candidate,
  }) : super(key: key);

  @override
  State<SlApplicationScreen> createState() => _SlApplicationScreenState();
}

class _SlApplicationScreenState extends State<SlApplicationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  void _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'eleanorpena@gmail.com',
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw 'Could not launch $emailUri';
    }
  }

  late JobProviderCandidate _jobProvider;
  late InterviewProvider _interviewProvider;

  @override
  void initState() {
    super.initState();
    _jobProvider = Provider.of<JobProviderCandidate>(context, listen: false);
    _interviewProvider = Provider.of<InterviewProvider>(context, listen: false);

    _tabController = TabController(length: 2, vsync: this);
    candidateNameController.text =
        _jobProvider.findDataOfCandidate(widget.candidateId)!.name;

    _tabController.addListener(() {
      setState(() {});
    });

    // selectedDate = today;
    selectedType = 'Online';

    getRecruiterName();
    // _interviewProvider.fetchInterviews(widget.candidateId, widget.candidate!.jobPostId);

    print("SANA MERON: ${widget.candidateId}, ${widget.candidate!.jobPostId}");
  }

  void getRecruiterName() async {
    lateRecruiterName = await _jobProvider.getCurrentUserName();
    setState(() {
      recruiterName = lateRecruiterName;
      interviewerNameController.text = recruiterName;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  DateTime today = DateTime.now();
  DateTime currentDate = DateTime.now();
  CalendarController _calendarController = CalendarController();

  //Here
  final candidateNameController = TextEditingController();
  final interviewerNameController = TextEditingController();

  late String lateRecruiterName;
  String recruiterName = "";

  final List<Applicant> applicants = [
    Applicant(
      pfp: 'assets/images/pfp/sampleID1.png',
      name: 'John Doe',
      job: 'Software Engineer',
      branch: 'Jollibee - Magic Mall Urdaneta',
    ),
    Applicant(
      pfp: 'assets/images/pfp/fsampleID1.jpg',
      name: 'Jane Smith',
      job: 'Project Manager',
      branch: 'Jollibee - SM City Manila',
    ),
    Applicant(
      pfp: 'assets/images/pfp/sampleID2.png',
      name: 'Michael Johnson',
      job: 'UX Designer',
      branch: 'Jollibee - SM City North EDSA',
    ),
    Applicant(
      pfp: 'assets/images/pfp/fsampleID2.jpg',
      name: 'Emily Davis',
      job: 'Data Scientist',
      branch: 'Jollibee - Robinsons Galleria Cebu',
    ),
    Applicant(
      pfp: 'assets/images/pfp/sample1D3.png',
      name: 'James Brown',
      job: 'Product Owner',
      branch: 'Jollibee - Ayala Malls Cloverleaf',
    ),
    Applicant(
      pfp: 'assets/images/pfp/fsampleID3.jpg',
      name: 'Sophia Garcia',
      job: 'QA Tester',
      branch: 'Jollibee - Trinoma',
    ),
    Applicant(
      name: 'Olivia Wilson',
      job: 'System Analyst',
      branch: 'Jollibee - SM City Iloilo',
      pfp: 'assets/images/pfp/fsampleID4.jpg',
    ),
    Applicant(
      name: 'William Martinez',
      job: 'DevOps Engineer',
      branch: 'Jollibee - Market! Market!',
      pfp: 'assets/images/pfp/sampleID4.png',
    ),
    Applicant(
      name: 'Liam Anderson',
      job: 'Front-end Developer',
      branch: 'Jollibee - SM City Clark',
      pfp: 'assets/images/pfp/sampleID5.png',
    ),
    Applicant(
      name: 'Noah Thomas',
      job: 'Back-end Developer',
      branch: 'Jollibee - Alabang Town Center',
      pfp: 'assets/images/pfp/sampleID6.png',
    ),
    Applicant(
      name: 'Lucas Lee',
      job: 'Mobile Developer',
      branch: 'Jollibee - SM City Dasmariñas',
      pfp: 'assets/images/pfp/sampleID7.png',
    ),
    Applicant(
      pfp: 'assets/images/pfp/fsampleID5.jpg',
      name: 'Mia Walker',
      job: 'Marketing Specialist',
      branch: 'Jollibee - Greenhills Shopping Center',
    ),
    Applicant(
      pfp: 'assets/images/pfp/fsampleID6.jpg',
      name: 'Isabella Hall',
      job: 'HR Manager',
      branch: 'Jollibee - Glorietta 4',
    ),
  ];

  List<String> staffs = [
    'Aiden Reed',
    'Harper Lewis',
    'Ethan Scott',
    'Chloe Turner',
    'Mason White',
    'Avery Mitchell',
    'Logan Young',
    'Abigail Collins',
    'Jackson Brooks',
    'Ella Ramirez',
    'Henry Foster',
    'Grace Bennett',
    'Daniel Morgan',
  ];

  final List<String> interviewTypes = ['Online', 'F2F'];
  List<String> selectedInterviewers = [];
  Applicant? selectedApplicant;
  String? selectedType;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  TextEditingController eventController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _dropdownSearchFieldController =
      TextEditingController();

  SuggestionsBoxController suggestionBoxController = SuggestionsBoxController();

  void saveInterviewToDB(InterviewEvent e) {
    //Aside from adding it to local list, add it also into the firebase
    print(
        "Interview event details: ${e.applicant} ${e.date} ${e.interviewers}");
    // setState(() {
    //   events.add(e);
    // });

    _jobProvider.forInterviewCandidate(widget.candidateId);

    _interviewProvider.saveInterview(
      e,
      widget.candidateId,
      widget.candidate.jobPostId,
      widget.candidate.id,
      widget.candidate.jobApplicationDocId!,
      widget.candidate.profession,
    );
    _jobProvider.pushNotificationToJobseeker(
      widget.candidate.jobPostId,
      widget.candidate.id,
      'You have been scheduled for Interview: ${e.title}',
      "${e.notes} The date of your interview is ${e.date}. Starts in ${e.startTime}, end in ${e.endTime}.",
    );
    resetScheduleInterviewerForm();
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  void showSaveInterviewConfirmationDialog(
      BuildContext context, InterviewEvent e) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
              ),
              content: Container(
                width: MediaQuery.of(context).size.width * 0.4,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Confirm Interview",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Gap(10),
                    Text(
                      "Do you want to save this interview?",
                      style: TextStyle(fontSize: 16),
                    ),
                    Gap(8),
                    Text(
                      "Saving this will notify the applicant with the interview details.",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF157925),
                      ),
                    ),
                    Gap(20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 8),
                            backgroundColor: Color.fromARGB(255, 180, 180, 180),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Gap(10),
                        TextButton(
                          onPressed: () {
                            debugPrint("TO BE SAVED TO DB:\n"
                                // "Recruiter ID: $recruiterId\n"
                                "Jobseeker ID: ${widget.candidateId}\n"
                                "Job Post ID: ${widget.candidate.jobPostId}\n"
                                "Interview Details:\n"
                                "- Applicant: ${e.applicant}\n"
                                "- Title: ${e.title}\n"
                                "- Type: ${e.type}\n"
                                "- Interviewers: ${e.interviewers}\n"
                                "- Date: ${e.date}\n"
                                "- Start Time: ${e.startTime}\n"
                                "- End Time: ${e.endTime}\n"
                                "- Notes: ${e.notes}\n"
                                "- Location: ${e.location ?? 'No location'}");
                            saveInterviewToDB(e);
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 8),
                            backgroundColor: const Color(0xFF157925),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Save this interview',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void showCancelInterviewConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
              ),
              content: Container(
                width: MediaQuery.of(context).size.width * 0.4,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Cancel Scheduling",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Gap(10),
                    Text(
                      "Are you sure you want to cancel scheduling this interview?",
                      style: TextStyle(fontSize: 16),
                    ),
                    Gap(8),
                    Text(
                      "All entered information will be lost and won't be saved.",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFd74a4a),
                      ),
                    ),
                    Gap(20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 8),
                            backgroundColor: Color.fromARGB(255, 180, 180, 180),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Keep Editing',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Gap(10),
                        TextButton(
                          onPressed: () {
                            resetScheduleInterviewerForm();
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 8),
                            backgroundColor: const Color(0xFFd74a4a),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Yes, Cancel',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  List<Applicant> getSuggestions(String query) {
    List<Applicant> matches = applicants
        .where((applicant) =>
            applicant.name.toLowerCase().contains(query.toLowerCase()) ||
            applicant.job.toLowerCase().contains(query.toLowerCase()) ||
            applicant.branch!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return matches;
  }

  List<InterviewEvent> getScheduledInterviews(DateTime date) {
    return events
        .where((event) =>
            event.date?.year == date.year &&
            event.date?.month == date.month &&
            event.date?.day == date.day)
        .toList();
  }

  bool hasEvents(DateTime date) {
    return getScheduledInterviews(date).isNotEmpty;
  }

  DateTime? selectedDate;
  Future<void> _selectDate(BuildContext context, StateSetter setState) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Default to the current date
      firstDate: DateTime.now(), // Earliest date selectable
      lastDate: DateTime(2100), // Latest date selectable
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }

    debugPrint("Selected dateeee: $selectedDate");

    if (selectedDate != null) {
      debugPrint("Hindi siya nulllll ${formatDate(selectedDate!)}");
    }
  }

  String formatDate(DateTime dateTime) {
    return DateFormat('MMMM dd, yyyy').format(dateTime); // January 20, 2024
  }

  List<InterviewEvent> events = [
    InterviewEvent(
      applicant: "PAtrick",
      title: 'First Round Interview',
      type: 'F2F',
      interviewers: [
        'Dan Galano',
        'Monica Ave',
        'Dan Galano',
        'Monica Ave',
        'Dan Galano',
        'Monica Ave'
      ],
      date: DateTime.now(),
      startTime: TimeOfDay.now(),
      endTime: TimeOfDay.now(),
      notes: 'Bring your guts!!!',
      location:
          'Rm 230, 2nd Floor, XYZ Bldg., ABC st., Urdaneta City, Pangasinan',
    ),
    //   InterviewEvent(
    //     applicant: Applicant(
    //       name: 'Dessa Mine',
    //       job: 'Graphic Designer',
    //       branch: 'Urdaneta',
    //     ),
    //     title: 'Second Round Interview',
    //     type: 'F2F',
    //     interviewers: ['Dan Galano', 'Monica Ave'],
    //     date: DateTime(2024, 9, 27),
    //     startTime: TimeOfDay.now(),
    //     endTime: TimeOfDay.now(),
    //     notes: 'Bring your guts!!!',
    //     location:
    //         'Rm 230, 2nd Floor, XYZ Bldg., ABC st., Urdaneta City, Pangasinan',
    //   ),
    //   InterviewEvent(
    //     applicant:
    //         Applicant(name: 'Hana Montana', job: 'Dancerist', branch: 'Dagupan'),
    //     title: 'First Round Interview',
    //     type: 'Online',
    //     interviewers: ['Dan Galano', 'Monica Ave'],
    //     date: DateTime.now(),
    //     startTime: TimeOfDay.now(),
    //     endTime: TimeOfDay.now(),
    //     notes: 'Bring your guts!!!',
    //   )
  ];

  void resetScheduleInterviewerForm() {
    setState(() {
      selectedApplicant = null;
      titleController.clear();
      selectedType = 'Online';
      startTime = null;
      endTime = null;
      notesController.clear();
      selectedInterviewers.clear();
      _dropdownSearchFieldController.clear();
      locationController.clear();
    });
  }

  void _scheduleInterview(DateTime date) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              contentPadding: EdgeInsets.only(
                left: 40,
                right: 40,
                top: 20,
                bottom: 20,
              ),
              actionsPadding: EdgeInsets.only(
                bottom: 40,
                left: 40,
                right: 40,
              ),
              titlePadding: EdgeInsets.only(
                top: 40,
                left: 40,
                right: 40,
              ),
              title: Row(
                children: [
                  Text('Schedule New Interview ('),
                  Text(
                    DateFormat('MMM d, y').format(date) + ")",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // buildSearchDropdown(setState),
                    TextField(
                      controller: candidateNameController,
                      enabled: false,
                      decoration: InputDecoration(
                        // hintText: "",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                    InkWell(
                      mouseCursor: SystemMouseCursors.click,
                      onTap: () async {
                        await _selectDate(context, setState);
                        debugPrint("Date selection selected!!!");
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 5.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                        ),
                        child: Row(
                          children: [
                            Text(
                              selectedDate != null
                                  ? formatDate(
                                      selectedDate!) // Format the selected date
                                  : 'Select interview date', // Default text
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: selectedDate != null
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        label: Text('Enter title'),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Interview Type',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: buildCustomDropdown<String>(
                            value: selectedType ?? interviewTypes.first,
                            items: interviewTypes,
                            onChanged: (value) {
                              setState(() {
                                selectedType = value;
                                if (selectedType == 'Online') {
                                  locationController.clear();
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Visibility(
                      visible: selectedType == 'F2F',
                      child: TextField(
                        controller: locationController,
                        decoration: InputDecoration(
                          label: Text('Enter Location'),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    // buildMultiSelectDropdown(setState),
                    TextField(
                      controller: interviewerNameController,
                      enabled: false,
                      decoration: InputDecoration(
                        // hintText: "",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                    // TextField(
                    //   enabled: false,
                    //   style: TextStyle(color: Colors.black, fontSize: 16),
                    //   controller: TextEditingController(
                    //     text: DateFormat('yyyy-MM-dd').format(date),
                    //   ),
                    //   decoration: InputDecoration(
                    //     border: OutlineInputBorder(
                    //       borderRadius: BorderRadius.all(Radius.circular(10)),
                    //       borderSide: BorderSide(color: Colors.black),
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(height: 10),

                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            mouseCursor: SystemMouseCursors.click,
                            onTap: () async {
                              await _selectStartTime(context, setState);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.0,
                                  horizontal: 5.0), // Adjust padding as needed
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Row(
                                children: [
                                  // Show label only if startTime is selected
                                  if (startTime != null)
                                    Text(
                                      'Start Time: ',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16),
                                    ),
                                  Text(
                                    startTime != null
                                        ? '${startTime!.format(context)}'
                                        : 'Select Start Time',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: startTime != null
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                            width: 10), // Space between the two time fields
                        Expanded(
                          child: InkWell(
                            mouseCursor: SystemMouseCursors.click,
                            onTap: () async {
                              await _selectEndTime(context, setState);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.0,
                                  horizontal: 5.0), // Adjust padding as needed
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Row(
                                children: [
                                  // Show label only if endTime is selected
                                  if (endTime != null)
                                    Text(
                                      'End Time: ',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16),
                                    ),
                                  Text(
                                    endTime != null
                                        ? '${endTime!.format(context)}'
                                        : 'Select End Time',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: endTime != null
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Visibility(
                      visible: durationText(startTime, endTime) != '',
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            durationText(startTime, endTime),
                            style: TextStyle(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Additional Notes/Instructions',
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          ' (Optional)',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(
                              0xFFfd7206,
                            ),
                          ),
                        ),
                      ],
                    ),
                    TextField(
                      controller: notesController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText:
                            'e.g., "Candidate should bring portfolio," "Requires technical skills evaluation"', // Placeholder text
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              // Check if all relevant fields are empty
                              if (titleController.text.isEmpty &&
                                  selectedInterviewers.isEmpty &&
                                  startTime == null &&
                                  endTime == null &&
                                  selectedApplicant == null &&
                                  locationController.text.isEmpty) {
                                // If all fields are empty, simply pop off the dialog
                                Navigator.pop(context);
                                return;
                              }

                              // If at least one field is filled, show the confirmation dialog
                              showCancelInterviewConfirmationDialog(context);
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 16),
                              backgroundColor:
                                  Color.fromARGB(255, 180, 180, 180),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Gap(10),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              // Validate fields
                              if (titleController.text.isEmpty ||
                                  selectedType == null ||
                                  // selectedInterviewers.isEmpty ||
                                  startTime == null ||
                                  endTime == null) {
                                // Show message alert for missing general required fields
                                EasyLoading.showToast(
                                  'Please fill all required fields.',
                                  dismissOnTap: true,
                                  toastPosition: EasyLoadingToastPosition.top,
                                  duration: Duration(seconds: 3),
                                  maskType: EasyLoadingMaskType.black,
                                );

                                return; // Do not proceed with saving
                              }
// Now validate location only if 'F2F' is selected
                              if (selectedType == 'F2F' &&
                                  locationController.text.isEmpty) {
                                // Show message alert for missing location in 'F2F'
                                EasyLoading.showToast(
                                  'Please provide a location for face-to-face interviews.',
                                  dismissOnTap: true,
                                  toastPosition: EasyLoadingToastPosition.top,
                                  duration: Duration(seconds: 3),
                                  maskType: EasyLoadingMaskType.black,
                                );

                                return; // Do not proceed with saving if F2F location is missing
                              }
                              // Create and add the interview event
                              InterviewEvent newEvent = InterviewEvent(
                                applicant: candidateNameController.text,
                                title: titleController.text,
                                type: selectedType,
                                // interviewers:
                                //     List<String>.from(selectedInterviewers),
                                interviewers: [interviewerNameController.text],
                                date: selectedDate,
                                startTime: startTime,
                                endTime: endTime,
                                notes: notesController.text,
                              );

                              print(
                                  "DETAILSSSSS: Applicant name: ${candidateNameController.text}, interviewer: ${interviewerNameController.text} Title: ${titleController.text}, Interview Type: ${selectedType}, Start time: ${startTime}, End time: ${endTime}, additional notes: ${notesController.text} Selected date: ${selectedDate}");

                              // Add new event to the list and update the UI
                              showSaveInterviewConfirmationDialog(
                                  context, newEvent);
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 16),
                              backgroundColor: const Color(0xFF157925),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Save this Interview',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget buildSearchDropdown(StateSetter setState) {
    return GestureDetector(
      onTap: () {
        suggestionBoxController.close();
      },
      child: DropDownSearchFormField<Applicant>(
        // Change type to Applicant
        textFieldConfiguration: TextFieldConfiguration(
          controller: _dropdownSearchFieldController,
          decoration: InputDecoration(
            label: Text('Select Applicant'),
            border: OutlineInputBorder(),
          ),
        ),
        suggestionsCallback: (pattern) async {
          return await getSuggestions(pattern); // Now returns List<Applicant>
        },
        itemBuilder: (context, applicant) {
          // Change to accept Applicant
          return ListTile(
            title: Text(applicant.name), // Show applicant's name
            subtitle: Text(
                '${applicant.job} - ${applicant.branch}'), // Show job and branch
          );
        },
        itemSeparatorBuilder: (context, index) {
          return const Divider();
        },
        onSuggestionSelected: (Applicant applicant) {
          _dropdownSearchFieldController.text = applicant.name; // Set name
          selectedApplicant = applicant; // Save entire applicant object
        },
        suggestionsBoxController: suggestionBoxController,
        validator: (value) => value == null
            ? 'Please select an applicant'
            : null, // Adjust for Applicant type
        displayAllSuggestionWhenTap: true,
        suggestionsBoxDecoration: SuggestionsBoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
      ),
    );
  }

  Widget buildMultiSelectDropdown(StateSetter setState) {
    staffs.sort((a, b) => a.compareTo(b));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonHideUnderline(
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              label: Text('Select Interviewer(s)'),
            ),
            items: staffs.map((String interviewer) {
              return DropdownMenuItem<String>(
                value: interviewer,
                child: Text(interviewer),
              );
            }).toList(),
            onChanged: (String? value) {
              if (value != null && !selectedInterviewers.contains(value)) {
                setState(() {
                  selectedInterviewers.add(value);
                });
                print(selectedInterviewers);
              }
            },
            isExpanded: true,
            isDense: true,
          ),
        ),
        SizedBox(height: 10),
        Wrap(
          spacing: 8.0,
          children: selectedInterviewers
              .map((interviewer) => Chip(
                    label: Text(interviewer),
                    onDeleted: () {
                      setState(() {
                        selectedInterviewers.remove(interviewer);
                      });
                    },
                  ))
              .toList(),
        ),
      ],
    );
  }

  // Future<void> _selectDate(StateSetter setState) async {
  //   DateTime? pickedDate = await showDatePicker(
  //     context: context,
  //     initialDate: selectedDate ?? DateTime.now(),
  //     firstDate: DateTime(2000),
  //     lastDate: DateTime(2101),
  //   );
  //   if (pickedDate != null && pickedDate != selectedDate) {
  //     setState(() {
  //       selectedDate = pickedDate;
  //     });
  //   }
  // }

  Future<void> _selectStartTime(
      BuildContext context, StateSetter setState) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: startTime ?? TimeOfDay.now(),
    );
    if (pickedTime != null && pickedTime != startTime) {
      setState(() {
        startTime = pickedTime;
      });
    }
  }

  Future<void> _selectEndTime(
      BuildContext context, StateSetter setState) async {
    // Check if start time is set
    if (startTime == null) {
      EasyLoading.showToast(
        'Please select a start time first.',
        dismissOnTap: true,
        toastPosition: EasyLoadingToastPosition.top,
        duration: Duration(seconds: 3),
        maskType: EasyLoadingMaskType.black,
      );
      return; // Prevent selecting end time if start time is not selected
    }

    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: endTime ??
          startTime!.replacing(
              hour: startTime!.hour + 1), // Default to 1 hour after start time
    );

    // Proceed with checking if pickedTime is null
    if (pickedTime != null && pickedTime != endTime) {
      // Convert TimeOfDay to DateTime for comparison
      DateTime startDateTime = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        startTime!.hour,
        startTime!.minute,
      );
      DateTime endDateTime = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        pickedTime.hour,
        pickedTime.minute,
      );

      // Check if the selected end time is later than start time
      if (endDateTime.isBefore(startDateTime)) {
        EasyLoading.showToast(
          'End time must be after start time.',
          dismissOnTap: true,
          toastPosition: EasyLoadingToastPosition.top,
          duration: Duration(seconds: 3),
          maskType: EasyLoadingMaskType.black,
        );
        return; // Prevent setting end time if it's not after start time
      }

      // Check if the selected end time is at least 5 minutes and at most 8 hours later
      Duration difference = endDateTime.difference(startDateTime);
      if (difference.inMinutes < 5) {
        EasyLoading.showToast(
          'The interview must last at least 5 minutes.',
          dismissOnTap: true,
          toastPosition: EasyLoadingToastPosition.top,
          duration: Duration(seconds: 3),
          maskType: EasyLoadingMaskType.black,
        );
        return; // Prevent setting end time if it's not at least 5 minutes later
      }

      if (difference.inHours > 8) {
        EasyLoading.showToast(
          'The interview cannot exceed 8 hours.',
          dismissOnTap: true,
          toastPosition: EasyLoadingToastPosition.top,
          duration: Duration(seconds: 3),
          maskType: EasyLoadingMaskType.black,
        );
        return; // Prevent setting end time if it exceeds 8 hours
      }

      setState(() {
        endTime = pickedTime;
      });
    }
  }

  String durationText(TimeOfDay? startTime, TimeOfDay? endTime) {
    if (startTime == null || endTime == null) {
      return '';
    }

    final startDateTime = DateTime(0, 0, 0, startTime.hour, startTime.minute);
    final endDateTime = DateTime(0, 0, 0, endTime.hour, endTime.minute);

    final duration = endDateTime.difference(startDateTime);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    // Create a list to hold parts of the duration text
    List<String> durationParts = [];

    // Add hours to the list if there are hours
    if (hours > 0) {
      durationParts.add('${hours}hr${hours > 1 ? 's' : ''}');
    }

    // Add minutes to the list if there are minutes
    if (minutes > 0) {
      durationParts.add('${minutes}min${minutes > 1 ? 's' : ''}');
    }

    // Join the parts together
    return 'The interview will be ${durationParts.join(' ')} long.';
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return "January";
      case 2:
        return "February";
      case 3:
        return "March";
      case 4:
        return "April";
      case 5:
        return "May";
      case 6:
        return "June";
      case 7:
        return "July";
      case 8:
        return "August";
      case 9:
        return "September";
      case 10:
        return "October";
      case 11:
        return "November";
      case 12:
        return "December";
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    var jobCandidateProvider = Provider.of<JobProviderCandidate>(context);
    DateTime applicationDate = jobCandidateProvider
        .findDataOfCandidate(widget.candidateId)!
        .applicationDate;
    String formattedDate =
        jobCandidateProvider.formatApplicationDate(applicationDate);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton.icon(
          onPressed: widget.onBack,
          label: const Text(
            "Back",
            style: TextStyle(color: Color(0xFFff9800), fontFamily: 'Galano'),
          ),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFFff9800),
          ),
        ),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: SingleChildScrollView(
                  child: Card(
                    color: Colors.white,
                    elevation: 3,
                    margin: const EdgeInsets.all(10),
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const CircleAvatar(
                                radius: 70,
                                backgroundImage:
                                    AssetImage('assets/images/pfp.png'),
                              ),
                              const Gap(15),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Text('Application Date: '),
                                      Text(
                                        formattedDate,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Gap(10),
                                  Text(
                                    jobCandidateProvider
                                        .findDataOfCandidate(
                                            widget.candidateId)!
                                        .name,
                                    style: const TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: GestureDetector(
                                      onTap: _launchEmail,
                                      child: Text(
                                        jobCandidateProvider
                                            .findDataOfCandidate(
                                                widget.candidateId)!
                                            .email,
                                        style: const TextStyle(
                                          decoration: TextDecoration.underline,
                                          decorationColor: Color(0xFFff9800),
                                          color: Color(0xFFff9800),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    jobCandidateProvider
                                        .findDataOfCandidate(
                                            widget.candidateId)!
                                        .profession,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const Gap(10),
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    constraints: BoxConstraints(
                                      minWidth: 80,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(5),
                                      ),
                                      border: Border.all(color: Colors.grey),
                                    ),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Row(
                                        children: [
                                          const Text("Status: "),
                                          Text(
                                            jobCandidateProvider
                                                .findDataOfCandidate(
                                                    widget.candidateId)!
                                                .status,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Gap(30),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    children: const [
                                      Icon(
                                        Icons.lock,
                                        size: 16,
                                      ),
                                      Gap(10),
                                      Text(
                                        "Interested?",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Gap(20),
                                  TextButton(
                                    onPressed: () => moveBackToReviewDialog(
                                        context, widget.candidateId),
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 8),
                                      backgroundColor:
                                          Color.fromARGB(255, 226, 226, 226),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text(
                                      'Move back to "For Review"',
                                      style: TextStyle(
                                        color: Color(0xFF424242),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  const Gap(10),
                                  TextButton(
                                    onPressed: () {
                                      showRejectDialog(
                                          context, widget.candidateId);
                                      if (jobCandidateProvider.rejectMessage !=
                                          "") {
                                        jobCandidateProvider
                                            .clearMessage("Reject");
                                      }
                                    },
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 89, vertical: 8),
                                      backgroundColor: const Color.fromARGB(
                                          255, 255, 209, 209),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text(
                                      'Reject',
                                      style: TextStyle(
                                        color: Color(0xFFd74a4a),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  const Gap(30),
                                  TextButton(
                                    onPressed: () {},
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 65, vertical: 8),
                                      backgroundColor: const Color(0xFF3b7dff),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          "assets/images/msg-white-icon.png",
                                          width: 14,
                                        ),
                                        const Gap(10),
                                        const Text(
                                          'Message',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Gap(10),
                                  TextButton(
                                    onPressed: () {
                                      // final homeState =
                                      //     context.findAncestorStateOfType<
                                      //         RecruiterHomeScreenState>();
                                      // homeState!.changeDestination(4);

                                      _scheduleInterview(DateTime.now());
                                    },
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 29, vertical: 8),
                                      backgroundColor: const Color(0xFFfd7206),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.calendar_month_rounded,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                        const Gap(10),
                                        const Text(
                                          'Schedule interview',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Gap(30),
                          TabBarInside(
                            tabController: _tabController,
                            tabs: const [
                              Tab(text: 'Application'),
                              Tab(text: 'Resume'),
                            ],
                            views: [
                              ApplicationView(
                                jobPostId: jobCandidateProvider
                                    .findDataOfCandidate(widget.candidateId)!
                                    .jobPostId,
                                jobSeekerId: widget.candidateId,
                                jobApplication: jobCandidateProvider
                                    .findDataOfCandidate(widget.candidateId)!
                                    .jobApplicationDocId!,
                              ),
                              ResumeView(
                                jobPostId: jobCandidateProvider
                                    .findDataOfCandidate(widget.candidateId)!
                                    .jobPostId,
                                jobSeekerId: widget.candidateId,
                                jobApplication: jobCandidateProvider
                                    .findDataOfCandidate(widget.candidateId)!
                                    .jobApplicationDocId!,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Card(
                  color: Colors.white,
                  elevation: 3,
                  margin: const EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(
                              Icons.lock,
                              size: 16,
                            ),
                            Gap(10),
                            Text(
                              "Notes",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Gap(20),
                            Text(
                              "Only visible to the team",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                        const Gap(20),
                        Container(
                          height: 430,
                          width: double.infinity,
                          child: TextField(
                            controller: TextEditingController(
                              text: "Ok naman siya",
                            ),
                            maxLines: 20,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Gap(30),
      ],
    );
  }
}
