import 'dart:math';
import 'package:drop_down_search_field/drop_down_search_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:huzzl_web/views/job%20seekers/home/home_script.dart';
import 'package:huzzl_web/views/job%20seekers/home/home_widgets.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/job%20seekers/home/home_widgets.dart';
import 'package:huzzl_web/views/job%20seekers/home/job_provider.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/calendar_ui/applicant_model.dart';
import 'package:huzzl_web/widgets/buttons/blue/bluefilled_circlebutton.dart';
import 'package:huzzl_web/widgets/dropdown/DropdownWithCheckboxes.dart';
import 'package:huzzl_web/widgets/dropdown/DropdownWithCheckboxes.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'package:huzzl_web/views/job%20seekers/my_jobs/my_jobs.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class JobSeekerHomeScreen extends StatefulWidget {
  final String? resumeText;
  final String uid;

  const JobSeekerHomeScreen({super.key, this.resumeText, required this.uid});

  @override
  State<JobSeekerHomeScreen> createState() => _JobSeekerHomeScreenState();
}

class _JobSeekerHomeScreenState extends State<JobSeekerHomeScreen>
    with AutomaticKeepAliveClientMixin {
  // List<Map<String, String>> jobs = [];
  // bool isLoading = false;
  final TextEditingController _searchController = TextEditingController();
  // bool hasResults = true;
  bool isSearching = false;
  List<String> selectedJobTitles = [];
  var locationController = TextEditingController();
  // List<String> selectedJobTitles = []; // Tracks selected job titles

  List<String> datePostedOptions = [
    'Last 24 hours',
    'Last 7 days',
    'Last 30 days',
    'Anytime'
  ];
  String? selectedDate; // Default selection

  List<String> loadingPhrases = [
    "Chasing Opportunities...",
    "Racing Towards Your Next Job...",
    "Finding the Perfect Fit...",
    "Running to Match Your Skills...",
    "On the Hunt for Jobs...",
    "Your Dream Job is Around the Corner...",
    "Matching You with Top Jobs...",
    "Scouting the Best Opportunities...",
    "Tracking Down the Best Matches...",
    "On a Job-Search Marathon..."
  ];

  int currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    final jobProvider = Provider.of<JobProvider>(context, listen: false);
    // jobProvider.loadJobs();
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      setState(() {
        currentIndex = (currentIndex + 1) % loadingPhrases.length;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  void onSearch() {
    final jobProvider = Provider.of<JobProvider>(context, listen: false);
    final searchedWord = _searchController.text.trim().toLowerCase();
    if (searchedWord.isNotEmpty) {
      jobProvider.loadJobs(searchedWord);
    }
    if (jobProvider.jobs.isEmpty) {
      jobProvider.loadJobs(searchedWord);
    }
    // setState(() {
    //   jobProvider.jobs.shuffle(Random());
    // });
    print("---UID:----- ${widget.uid}");
  }

  void onFilterClicked() {
    final jobProvider = Provider.of<JobProvider>(context, listen: false);
    // final searchedWord = _searchController.text.trim().toLowerCase();
    String searchedWord = "";
    if (jobProvider.selectedJobTitles.length == 1) {
      searchedWord = jobProvider.selectedJobTitles[0].trim().toLowerCase();
    }
    if (searchedWord.isNotEmpty) {
      jobProvider.loadJobs(searchedWord);
    }
    if (jobProvider.jobs.isEmpty) {
      jobProvider.loadJobs(searchedWord);
    }
    // setState(() {
    //   jobProvider.jobs.shuffle(Random());
    // });
    print("---UID:----- ${widget.uid}");
  }

  void clearSearch() {
    _searchController.clear();
    final jobProvider = Provider.of<JobProvider>(context, listen: false);
    jobProvider.restoreDefaultJobs(); // Restore default jobs

    setState(() {
      isSearching = false; // Reset searching state
    });
  }

  List<String> selectedLocations = []; // Store selected locations

// TextEditingController to manage input text in the TextField
  TextEditingController _dropdownSearchFieldController =
      TextEditingController();

// Build the location input UI with Add button
  Widget buildAddLocation(StateSetter setState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // TextField for input
            Expanded(
              child: TextField(
                controller: _dropdownSearchFieldController,
                decoration: InputDecoration(
                  hintText: 'City/Municipality/Province',
                  hintStyle: TextStyle(
                      fontFamily: 'Galano', fontSize: 14, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        BorderSide(color: Color(0xFFD1E1FF), width: 1.5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        BorderSide(color: Color(0xFFD1E1FF), width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        BorderSide(color: Color(0xFFD1E1FF), width: 1.5),
                  ),
                ),
                onChanged: (text) {
                  setState(() {
                    // Trigger a rebuild when text changes (for enabling/disabling the "Add" button)
                  });
                },
              ),
            ),

            // "Add" button: only shows if there's text in the field
            if (_dropdownSearchFieldController.text.isNotEmpty &&
                selectedLocations.length < 3)
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  String location = _dropdownSearchFieldController.text.trim();

                  if (location.isNotEmpty &&
                      !selectedLocations.any((selected) =>
                          selected.toLowerCase() == location.toLowerCase())) {
                    setState(() {
                      selectedLocations
                          .add(location); // Add location to selected list
                    });
                  }

                  // Clear the input field after adding
                  _dropdownSearchFieldController.clear();
                },
              ),
          ],
        ),
        SizedBox(height: 10),
        // Display selected locations as chips
        Wrap(
          spacing: 8.0,
          children: selectedLocations.map((location) {
            return Chip(
              label: Text(location),
              onDeleted: () {
                setState(() {
                  selectedLocations
                      .remove(location); // Remove from selected list
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final jobProvider = Provider.of<JobProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                // Sidebar Filters
                Container(
                  width: 320,
                  padding: EdgeInsets.all(30),
                  child: ListView(
                    children: [
                      Text(
                        'Classification',
                        style: TextStyle(
                            fontFamily: 'Galano',
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                      ),
                      Gap(16),
                      PopupMenuButton<int>(
                        color: Colors.white,
                        onSelected: (value) {},
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0xFFD1E1FF)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.arrow_drop_down),
                              Text("Select classification"),
                            ],
                          ),
                        ),
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem<int>(
                              enabled: false,
                              child: SingleChildScrollView(
                                child: DropdownWithCheckboxes(
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
                                      title:
                                          'Administration and Office Support',
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
                                  preSelectedItems: selectedJobTitles,
                                  onSelectionChanged: (selectedItems) {
                                    setState(() {
                                      selectedJobTitles = selectedItems;
                                    });
                                    print('Selected items: ${selectedItems}');
                                  },
                                ),
                              ),
                            ),
                          ];
                        },
                      ),
                      SizedBox(height: 20),
                      Text("Selected Titles: ${selectedJobTitles.join(', ')}"),
                      Gap(20),
                      // Location field
                      Text(
                        'Location (up to 3)',
                        style: TextStyle(
                            fontFamily: 'Galano',
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                      ),
                      Gap(8),
                      buildAddLocation(setState),
                      Gap(16),

                      // Salary range
                      Text(
                        'Platform',
                        style: TextStyle(
                            fontFamily: 'Galano',
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                      ),
                      Gap(8),
                      DropdownButtonFormField<String>(
                        value: 'all',
                        items: [
                          DropdownMenuItem(
                              value: 'all', child: Text('All platforms')),
                          DropdownMenuItem(
                              value: 'huzzl',
                              child: Row(
                                children: [
                                  Image.asset(
                                      'assets/images/huzzl_logo_ulo.png',
                                      height: 30),
                                ],
                              )),
                          DropdownMenuItem(
                              value: 'jobstreet',
                              child: Row(
                                children: [
                                  Image.asset(
                                      'assets/images/jobstreet-logo.png',
                                      height: 30),
                                ],
                              )),
                          DropdownMenuItem(
                              value: 'kalibrr',
                              child: Row(
                                children: [
                                  Image.asset('assets/images/kalibbr-logo.png',
                                      height: 30),
                                ],
                              )),
                          DropdownMenuItem(
                              value: 'onlinejobsph',
                              child: Row(
                                children: [
                                  Image.asset(
                                      'assets/images/onlinejobsph-logo.png',
                                      height: 30),
                                ],
                              )),
                          DropdownMenuItem(
                            value: 'philjobnet',
                            child: Row(
                              children: [
                                Image.asset('assets/images/philjobnet-logo.png',
                                    height: 30),
                              ],
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            // _selectedRate = value;
                          });
                        },
                        decoration: InputDecoration(
                          // labelText: 'Select date posted',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                                color: Color(0xFFD1E1FF), width: 1.5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                                color: Color(0xFFD1E1FF), width: 1.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                                color: Color(0xFFD1E1FF), width: 1.5),
                          ),
                        ),
                      ),
                      SizedBox(height: 50),
                      Row(
                        children: [
                          Expanded(
                            child: BlueFilledCircleButton(
                              onPressed: () {},
                              text: 'Filter jobs',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  height: double.infinity,
                  color: Colors.grey[300],
                ),
                // Job Listings
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // Search bar
                        Row(
                          children: [
                            Container(
                              width: 700,
                              child: TextField(
                                controller: _searchController,
                                decoration: InputDecoration(
                                  hintText: 'Enter job title or keywords',
                                  hintStyle: TextStyle(fontFamily: 'Galano'),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                        color: Color(0xFFD1E1FF), width: 2),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                        color: Color(0xFFD1E1FF), width: 2),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                        color: Color(0xFFD1E1FF), width: 2),
                                  ),
                                  suffixIcon: isSearching
                                      ? IconButton(
                                          icon: Icon(Icons.clear),
                                          onPressed:
                                              clearSearch, // Clear search logic
                                        )
                                      : null,
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.all(
                                        10), // Adjust padding as needed
                                    child: Icon(
                                      Icons.search,
                                      color: Color(0xFFFE9703),
                                    ), // Change color if needed
                                  ),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    isSearching =
                                        _searchController.text.isNotEmpty;
                                  });
                                },
                              ),
                            ),
                            SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: onSearch,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF0038FF),
                                padding: EdgeInsets.all(20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                'Find Jobs',
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),

                        // Main content based on search and job data state
                        jobProvider.isLoading
                            ? Padding(
                                padding: const EdgeInsets.only(top: 150),
                                child: Center(
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        'assets/images/gif/huzzl_loading.gif',
                                        height: 80,
                                      ),
                                      Text(
                                        loadingPhrases[currentIndex],
                                        style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          color: Color(0xFFfd7206),
                                          fontFamily: 'Galano',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : jobProvider.hasResults &&
                                    (jobProvider.searchJobs.isNotEmpty ||
                                        jobProvider.jobs
                                            .isNotEmpty) // Show jobs if available
                                ? Expanded(
                                    child: ListView.builder(
                                      itemCount: jobProvider
                                              .searchJobs.isNotEmpty
                                          ? jobProvider.searchJobs
                                              .length // Use searchJobs if a search query is active
                                          : jobProvider.jobs
                                              .length, // Use jobs if no search query is active
                                      itemBuilder: (context, index) {
                                        final job = jobProvider
                                                .searchJobs.isNotEmpty
                                            ? jobProvider.searchJobs[
                                                index] // Use filtered jobs
                                            : jobProvider
                                                .jobs[index]; // Use all jobs

                                        return buildJobCard(
                                            // uid: job['uid'] ?? '', // jobpostUid
                                            jobPostUid: job['uid'] ?? '',
                                            userId: FirebaseAuth.instance
                                                    .currentUser?.uid ??
                                                "",
                                            recruiterUid: job['userUid'] ?? '',
                                            joblink: job['jobLink'] ?? '',
                                            datePosted: job['datePosted'] ??
                                                'No Date Posted',
                                            title: job['title']!,
                                            location: job['location'] ??
                                                'No Location',
                                            rate:
                                                job['salary'] ?? 'Not provided',
                                            description: job['description'] ??
                                                'No description available',
                                            website: job['website']!,
                                            tags:
                                                job['tags']?.split(', ') ?? [],
                                            context: context);
                                      },
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(top: 180),
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            'assets/images/huzzl_notfound.png',
                                            height: 150,
                                          ),
                                        ],
                                      ),
                                    ),
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
