import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/responsive_sizes.dart';
import 'package:huzzl_web/views/recruiters/branches_tab/logic/date-converter.dart';
import 'package:huzzl_web/views/recruiters/home/00%20home.dart';
import 'package:huzzl_web/views/recruiters/register/mainHiringManager_provider.dart';
import 'package:huzzl_web/widgets/buttons/blue/bluefilled_circlebutton.dart';
import 'package:huzzl_web/widgets/navbar/navbar_login_registration.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:drop_down_search_field/drop_down_search_field.dart';
import 'package:change_case/change_case.dart';
import 'package:image_picker/image_picker.dart';

class CompanyProfileRecruiter extends StatefulWidget {
  final UserCredential userCredential;
  CompanyProfileRecruiter({
    required this.userCredential,
    super.key,
  });

  @override
  State<CompanyProfileRecruiter> createState() =>
      _CompanyProfileRecruiterState();
}

class _CompanyProfileRecruiterState extends State<CompanyProfileRecruiter> {
  // final _formKey = GlobalKey<FormState>();
  final _companyName = TextEditingController();
  final _ceoFirstName = TextEditingController();
  final _ceoLastName = TextEditingController();
  final _description = TextEditingController();
  final _companyWebsite = TextEditingController();
  final _socialMediaLinks = TextEditingController();

  bool isProvinceVisible = true;

  bool iscompanyNameValid = true;
  bool isceoFirstNameValid = true;
  bool isceoLastNameValid = true;
  bool isdescriptionValid = true;
  bool iscompanyWebsiteValid = true;
  bool isHouseValid = true;
  String? errorMessage;

  FocusNode companyNameFocusNode = FocusNode();
  FocusNode ceoFirstNameFocusNode = FocusNode();
  FocusNode ceoLastNameFocusNode = FocusNode();
  FocusNode regionFocusNode = FocusNode();
  FocusNode provinceFocusNode = FocusNode();
  FocusNode cityFocusNode = FocusNode();
  FocusNode barangayFocusNode = FocusNode();
  FocusNode houseFocusNode = FocusNode();
  FocusNode industryFocusNode = FocusNode();
  FocusNode sizeFocusNode = FocusNode();
  FocusNode descriptionFocusNode = FocusNode();

  final companyNameFieldKey = GlobalKey<FormFieldState>();
  final ceoFirstNameFieldKey = GlobalKey<FormFieldState>();
  final ceoLastNameFieldKey = GlobalKey<FormFieldState>();
  final regionFieldKey = GlobalKey<FormFieldState>();
  final provinceFieldKey = GlobalKey<FormFieldState>();
  final cityFieldKey = GlobalKey<FormFieldState>();
  final barangayFieldKey = GlobalKey<FormFieldState>();
  final houseFieldKey = GlobalKey<FormFieldState>();
  final industryFieldKey = GlobalKey<FormFieldState>();
  final sizeFieldKey = GlobalKey<FormFieldState>();
  final descriptionFieldKey = GlobalKey<FormFieldState>();
  final websiteKey = GlobalKey<FormFieldState>();
  final socialMediaKey = GlobalKey<FormFieldState>();
  bool hasInteracted = false;

  bool isRegionValid = true;
  bool isProvinceValid = true;
  bool isCityValid = true;
  bool isBarangayValid = true;

  TextEditingController regionController = TextEditingController();
  TextEditingController provinceController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController barangayController = TextEditingController();
  TextEditingController houseController = TextEditingController();
  List<Map<String, dynamic>> regions = [];
  List<Map<String, dynamic>> provinces = [];
  List<Map<String, dynamic>> cities = [];
  List<Map<String, dynamic>> barangays = [];
  String? selectedRegion;
  String? selectedProvince;
  String? selectedCity;
  String? selectedBarangay;
  SuggestionsBoxController suggestionBoxController = SuggestionsBoxController();

  //List of documents for business verification
  List<String> businessDocs = <String>[
    "Article of incorporation",
    "Business licence",
    "Company liability insurance",
    "Office utility bill",
    "Lease of franchise agreement",
    "Tax permit",
    "Staffing agency employment letter or payslip",
  ];

  @override
  void initState() {
    super.initState();
    fetchRegions();
    companyNameFocusNode = FocusNode();
    ceoFirstNameFocusNode = FocusNode();
    ceoLastNameFocusNode = FocusNode();
    regionFocusNode = FocusNode();
    provinceFocusNode = FocusNode();
    cityFocusNode = FocusNode();
    barangayFocusNode = FocusNode();
    houseFocusNode = FocusNode();
    industryFocusNode = FocusNode();
    sizeFocusNode = FocusNode();
    descriptionFocusNode = FocusNode();

    companyNameFocusNode.addListener(() {
      if (!companyNameFocusNode.hasFocus) {
        companyNameFieldKey.currentState?.validate();
      }
    });
    ceoFirstNameFocusNode.addListener(() {
      if (!ceoFirstNameFocusNode.hasFocus) {
        ceoFirstNameFieldKey.currentState?.validate();
      }
    });

    ceoLastNameFocusNode.addListener(() {
      if (!ceoLastNameFocusNode.hasFocus) {
        ceoLastNameFieldKey.currentState?.validate();
      }
    });

    industryFocusNode.addListener(() {
      if (!industryFocusNode.hasFocus) {
        industryFieldKey.currentState?.validate();
      }
    });

    sizeFocusNode.addListener(() {
      if (!sizeFocusNode.hasFocus) {
        sizeFieldKey.currentState?.validate();
      }
    });

    descriptionFocusNode.addListener(() {
      if (!descriptionFocusNode.hasFocus) {
        descriptionFieldKey.currentState?.validate();
      }
    });
  }

  @override
  void dispose() {
    companyNameFocusNode.dispose();
    ceoFirstNameFocusNode.dispose();
    ceoLastNameFocusNode.dispose();
    regionFocusNode.dispose();
    provinceFocusNode.dispose();
    cityFocusNode.dispose();
    barangayFocusNode.dispose();
    houseFocusNode.dispose();
    industryFocusNode.dispose();
    sizeFocusNode.dispose();
    descriptionFocusNode.dispose();

    super.dispose();
  }

  //Capitalizer
  // String capitalizeEachWord(String input) {
  //   return input
  //       .split(' ')
  //       .map((word) => word.isNotEmpty
  //           ? word[0].toUpperCase() + word.substring(1).toLowerCase()
  //           : '')
  //       .join(' ');
  // }

// Fetch regions from the API
  Future<void> fetchRegions() async {
    final response =
        await http.get(Uri.parse('https://psgc.gitlab.io/api/regions/'));
    if (response.statusCode == 200) {
      setState(() {
        // Storing the entire region object (name and code)
        regions = List<Map<String, dynamic>>.from(jsonDecode(response.body));
      });
    } else {
      throw Exception('Failed to load regions');
    }
  }

// Fetch provinces or cities based on the selected region
  Future<void> fetchProvincesOrCities(String regionCode) async {
    if (regionCode == '130000000') {
      // If regionCode is NCR (130000000), fetch cities directly
      await fetchCitiesForRegion(regionCode);
    } else {
      final response = await http.get(Uri.parse(
          'https://psgc.gitlab.io/api/regions/$regionCode/provinces/'));
      if (response.statusCode == 200) {
        setState(() {
          provinces =
              List<Map<String, dynamic>>.from(jsonDecode(response.body));
          selectedProvince = null; // Reset province
          cities = [];
          selectedCity = null; // Reset city
          barangays = []; // Reset barangays
          selectedBarangay = null; // Reset barangay
        });
      } else {
        throw Exception('Failed to load provinces');
      }
    }
  }

// Fetch cities directly for regions like NCR
  Future<void> fetchCitiesForRegion(String regionCode) async {
    final response = await http.get(Uri.parse(
        'https://psgc.gitlab.io/api/regions/$regionCode/cities-municipalities/'));
    if (response.statusCode == 200) {
      setState(() {
        cities = List<Map<String, dynamic>>.from(jsonDecode(response.body));
        selectedCity = null; // Reset city
        selectedBarangay = null; // Reset barangay
        barangays = []; // Reset barangays
      });
    } else {
      throw Exception('Failed to load cities');
    }
  }

// Fetch cities by province code
  Future<void> fetchCities(String provinceCode) async {
    final response = await http.get(Uri.parse(
        'https://psgc.gitlab.io/api/provinces/$provinceCode/cities-municipalities/'));
    if (response.statusCode == 200) {
      setState(() {
        cities = List<Map<String, dynamic>>.from(jsonDecode(response.body));
        selectedCity = null; // Reset city
        selectedBarangay = null; // Reset barangay
        barangays = []; // Clear barangays
      });
    } else {
      throw Exception('Failed to load cities');
    }
  }

// Fetch barangays by city/municipality code
  Future<void> fetchBarangays(String cityCode) async {
    final response = await http.get(Uri.parse(
        'https://psgc.gitlab.io/api/cities-municipalities/$cityCode/barangays/'));
    if (response.statusCode == 200) {
      setState(() {
        barangays = List<Map<String, dynamic>>.from(jsonDecode(response.body));
        selectedBarangay = null; // Reset barangay
      });
    } else {
      throw Exception('Failed to load barangays');
    }
  }

  //Industry
  String? _selectedIndustry;
  bool isindustryValid = true;
  TextEditingController industryController = TextEditingController();
  final List<String> _industries = [
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

  //Size
  String? _selectedSizeOfCompany;
  final List<String> sizeOfCompany = [
    "It's just me",
    '2 to 9 employees',
    '10 to 99 employees',
    '100 to 1,000 employees',
    'more than 1,000 employees',
  ];

  //Business Docs File
  List<String> fileNames = []; // List to hold file names
  double containerHeight = 100;
  bool isFileNamesEmpty = false;
  PlatformFile? pickedFile;

  List<PlatformFile> pickedFiles = [];

  void _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg'],
    );

    if (result != null) {
      setState(() {
        pickedFiles = result.files; // Store all picked files
        fileNames.clear();
        containerHeight = 100;

        for (var file in pickedFiles) {
          fileNames.add(file.name);
          containerHeight += 15; // Increase height for each new file
        }
      });
    }
  }

  Future<void> uploadFiles() async {
    if (fileNames.isEmpty) {
      print("No files selected.");
      return;
    }
print("business docu uploaded!!");
    // for (var pickedFile in pickedFiles) {
    //   try {
    //     final path =
    //         'BusinessDocuments/${widget.userCredential.user!.uid}/${pickedFile.name}';

    //     if (pickedFile.bytes != null) {
    //       // Upload using bytes for web
    //       print("Uploading file in web using bytes: ${pickedFile.name}...");
    //       final Uint8List fileBytes = pickedFile.bytes!;

    //       final ref = FirebaseStorage.instance.ref().child(path);
    //       final uploadTask = ref.putData(fileBytes);

    //       // Monitor upload progress
    //       uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
    //         print(
    //             'Upload progress for ${pickedFile.name}: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100}%');
    //       }, onError: (e) {
    //         print("Error during file upload: $e");
    //       });

    //       // Await the task completion
    //       final snapshot = await uploadTask;
    //       final downloadUrl = await snapshot.ref.getDownloadURL();
    //       print("File uploaded successfully: $downloadUrl");
    //     } else {
    //       throw Exception("No valid file data found for ${pickedFile.name}.");
    //     }
    //   } catch (e) {
    //     print("File upload failed for ${pickedFile.name}: $e");
    //   }
    // }
  
  
  }

  //Link
  List<String> socialMediaLinks = [];

  //SubmitForm
  void submitCompanyProfileForm() async {
    if (fileNames.isEmpty) {
      setState(() {
        isFileNamesEmpty = true;
      });
    } else if (fileNames.isNotEmpty) {
      setState(() {
        isFileNamesEmpty = false;
      });
    }
    final isValidCompanyName = companyNameFieldKey.currentState!.validate();
    final isValidFirstName = ceoFirstNameFieldKey.currentState!.validate();
    final isValidLastName = ceoLastNameFieldKey.currentState!.validate();
    final isValidRegion = regionFieldKey.currentState!.validate();
    final isValidProvince = provinceFieldKey.currentState!.validate();
    final isValidCity = cityFieldKey.currentState!.validate();
    final isValidBarangay = barangayFieldKey.currentState!.validate();
    final isValidHouse = houseFieldKey.currentState!.validate();
    final isValidIndustry = industryFieldKey.currentState!.validate();
    final isValidSize = sizeFieldKey.currentState!.validate();
    final isValidDescription = descriptionFieldKey.currentState!.validate();
    final isValidWebsite = websiteKey.currentState!.validate();
    final isValidSocialMedia = socialMediaKey.currentState!.validate();
    bool isValid = isValidCompanyName &&
        isValidFirstName &&
        isValidLastName &&
        isValidRegion &&
        isValidProvince &&
        isValidCity &&
        isValidBarangay &&
        isValidHouse &&
        isValidIndustry &&
        isValidSize &&
        isValidDescription &&
        isValidWebsite &&
        isValidSocialMedia &&
        fileNames.isNotEmpty;
    if (isValid) {
      try {
        await uploadFiles();
        // Social Links
        if (_socialMediaLinks.text.isNotEmpty) {
          String inputSocialMedia = _socialMediaLinks.text;
          setState(() {
            socialMediaLinks =
                inputSocialMedia.split(',').map((link) => link.trim()).toList();
          });
          print("Socials: $socialMediaLinks");
        }
        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userCredential.user!.uid)
            .collection("company_information")
            .add({
          'uid': widget.userCredential.user!.uid,
          'companyName': _companyName.text.trim().toCapitalCase(),
          'ceoFirstName': _ceoFirstName.text.trim().toCapitalCase(),
          'ceoLastName': _ceoLastName.text.trim().toCapitalCase(),
          'region': selectedRegion ?? 'not specified',
          'province': selectedProvince ?? 'not specified',
          'city': selectedCity ?? 'not specified',
          'barangay': selectedBarangay ?? 'not specified',
          'industry': _selectedIndustry ?? 'not specified',
          'locationOtherInformation':
              houseController.text.trim().toCapitalCase(),
          'companySize': _selectedSizeOfCompany,
          'companyDescription': _description.text.trim().toSentenceCase(),
          'companyWebsite': _companyWebsite.text.isNotEmpty
              ? _companyWebsite.text.toLowerCase().trim()
              : 'none',
          'companyLinks': _socialMediaLinks.text.isNotEmpty
              ? socialMediaLinks
              : "not specified",
        });
        String loggedInUserId = widget.userCredential.user!.uid;
        String formattedDateEstablished =
            DateFormat('MMMM d, yyyy').format(DateTime.now());
        if (!context.mounted) return;
        final hiringManager =
            Provider.of<HiringManagerDetails>(context, listen: false);
        // Save data to Firestore
        final docRef = await FirebaseFirestore.instance
            .collection('users')
            .doc(loggedInUserId)
            .collection('branches')
            .add({
          'branchName': "Main Branch",
          'firstName': hiringManager.firstName,
          'lastName': hiringManager.lastName,
          'phone': hiringManager.phone,
          'email': hiringManager.email.toLowerCase(),
          'password': hiringManager.password,
          'region': selectedRegion ?? 'not specified',
          'province': selectedProvince ?? 'not specified',
          'city': selectedCity ?? 'not specified',
          'barangay': selectedBarangay ?? 'not specified',
          'zip': '123',
          'house': houseController.text.trim().toCapitalCase(),
          'estDate': formattedDateEstablished, // Use formatted date here
          'created_at': Timestamp.now(),
          'created_by': loggedInUserId,
          'isMain': true,
          'isActive': true,
        });
        String email = hiringManager.email.toLowerCase();
        await FirebaseFirestore.instance.collection('users').doc(email).set({
          'firstName': hiringManager.firstName,
          'lastName': hiringManager.lastName,
          'phone': hiringManager.phone,
          'email': email,
          'password': hiringManager.password,
          'role': 'hiringManager',
          'branchId': docRef.id,
          'created_at': Timestamp.now(),
          'created_by': loggedInUserId,
        });

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const RecruiterHomeScreen(),
          ),
        );
        // print("User credential: ${widget.userCredential.user!.uid}");
      } catch (e) {
        // Handle any errors
        print("Failed to submit company profile: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit company profile: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, sizeInfo) {
      return Scaffold(
        body: Padding(
          padding: EdgeInsets.all(ResponsiveSizes.paddingSmall(sizeInfo)),
          child: Column(
            children: [
              NavBarLoginRegister(),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: sizeInfo.isDesktop
                            ? MediaQuery.of(context).size.width * 0.2
                            : MediaQuery.of(context).size.width * 0.1),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Company Profile",
                                    style: TextStyle(
                                      fontFamily: "Galano",
                                      fontSize: ResponsiveSizes.titleTextSize(
                                          sizeInfo),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    "Please provide the following to complete company profile.",
                                    style: TextStyle(
                                      fontFamily: "Galano",
                                      fontSize:
                                          ResponsiveSizes.subtitleTextSize(
                                              sizeInfo),
                                    ),
                                    softWrap: true,
                                    maxLines: null,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        Text(
                          "Company Name",
                          style: TextStyle(
                            fontSize: ResponsiveSizes.bodyTextSize(sizeInfo),
                            color: Color(0xff373030),
                            fontFamily: 'Galano',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Gap(10),
                        TextFormField(
                          key: companyNameFieldKey,
                          focusNode: companyNameFocusNode,
                          controller: _companyName,
                          decoration: InputDecoration(
                            hintText: "Company Name",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: iscompanyNameValid
                                    ? Color(0xFFD1E1FF)
                                    : Colors
                                        .red, // Normal or red depending on validation
                                width: 1.5,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: iscompanyNameValid
                                    ? Color(0xFFD1E1FF)
                                    : Colors.red, // Red border if invalid
                                width: 1.5,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: iscompanyNameValid
                                    ? Color(0xFFD1E1FF)
                                    : Colors.red, // Red border if invalid
                                width: 1.5,
                              ),
                            ),
                            errorText: iscompanyNameValid
                                ? null
                                : 'Company name is required.', // Display error message if invalid
                          ),
                          onChanged: (value) {
                            setState(() {
                              iscompanyNameValid = value
                                  .trim()
                                  .isNotEmpty; // Set to true if not empty
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Company name is required.'; // Show error message
                            }
                            return null; // No error if valid
                          },
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Chief Executive Officer",
                          style: TextStyle(
                            fontSize: ResponsiveSizes.bodyTextSize(sizeInfo),
                            color: Color(0xff373030),
                            fontFamily: 'Galano',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Gap(10),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextFormField(
                                    key: ceoFirstNameFieldKey,
                                    focusNode: ceoFirstNameFocusNode,
                                    controller: _ceoFirstName,
                                    decoration: InputDecoration(
                                      labelText: "First Name",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                          color: isceoFirstNameValid
                                              ? Color(0xFFD1E1FF)
                                              : Colors
                                                  .red, // Normal or red depending on validation
                                          width: 1.5,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                          color: isceoFirstNameValid
                                              ? Color(0xFFD1E1FF)
                                              : Colors
                                                  .red, // Red border if invalid
                                          width: 1.5,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                          color: isceoFirstNameValid
                                              ? Color(0xFFD1E1FF)
                                              : Colors
                                                  .red, // Red border if invalid
                                          width: 1.5,
                                        ),
                                      ),
                                      errorText: isceoFirstNameValid
                                          ? null
                                          : 'CEO first name is required.', // Display error message if invalid
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        isceoFirstNameValid = value
                                            .trim()
                                            .isNotEmpty; // Set to true if not empty
                                      });
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'CEO first name is required.'; // Show error message
                                      }
                                      return null; // No error if valid
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextFormField(
                                    key: ceoLastNameFieldKey,
                                    focusNode: ceoLastNameFocusNode,
                                    controller: _ceoLastName,
                                    decoration: InputDecoration(
                                      labelText: "Last Name",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                          color: isceoLastNameValid
                                              ? Color(0xFFD1E1FF)
                                              : Colors
                                                  .red, // Normal or red depending on validation
                                          width: 1.5,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                          color: isceoLastNameValid
                                              ? Color(0xFFD1E1FF)
                                              : Colors
                                                  .red, // Red border if invalid
                                          width: 1.5,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                          color: isceoLastNameValid
                                              ? Color(0xFFD1E1FF)
                                              : Colors
                                                  .red, // Red border if invalid
                                          width: 1.5,
                                        ),
                                      ),
                                      errorText: isceoLastNameValid
                                          ? null
                                          : 'CEO last name is required.', // Display error message if invalid
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        isceoLastNameValid = value
                                            .trim()
                                            .isNotEmpty; // Set to true if not empty
                                      });
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'CEO last name is required.'; // Show error message
                                      }
                                      return null; // No error if valid
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        //Headquaters
                        const SizedBox(height: 20),
                        Text(
                          "Headquarters",
                          style: TextStyle(
                            fontSize: ResponsiveSizes.bodyTextSize(sizeInfo),
                            color: Color(0xff373030),
                            fontFamily: 'Galano',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Gap(10),
                        sizeInfo.isMobile
                            ? Column(
                                children: [
                                  Row(
                                    children: [
                                      // Region Dropdown
                                      Expanded(
                                        child: DropDownSearchFormField<String>(
                                          key: regionFieldKey,
                                          hideOnEmpty: true,
                                          hideOnError: true,
                                          hideOnLoading: true,
                                          autoFlipDirection: true,
                                          textFieldConfiguration:
                                              TextFieldConfiguration(
                                            controller: regionController,
                                            focusNode:
                                                regionFocusNode, // Add FocusNode to listen for focus changes
                                            decoration: InputDecoration(
                                              labelText: 'Region',
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                borderSide: const BorderSide(
                                                  color: Color(0xFFD1E1FF),
                                                  width: 1.5,
                                                ),
                                              ),
                                              errorText: isRegionValid
                                                  ? null
                                                  : 'Please select a valid region.', // Show error text if invalid
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                borderSide: const BorderSide(
                                                  color: Color(0xFFD1E1FF),
                                                  width: 1.5,
                                                ),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                borderSide: const BorderSide(
                                                  color: Color(0xFFD1E1FF),
                                                  width: 1.5,
                                                ),
                                              ),
                                            ),
                                            onChanged: (value) {
                                              final formattedRegionName =
                                                  value.trim().toCapitalCase();

                                              String? matchedRegionCode;
                                              for (var region in regions) {
                                                if (region['name']
                                                        .toLowerCase() ==
                                                    formattedRegionName
                                                        .toLowerCase()) {
                                                  matchedRegionCode =
                                                      region['code'];
                                                  break;
                                                }
                                              }

                                              setState(() {
                                                if (matchedRegionCode ==
                                                    '130000000') {
                                                  print("""
DITOOOOOOOOOOOOOOOOOOOOOOOOO ALLEN
DITOOOOOOOOOOOOOOOOOOOOOOOOO ALLEN
DITOOOOOOOOOOOOOOOOOOOOOOOOO ALLEN
DITOOOOOOOOOOOOOOOOOOOOOOOOO ALLEN
DITOOOOOOOOOOOOOOOOOOOOOOOOO ALLEN
DITOOOOOOOOOOOOOOOOOOOOOOOOO ALLEN
DITOOOOOOOOOOOOOOOOOOOOOOOOO ALLEN
""");
                                                  isProvinceVisible = false;
                                                } else {
                                                  isProvinceVisible = true;
                                                }
                                                if (matchedRegionCode != null) {
                                                  regionController.text =
                                                      formattedRegionName;
                                                  selectedRegion =
                                                      formattedRegionName;
                                                  provinceController.clear();
                                                  selectedProvince = null;
                                                  fetchProvincesOrCities(
                                                      matchedRegionCode);
                                                  isRegionValid =
                                                      true; // Set the field as valid
                                                } else {
                                                  selectedRegion = null;
                                                  provinceController.clear();
                                                  selectedProvince = null;
                                                  provinces = [];
                                                  cityController.clear();
                                                  selectedCity = null;
                                                  cities = [];
                                                  barangayController.clear();
                                                  selectedBarangay = null;
                                                  barangays = [];
                                                  isRegionValid = false;
                                                  houseController.clear();
                                                }
                                              });
                                            },
                                            onEditingComplete: () {
                                              // When the user finishes editing, validate the region input
                                              if (selectedRegion == null) {
                                                setState(() {
                                                  isRegionValid =
                                                      false; // If no valid region is selected, mark as invalid
                                                });
                                              }
                                              regionFocusNode
                                                  .unfocus(); // Unfocus the field when editing is complete
                                            },
                                          ),
                                          noItemsFoundBuilder:
                                              (BuildContext context) => Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              'No region found',
                                              style: TextStyle(
                                                fontSize: ResponsiveSizes
                                                    .bodyTextSize(sizeInfo),
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                          suggestionsCallback: (pattern) {
                                            return Future.value(
                                              regions
                                                  .where((region) =>
                                                      region['name']
                                                          .toLowerCase()
                                                          .contains(pattern
                                                              .toLowerCase()
                                                              .trim()))
                                                  .map((region) =>
                                                      region['name']),
                                            );
                                          },
                                          itemBuilder: (context, region) {
                                            return ListTile(
                                              title: Text(region),
                                            );
                                          },
                                          onSuggestionSelected: (regionName) {
                                            setState(() {
                                              selectedRegion = regionName;
                                              regionController.text =
                                                  regionName;
                                              selectedProvince = null;
                                              selectedCity = null;
                                              selectedBarangay = null;
                                              provinces = [];
                                              cities = [];
                                              barangays = [];
                                              isRegionValid =
                                                  true; // Valid region selected
                                            });

                                            final selectedRegionData =
                                                regions.firstWhere(
                                              (region) =>
                                                  region['name'] == regionName,
                                              orElse: () =>
                                                  {'code': '', 'name': ''},
                                            );

                                            setState(() {
                                              if (selectedRegionData['code'] ==
                                                  '130000000') {
                                                print("""
DITOOOOOOOOOOOOOOOOOOOOOOOOO ALLEN
DITOOOOOOOOOOOOOOOOOOOOOOOOO ALLEN
DITOOOOOOOOOOOOOOOOOOOOOOOOO ALLEN
DITOOOOOOOOOOOOOOOOOOOOOOOOO ALLEN
DITOOOOOOOOOOOOOOOOOOOOOOOOO ALLEN
DITOOOOOOOOOOOOOOOOOOOOOOOOO ALLEN
DITOOOOOOOOOOOOOOOOOOOOOOOOO ALLEN
""");
                                                isProvinceVisible = false;
                                              } else {
                                                isProvinceVisible = true;
                                              }
                                            });

                                            if (selectedRegionData['code'] !=
                                                '') {
                                              String regionCode =
                                                  selectedRegionData['code'];
                                              fetchProvincesOrCities(
                                                  regionCode);
                                            }
                                          },
                                          validator: (value) =>
                                              value == null || value.isEmpty
                                                  ? 'Region is required.'
                                                  : null,
                                        ),
                                      ),
                                      if (isProvinceVisible) Gap(20),
                                      if (isProvinceVisible)
                                        Expanded(
                                          child:
                                              DropDownSearchFormField<String>(
                                            key: provinceFieldKey,
                                            textFieldConfiguration:
                                                TextFieldConfiguration(
                                              controller: provinceController,
                                              focusNode:
                                                  provinceFocusNode, // Add FocusNode to track focus changes
                                              enabled: selectedRegion != null,
                                              decoration: InputDecoration(
                                                labelText: 'Province',
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  borderSide: const BorderSide(
                                                    color: Color(0xFFD1E1FF),
                                                    width: 1.5,
                                                  ),
                                                ),
                                                errorText: isProvinceValid
                                                    ? null
                                                    : 'Please select a valid province.', // Show error message if invalid
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  borderSide: const BorderSide(
                                                    color: Color(0xFFD1E1FF),
                                                    width: 1.5,
                                                  ),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  borderSide: const BorderSide(
                                                    color: Color(0xFFD1E1FF),
                                                    width: 1.5,
                                                  ),
                                                ),
                                              ),
                                              onChanged: (value) {
                                                // Trim the input and capitalize each word
                                                final formattedProvinceName =
                                                    value
                                                        .trim()
                                                        .toCapitalCase();

                                                String? matchedProvinceCode;
                                                for (var province
                                                    in provinces) {
                                                  if (province['name']
                                                          .toLowerCase() ==
                                                      formattedProvinceName
                                                          .toLowerCase()) {
                                                    matchedProvinceCode =
                                                        province['code'];
                                                    break;
                                                  }
                                                }

                                                setState(() {
                                                  if (matchedProvinceCode !=
                                                      null) {
                                                    selectedProvince =
                                                        formattedProvinceName;
                                                    provinceController.text =
                                                        formattedProvinceName; // Update the controller's text
                                                    selectedCity =
                                                        null; // Reset city selection
                                                    selectedBarangay =
                                                        null; // Reset barangay selection
                                                    barangays
                                                        .clear(); // Clear barangays list
                                                    fetchCities(
                                                        matchedProvinceCode); // Fetch cities for the matched province
                                                    isProvinceValid =
                                                        true; // Set the field as valid
                                                  } else {
                                                    selectedProvince = null;
                                                    cityController.clear();
                                                    selectedCity = null;
                                                    cities = [];

                                                    barangayController.clear();
                                                    selectedBarangay = null;
                                                    barangays = [];
                                                    isProvinceValid =
                                                        false; // Set the field as invalid

                                                    houseController.clear();
                                                  }
                                                });
                                              },
                                              onEditingComplete: () {
                                                // When the user finishes editing, validate the province input
                                                if (selectedProvince == null) {
                                                  setState(() {
                                                    isProvinceValid =
                                                        false; // If no valid province is selected, mark as invalid
                                                  });
                                                }
                                                provinceFocusNode
                                                    .unfocus(); // Unfocus the field when editing is complete
                                              },
                                            ),
                                            noItemsFoundBuilder:
                                                (BuildContext context) =>
                                                    Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                'No province found',
                                                style: TextStyle(
                                                  fontSize: ResponsiveSizes
                                                      .bodyTextSize(sizeInfo),
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                            suggestionsCallback: (pattern) {
                                              return Future.value(
                                                provinces
                                                    .where((province) =>
                                                        province['name']
                                                            .toLowerCase()
                                                            .contains(pattern
                                                                .toLowerCase()
                                                                .trim()))
                                                    .map((province) =>
                                                        province['name']),
                                              );
                                            },
                                            itemBuilder: (context, province) {
                                              return ListTile(
                                                title: Text(province),
                                              );
                                            },
                                            onSuggestionSelected:
                                                (provinceName) {
                                              // Capitalize the province name input to ensure consistency
                                              String formattedProvinceName =
                                                  provinceName
                                                      .trim()
                                                      .toCapitalCase();

                                              setState(() {
                                                selectedProvince =
                                                    formattedProvinceName;
                                                provinceController.text =
                                                    formattedProvinceName; // Update the controller's text
                                                selectedCity =
                                                    null; // Reset city selection
                                                selectedBarangay =
                                                    null; // Reset barangay selection
                                                barangays
                                                    .clear(); // Clear barangays list
                                                isProvinceValid =
                                                    true; // Valid province selected
                                              });

                                              // Find the selected province's code; consider case-insensitive matching
                                              final selectedProvinceData =
                                                  provinces.firstWhere(
                                                (province) =>
                                                    province['name']
                                                        .toLowerCase() ==
                                                    formattedProvinceName
                                                        .toLowerCase(),
                                                orElse: () =>
                                                    {}, // Provide a fallback if no match is found
                                              );

                                              // Only proceed if a valid province code was found
                                              if (selectedProvinceData
                                                  .isNotEmpty) {
                                                String provinceCode =
                                                    selectedProvinceData[
                                                        'code'];
                                                fetchCities(
                                                    provinceCode); // Fetch cities for the selected province
                                              }
                                            },
                                            validator: (value) =>
                                                value == null || value.isEmpty
                                                    ? 'Province is required.'
                                                    : null,
                                            enabled: selectedRegion !=
                                                null, // Enable only if a region is selected
                                          ),
                                        ),
                                    ],
                                  ),
                                  Gap(10),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: DropDownSearchFormField<String>(
                                          key: cityFieldKey,
                                          textFieldConfiguration:
                                              TextFieldConfiguration(
                                            enabled: selectedProvince != null ||
                                                isProvinceVisible == false,
                                            controller: cityController,
                                            focusNode:
                                                cityFocusNode, // Add FocusNode to track focus changes
                                            decoration: InputDecoration(
                                              labelText: 'City/Municipality',
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                borderSide: const BorderSide(
                                                  color: Color(0xFFD1E1FF),
                                                  width: 1.5,
                                                ),
                                              ),
                                              errorText: isCityValid
                                                  ? null
                                                  : 'Please select a valid city/municipality.', // Show error message if invalid
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                borderSide: const BorderSide(
                                                  color: Color(0xFFD1E1FF),
                                                  width: 1.5,
                                                ),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                borderSide: const BorderSide(
                                                  color: Color(0xFFD1E1FF),
                                                  width: 1.5,
                                                ),
                                              ),
                                            ),
                                            onChanged: (value) {
                                              // Trim the input and capitalize each word
                                              final formattedCityName =
                                                  value.trim().toCapitalCase();

                                              String? matchedCityCode;
                                              for (var city in cities) {
                                                if (city['name']
                                                        .toLowerCase() ==
                                                    formattedCityName
                                                        .toLowerCase()) {
                                                  matchedCityCode =
                                                      city['code'];
                                                  break;
                                                }
                                              }

                                              setState(() {
                                                if (matchedCityCode != null) {
                                                  selectedCity =
                                                      formattedCityName;
                                                  cityController.text =
                                                      formattedCityName; // Update the controller's text
                                                  selectedBarangay =
                                                      null; // Reset barangay selection
                                                  fetchBarangays(
                                                      matchedCityCode); // Fetch barangays for the matched city
                                                  isCityValid =
                                                      true; // Set the field as valid
                                                } else {
                                                  selectedCity = null;
                                                  barangayController.clear();
                                                  selectedBarangay = null;
                                                  barangays = [];
                                                  isCityValid =
                                                      false; // Set the field as invalid

                                                  houseController.clear();
                                                }
                                              });
                                            },
                                            onEditingComplete: () {
                                              // When the user finishes editing, validate the city input
                                              if (selectedCity == null) {
                                                setState(() {
                                                  isCityValid =
                                                      false; // If no valid city is selected, mark as invalid
                                                });
                                              }
                                              cityFocusNode
                                                  .unfocus(); // Unfocus the field when editing is complete
                                            },
                                          ),
                                          noItemsFoundBuilder:
                                              (BuildContext context) => Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              'No city/municipality found',
                                              style: TextStyle(
                                                fontSize: ResponsiveSizes
                                                    .bodyTextSize(sizeInfo),
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                          suggestionsCallback: (pattern) {
                                            return Future.value(
                                              cities
                                                  .where((city) => city['name']
                                                      .toLowerCase()
                                                      .contains(pattern
                                                          .toLowerCase()
                                                          .trim()))
                                                  .map((city) => city['name']),
                                            );
                                          },
                                          itemBuilder: (context, city) {
                                            return ListTile(
                                              title: Text(city),
                                            );
                                          },
                                          onSuggestionSelected: (cityName) {
                                            // Capitalize the city name input to ensure consistency
                                            String formattedCityName =
                                                cityName.trim().toCapitalCase();

                                            setState(() {
                                              selectedCity = formattedCityName;
                                              cityController.text =
                                                  formattedCityName; // Update the controller's text
                                              selectedBarangay =
                                                  null; // Reset barangay selection
                                              isCityValid =
                                                  true; // Valid city selected
                                            });

                                            // Find the selected city's code; consider case-insensitive matching
                                            final selectedCityData =
                                                cities.firstWhere(
                                              (city) =>
                                                  city['name'].toLowerCase() ==
                                                  formattedCityName
                                                      .toLowerCase(),
                                              orElse: () =>
                                                  {}, // Provide a fallback if no match is found
                                            );

                                            // Only proceed if a valid city code was found
                                            if (selectedCityData.isNotEmpty) {
                                              String cityCode =
                                                  selectedCityData['code'];
                                              fetchBarangays(
                                                  cityCode); // Fetch barangays for the selected city
                                            }
                                          },
                                          validator: (value) => value == null ||
                                                  value.isEmpty
                                              ? 'City/Municipality is required.'
                                              : null,
                                          enabled: selectedProvince != null ||
                                              selectedRegion ==
                                                  'NCR', // Enable if province is selected or region is NCR
                                        ),
                                      ),
                                      Gap(20),
                                      Expanded(
                                        child: DropDownSearchFormField<String>(
                                          key: barangayFieldKey,
                                          textFieldConfiguration:
                                              TextFieldConfiguration(
                                            controller: barangayController,
                                            enabled: selectedCity != null,
                                            focusNode:
                                                barangayFocusNode, // Add FocusNode to track focus changes
                                            decoration: InputDecoration(
                                              labelText: 'Barangay',
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                borderSide: const BorderSide(
                                                  color: Color(0xFFD1E1FF),
                                                  width: 1.5,
                                                ),
                                              ),
                                              errorText: isBarangayValid
                                                  ? null
                                                  : 'Please select a valid barangay.', // Show error message if invalid
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                borderSide: const BorderSide(
                                                  color: Color(0xFFD1E1FF),
                                                  width: 1.5,
                                                ),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                borderSide: const BorderSide(
                                                  color: Color(0xFFD1E1FF),
                                                  width: 1.5,
                                                ),
                                              ),
                                            ),
                                            onChanged: (value) {
                                              // Trim the input and capitalize each word
                                              final formattedBarangayName =
                                                  value.trim().toCapitalCase();

                                              // Check if the input matches any barangay
                                              String? matchedBarangayCode;
                                              for (var barangay in barangays) {
                                                if (barangay['name']
                                                        .toLowerCase() ==
                                                    formattedBarangayName
                                                        .toLowerCase()) {
                                                  matchedBarangayCode =
                                                      barangay['code'];
                                                  break;
                                                }
                                              }

                                              setState(() {
                                                if (matchedBarangayCode !=
                                                    null) {
                                                  selectedBarangay =
                                                      formattedBarangayName;
                                                  barangayController.text =
                                                      formattedBarangayName; // Update the controller's text
                                                  isBarangayValid =
                                                      true; // Set the field as valid
                                                } else {
                                                  selectedBarangay =
                                                      null; // Reset barangay selection if no match
                                                  isBarangayValid =
                                                      false; // Set the field as invalid

                                                  houseController.clear();
                                                }
                                              });
                                            },
                                            onEditingComplete: () {
                                              // When the user finishes editing, validate the barangay input
                                              if (selectedBarangay == null) {
                                                setState(() {
                                                  isBarangayValid =
                                                      false; // If no valid barangay is selected, mark as invalid
                                                });
                                              }
                                              barangayFocusNode
                                                  .unfocus(); // Unfocus the field when editing is complete
                                            },
                                          ),
                                          noItemsFoundBuilder:
                                              (BuildContext context) => Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              'No barangay found',
                                              style: TextStyle(
                                                fontSize: ResponsiveSizes
                                                    .bodyTextSize(sizeInfo),
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                          suggestionsCallback: (pattern) {
                                            return Future.value(
                                              barangays
                                                  .where((barangay) =>
                                                      barangay['name']
                                                          .toLowerCase()
                                                          .contains(pattern
                                                              .toLowerCase()
                                                              .trim()))
                                                  .map((barangay) =>
                                                      barangay['name']),
                                            );
                                          },
                                          itemBuilder: (context, barangay) {
                                            return ListTile(
                                              title: Text(barangay),
                                            );
                                          },
                                          onSuggestionSelected: (barangayName) {
                                            // Capitalize the barangay name input to ensure consistency
                                            String formattedBarangayName =
                                                barangayName
                                                    .trim()
                                                    .toCapitalCase();

                                            setState(() {
                                              selectedBarangay =
                                                  formattedBarangayName;
                                              barangayController.text =
                                                  formattedBarangayName; // Update the controller's text
                                              isBarangayValid =
                                                  true; // Valid barangay selected
                                            });

                                            // Find the selected barangay's code; consider case-insensitive matching
                                            final selectedBarangayData =
                                                barangays.firstWhere(
                                              (barangay) =>
                                                  barangay['name']
                                                      .toLowerCase() ==
                                                  formattedBarangayName
                                                      .toLowerCase(),
                                              orElse: () =>
                                                  {}, // Provide a fallback if no match is found
                                            );

                                            // Only proceed if a valid barangay code was found
                                            if (selectedBarangayData
                                                .isNotEmpty) {
                                              String barangayCode =
                                                  selectedBarangayData['code'];
                                              // Do something with the barangay code if needed
                                            }
                                          },
                                          validator: (value) =>
                                              value == null || value.isEmpty
                                                  ? 'Barangay is required.'
                                                  : null,
                                          enabled: selectedCity !=
                                              null, // Enable only if a city is selected
                                        ),
                                      ),
                                    ],
                                  ),
                                  Gap(10),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          key: houseFieldKey,
                                          focusNode: houseFocusNode,
                                          enabled: selectedBarangay !=
                                              null, // Enable only if a barangay is selected
                                          controller: houseController,
                                          decoration: InputDecoration(
                                            labelText:
                                                "Building No./House No., Street, Subdivision/Village",
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              borderSide: BorderSide(
                                                color: isHouseValid
                                                    ? Color(0xFFD1E1FF)
                                                    : Colors
                                                        .red, // Normal or red depending on validation
                                                width: 1.5,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              borderSide: BorderSide(
                                                color: isHouseValid
                                                    ? Color(0xFFD1E1FF)
                                                    : Colors
                                                        .red, // Red border if invalid
                                                width: 1.5,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              borderSide: BorderSide(
                                                color: isHouseValid
                                                    ? Color(0xFFD1E1FF)
                                                    : Colors
                                                        .red, // Red border if invalid
                                                width: 1.5,
                                              ),
                                            ),
                                            errorText: isHouseValid
                                                ? null
                                                : 'Building No./House No., Street, Subdivision/Village are required.', // Display error message if invalid
                                          ),
                                          onChanged: (value) {
                                            setState(() {
                                              isHouseValid = value
                                                  .trim()
                                                  .isNotEmpty; // Set to true if not empty
                                            });
                                          },
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Building No./House No., Street, Subdivision/Village are required.'; // Show error message
                                            }
                                            return null; // No error if valid
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  Row(
                                    children: [
                                      // Region Dropdown
                                      Expanded(
                                        child: DropDownSearchFormField<String>(
                                          key: regionFieldKey,
                                          hideOnEmpty: true,
                                          hideOnError: true,
                                          hideOnLoading: true,
                                          autoFlipDirection: true,
                                          textFieldConfiguration:
                                              TextFieldConfiguration(
                                            controller: regionController,
                                            focusNode:
                                                regionFocusNode, // Add FocusNode to listen for focus changes
                                            decoration: InputDecoration(
                                              labelText: 'Region',
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                borderSide: const BorderSide(
                                                  color: Color(0xFFD1E1FF),
                                                  width: 1.5,
                                                ),
                                              ),
                                              errorText: isRegionValid
                                                  ? null
                                                  : 'Please select a valid region.', // Show error text if invalid
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                borderSide: const BorderSide(
                                                  color: Color(0xFFD1E1FF),
                                                  width: 1.5,
                                                ),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                borderSide: const BorderSide(
                                                  color: Color(0xFFD1E1FF),
                                                  width: 1.5,
                                                ),
                                              ),
                                            ),
                                            onChanged: (value) {
                                              final formattedRegionName =
                                                  value.trim().toCapitalCase();

                                              String? matchedRegionCode;
                                              for (var region in regions) {
                                                if (region['name']
                                                        .toLowerCase() ==
                                                    formattedRegionName
                                                        .toLowerCase()) {
                                                  matchedRegionCode =
                                                      region['code'];
                                                  break;
                                                }
                                              }

                                              setState(() {
                                                if (matchedRegionCode ==
                                                    '130000000') {
                                                  print("""
DITOOOOOOOOOOOOOOOOOOOOOOOOO ALLEN
DITOOOOOOOOOOOOOOOOOOOOOOOOO ALLEN
DITOOOOOOOOOOOOOOOOOOOOOOOOO ALLEN
DITOOOOOOOOOOOOOOOOOOOOOOOOO ALLEN
DITOOOOOOOOOOOOOOOOOOOOOOOOO ALLEN
DITOOOOOOOOOOOOOOOOOOOOOOOOO ALLEN
DITOOOOOOOOOOOOOOOOOOOOOOOOO ALLEN
""");
                                                  isProvinceVisible = false;
                                                } else {
                                                  isProvinceVisible = true;
                                                }
                                                if (matchedRegionCode != null) {
                                                  regionController.text =
                                                      formattedRegionName;
                                                  selectedRegion =
                                                      formattedRegionName;
                                                  provinceController.clear();
                                                  selectedProvince = null;
                                                  fetchProvincesOrCities(
                                                      matchedRegionCode);
                                                  isRegionValid =
                                                      true; // Set the field as valid
                                                } else {
                                                  selectedRegion = null;
                                                  provinceController.clear();
                                                  selectedProvince = null;
                                                  provinces = [];
                                                  cityController.clear();
                                                  selectedCity = null;
                                                  cities = [];
                                                  barangayController.clear();
                                                  selectedBarangay = null;
                                                  barangays = [];
                                                  isRegionValid = false;
                                                  houseController.clear();
                                                }
                                              });
                                            },
                                            onEditingComplete: () {
                                              // When the user finishes editing, validate the region input
                                              if (selectedRegion == null) {
                                                setState(() {
                                                  isRegionValid =
                                                      false; // If no valid region is selected, mark as invalid
                                                });
                                              }
                                              regionFocusNode
                                                  .unfocus(); // Unfocus the field when editing is complete
                                            },
                                          ),
                                          noItemsFoundBuilder:
                                              (BuildContext context) => Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              'No region found',
                                              style: TextStyle(
                                                fontSize: ResponsiveSizes
                                                    .bodyTextSize(sizeInfo),
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                          suggestionsCallback: (pattern) {
                                            return Future.value(
                                              regions
                                                  .where((region) =>
                                                      region['name']
                                                          .toLowerCase()
                                                          .contains(pattern
                                                              .toLowerCase()
                                                              .trim()))
                                                  .map((region) =>
                                                      region['name']),
                                            );
                                          },
                                          itemBuilder: (context, region) {
                                            return ListTile(
                                              title: Text(region),
                                            );
                                          },
                                          onSuggestionSelected: (regionName) {
                                            setState(() {
                                              selectedRegion = regionName;
                                              regionController.text =
                                                  regionName;
                                              selectedProvince = null;
                                              selectedCity = null;
                                              selectedBarangay = null;
                                              provinces = [];
                                              cities = [];
                                              barangays = [];
                                              isRegionValid =
                                                  true; // Valid region selected
                                            });

                                            final selectedRegionData =
                                                regions.firstWhere(
                                              (region) =>
                                                  region['name'] == regionName,
                                              orElse: () =>
                                                  {'code': '', 'name': ''},
                                            );

                                            setState(() {
                                              if (selectedRegionData['code'] ==
                                                  '130000000') {
                                                print("""
DITOOOOOOOOOOOOOOOOOOOOOOOOO ALLEN
DITOOOOOOOOOOOOOOOOOOOOOOOOO ALLEN
DITOOOOOOOOOOOOOOOOOOOOOOOOO ALLEN
DITOOOOOOOOOOOOOOOOOOOOOOOOO ALLEN
DITOOOOOOOOOOOOOOOOOOOOOOOOO ALLEN
DITOOOOOOOOOOOOOOOOOOOOOOOOO ALLEN
DITOOOOOOOOOOOOOOOOOOOOOOOOO ALLEN
""");
                                                isProvinceVisible = false;
                                              } else {
                                                isProvinceVisible = true;
                                              }
                                            });

                                            if (selectedRegionData['code'] !=
                                                '') {
                                              String regionCode =
                                                  selectedRegionData['code'];
                                              fetchProvincesOrCities(
                                                  regionCode);
                                            }
                                          },
                                          validator: (value) =>
                                              value == null || value.isEmpty
                                                  ? 'Region is required.'
                                                  : null,
                                        ),
                                      ),
                                      if (isProvinceVisible) Gap(20),
                                      if (isProvinceVisible)
                                        Expanded(
                                          child:
                                              DropDownSearchFormField<String>(
                                            key: provinceFieldKey,
                                            textFieldConfiguration:
                                                TextFieldConfiguration(
                                              controller: provinceController,
                                              focusNode:
                                                  provinceFocusNode, // Add FocusNode to track focus changes
                                              enabled: selectedRegion != null,
                                              decoration: InputDecoration(
                                                labelText: 'Province',
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  borderSide: const BorderSide(
                                                    color: Color(0xFFD1E1FF),
                                                    width: 1.5,
                                                  ),
                                                ),
                                                errorText: isProvinceValid
                                                    ? null
                                                    : 'Please select a valid province.', // Show error message if invalid
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  borderSide: const BorderSide(
                                                    color: Color(0xFFD1E1FF),
                                                    width: 1.5,
                                                  ),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  borderSide: const BorderSide(
                                                    color: Color(0xFFD1E1FF),
                                                    width: 1.5,
                                                  ),
                                                ),
                                              ),
                                              onChanged: (value) {
                                                // Trim the input and capitalize each word
                                                final formattedProvinceName =
                                                    value
                                                        .trim()
                                                        .toCapitalCase();

                                                String? matchedProvinceCode;
                                                for (var province
                                                    in provinces) {
                                                  if (province['name']
                                                          .toLowerCase() ==
                                                      formattedProvinceName
                                                          .toLowerCase()) {
                                                    matchedProvinceCode =
                                                        province['code'];
                                                    break;
                                                  }
                                                }

                                                setState(() {
                                                  if (matchedProvinceCode !=
                                                      null) {
                                                    selectedProvince =
                                                        formattedProvinceName;
                                                    provinceController.text =
                                                        formattedProvinceName; // Update the controller's text
                                                    selectedCity =
                                                        null; // Reset city selection
                                                    selectedBarangay =
                                                        null; // Reset barangay selection
                                                    barangays
                                                        .clear(); // Clear barangays list
                                                    fetchCities(
                                                        matchedProvinceCode); // Fetch cities for the matched province
                                                    isProvinceValid =
                                                        true; // Set the field as valid
                                                  } else {
                                                    selectedProvince = null;
                                                    cityController.clear();
                                                    selectedCity = null;
                                                    cities = [];

                                                    barangayController.clear();
                                                    selectedBarangay = null;
                                                    barangays = [];
                                                    isProvinceValid =
                                                        false; // Set the field as invalid

                                                    houseController.clear();
                                                  }
                                                });
                                              },
                                              onEditingComplete: () {
                                                // When the user finishes editing, validate the province input
                                                if (selectedProvince == null) {
                                                  setState(() {
                                                    isProvinceValid =
                                                        false; // If no valid province is selected, mark as invalid
                                                  });
                                                }
                                                provinceFocusNode
                                                    .unfocus(); // Unfocus the field when editing is complete
                                              },
                                            ),
                                            noItemsFoundBuilder:
                                                (BuildContext context) =>
                                                    Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                'No province found',
                                                style: TextStyle(
                                                  fontSize: ResponsiveSizes
                                                      .bodyTextSize(sizeInfo),
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                            suggestionsCallback: (pattern) {
                                              return Future.value(
                                                provinces
                                                    .where((province) =>
                                                        province['name']
                                                            .toLowerCase()
                                                            .contains(pattern
                                                                .toLowerCase()
                                                                .trim()))
                                                    .map((province) =>
                                                        province['name']),
                                              );
                                            },
                                            itemBuilder: (context, province) {
                                              return ListTile(
                                                title: Text(province),
                                              );
                                            },
                                            onSuggestionSelected:
                                                (provinceName) {
                                              // Capitalize the province name input to ensure consistency
                                              String formattedProvinceName =
                                                  provinceName
                                                      .trim()
                                                      .toCapitalCase();

                                              setState(() {
                                                selectedProvince =
                                                    formattedProvinceName;
                                                provinceController.text =
                                                    formattedProvinceName; // Update the controller's text
                                                selectedCity =
                                                    null; // Reset city selection
                                                selectedBarangay =
                                                    null; // Reset barangay selection
                                                barangays
                                                    .clear(); // Clear barangays list
                                                isProvinceValid =
                                                    true; // Valid province selected
                                              });

                                              // Find the selected province's code; consider case-insensitive matching
                                              final selectedProvinceData =
                                                  provinces.firstWhere(
                                                (province) =>
                                                    province['name']
                                                        .toLowerCase() ==
                                                    formattedProvinceName
                                                        .toLowerCase(),
                                                orElse: () =>
                                                    {}, // Provide a fallback if no match is found
                                              );

                                              // Only proceed if a valid province code was found
                                              if (selectedProvinceData
                                                  .isNotEmpty) {
                                                String provinceCode =
                                                    selectedProvinceData[
                                                        'code'];
                                                fetchCities(
                                                    provinceCode); // Fetch cities for the selected province
                                              }
                                            },
                                            validator: (value) =>
                                                value == null || value.isEmpty
                                                    ? 'Province is required.'
                                                    : null,
                                            enabled: selectedRegion !=
                                                null, // Enable only if a region is selected
                                          ),
                                        ),
                                      Gap(20),
                                      Expanded(
                                        child: DropDownSearchFormField<String>(
                                          key: cityFieldKey,
                                          textFieldConfiguration:
                                              TextFieldConfiguration(
                                            enabled: selectedProvince != null ||
                                                isProvinceVisible == false,
                                            controller: cityController,
                                            focusNode:
                                                cityFocusNode, // Add FocusNode to track focus changes
                                            decoration: InputDecoration(
                                              labelText: 'City/Municipality',
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                borderSide: const BorderSide(
                                                  color: Color(0xFFD1E1FF),
                                                  width: 1.5,
                                                ),
                                              ),
                                              errorText: isCityValid
                                                  ? null
                                                  : 'Please select a valid city/municipality.', // Show error message if invalid
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                borderSide: const BorderSide(
                                                  color: Color(0xFFD1E1FF),
                                                  width: 1.5,
                                                ),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                borderSide: const BorderSide(
                                                  color: Color(0xFFD1E1FF),
                                                  width: 1.5,
                                                ),
                                              ),
                                            ),
                                            onChanged: (value) {
                                              // Trim the input and capitalize each word
                                              final formattedCityName =
                                                  value.trim().toCapitalCase();

                                              String? matchedCityCode;
                                              for (var city in cities) {
                                                if (city['name']
                                                        .toLowerCase() ==
                                                    formattedCityName
                                                        .toLowerCase()) {
                                                  matchedCityCode =
                                                      city['code'];
                                                  break;
                                                }
                                              }

                                              setState(() {
                                                if (matchedCityCode != null) {
                                                  selectedCity =
                                                      formattedCityName;
                                                  cityController.text =
                                                      formattedCityName; // Update the controller's text
                                                  selectedBarangay =
                                                      null; // Reset barangay selection
                                                  fetchBarangays(
                                                      matchedCityCode); // Fetch barangays for the matched city
                                                  isCityValid =
                                                      true; // Set the field as valid
                                                } else {
                                                  selectedCity = null;
                                                  barangayController.clear();
                                                  selectedBarangay = null;
                                                  barangays = [];
                                                  isCityValid =
                                                      false; // Set the field as invalid

                                                  houseController.clear();
                                                }
                                              });
                                            },
                                            onEditingComplete: () {
                                              // When the user finishes editing, validate the city input
                                              if (selectedCity == null) {
                                                setState(() {
                                                  isCityValid =
                                                      false; // If no valid city is selected, mark as invalid
                                                });
                                              }
                                              cityFocusNode
                                                  .unfocus(); // Unfocus the field when editing is complete
                                            },
                                          ),
                                          noItemsFoundBuilder:
                                              (BuildContext context) => Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              'No city/municipality found',
                                              style: TextStyle(
                                                fontSize: ResponsiveSizes
                                                    .bodyTextSize(sizeInfo),
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                          suggestionsCallback: (pattern) {
                                            return Future.value(
                                              cities
                                                  .where((city) => city['name']
                                                      .toLowerCase()
                                                      .contains(pattern
                                                          .toLowerCase()
                                                          .trim()))
                                                  .map((city) => city['name']),
                                            );
                                          },
                                          itemBuilder: (context, city) {
                                            return ListTile(
                                              title: Text(city),
                                            );
                                          },
                                          onSuggestionSelected: (cityName) {
                                            // Capitalize the city name input to ensure consistency
                                            String formattedCityName =
                                                cityName.trim().toCapitalCase();

                                            setState(() {
                                              selectedCity = formattedCityName;
                                              cityController.text =
                                                  formattedCityName; // Update the controller's text
                                              selectedBarangay =
                                                  null; // Reset barangay selection
                                              isCityValid =
                                                  true; // Valid city selected
                                            });

                                            // Find the selected city's code; consider case-insensitive matching
                                            final selectedCityData =
                                                cities.firstWhere(
                                              (city) =>
                                                  city['name'].toLowerCase() ==
                                                  formattedCityName
                                                      .toLowerCase(),
                                              orElse: () =>
                                                  {}, // Provide a fallback if no match is found
                                            );

                                            // Only proceed if a valid city code was found
                                            if (selectedCityData.isNotEmpty) {
                                              String cityCode =
                                                  selectedCityData['code'];
                                              fetchBarangays(
                                                  cityCode); // Fetch barangays for the selected city
                                            }
                                          },
                                          validator: (value) => value == null ||
                                                  value.isEmpty
                                              ? 'City/Municipality is required.'
                                              : null,
                                          enabled: selectedProvince != null ||
                                              selectedRegion ==
                                                  'NCR', // Enable if province is selected or region is NCR
                                        ),
                                      ),
                                    ],
                                  ),
                                  Gap(10),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: DropDownSearchFormField<String>(
                                          key: barangayFieldKey,
                                          textFieldConfiguration:
                                              TextFieldConfiguration(
                                            controller: barangayController,
                                            enabled: selectedCity != null,
                                            focusNode:
                                                barangayFocusNode, // Add FocusNode to track focus changes
                                            decoration: InputDecoration(
                                              labelText: 'Barangay',
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                borderSide: const BorderSide(
                                                  color: Color(0xFFD1E1FF),
                                                  width: 1.5,
                                                ),
                                              ),
                                              errorText: isBarangayValid
                                                  ? null
                                                  : 'Please select a valid barangay.', // Show error message if invalid
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                borderSide: const BorderSide(
                                                  color: Color(0xFFD1E1FF),
                                                  width: 1.5,
                                                ),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                borderSide: const BorderSide(
                                                  color: Color(0xFFD1E1FF),
                                                  width: 1.5,
                                                ),
                                              ),
                                            ),
                                            onChanged: (value) {
                                              // Trim the input and capitalize each word
                                              final formattedBarangayName =
                                                  value.trim().toCapitalCase();

                                              // Check if the input matches any barangay
                                              String? matchedBarangayCode;
                                              for (var barangay in barangays) {
                                                if (barangay['name']
                                                        .toLowerCase() ==
                                                    formattedBarangayName
                                                        .toLowerCase()) {
                                                  matchedBarangayCode =
                                                      barangay['code'];
                                                  break;
                                                }
                                              }

                                              setState(() {
                                                if (matchedBarangayCode !=
                                                    null) {
                                                  selectedBarangay =
                                                      formattedBarangayName;
                                                  barangayController.text =
                                                      formattedBarangayName; // Update the controller's text
                                                  isBarangayValid =
                                                      true; // Set the field as valid
                                                } else {
                                                  selectedBarangay =
                                                      null; // Reset barangay selection if no match
                                                  isBarangayValid =
                                                      false; // Set the field as invalid

                                                  houseController.clear();
                                                }
                                              });
                                            },
                                            onEditingComplete: () {
                                              // When the user finishes editing, validate the barangay input
                                              if (selectedBarangay == null) {
                                                setState(() {
                                                  isBarangayValid =
                                                      false; // If no valid barangay is selected, mark as invalid
                                                });
                                              }
                                              barangayFocusNode
                                                  .unfocus(); // Unfocus the field when editing is complete
                                            },
                                          ),
                                          noItemsFoundBuilder:
                                              (BuildContext context) => Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              'No barangay found',
                                              style: TextStyle(
                                                fontSize: ResponsiveSizes
                                                    .bodyTextSize(sizeInfo),
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                          suggestionsCallback: (pattern) {
                                            return Future.value(
                                              barangays
                                                  .where((barangay) =>
                                                      barangay['name']
                                                          .toLowerCase()
                                                          .contains(pattern
                                                              .toLowerCase()
                                                              .trim()))
                                                  .map((barangay) =>
                                                      barangay['name']),
                                            );
                                          },
                                          itemBuilder: (context, barangay) {
                                            return ListTile(
                                              title: Text(barangay),
                                            );
                                          },
                                          onSuggestionSelected: (barangayName) {
                                            // Capitalize the barangay name input to ensure consistency
                                            String formattedBarangayName =
                                                barangayName
                                                    .trim()
                                                    .toCapitalCase();

                                            setState(() {
                                              selectedBarangay =
                                                  formattedBarangayName;
                                              barangayController.text =
                                                  formattedBarangayName; // Update the controller's text
                                              isBarangayValid =
                                                  true; // Valid barangay selected
                                            });

                                            // Find the selected barangay's code; consider case-insensitive matching
                                            final selectedBarangayData =
                                                barangays.firstWhere(
                                              (barangay) =>
                                                  barangay['name']
                                                      .toLowerCase() ==
                                                  formattedBarangayName
                                                      .toLowerCase(),
                                              orElse: () =>
                                                  {}, // Provide a fallback if no match is found
                                            );

                                            // Only proceed if a valid barangay code was found
                                            if (selectedBarangayData
                                                .isNotEmpty) {
                                              String barangayCode =
                                                  selectedBarangayData['code'];
                                              // Do something with the barangay code if needed
                                            }
                                          },
                                          validator: (value) =>
                                              value == null || value.isEmpty
                                                  ? 'Barangay is required.'
                                                  : null,
                                          enabled: selectedCity !=
                                              null, // Enable only if a city is selected
                                        ),
                                      ),
                                      Gap(20),
                                      Expanded(
                                        child: TextFormField(
                                          key: houseFieldKey,
                                          focusNode: houseFocusNode,
                                          enabled: selectedBarangay !=
                                              null, // Enable only if a barangay is selected
                                          controller: houseController,
                                          decoration: InputDecoration(
                                            labelText:
                                                "Building No./House No., Street, Subdivision/Village",
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              borderSide: BorderSide(
                                                color: isHouseValid
                                                    ? Color(0xFFD1E1FF)
                                                    : Colors
                                                        .red, // Normal or red depending on validation
                                                width: 1.5,
                                              ),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              borderSide: BorderSide(
                                                color: isHouseValid
                                                    ? Color(0xFFD1E1FF)
                                                    : Colors
                                                        .red, // Red border if invalid
                                                width: 1.5,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              borderSide: BorderSide(
                                                color: isHouseValid
                                                    ? Color(0xFFD1E1FF)
                                                    : Colors
                                                        .red, // Red border if invalid
                                                width: 1.5,
                                              ),
                                            ),
                                            errorText: isHouseValid
                                                ? null
                                                : 'Building No./House No., Street, Subdivision/Village are required.', // Display error message if invalid
                                          ),
                                          onChanged: (value) {
                                            setState(() {
                                              isHouseValid = value
                                                  .trim()
                                                  .isNotEmpty; // Set to true if not empty
                                            });
                                          },
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Building No./House No., Street, Subdivision/Village are required.'; // Show error message
                                            }
                                            return null; // No error if valid
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                        Gap(20),
                        // Text(
                        //   "Industry",
                        //   style: TextStyle(
                        //     fontSize: ResponsiveSizes.bodyTextSize(sizeInfo),
                        //     color: Color(0xff373030),
                        //     fontFamily: 'Galano',
                        //     fontWeight: FontWeight.w500,
                        //   ),
                        // ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // DropdownButtonFormField<String>(
                            //   key: industryFieldKey,
                            //   focusNode: industryFocusNode,
                            //   isExpanded: true,
                            //   hint: const Text('Select an industry'),
                            //   value: _selectedIndustry,
                            //   items: _industries.map<DropdownMenuItem<String>>(
                            //       (String industry) {
                            //     return DropdownMenuItem<String>(
                            //       value: industry,
                            //       child: Text(industry),
                            //     );
                            //   }).toList(),
                            //   onChanged: (String? newValue) {
                            //     setState(() {
                            //       _selectedIndustry = newValue;
                            //     });
                            //   },
                            //   validator: (value) {
                            //     if (value == null || value.isEmpty) {
                            //       return 'Industry is required.';
                            //     }
                            //     return null;
                            //   },
                            // ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Industry",
                                  style: TextStyle(
                                    fontSize:
                                        ResponsiveSizes.bodyTextSize(sizeInfo),
                                    color: Color(0xff373030),
                                    fontFamily: 'Galano',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            Gap(10),
                            DropDownSearchFormField<String>(
                              key: industryFieldKey,
                              hideOnEmpty: true,
                              hideOnError: true,
                              hideOnLoading: true,
                              autoFlipDirection: true,
                              textFieldConfiguration: TextFieldConfiguration(
                                controller: industryController,
                                focusNode: industryFocusNode,
                                decoration: InputDecoration(
                                  labelText: 'Select Industry',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      color: Color(0xFFD1E1FF),
                                      width: 1.5,
                                    ),
                                  ),
                                  errorText: isindustryValid
                                      ? null
                                      : 'Please select an industry from the list only.', // Show error text if invalid
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      color: Color(0xFFD1E1FF),
                                      width: 1.5,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      color: Color(0xFFD1E1FF),
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                                onChanged: (value) {
                                  final formattedIndustryName =
                                      value.trim().toCapitalCase();

                                  String? matchedIndustry;
                                  for (var industry in _industries) {
                                    if (industry.toLowerCase() ==
                                        formattedIndustryName.toLowerCase()) {
                                      matchedIndustry = industry;
                                      break;
                                    }
                                  }

                                  setState(() {
                                    if (matchedIndustry != null) {
                                      industryController.text =
                                          formattedIndustryName;
                                      _selectedIndustry = formattedIndustryName;
                                      isindustryValid = true;
                                    } else {
                                      isindustryValid = false;
                                    }
                                  });
                                },
                                onEditingComplete: () {
                                  // When the user finishes editing, validate the region input
                                  if (_selectedIndustry == null) {
                                    setState(() {
                                      isindustryValid =
                                          false; // If no valid region is selected, mark as invalid
                                    });
                                  }
                                  industryFocusNode
                                      .unfocus(); // Unfocus the field when editing is complete
                                },
                              ),
                              noItemsFoundBuilder: (BuildContext context) =>
                                  Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'No such industry found',
                                  style: TextStyle(
                                    fontSize:
                                        ResponsiveSizes.bodyTextSize(sizeInfo),
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              suggestionsCallback: (pattern) {
                                return Future.value(
                                  _industries
                                      .where((industry) => industry
                                          .toLowerCase()
                                          .contains(
                                              pattern.toLowerCase().trim()))
                                      .toList(),
                                );
                              },
                              itemBuilder: (context, industry) {
                                return ListTile(
                                  title: Text(industry),
                                );
                              },
                              onSuggestionSelected: (industry) {
                                setState(() {
                                  _selectedIndustry = industry;
                                  industryController.text = industry;
                                  isindustryValid = true;
                                });
                              },
                              validator: (value) =>
                                  value == null || value.isEmpty
                                      ? 'Industry is required.'
                                      : null,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Size",
                          style: TextStyle(
                            fontSize: ResponsiveSizes.bodyTextSize(sizeInfo),
                            color: Color(0xff373030),
                            fontFamily: 'Galano',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Gap(10),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            DropdownButtonFormField<String>(
                              key: sizeFieldKey,
                              focusNode: sizeFocusNode,
                              isExpanded: true,
                              value: _selectedSizeOfCompany ?? sizeOfCompany[0],
                              items: sizeOfCompany
                                  .map<DropdownMenuItem<String>>((String size) {
                                return DropdownMenuItem<String>(
                                  value: size,
                                  child: Text(size),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedSizeOfCompany = newValue;
                                  FocusScope.of(context).unfocus();
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Size is required.';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                // labelText: 'Select size',
                                labelStyle: TextStyle(color: Colors.grey),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 16),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: Color(0xFFD1E1FF),
                                    width: 1.5,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: Color(0xFFD1E1FF),
                                    width: 2,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: Color(0xFF3F51B5),
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Description",
                                  style: TextStyle(
                                    fontSize:
                                        ResponsiveSizes.bodyTextSize(sizeInfo),
                                    color: Color(0xff373030),
                                    fontFamily: 'Galano',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  "Introduce your company to people in few lines.",
                                  style: TextStyle(
                                    fontSize:
                                        ResponsiveSizes.noteTextSize(sizeInfo),
                                    color: Color(0xff373030),
                                    fontFamily: 'Galano',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Gap(20),
                        TextFormField(
                          key: descriptionFieldKey,
                          focusNode: descriptionFocusNode,
                          controller: _description,
                          maxLines: 7,
                          style: TextStyle(
                            fontSize: ResponsiveSizes.bodyTextSize(sizeInfo),
                            fontFamily: "Galano",
                          ),
                          decoration: InputDecoration(
                            hintText:
                                "Present your company by communicating your business, your market position, your company culture, etc.",
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: ResponsiveSizes.bodyTextSize(sizeInfo),
                              fontFamily: "Galano",
                              fontWeight: FontWeight.w100,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: isdescriptionValid
                                    ? Color(0xFFD1E1FF)
                                    : Colors
                                        .red, // Change border color based on validation
                                width: 1.5,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: isdescriptionValid
                                    ? Color(0xFFD1E1FF)
                                    : Colors.red, // Red border if invalid
                                width: 1.5,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: isdescriptionValid
                                    ? Color(0xFFD1E1FF)
                                    : Colors.red, // Red border if invalid
                                width: 1.5,
                              ),
                            ),
                            errorText: isdescriptionValid
                                ? null
                                : 'Description is required.', // Display error message if invalid
                          ),
                          onChanged: (value) {
                            setState(() {
                              isdescriptionValid = value.trim().isNotEmpty;
                            });
                          },
                          validator: (value) {
                            final wordCount = value?.trim().isEmpty == true
                                ? 0
                                : value!.trim().split(RegExp(r'\s+')).length;
                            if (wordCount < 100) {
                              return 'At least 100 words are required.'; // Show error message
                            }
                            return null; // No error if valid
                          },
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Company's website (optional)",
                          style: TextStyle(
                            fontSize: ResponsiveSizes.bodyTextSize(sizeInfo),
                            color: const Color(0xff373030),
                            fontFamily: 'Galano',
                            fontWeight: FontWeight.w100,
                          ),
                        ),
                        Gap(10),
                        TextFormField(
                          key: websiteKey,
                          controller: _companyWebsite,
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: "Galano",
                          ),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
                            hintStyle: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontFamily: "Galano",
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color(0xFFD1E1FF),
                                width: 1.5,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color(0xFFD1E1FF),
                                width: 1.5,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color(0xFFD1E1FF),
                                width: 1.5,
                              ),
                            ),
                          ),
                          // validator: (value) {
                          //   if (value!.isEmpty || value == null) {
                          //     return "Last name is required.";
                          //   }
                          // },
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Company's Social Media Links (optional)",
                          style: TextStyle(
                            fontSize: ResponsiveSizes.bodyTextSize(sizeInfo),
                            color: Color(0xff373030),
                            fontFamily: 'Galano',
                            fontWeight: FontWeight.w100,
                          ),
                        ),
                        Gap(10),
                        TextFormField(
                          key: socialMediaKey,
                          controller: _socialMediaLinks,
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: "Galano",
                          ),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
                            hintStyle: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontFamily: "Galano",
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color(0xFFD1E1FF),
                                width: 1.5,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color(0xFFD1E1FF),
                                width: 1.5,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color(0xFFD1E1FF),
                                width: 1.5,
                              ),
                            ), // Display error message if invalid
                          ),
                          // validator: (value) {
                          //   if (value!.isEmpty || value == null) {
                          //     return "Last name is required.";
                          //   }
                          // },
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Verify with document helps us confirm you work for a real business",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xff373030),
                            fontFamily: 'Galano',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (isFileNamesEmpty)
                          const Text(
                            "Business document is required.",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.red,
                              fontFamily: 'Galano',
                            ),
                          ),
                        const SizedBox(height: 10),
                        const Text(
                          "Some acceptable documents include:",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xff373030),
                            fontFamily: 'Galano',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        ListView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: businessDocs
                              .map(
                                (item) => Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      '• ',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    Expanded(
                                      child: Text(
                                        item,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              .toList(),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: 150,
                          width: MediaQuery.of(context).size.width * 0.8,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.blueAccent,
                                style: BorderStyle.solid,
                                width: 2),
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.grey[200],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.upload_file,
                                  size: 40, color: Colors.blueAccent),
                              const Text("Upload your files here"),
                              GestureDetector(
                                onTap: _pickFile,
                                child: const Text(
                                  "Select a file",
                                  style: TextStyle(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline),
                                ),
                              ),
                              SizedBox(height: 10),
                              // Display selected or dropped files
                            ],
                          ),
                        ),
                        if (pickedFiles
                            .isNotEmpty) // Check if there are picked files
                          SizedBox(
                            height: containerHeight,
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Column(
                              children: [
                                const SizedBox(height: 10),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: pickedFiles
                                        .length, // Use pickedFiles.length
                                    itemBuilder: (context, index) {
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            pickedFiles[index]
                                                .name, // Display file name
                                            style:
                                                const TextStyle(fontSize: 16),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              setState(() {
                                                // Remove the file from pickedFiles and update containerHeight
                                                containerHeight -=
                                                    15; // Adjust height accordingly
                                                pickedFiles.removeAt(index);
                                              });
                                            },
                                            icon: const Icon(Icons.close),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // DragTarget<PlatformFile>(
                        //   onAccept: (file) => _onDropFile(
                        //       file), // Expecting a single PlatformFile
                        //   builder: (context, candidateData, rejectedData) {
                        //     return Container(
                        //       height: 150,
                        //       width: 300,
                        //       decoration: BoxDecoration(
                        //         border: Border.all(
                        //             color: Colors.blueAccent,
                        //             style: BorderStyle.solid,
                        //             width: 2),
                        //         borderRadius: BorderRadius.circular(12),
                        //         color: Colors.grey[200],
                        //       ),
                        //       child: Column(
                        //         mainAxisAlignment: MainAxisAlignment.center,
                        //         children: [
                        //           Icon(Icons.upload_file,
                        //               size: 40, color: Colors.blueAccent),
                        //           GestureDetector(
                        //             onTap: _pickFile,
                        //             child: Text(
                        //               "Select a file",
                        //               style: TextStyle(
                        //                   color: Colors.blue,
                        //                   decoration: TextDecoration.underline),
                        //             ),
                        //           ),
                        //           SizedBox(height: 10),
                        //           // Display selected or dropped files
                        //           if (fileNames.isNotEmpty)
                        //             Expanded(
                        //               child: ListView.builder(
                        //                 itemCount: fileNames.length,
                        //                 itemBuilder: (context, index) {
                        //                   return Text(fileNames[index],
                        //                       style: TextStyle(fontSize: 16));
                        //                 },
                        //               ),
                        //             ),
                        //         ],
                        //       ),
                        //     );
                        //   },
                        // ),
                        sizeInfo.isMobile
                            ? SizedBox(height: 20)
                            : SizedBox(height: 30),
                        sizeInfo.isMobile
                            ? Row(
                                children: [
                                  Expanded(
                                    child: BlueFilledCircleButton(
                                        onPressed: () {
                                          submitCompanyProfileForm();
                                        },
                                        text: "Submit"),
                                  ),
                                ],
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  BlueFilledCircleButton(
                                    onPressed: () {
                                      submitCompanyProfileForm();
                                    },
                                    text: "Submit",
                                    width: 150,
                                  ),
                                ],
                              ),
                        sizeInfo.isMobile
                            ? SizedBox(height: 20)
                            : SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
