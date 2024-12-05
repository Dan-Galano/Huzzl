import 'package:drop_down_search_field/drop_down_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/models/candidate.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/widgets/customDropdown.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/calendar_ui/applicant_model.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/calendar_ui/interview_model.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/controller/interview_provider.dart';
import 'package:huzzl_web/views/recruiters/jobs_tab/controller/job_provider_candidate.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class InterviewCalendar extends StatefulWidget {
  const InterviewCalendar({Key? key}) : super(key: key);

  @override
  _InterviewCalendarState createState() => _InterviewCalendarState();
}

class _InterviewCalendarState extends State<InterviewCalendar> {
  DateTime today = DateTime.now();
  DateTime currentDate = DateTime.now();
  CalendarController _calendarController = CalendarController();

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

  final List<String> interviewTypes = ['Online'];
  List<String> selectedInterviewers = [];
  Candidate? selectedApplicant;
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
  late InterviewProvider _interviewProvider;
  late JobProviderCandidate _jobProviderCandidate;

  late List<Candidate> lateApplicants;
  List<Candidate> applicants = [];

  //here
  void fetchAllApplicant() async {
    lateApplicants =
        await _jobProviderCandidate.fetchAllCandidatesForCalendar();
    setState(() {
      applicants = lateApplicants;
    });

    debugPrint("All applicant has been fetch");
  }

  final interviewerNameController = TextEditingController();

  late String lateRecruiterName;
  String recruiterName = "";

  void getRecruiterName() async {
    lateRecruiterName = await _jobProviderCandidate.getCurrentUserName();
    setState(() {
      recruiterName = lateRecruiterName;
      interviewerNameController.text = recruiterName;
    });
  }

  @override
  void initState() {
    super.initState();
    _interviewProvider = Provider.of<InterviewProvider>(context, listen: false);
    _jobProviderCandidate =
        Provider.of<JobProviderCandidate>(context, listen: false);
    selectedDate = today;
    selectedType = 'Online';

    // _interviewProvider.fetchAllInterviews();
    fetchinterview();
    fetchAllApplicant();
    getRecruiterName();
  }

  void fetchinterview() async {
    await _interviewProvider.fetchAllInterviews();
    debugPrint("interview fetch");
  }

  void saveInterviewToDB(InterviewEvent e) {
    // Helper function to convert TimeOfDay to DateTime
    DateTime _convertTimeOfDayToDateTime(TimeOfDay time) {
      final now = DateTime.now();
      return DateTime(now.year, now.month, now.day, time.hour, time.minute);
    }

    // Format the date
    final DateFormat dateFormat =
        DateFormat('MMMM d, y'); // Example: December 5, 2024
    final String formattedDate = dateFormat.format(e.date!);

    // Format start time and end time
    final DateFormat timeFormat = DateFormat('h:mma');
    final String formattedStartTime = timeFormat
        .format(_convertTimeOfDayToDateTime(e.startTime!))
        .toLowerCase();
    final String formattedEndTime = timeFormat
        .format(_convertTimeOfDayToDateTime(e.endTime!))
        .toLowerCase();

    // Print interview event details
    print(
        "Interview event details: ${e.applicant} $formattedDate ${e.interviewers}");

    // Call job provider and interview provider methods
    _jobProviderCandidate.forInterviewCandidate(selectedApplicant!.id);

    _interviewProvider.saveInterview(
      e,
      selectedApplicant!.id,
      selectedApplicant!.jobPostId,
      selectedApplicant!.id,
      selectedApplicant!.jobApplicationDocId!,
      selectedApplicant!.profession,
    );

    // Push notification to jobseeker
    _jobProviderCandidate.pushNotificationToJobseeker(
      selectedApplicant!.jobPostId,
      selectedApplicant!.id,
      'You have been scheduled for Interview: ${e.title}',
      "${e.notes} The date of your interview is $formattedDate. Starts at $formattedStartTime, ends at $formattedEndTime.",
    );

    // Send email notification to jobseeker
    _jobProviderCandidate.sendEmailNotification(
        selectedApplicant!.jobPostId, selectedApplicant!.id, "Interview",
        message:
            "Your interview for the ${selectedApplicant!.profession} position is scheduled. ${e.notes} The date of your interview is $formattedDate. Starts at $formattedStartTime, ends at $formattedEndTime.");

    // Log the activity
    _jobProviderCandidate.activityLogs(
      action: "Scheduled an interview",
      message: "Successfully scheduled an interview.",
    );

    // Reset the schedule interviewer form and navigate back
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
                                // "Jobseeker ID: ${widget.candidateId}\n"
                                // "Job Post ID: ${widget.candidate.jobPostId}\n"
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

  List<Candidate> getSuggestions(String query) {
    List<Candidate> matches = applicants
        .where((applicant) =>
            applicant.name.toLowerCase().contains(query.toLowerCase()) ||
            applicant.profession.toLowerCase().contains(query.toLowerCase()))
        .toList();
    for (var match in matches) {
      debugPrint("name : ${match.name}. profession : ${match.profession}");
    }
    return matches;
  }

  List<InterviewEvent> getScheduledInterviews(DateTime date) {
    return _interviewProvider.events
        .where((event) =>
            event.date?.year == date.year &&
            event.date?.month == date.month &&
            event.date?.day == date.day)
        .toList();
  }

  bool hasEvents(DateTime date) {
    return getScheduledInterviews(date).isNotEmpty;
  }

  DateTime selectedDate = DateTime.now();
  // List<InterviewEvent>? events;
  // [
  // InterviewEvent(
  //   applicant:
  //       "Patrick John Tomas",
  //   title: 'First Round Interview',
  //   type: 'F2F',
  //   interviewers: [
  //     'Dan Galano',
  //     'Monica Ave',
  //     'Dan Galano',
  //     'Monica Ave',
  //     'Dan Galano',
  //     'Monica Ave'
  //   ],
  //   date: DateTime.now(),
  //   startTime: TimeOfDay.now(),
  //   endTime: TimeOfDay.now(),
  //   notes: 'Bring your guts!!!',
  //   location:
  //       'Rm 230, 2nd Floor, XYZ Bldg., ABC st., Urdaneta City, Pangasinan',
  // ),
  // InterviewEvent(
  //   applicant: Applicant(
  //     name: 'Dessa Mine',
  //     job: 'Graphic Designer',
  //     branch: 'Urdaneta',
  //   ),
  //   title: 'Second Round Interview',
  //   type: 'F2F',
  //   interviewers: ['Dan Galano', 'Monica Ave'],
  //   date: DateTime(2024, 9, 27),
  //   startTime: TimeOfDay.now(),
  //   endTime: TimeOfDay.now(),
  //   notes: 'Bring your guts!!!',
  //   location:
  //       'Rm 230, 2nd Floor, XYZ Bldg., ABC st., Urdaneta City, Pangasinan',
  // ),
  // InterviewEvent(
  //   applicant:
  //       Applicant(name: 'Hana Montana', job: 'Dancerist', branch: 'Dagupan'),
  //   title: 'First Round Interview',
  //   type: 'Online',
  //   interviewers: ['Dan Galano', 'Monica Ave'],
  //   date: DateTime.now(),
  //   startTime: TimeOfDay.now(),
  //   endTime: TimeOfDay.now(),
  //   notes: 'Bring your guts!!!',
  // )
  // ];

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
                    buildSearchDropdown(setState),
                    SizedBox(height: 10),
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        label: Text('Enter title'),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   children: [
                    //     Text(
                    //       'Interview Type',
                    //       style: TextStyle(fontSize: 12),
                    //     ),
                    //   ],
                    // ),
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
                                  endTime == null ||
                                  selectedApplicant == null) {
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
                                applicant: selectedApplicant!.name,
                                title: titleController.text,
                                type: selectedType,
                                // interviewers:
                                //     List<String>.from(selectedInterviewers),
                                interviewers: [interviewerNameController.text],
                                date: selectedDate,
                                startTime: startTime,
                                endTime: endTime,
                                notes: notesController.text,
                                location: locationController.text,
                              );

                              print(
                                  "DETAILSSSSS: Applicant name: ${selectedApplicant!.name}, interviewer: ${interviewerNameController.text} Title: ${titleController.text}, Interview Type: ${selectedType}, Start time: ${startTime}, End time: ${endTime}, additional notes: ${notesController.text} Selected date: ${selectedDate}");

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
      child: DropDownSearchFormField<Candidate>(
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
            subtitle: Text('${applicant.profession}'), // Show job and branch
          );
        },
        itemSeparatorBuilder: (context, index) {
          return const Divider();
        },
        onSuggestionSelected: (Candidate applicant) {
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
    var interviewProvider = Provider.of<InterviewProvider>(context);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 243, 243),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TextButton.icon(
          //   onPressed: widget.onBack,
          //   label: const Text(
          //     "Back",
          //     style: TextStyle(color: Color(0xFFff9800), fontFamily: 'Galano'),
          //   ),
          //   icon: const Icon(
          //     Icons.arrow_back_ios_new_rounded,
          //     color: Color(0xFFff9800),
          //   ),
          // ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      bottom: 20,
                      left: 20,
                      right: 20,
                    ),
                    child: Card(
                      color: Colors.white,
                      elevation: 4,
                      child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          //   child: SfCalendar(
                          //     initialDisplayDate: DateTime.now(),
                          //     showNavigationArrow: true,
                          //     headerDateFormat: 'MMM y',
                          //     headerHeight: 100,
                          //     viewHeaderHeight: 30,
                          //     headerStyle: CalendarHeaderStyle(
                          //       backgroundColor: Colors.transparent,
                          //       textAlign: TextAlign.center,
                          //       textStyle: TextStyle(
                          //         fontSize: 30,
                          //         fontWeight: FontWeight.w800,
                          //       ),
                          //     ),
                          //     view: CalendarView.month,
                          //     controller: _calendarController,
                          //     onViewChanged: (ViewChangedDetails details) {
                          //       WidgetsBinding.instance.addPostFrameCallback((_) {
                          //         setState(() {
                          //           currentDate = details.visibleDates.first;
                          //         });
                          //       });
                          //     },
                          //     monthCellBuilder:
                          //         (BuildContext context, MonthCellDetails details) {
                          //       bool hasEvent = hasEvents(details.date);
                          //       bool isToday = isSameDate(details.date, today);
                          //       bool isPast = details.date.isBefore(
                          //           DateTime.now().subtract(Duration(days: 1)));
                          //       // bool isFutureOrToday = details.date.isAfter(DateTime.now().subtract(Duration(days:1)));

                          //       return Container(
                          //         child: Stack(
                          //           children: [
                          //             Center(
                          //               child: Container(
                          //                 decoration: BoxDecoration(
                          //                   shape: BoxShape.circle,
                          //                   border: hasEvent
                          //                       ? Border.all(
                          //                           color: isPast
                          //                               ? Colors.grey.shade400
                          //                               : Colors.orange,
                          //                           width: 3,
                          //                           strokeAlign: 3,
                          //                         )
                          //                       : null,
                          //                   color: isToday ? Colors.blue : null,
                          //                 ),
                          //                 padding: EdgeInsets.all(8),
                          //                 child: Text(
                          //                   details.date.day.toString(),
                          //                   style: TextStyle(
                          //                     fontSize: 20,
                          //                     color: isToday
                          //                         ? Colors.white
                          //                         : (hasEvent
                          //                             ? (isPast
                          //                                 ? Colors.grey.shade400
                          //                                 : Color.fromARGB(
                          //                                     255, 244, 158, 54))
                          //                             : (isPast
                          //                                 ? Colors.grey.shade400
                          //                                 : Colors.black)),
                          //                     fontWeight: FontWeight.bold,
                          //                   ),
                          //                 ),
                          //               ),
                          //             ),
                          //           ],
                          //         ),
                          //       );
                          //     },
                          //     onTap: (CalendarTapDetails details) {
                          //       if (details.date != null) {
                          //         setState(() {
                          //           selectedDate = details.date!;
                          //         });
                          //       }
                          //     },
                          //   ),
                          // ),

                          child: Column(
                            children: [
                              // Add "Back to Current Month" button
                              Visibility(
                                visible: _calendarController.displayDate !=
                                        null &&
                                    (_calendarController.displayDate!.year !=
                                            DateTime.now().year ||
                                        _calendarController
                                                .displayDate!.month !=
                                            DateTime.now().month),
                                child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _calendarController.displayDate =
                                          DateTime.now();
                                    });
                                  },
                                  child: Text(
                                    'Back to Current Month',
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),

                              // Calendar widget
                              Expanded(
                                child: SfCalendar(
                                  initialDisplayDate: DateTime.now(),
                                  showNavigationArrow: true,
                                  headerDateFormat: 'MMM y',
                                  headerHeight: 100,
                                  viewHeaderHeight: 30,
                                  headerStyle: CalendarHeaderStyle(
                                    backgroundColor: Colors.transparent,
                                    textAlign: TextAlign.center,
                                    textStyle: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  view: CalendarView.month,
                                  controller: _calendarController,
                                  onViewChanged: (ViewChangedDetails details) {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      setState(() {
                                        currentDate =
                                            details.visibleDates.first;
                                      });
                                    });
                                  },
                                  monthCellBuilder: (BuildContext context,
                                      MonthCellDetails details) {
                                    bool hasEvent = hasEvents(details.date);
                                    bool isToday =
                                        isSameDate(details.date, today);
                                    bool isPast = details.date.isBefore(
                                        DateTime.now()
                                            .subtract(Duration(days: 1)));

                                    return Container(
                                      child: Stack(
                                        children: [
                                          Center(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: hasEvent
                                                    ? Border.all(
                                                        color: isPast
                                                            ? Colors
                                                                .grey.shade400
                                                            : Colors.orange,
                                                        width: 3,
                                                        strokeAlign: 3,
                                                      )
                                                    : null,
                                                color: isToday
                                                    ? Colors.blue
                                                    : null,
                                              ),
                                              padding: EdgeInsets.all(8),
                                              child: Text(
                                                details.date.day.toString(),
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  color: isToday
                                                      ? Colors.white
                                                      : (hasEvent
                                                          ? (isPast
                                                              ? Colors
                                                                  .grey.shade400
                                                              : Color.fromARGB(
                                                                  255,
                                                                  244,
                                                                  158,
                                                                  54))
                                                          : (isPast
                                                              ? Colors
                                                                  .grey.shade400
                                                              : Colors.black)),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  onTap: (CalendarTapDetails details) {
                                    if (details.date != null) {
                                      setState(() {
                                        selectedDate = details.date!;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ],
                          )),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      bottom: 20,
                      left: 0,
                      right: 20,
                    ),
                    child: Card(
                      color: Colors.white,
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: LayoutBuilder(
                                      builder: (context, constraints) {
                                        bool isToday = isSameDate(
                                            selectedDate!,
                                            DateTime
                                                .now()); // Check if selectedDate is today

                                        if (constraints.maxWidth > 200) {
                                          return RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: DateFormat(
                                                          'MMMM d, yyyy')
                                                      .format(
                                                          selectedDate!), // Month, day, year part
                                                  style: TextStyle(
                                                    fontSize: 25,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors
                                                        .black, // Default color
                                                  ),
                                                ),
                                                if (isToday) ...[
                                                  TextSpan(
                                                    text:
                                                        ' (Today)', // Today part
                                                    style: TextStyle(
                                                      fontSize: 25,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors
                                                          .orange, // Highlighted color for "Today"
                                                    ),
                                                  ),
                                                ],
                                                if (!isToday) ...[
                                                  TextSpan(
                                                    text: DateFormat(' (EEEE)')
                                                        .format(
                                                            selectedDate!), // Month, day, year part
                                                    style: TextStyle(
                                                      fontSize: 25,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors
                                                          .black, // Default color
                                                    ),
                                                  ),
                                                ],
                                              ],
                                            ),
                                          );
                                        } else {
                                          return Tooltip(
                                            message: DateFormat(
                                                    'MMMM d, yyyy (EEEE)')
                                                .format(selectedDate!),
                                            child: RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: DateFormat(
                                                            'MMMM d, yyyy')
                                                        .format(
                                                            selectedDate!), // Month, day, year part
                                                    style: TextStyle(
                                                      fontSize: 25,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors
                                                          .black, // Default color
                                                    ),
                                                  ),
                                                  if (isToday) ...[
                                                    TextSpan(
                                                      text:
                                                          ' (Today)', // Today part
                                                      style: TextStyle(
                                                        fontSize: 25,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors
                                                            .orange, // Highlighted color for "Today"
                                                      ),
                                                    ),
                                                  ],
                                                  if (!isToday) ...[
                                                    if (!isToday) ...[
                                                      TextSpan(
                                                        text: DateFormat(
                                                                ' (EEEE)')
                                                            .format(
                                                                selectedDate!), // Month, day, year part
                                                        style: TextStyle(
                                                          fontSize: 25,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors
                                                              .black, // Default color
                                                        ),
                                                      ),
                                                    ],
                                                  ],
                                                ],
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                  if (selectedDate.isAfter(DateTime.now()
                                      .subtract(Duration(
                                          days:
                                              1)))) // Check if selectedDate is today or in the future
                                    Tooltip(
                                      message: "Schedule new interview",
                                      height: 20,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.add,
                                          size: 30,
                                        ),
                                        onPressed: () =>
                                            _scheduleInterview(selectedDate!),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            Expanded(
                              child: getScheduledInterviews(selectedDate!)
                                      .isNotEmpty
                                  ? ListView(
                                      children:
                                          getScheduledInterviews(selectedDate!)
                                              .map((event) {
                                        return Card(
                                          color: Colors.white,
                                          borderOnForeground: true,
                                          elevation: 2,
                                          shadowColor: Colors.grey,
                                          child: Padding(
                                            padding: EdgeInsets.all(20),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                // Time row
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Expanded(
                                                      child: Card(
                                                        elevation: 0,
                                                        color:
                                                            Color(0xFF8d8d8d),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10.0),
                                                          child: Text(
                                                            '${event.startTime!.format(context)}  -  ${event.endTime!.format(context)}',
                                                            style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            softWrap: true,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    // Visibility(
                                                    //   visible: selectedDate
                                                    //       .isAfter(DateTime
                                                    //               .now()
                                                    //           .subtract(
                                                    //               Duration(
                                                    //                   days:
                                                    //                       1))),
                                                    //   child: Row(
                                                    //     mainAxisAlignment:
                                                    //         MainAxisAlignment
                                                    //             .end,
                                                    //     children: [
                                                    //       Tooltip(
                                                    //         message:
                                                    //             "Edit Details",
                                                    //         child: IconButton(
                                                    //           onPressed: () {
                                                    //             // Handle edit details action
                                                    //           },
                                                    //           icon: Icon(
                                                    //             Icons.edit,
                                                    //             color: Color(
                                                    //                 0xFffd7206),
                                                    //           ),
                                                    //         ),
                                                    //       ),
                                                    //       SizedBox(
                                                    //           width:
                                                    //               5), // Gap replaced by SizedBox
                                                    //       Tooltip(
                                                    //         message:
                                                    //             "Reschedule",
                                                    //         child: IconButton(
                                                    //           onPressed: () {
                                                    //             // Handle reschedule action
                                                    //           },
                                                    //           icon: Icon(
                                                    //             Icons
                                                    //                 .event_rounded,
                                                    //             color: Color(
                                                    //                 0xFffd7206),
                                                    //           ),
                                                    //         ),
                                                    //       ),
                                                    //     ],
                                                    //   ),
                                                    // ),
                                                  ],
                                                ),
                                                SizedBox(
                                                    height:
                                                        10), // Replaced Gap(10)

                                                // Applicant row
                                                // Row(
                                                //   children: [
                                                //     CircleAvatar(
                                                //       radius: 40,
                                                //       backgroundImage:
                                                //           AssetImage(event
                                                //                   .applicant
                                                //                   ?.pfp ??
                                                //               'assets/images/pfp.png'),
                                                //     ),
                                                //     SizedBox(width: 20),
                                                //     Expanded(
                                                //       child: Column(
                                                //         crossAxisAlignment:
                                                //             CrossAxisAlignment
                                                //                 .start,
                                                //         children: [
                                                //           Text(
                                                //             event.applicant
                                                //                     ?.name ??
                                                //                 'Unknown Applicant',
                                                //             style: TextStyle(
                                                //               fontSize: 20,
                                                //               fontWeight:
                                                //                   FontWeight
                                                //                       .bold,
                                                //             ),
                                                //             softWrap: true,
                                                //           ),
                                                //           SizedBox(height: 3),
                                                //           Text(
                                                //             event.applicant
                                                //                     ?.job ??
                                                //                 'Unknown Job',
                                                //             style: TextStyle(
                                                //               fontSize: 18,
                                                //             ),
                                                //             softWrap: true,
                                                //           ),
                                                //           SizedBox(height: 3),
                                                //           Text(
                                                //             event.applicant
                                                //                     ?.branch ??
                                                //                 'Unknown Branch',
                                                //             style: TextStyle(
                                                //               fontSize: 18,
                                                //             ),
                                                //             softWrap: true,
                                                //           ),
                                                //         ],
                                                //       ),
                                                //     ),
                                                //   ],
                                                Text(
                                                    "Applicant name: ${event.applicant!}"),
                                                SizedBox(height: 20),

                                                // Title row
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Title: ",
                                                      style: TextStyle(
                                                          fontSize: 16),
                                                    ),
                                                    Flexible(
                                                      child: Text(
                                                        event.title!,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                        ),
                                                        softWrap: true,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 10),

                                                // Interviewers row
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Interviewer(s): ",
                                                      style: TextStyle(
                                                          fontSize: 16),
                                                    ),
                                                    Flexible(
                                                      child: Text(
                                                        event.interviewers!
                                                            .join(', '),
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                        ),
                                                        softWrap: true,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 10),

                                                // Interview Type row
                                                Row(
                                                  children: [
                                                    Text(
                                                      "Interview Type: ",
                                                      style: TextStyle(
                                                          fontSize: 16),
                                                    ),
                                                    Text(
                                                      event.type!,
                                                      style: TextStyle(
                                                        color: event.type! ==
                                                                'F2F'
                                                            ? Color(0xFFfd7206)
                                                            : Color(0xFF3b7dff),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 10),

                                                // Location (if F2F)
                                                Visibility(
                                                  visible: event.type == 'F2F',
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "Location: ",
                                                        style: TextStyle(
                                                            fontSize: 16),
                                                      ),
                                                      Flexible(
                                                        child: Text(
                                                          event.location ??
                                                              'No Location specified',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16,
                                                          ),
                                                          softWrap: true,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(height: 10),

                                                // Additional notes/instructions
                                                Visibility(
                                                  visible: event.notes !=
                                                          null &&
                                                      event.notes!.isNotEmpty,
                                                  child: Text(
                                                    "Additional notes/instructions: ",
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                  ),
                                                ),
                                                SizedBox(height: 5),
                                                Visibility(
                                                  visible: event.notes !=
                                                          null &&
                                                      event.notes!.isNotEmpty,
                                                  child: Text(
                                                    event.notes ?? '',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                    softWrap: true,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    )
                                  : Center(
                                      child:
                                          Text('No scheduled for this date')),
                            ),
                          ],
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
    );
  }

  bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
