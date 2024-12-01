import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:huzzl_web/user-provider.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/03b%20%20jobtitle_chip.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/providers/appstate.dart';
import 'package:huzzl_web/views/job%20seekers/main_screen.dart';
import 'package:huzzl_web/widgets/buttons/blue/bluefilled_circlebutton.dart';
import 'package:huzzl_web/widgets/dropdown/DropdownWithCheckboxes.dart';
import 'package:huzzl_web/widgets/loading_dialog.dart';
import 'package:provider/provider.dart';

class JobTitlesPage extends StatefulWidget {
  final VoidCallback nextPage;
  final VoidCallback previousPage;
  final Function(List<String>)
      onSaveJobTitles; // Pass selected job titles as a comma-separated string
  List? currentSelectedJobTitles;
  final int noOfPages;

  JobTitlesPage({
    super.key,
    required this.nextPage,
    required this.previousPage,
    required this.onSaveJobTitles,
    required this.currentSelectedJobTitles,
    required this.noOfPages,
  });

  @override
  _JobTitlesPageState createState() => _JobTitlesPageState();
}

class _JobTitlesPageState extends State<JobTitlesPage> {
  @override
  void initState() {
    super.initState();
    // Initialize with currentSelectedJobTitles if available
    selectedJobTitles = widget.currentSelectedJobTitles?.cast<String>() ?? [];
  }

  List<String> selectedJobTitles = [];

  void _removeJobTitle(String title) {
    setState(() {
      selectedJobTitles.remove(title);
    });
  }

  void _submitJobTitlesForm() {
    if (selectedJobTitles.isEmpty) {
      return;
    }
    final appState = Provider.of<AppState>(context, listen: false);
    appState.setCurrentSelectedJobTitles(selectedJobTitles);
    widget.onSaveJobTitles(selectedJobTitles);
    widget.nextPage();
  }

  void _submitPreferences() async {
    final appState = Provider.of<AppState>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    String? userId = userProvider.loggedInUserId;

    if (userId == null) {
      print('User not logged in!');
      return;
    }

     Map<String, dynamic> jobPreferences = {
      'selectedLocation': null,
      'selectedPayRate': null,
      'currentSelectedJobTitles': null,
      'uid': userId,
    };


    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      CollectionReference usersRef = firestore.collection('users');

      await usersRef.doc(userId).set(jobPreferences, SetOptions(merge: true));
      print('Job preferences saved successfully!');

      // Show loading dialog
      _showLoadingDialog(context);

      // Delay for 3 seconds to keep the dialog visible before navigating
      await Future.delayed(Duration(seconds: 3));

      // Navigate to the next screen after the delay
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) => JobseekerMainScreen(uid: userId)),
      );
    } catch (e) {
      print('Error saving job preferences: $e');
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '3/${widget.noOfPages}',
                          style: TextStyle(
                            fontSize: 20,
                            color: Color(0xff373030),
                            fontFamily: 'Galano',
                            fontWeight: FontWeight.w100,
                          ),
                        ),
                        TextButton(
                          child: Text("Skip all",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold)),
                          onPressed: _submitPreferences,
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      'What kind of jobs are you looking for?',
                      style: TextStyle(
                        fontSize: 22,
                        color: Color(0xff373030),
                        fontFamily: 'Galano',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'This helps us match you with relevant jobs.',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xff373030),
                        fontFamily: 'Galano',
                        fontWeight: FontWeight.w100,
                      ),
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/info.png',
                          width: 20,
                          height: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Select up to 3 classifications.',
                          style: TextStyle(
                            fontSize: 15,
                            color: Color(0xff929292),
                            fontFamily: 'Galano',
                            fontWeight: FontWeight.w100,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    SelectedJobTitlesWrap(
                      selectedJobTitles: selectedJobTitles,
                      onRemoveJobTitle: _removeJobTitle,
                    ),
                    SizedBox(height: 10),
                    DropdownWithCheckboxes(
                      sections: [
                        DropdownSection(
                          title: 'Accounting and Finance',
                          items: [
                            'Accountant',
                            'Auditor',
                            'Bookkeeper',
                            'Budget Analyst',
                            'Chief Financial Officer',
                            'Controller',
                            'Financial Analyst',
                            'Payroll Specialist',
                            'Tax Specialist',
                            'Treasurer',
                          ],
                        ),
                        DropdownSection(
                          title: 'Administration and Office Support',
                          items: [
                            'Administrative Assistant',
                            'Clerk',
                            'Data Entry Specialist',
                            'Executive Assistant',
                            'Office Manager',
                            'Receptionist',
                            'Secretary',
                            'Virtual Assistant',
                          ],
                        ),
                        DropdownSection(
                          title: 'Agriculture and Forestry',
                          items: [
                            'Agricultural Engineer',
                            'Agronomist',
                            'Farm Manager',
                            'Forester',
                            'Horticulturist',
                            'Soil Scientist',
                          ],
                        ),
                        DropdownSection(
                          title: 'Arts, Design and Creative',
                          items: [
                            'Animator',
                            'Art Director',
                            'Graphic Designer',
                            'Illustrator',
                            'Interior Designer',
                            'Multimedia Artist',
                            'Photographer',
                            'UI UX Designer',
                            'Videographer',
                            'Visual Effects Artist',
                          ],
                        ),
                        DropdownSection(
                          title: 'Construction and Real Estate',
                          items: [
                            'Architect',
                            'Bricklayer',
                            'Carpenter',
                            'Construction Manager',
                            'Electrician',
                            'Plumber',
                            'Project Manager',
                            'Quantity Surveyor',
                            'Real Estate Agent',
                            'Surveyor',
                          ],
                        ),
                        DropdownSection(
                          title: 'Customer Service and Support',
                          items: [
                            'Call Center Agent',
                            'Client Relations Specialist',
                            'Customer Service Representative',
                            'Help Desk Specialist',
                            'Technical Support Specialist',
                          ],
                        ),
                        DropdownSection(
                          title: 'Education and Training',
                          items: [
                            'Curriculum Developer',
                            'Elementary School Teacher',
                            'High School Teacher',
                            'Librarian',
                            'Professor',
                            'Special Education Teacher',
                            'Trainer',
                            'Tutor',
                          ],
                        ),
                        DropdownSection(
                          title: 'Engineering',
                          items: [
                            'Aerospace Engineer',
                            'Biomedical Engineer',
                            'Chemical Engineer',
                            'Civil Engineer',
                            'Electrical Engineer',
                            'Environmental Engineer',
                            'Industrial Engineer',
                            'Mechanical Engineer',
                            'Software Engineer',
                            'Structural Engineer',
                          ],
                        ),
                        DropdownSection(
                          title: 'Healthcare and Medicine',
                          items: [
                            'Dentist',
                            'Medical Assistant',
                            'Nurse',
                            'Paramedic',
                            'Pharmacist',
                            'Physical Therapist',
                            'Physician',
                            'Radiologist',
                            'Surgeon',
                            'Veterinarian',
                          ],
                        ),
                        DropdownSection(
                          title: 'Hospitality and Tourism',
                          items: [
                            'Bartender',
                            'Chef',
                            'Event Planner',
                            'Hotel Manager',
                            'Housekeeper',
                            'Reservation Agent',
                            'Tour Guide',
                            'Travel Agent',
                            'Waiter Waitress',
                          ],
                        ),
                        DropdownSection(
                          title: 'Human Resources and Recruitment',
                          items: [
                            'HR Manager',
                            'Recruiter',
                            'Training Coordinator',
                            'Compensation Specialist',
                            'Talent Acquisition Specialist',
                          ],
                        ),
                        DropdownSection(
                          title: 'Information Technology',
                          items: [
                            'Data Analyst',
                            'Database Administrator',
                            'IT Support Specialist',
                            'Network Administrator',
                            'Software Developer',
                            'Systems Analyst',
                            'Web Developer',
                          ],
                        ),
                        DropdownSection(
                          title: 'Legal and Compliance',
                          items: [
                            'Attorney',
                            'Compliance Officer',
                            'Corporate Lawyer',
                            'Legal Assistant',
                            'Paralegal',
                          ],
                        ),
                        DropdownSection(
                          title: 'Manufacturing and Production',
                          items: [
                            'Assembly Line Worker',
                            'Machine Operator',
                            'Manufacturing Engineer',
                            'Production Manager',
                            'Quality Assurance Specialist',
                          ],
                        ),
                        DropdownSection(
                          title: 'Marketing and Advertising',
                          items: [
                            'Brand Manager',
                            'Content Strategist',
                            'Copywriter',
                            'Digital Marketing Specialist',
                            'Market Research Analyst',
                            'Marketing Manager',
                            'Public Relations Specialist',
                            'SEO Specialist',
                            'Social Media Manager',
                          ],
                        ),
                        DropdownSection(
                          title: 'Media and Communication',
                          items: [
                            'Broadcast Journalist',
                            'Content Creator',
                            'Editor',
                            'Journalist',
                            'Producer',
                            'Public Relations Officer',
                            'Reporter',
                            'Translator',
                          ],
                        ),
                        DropdownSection(
                          title: 'Retail and Sales',
                          items: [
                            'Cashier',
                            'Merchandiser',
                            'Retail Manager',
                            'Sales Associate',
                            'Sales Manager',
                            'Store Manager',
                          ],
                        ),
                        DropdownSection(
                          title: 'Science and Research',
                          items: [
                            'Biochemist',
                            'Geologist',
                            'Laboratory Technician',
                            'Research Scientist',
                            'Statistician',
                          ],
                        ),
                        DropdownSection(
                          title: 'Skilled Trades and Craft',
                          items: [
                            'Blacksmith',
                            'Machinist',
                            'Mechanic',
                            'Tailor',
                            'Welder',
                          ],
                        ),
                        DropdownSection(
                          title: 'Transportation and Logistics',
                          items: [
                            'Delivery Driver',
                            'Logistics Coordinator',
                            'Supply Chain Manager',
                            'Truck Driver',
                            'Warehouse Manager',
                          ],
                        ),
                        DropdownSection(
                          title: 'Other',
                          items: [
                            'Entrepreneur',
                            'Freelancer',
                          ],
                        ),
                      ],
                      maxSelections: 3,
                      preSelectedItems:
                          widget.currentSelectedJobTitles?.cast<String>() ?? [],
                      onSelectionChanged: (selectedItems) {
                        setState(() {
                          selectedJobTitles =
                              selectedItems; // Update local state
                        });
                        print('Selected items: ${selectedItems}');
                      },
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          child: Text("Skip",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.bold)),
                          onPressed: () {
                            selectedJobTitles.clear();

                            widget.onSaveJobTitles(selectedJobTitles);
                            widget.nextPage();
                          },
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: SizedBox(
                            width: 130,
                            child: BlueFilledCircleButton(
                              onPressed: _submitJobTitlesForm,
                              text: 'Next',
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
