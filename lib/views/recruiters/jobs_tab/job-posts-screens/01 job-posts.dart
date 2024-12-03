import 'dart:convert';
import 'package:drop_down_search_field/drop_down_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gap/gap.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:huzzl_web/user-provider.dart';
import 'package:huzzl_web/views/recruiters/branches_tab/branch-manager-staff-model.dart';
import 'package:huzzl_web/views/recruiters/branches_tab/branch-provider.dart';
import 'package:huzzl_web/views/recruiters/jobs_tab/widgets/custom_input.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class JobPosts extends StatefulWidget {
  final VoidCallback nextPage;
  final VoidCallback cancel;
  String jobTitleController;
  String selectedIndustry;
  final ValueChanged<String?> onselectedIndustryChanged;
  final ValueChanged<String?> onselectedJobTitleChanged;
  String numOfPeopleToHire;
  final ValueChanged<String?> onNumOfPeopleToHireChanged;
  final ValueChanged<String?> onNumPeopleChanged;
  final ValueChanged<String?> onBranchChanged;
  final TextEditingController jobDescriptionController;

  JobPosts({
    required this.nextPage,
    required this.cancel,
    required this.jobTitleController,
    required this.selectedIndustry,
    required this.onselectedIndustryChanged,
    required this.onselectedJobTitleChanged,
    required this.numOfPeopleToHire,
    required this.onNumOfPeopleToHireChanged,
    required this.onNumPeopleChanged,
    required this.onBranchChanged,
    required this.jobDescriptionController,
  });

  @override
  _JobPostsState createState() => _JobPostsState();
}

class _JobPostsState extends State<JobPosts> {
  final _formKey = GlobalKey<FormState>();
  String?
      _selectedValue; // if more than one person is selected/value will be stored here

  String? selectedRegion;
  String? selectedProvince;
  String? selectedCity;
  String? selectedBarangay;

  List<dynamic> regions = [];
  List<dynamic> provinces = [];
  List<dynamic> cities = [];
  List<dynamic> barangays = [];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    final loggedInUserId =
        Provider.of<UserProvider>(context, listen: false).loggedInUserId;
    final branchProvider = Provider.of<BranchProvider>(context, listen: false);

    if (loggedInUserId != null) {
      await branchProvider.fetchActiveBranches(loggedInUserId);
      setState(() {
        branches = branchProvider.branches;
      });
    }
  }

  void _submitJobPosts() {
    if (_formKey.currentState!.validate()) {
      widget.nextPage();
    }
  }

  Future<void> fetchRegions() async {
    final response =
        await http.get(Uri.parse('https://psgc.gitlab.io/api/regions/'));
    if (response.statusCode == 200) {
      setState(() {
        regions = jsonDecode(response.body);
      });
    } else {
      throw Exception('Failed to load regions');
    }
  }

  Future<void> fetchProvinces(String regionCode) async {
    final response = await http.get(
        Uri.parse('https://psgc.gitlab.io/api/regions/$regionCode/provinces/'));
    if (response.statusCode == 200) {
      setState(() {
        provinces = jsonDecode(response.body);
        // resetSelections();
      });
    } else {
      throw Exception('Failed to load provinces');
    }
  }

  Future<void> fetchCities(String provinceCode) async {
    final response = await http.get(Uri.parse(
        'https://psgc.gitlab.io/api/provinces/$provinceCode/cities-municipalities/'));
    if (response.statusCode == 200) {
      setState(() {
        cities = jsonDecode(response.body);
        // resetCityAndBarangaySelections();
      });
    } else {
      throw Exception('Failed to load cities');
    }
  }

  Future<void> fetchBarangays(String cityCode) async {
    final response = await http.get(Uri.parse(
        'https://psgc.gitlab.io/api/cities-municipalities/$cityCode/barangays/'));
    if (response.statusCode == 200) {
      setState(() {
        barangays = jsonDecode(response.body);
        // selectedBarangay = null; // Reset selected barangay
      });
    } else {
      throw Exception('Failed to load barangays');
    }
  }

  // void resetSelections() {
  //   selectedProvince = null;
  //   selectedCity = null;
  //   selectedBarangay = null;
  //   cities = [];
  //   barangays = [];
  // }

  // void resetCityAndBarangaySelections() {
  //   selectedCity = null;
  //   selectedBarangay = null;
  //   barangays = [];
  // }

  final TextEditingController _dropdownSearchFieldController =
      TextEditingController();

  SuggestionsBoxController suggestionBoxController = SuggestionsBoxController();

  Branch? selectedBranch;
  List<Branch> branches = [];

  List<Branch> getSuggestions(String query) {
    List<Branch> matches = branches
        .where((branch) =>
            branch.branchName.toLowerCase().contains(query.toLowerCase()) ||
            branch.region.toLowerCase().contains(query.toLowerCase()) ||
            branch.province.toLowerCase().contains(query.toLowerCase()) ||
            branch.city.toLowerCase().contains(query.toLowerCase()) ||
            branch.house.toLowerCase().contains(query.toLowerCase()) ||
            branch.barangay.toLowerCase().contains(query.toLowerCase()) |
                branch.zip.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return matches;
  }

  Widget buildSearchDropdown(StateSetter setState) {
    return GestureDetector(
      onTap: () {
        suggestionBoxController.close();
      },
      child: DropDownSearchFormField<Branch>(
        textFieldConfiguration: TextFieldConfiguration(
          controller: _dropdownSearchFieldController,
          decoration: InputDecoration(
            // label: Text('Select Applicant'),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        suggestionsCallback: (pattern) async {
          return await getSuggestions(pattern);
        },
        itemBuilder: (context, branch) {
          return ListTile(
            title: Text(branch.branchName),
            subtitle: Text(
                '${branch.house} ${branch.barangay}, ${branch.city}, ${branch.zip}, ${branch.province}, ${branch.region}'),
          );
        },
        itemSeparatorBuilder: (context, index) {
          return const Divider();
        },
        onSuggestionSelected: (Branch branch) {
          _dropdownSearchFieldController.text = branch.branchName;
          selectedBranch = branch;
          widget.onBranchChanged(selectedBranch!.branchName);
        },
        suggestionsBoxController: suggestionBoxController,
        validator: (value) => value == null ? 'Please select branch' : null,
        displayAllSuggestionWhenTap: true,
        suggestionsBoxDecoration: SuggestionsBoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
      ),
    );
  }

  // Widget buildRegionDropdown() {
  //   return SizedBox(
  //     width: MediaQuery.of(context).size.width * 0.25,
  //     child: DropdownButtonFormField<String>(
  //       hint: const Text(
  //         'Select region',
  //         style: TextStyle(fontFamily: 'Galano'),
  //       ),
  //       decoration: customInputDecoration(),
  //       value: selectedRegion,
  //       items: regions.map<DropdownMenuItem<String>>((region) {
  //         return DropdownMenuItem<String>(
  //           value: region['name'],
  //           child: Text(region['name']),
  //         );
  //       }).toList(),
  //       onChanged: (String? newValue) {
  //         setState(() {
  //           selectedRegion = newValue;
  //           // resetSelections();
  //         });
  //         widget.onRegionChanged(newValue);
  //         if (newValue != null) {
  //           final selectedRegionCode = regions.firstWhere(
  //             (region) => region['name'] == newValue,
  //             orElse: () => null,
  //           )['code'];
  //           if (selectedRegionCode != null) {
  //             fetchProvinces(selectedRegionCode);
  //           }
  //         }
  //       },
  //       validator: (value) {
  //         if (value == null || value.isEmpty) {
  //           return 'Region is required.';
  //         }
  //         return null;
  //       },
  //     ),
  //   );
  // }

  // Widget buildProvinceDropdown() {
  //   return SizedBox(
  //     width: MediaQuery.of(context).size.width * 0.25,
  //     child: DropdownButtonFormField<String>(
  //       hint: Text(
  //         'Select Province',
  //         style: TextStyle(fontFamily: 'Galano'),
  //       ),
  //       decoration: customInputDecoration(),
  //       value: selectedProvince,
  //       items: provinces.map<DropdownMenuItem<String>>((province) {
  //         return DropdownMenuItem<String>(
  //           value: province['name'],
  //           child: Text(province['name']),
  //         );
  //       }).toList(),
  //       onChanged: (String? newValue) {
  //         setState(() {
  //           selectedProvince = newValue;
  //           // resetCityAndBarangaySelections();
  //         });
  //         widget.onProvinceChanged(newValue);
  //         if (newValue != null) {
  //           final selectedProvinceCode = provinces.firstWhere(
  //             (province) => province['name'] == newValue,
  //             orElse: () => null,
  //           )['code'];
  //           if (selectedProvinceCode != null) {
  //             fetchCities(selectedProvinceCode);
  //           }
  //         }
  //       },
  //       validator: (value) {
  //         if (value == null || value.isEmpty) {
  //           return 'Province is required.';
  //         }
  //         return null;
  //       },
  //     ),
  //   );
  // }

  // Widget buildCityDropdown() {
  //   return SizedBox(
  //     width: MediaQuery.of(context).size.width * 0.25,
  //     child: DropdownButtonFormField<String>(
  //       hint: Text(
  //         'Select City/Municipality',
  //         style: TextStyle(fontFamily: 'Galano'),
  //       ),
  //       decoration: customInputDecoration(),
  //       value: selectedCity,
  //       items: cities.map<DropdownMenuItem<String>>((city) {
  //         return DropdownMenuItem<String>(
  //           value: city['name'],
  //           child: Text(city['name']),
  //         );
  //       }).toList(),
  //       onChanged: (String? newValue) {
  //         setState(() {
  //           selectedCity = newValue;
  //           // selectedBarangay = null;
  //           // barangays = [];
  //         });
  //         widget.onCityChanged(newValue);
  //         if (newValue != null) {
  //           final selectedCitiesCode = cities.firstWhere(
  //             (city) => city['name'] == newValue,
  //             orElse: () => null,
  //           )['code'];
  //           if (selectedCitiesCode != null) {
  //             fetchBarangays(selectedCitiesCode);
  //           }
  //         }
  //       },
  //       validator: (value) {
  //         if (value == null || value.isEmpty) {
  //           return 'City is required.';
  //         }
  //         return null;
  //       },
  //     ),
  //   );
  // }

  // Widget buildBarangayDropdown() {
  //   return SizedBox(
  //     width: MediaQuery.of(context).size.width * 0.25,
  //     child: DropdownButtonFormField<String>(
  //       hint: Text(
  //         'Select Barangay',
  //         style: TextStyle(fontFamily: 'Galano'),
  //       ),
  //       decoration: customInputDecoration(),
  //       value: selectedBarangay,
  //       items: barangays.map<DropdownMenuItem<String>>((barangay) {
  //         return DropdownMenuItem<String>(
  //           value: barangay['name'],
  //           child: Text(barangay['name']),
  //         );
  //       }).toList(),
  //       onChanged: (String? newValue) {
  //         setState(() {
  //           selectedBarangay = newValue;
  //         });
  //         widget.onBarangayChanged(newValue);
  //       },
  //       validator: (value) {
  //         if (value == null || value.isEmpty) {
  //           return 'Barangay is required.';
  //         }
  //         return null;
  //       },
  //     ),
  //   );
  // }

  // Widget buildOtherLocationField() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text('If the location is not listed above, please enter it here:'),
  //       TextFormField(
  //         controller: widget.otherLocation,
  //         decoration: InputDecoration(
  //           isDense: true,
  //           border: OutlineInputBorder(
  //             borderRadius: BorderRadius.circular(8),
  //           ),
  //         ),
  //       ),
  //       Gap(10),
  //     ],
  //   );
  // }

  final List<String> _industries = [
    '',
    'Aerospace & Defense',
    'Agriculture',
    'Arts, Entertainment & Recreation',
    'Automotive',
    'Education',
    'Energy, Mining & Utilities',
    'Fashion & Beauty',
    'Finance & Accounting',
    'Food & Beverage',
    'Government & Public Administration',
    'Healthcare',
    'Hotels & Travel Accommodation',
    'Human Resources & Staffing',
    'Information Technology',
    'Insurance',
    'Legal',
    'Management & Consulting',
    'Manufacturing',
    'Media & Entertainment',
    'Military & Defense',
    'Mining',
    'Real Estate',
    'Retail & Consumer Goods',
    'Sales & Marketing',
    'Science & Medicine',
    'Sports & Medicine',
    'Supply Chain',
    'Transportation & Warehousing',
    'Travel & Hospitality',
  ];

// Remove duplicates from listOfJobTitle
  List<String>? listOfJobTitle = [];
  bool jobTitleIsEmpty = true;

  Future<void> generateJobTitleList(String selectedIndustry) async {
    // setState(() {
    //   jobTitleIsEmpty = listOfJobTitle.isEmpty;
    // });
    String geminiAPIKey = dotenv.env['GEMINI_API_KEY']!;
    String geminiModel = dotenv.env['MODEL']!;

    debugPrint("Selected industry: $selectedIndustry");

    var prompt =
        "Can you create a list of job titles based on this industry $selectedIndustry. Example output ['Software Engineer', 'Network Admin']. Always return your output like that. DONT RETURN ANYTHING BESIDES THE LIST.";

    final model = GenerativeModel(
      model: geminiModel,
      apiKey: geminiAPIKey,
    );

    try {
      final response = await model.generateContent([Content.text(prompt)]);
      debugPrint(response.text);

      // Parse the response text into a list of strings and remove duplicates
      setState(() {
        listOfJobTitle = _parseJobTitles(response.text!)
            .toSet()
            .toList(); // Removes duplicates
        jobTitleIsEmpty = listOfJobTitle!.isEmpty;
        debugPrint(listOfJobTitle!.length.toString());
      });

      for (var element in listOfJobTitle!) {
        debugPrint(element);
      }
    } catch (e) {
      debugPrint("Error generating job title list: $e");
    }
  }

// Function to parse the response text into a list of strings
  List<String> _parseJobTitles(String text) {
    // Strip out the brackets and split by comma
    text = text.replaceAll('[', '').replaceAll(']', '');
    return text.split(',').map((e) => e.trim().replaceAll("'", "")).toList();
  }

  Future<void> generateDescription(String selectedJobTitle) async {
    String geminiAPIKey = dotenv.env['GEMINI_API_KEY']!;
    String geminiModel = dotenv.env['MODEL']!;

    debugPrint("Selected job title: $selectedJobTitle");

    var prompt =
        "Generate a one-paragraph job description (80-100 words) for the job title: $selectedJobTitle. Follow the instructions strictly and return only the requested content. Just provide the description no [Company Name] [Position] anything like that. just pure job description.";

    final model = GenerativeModel(
      model: geminiModel,
      apiKey: geminiAPIKey,
    );

    try {
      final response = await model.generateContent([Content.text(prompt)]);
      if (response.text != null && response.text!.isNotEmpty) {
        debugPrint("Generated Description: ${response.text}");
        setState(() {
           widget.jobDescriptionController.text = response.text!;
        });
        debugPrint("Setted: ${widget.jobTitleController}");
      } else {
        debugPrint("Received empty or invalid response from the AI model.");
        // Optionally show a fallback message to the user
      }
    } catch (e) {
      debugPrint("Error generating job description: $e");
      // Handle errors more gracefully by notifying the user
    }
  }

  //   Future<void> generateMessage(String candidateId, String typeOfMessage) async {
  //   Candidate candidate = findDataOfCandidate(candidateId)!;

  //   await dotenv.load();
  //   String geminiAPIKey = dotenv.env['GEMINI_API_KEY']!;
  //   String geminiModel = dotenv.env['MODEL']!;

  //   final model = prefix.GenerativeModel(
  //     model: geminiModel,
  //     apiKey: geminiAPIKey,
  //   );

  //   var prompt = "";

  //   if (typeOfMessage == "Reject") {
  //     prompt =
  //         "Can you create a rejection message for ${candidate.name}. Make it formal and pleasing. In a paragraph form. Just show the message no other information. Example: We regret to inform you that we have selected other candidates whose qualifications more closely align with the position requirements. Do not include anything like this [position], [company] like that.";
  //   } else if (typeOfMessage == "Hire") {
  //     prompt =
  //         "Can you create a acception/hired message for ${candidate.name}. Make it formal and pleasing. In a paragraph form. Just show the message no other information. Example: We're excited to welcome you! Your skills and enthusiasm truly impressed us, and we're confident you'll bring great value. Starting soon, we look forward to your contributions. Congratulations, and welcome aboard! Do not include anything like this [position], [company] like that.";
  //   }
  //   final response = await model.generateContent([prefix.Content.text(prompt)]);
  //   print(response.text);
  //   if (typeOfMessage == "Reject") {
  //     _rejectMessage = response.text!;
  //   } else if (typeOfMessage == "Hire") {
  //     _hireMessage = response.text!;
  //   }

  //   notifyListeners();

  //   // return response.text!;
  // }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Container(
          width: 700,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Gap(25),
                const Text(
                  'Job post',
                  style: TextStyle(
                    fontFamily: 'Galano',
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff202855),
                  ),
                ),
                const Text(
                  'Please provide the following to complete a job post.',
                  style: TextStyle(
                    fontFamily: 'Galano',
                    fontSize: 14,
                  ),
                ),
                Gap(20),
                 Row(
                  children: [
                    Text(
                      'Where would you like to advertise this job?',
                      style: TextStyle(
                        fontFamily: 'Galano',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff202855),
                      ),
                    ),
                    Text(
                      ' *',
                      style: TextStyle(
                        fontFamily: 'Galano',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.redAccent,
                      ),
                    )
                  ],
                ),
                const Text(
                  'Select branch',
                  style: TextStyle(
                    fontFamily: 'Galano',
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 10),
                buildSearchDropdown(setState),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      'Industry',
                      style: TextStyle(
                        fontFamily: 'Galano',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff202855),
                      ),
                    ),
                    Text(
                      ' *',
                      style: TextStyle(
                        fontFamily: 'Galano',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.redAccent,
                      ),
                    )
                  ],
                ),
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  hint: const Text('Select an industry'),
                  decoration: customInputDecoration(),
                  value: widget.selectedIndustry,
                  items: _industries
                      .map<DropdownMenuItem<String>>((String industry) {
                    return DropdownMenuItem<String>(
                      value: industry,
                      child: Text(industry),
                    );
                  }).toList(),
                  onChanged: (String? newValue) async {
                    setState(() {
                      widget.selectedIndustry = newValue!;
                      // Reset the job title list when a new industry is selected
                      listOfJobTitle!.clear(); // Clear the previous job titles
                      jobTitleIsEmpty =
                          true; // Indicate that the job title list is empty
                    });
                    widget.onselectedIndustryChanged(newValue);
                    await generateJobTitleList(
                        newValue!); // Trigger to fetch job titles based on selected industry
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Industry is required.';
                    }
                    return null;
                  },
                ),
                Gap(20),
                if (!jobTitleIsEmpty) // Only show job title dropdown when job titles are available
                  Row(
                    children: [
                      Text(
                        'Job title',
                        style: TextStyle(
                          fontFamily: 'Galano',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff202855),
                        ),
                      ),
                      Text(
                        ' *',
                        style: TextStyle(
                          fontFamily: 'Galano',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.redAccent,
                        ),
                      )
                    ],
                  ),
                // Job Title (Dropdown to dynamically populate based on selected industry)
                if (!jobTitleIsEmpty)
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    hint: const Text('Select a job title'),
                    decoration: customInputDecoration(),
                    value: widget.jobTitleController.isNotEmpty
                        ? widget.jobTitleController
                        : null, // Ensure it reflects the selected value
                    items: listOfJobTitle!
                        .map<DropdownMenuItem<String>>((String jobTitle) {
                      return DropdownMenuItem<String>(
                        value: jobTitle,
                        child: Text(jobTitle),
                      );
                    }).toList(),
                    onChanged: (String? newValue) async {
                      setState(() {
                        widget.jobTitleController = newValue!;
                        debugPrint("Job title: ${newValue}");
                      });
                      widget.onselectedJobTitleChanged(newValue);
                      widget.jobDescriptionController.clear();
                      await generateDescription(newValue!);
                      
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Job title is required.';
                      }
                      return null;
                    },
                  ),

                SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      'Job description',
                      style: TextStyle(
                        fontFamily: 'Galano',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff202855),
                      ),
                    ),
                    Text(
                      ' *',
                      style: TextStyle(
                        fontFamily: 'Galano',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.redAccent,
                      ),
                    )
                  ],
                ),
                TextFormField(
                  controller: widget.jobDescriptionController,
                  minLines: 3,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: customInputDecoration(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Job description is required.";
                    } else {
                      // Split the text into words using space as the separator
                      List<String> words = value.trim().split(RegExp(r'\s+'));
                      if (words.length < 30) {
                        // if (words.length < 30) {
                        return "Job description must be at least 30 words.";
                      }
                    }
                    return null; // Return null if validation passes
                  },
                ),
                SizedBox(height: 20),

                Row(
                  children: [
                    Text(
                      'Number of people to hire for this job',
                      style: TextStyle(
                        fontFamily: 'Galano',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff202855),
                      ),
                    ),
                    Text(
                      ' *',
                      style: TextStyle(
                        fontFamily: 'Galano',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.redAccent,
                      ),
                    )
                  ],
                ),
                RadioListTile<String>(
                  title: const Text(
                    'One person',
                    style: TextStyle(
                      fontFamily: 'Galano',
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff202855),
                    ),
                  ),
                  value: 'One person',
                  groupValue: widget.numOfPeopleToHire,
                  onChanged: (value) {
                    setState(() {
                      widget.numOfPeopleToHire = value!;
                      _selectedValue = null; // Reset dropdown value
                    });
                    widget.onNumOfPeopleToHireChanged(value);
                  },
                ),
                RadioListTile<String>(
                  title: const Text(
                    'More than one person',
                    style: TextStyle(
                      fontFamily: 'Galano',
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff202855),
                    ),
                  ),
                  value: 'More than one person',
                  groupValue: widget.numOfPeopleToHire,
                  onChanged: (value) {
                    setState(() {
                      widget.numOfPeopleToHire = value!;
                      _selectedValue = null; // Reset dropdown value
                    });
                    widget.onNumOfPeopleToHireChanged(value);
                  },
                ),
                Gap(10),
                if (widget.numOfPeopleToHire == 'More than one person') ...[
                  DropdownButtonFormField<String>(
                    decoration: customInputDecoration(),
                    value: _selectedValue,
                    hint: const Text("Select an option"),
                    items: <String>[
                      // '1',
                      '2',
                      '3',
                      '4',
                      '5',
                      '6',
                      '7',
                      '8',
                      '9',
                      '10+',
                      'I have an ongoing need to fill this role'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedValue = newValue;
                      });
                      widget.onNumPeopleChanged(newValue);
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Required to select";
                      }
                      return null;
                    },
                  ),
                ],
                Gap(10),
                // // Region Dropdown
                // buildRegionDropdown(),
                // const SizedBox(height: 10),

                // // Province Dropdown
                // if (selectedRegion != null) buildProvinceDropdown(),
                // const SizedBox(height: 10),

                // // City Dropdown
                // if (selectedProvince != null) buildCityDropdown(),
                // const SizedBox(height: 10),

                // // Barangay Dropdown
                // if (selectedCity != null) buildBarangayDropdown(),
                // const SizedBox(height: 10),

                // // Other location information field
                // if (selectedBarangay != null) buildOtherLocationField(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: widget.cancel,
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                              fontFamily: 'Galano', color: Color(0xffFE9703)),
                        )),
                    Gap(10),
                    ElevatedButton(
                      onPressed: () => _submitJobPosts(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0038FF),
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 30),
                      ),
                      child: const Text('Next',
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                            fontFamily: 'Galano',
                            fontWeight: FontWeight.w700,
                          )),
                    ),
                  ],
                ),
                Gap(20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
