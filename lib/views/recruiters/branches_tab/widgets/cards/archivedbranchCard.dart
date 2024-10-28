import 'package:change_case/change_case.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drop_down_search_field/drop_down_search_field.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/responsive_sizes.dart';
import 'package:huzzl_web/user-provider.dart';
import 'package:huzzl_web/views/recruiters/branches_tab/branch-manager-staff-model.dart';
import 'package:huzzl_web/views/recruiters/branches_tab/branch-provider.dart';
import 'package:huzzl_web/views/recruiters/branches_tab/widgets/dialogs/confirmCancelAddingBranch.dart';
import 'package:huzzl_web/views/recruiters/branches_tab/widgets/searchmanager.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/tab-bars/application_screen.dart';
import 'package:huzzl_web/views/recruiters/home/00%20home.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ArchiveBranchCard extends StatefulWidget {
  final Branch branch;

  const ArchiveBranchCard({Key? key, required this.branch}) : super(key: key);

  @override
  State<ArchiveBranchCard> createState() => _ArchiveBranchCardState();
}

class _ArchiveBranchCardState extends State<ArchiveBranchCard> {
  bool _isHovered = false;

  bool isProvinceVisible = true;
  final branchNameController = TextEditingController();

  bool isEmailVerified = false;

  FocusNode regionFocusNode = FocusNode();
  FocusNode provinceFocusNode = FocusNode();
  FocusNode cityFocusNode = FocusNode();
  FocusNode barangayFocusNode = FocusNode();
  FocusNode zipFocusNode = FocusNode();
  FocusNode houseFocusNode = FocusNode();

  final regionFieldKey = GlobalKey<FormFieldState>();
  final provinceFieldKey = GlobalKey<FormFieldState>();
  final cityFieldKey = GlobalKey<FormFieldState>();
  final barangayFieldKey = GlobalKey<FormFieldState>();
  final zipFieldKey = GlobalKey<FormFieldState>();
  final houseFieldKey = GlobalKey<FormFieldState>();

  final GlobalKey<FormState> addOneBranchFieldKey = GlobalKey<FormState>();

  bool isRegionValid = true;
  bool isProvinceValid = true;
  bool isCityValid = true;
  bool isBarangayValid = true;
  bool isZipValid = true;
  bool isHouseValid = true;

  bool isbranchNameValid = true;

  TextEditingController regionController = TextEditingController();
  TextEditingController provinceController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController barangayController = TextEditingController();
  TextEditingController zipController = TextEditingController();
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
  TextEditingController estdateController = TextEditingController();
  DateTime? selectedestDate;

  @override
  void initState() {
    super.initState();

    ControllerManager().searchManagerController.addListener(() {
      setState(() {});
    });
    fetchRegions();
    regionFocusNode = FocusNode();
    provinceFocusNode = FocusNode();
    cityFocusNode = FocusNode();
    barangayFocusNode = FocusNode();
    zipFocusNode = FocusNode();
    houseFocusNode = FocusNode();
    branchNameController.text = widget.branch.branchName;
    regionController.text = widget.branch.region;
    provinceController.text = widget.branch.province;
    cityController.text = widget.branch.city;
    barangayController.text = widget.branch.barangay;
    zipController.text = widget.branch.zip;
    houseController.text = widget.branch.house;
    estdateController.text = widget.branch.estDate;
    selectedestDate = DateFormat("MMMM dd, yyyy").parse(widget.branch.estDate);

    isRegionValid = true;
    isProvinceValid = true;
    isCityValid = true;
    isBarangayValid = true;
    isZipValid = true;
    isHouseValid = true;

    isbranchNameValid = true;
    selectedRegion = widget.branch.region;
    selectedProvince = widget.branch.province;
    selectedCity = widget.branch.city;
    selectedBarangay = widget.branch.barangay;
  }

  @override
  void dispose() {
    estdateController.dispose();
    regionFocusNode.dispose();
    provinceFocusNode.dispose();
    cityFocusNode.dispose();
    barangayFocusNode.dispose();
    zipFocusNode.dispose();
    houseFocusNode.dispose();
    //  ControllerManager().searchManagerController.dispose();

    super.dispose();
  }

  void saveBranchChanges(String loggedInUserId) async {
    final isValidAll = addOneBranchFieldKey.currentState!.validate();
    final isValidRegion = regionFieldKey.currentState!.validate();
    bool isValidProvince = true;
    if (isProvinceVisible) {
      isValidProvince = provinceFieldKey.currentState!.validate();
    } else {
      provinceController.text = "Metro Manila";
      setState(() {
        selectedProvince = "Metro Manila";
      });
      isValidProvince = true;
    }
    final isValidCity = cityFieldKey.currentState!.validate();
    final isValidBarangay = barangayFieldKey.currentState!.validate();
    final isValidHouse = houseFieldKey.currentState!.validate();
    final isValidZip = zipFieldKey.currentState!.validate();
    bool isValid = isValidAll &&
        isValidRegion &&
        isValidProvince &&
        isValidCity &&
        isValidBarangay &&
        isValidHouse &&
        isValidZip;

    if (!isValid) {
      print("Validation failed: One or more fields are invalid.");
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
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
                  "Confirm Update",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Are you sure to update ${branchNameController.text}?",
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  "This will overwrite the current information.",
                  style: TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () =>
                          Navigator.pop(context), // Close the dialog
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 8),
                        backgroundColor:
                            const Color.fromARGB(255, 180, 180, 180),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 10),
                    TextButton(
                      onPressed: () async {
                        String formattedEstDate = DateFormat('MMMM dd, yyyy')
                            .format(selectedestDate!);

                        try {
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(loggedInUserId)
                              .collection('branches')
                              .doc(widget.branch.id)
                              .update({
                            'branchName': branchNameController.text.trim(),
                            'region': regionController.text.trim(),
                            'province': provinceController.text.trim(),
                            'city': cityController.text.trim(),
                            'barangay': barangayController.text.trim(),
                            'zip': zipController.text.trim(),
                            'house': houseController.text.trim(),
                            'last_updated_at': Timestamp.now(),
                            'last_updated_by': loggedInUserId,
                            'estDate': formattedEstDate,
                          });

                          print("Branch updated: ${widget.branch.id}");

                          EasyLoading.instance
                            ..displayDuration =
                                const Duration(milliseconds: 1500)
                            ..indicatorType =
                                EasyLoadingIndicatorType.fadingCircle
                            ..loadingStyle = EasyLoadingStyle.custom
                            ..backgroundColor = Color.fromARGB(255, 31, 150, 61)
                            ..textColor = Colors.white
                            ..fontSize = 16.0
                            ..indicatorColor = Colors.white
                            ..maskColor = Colors.black.withOpacity(0.5)
                            ..userInteractions = false
                            ..dismissOnTap = true;
                          EasyLoading.showToast(
                            "${branchNameController.text.trim()} is successfully updated!",
                            dismissOnTap: true,
                            toastPosition: EasyLoadingToastPosition.top,
                            duration: Duration(seconds: 3),
                          );

                          Provider.of<BranchProvider>(context, listen: false)
                              .searchArchiveBranch(
                                  branchNameController.text.trim(),
                                  loggedInUserId)
                              .then((_) {
                            print("Branches fetched successfully.");
                          }).catchError((e) {
                            print("Error fetching branches: $e");
                          });
                          Navigator.pop(context);
                          Navigator.pop(context);

                          ControllerManager().searchManagerController.text =
                              branchNameController.text.trim();
                        } catch (e) {
                          print("Error update branch: $e");
                        }
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 8),
                        backgroundColor: const Color(0xFF3b7dff),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Yes, save changes',
                        style: TextStyle(color: Colors.white),
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
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedestDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        selectedestDate = picked;
        estdateController.text = DateFormat('MMMM dd, yyyy')
            .format(picked); // Update text when date is picked
      });
    }
  }

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
// Fetch provinces or cities based on region code
  Future<void> fetchProvincesOrCities(String regionCode) async {
    try {
      setState(() {
        // Reset the state before fetching
        provinces = [];
        cities = [];
        selectedProvince = null;
        selectedCity = null;
        barangays = [];
        selectedBarangay = null;
      });

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
            // Reset selections after fetching
            selectedProvince = null;
            cities = []; // Clear previous cities
            selectedCity = null;
            barangays = [];
            selectedBarangay = null;
          });
        } else {
          throw Exception('Failed to load provinces');
        }
      }
    } catch (e) {
      // Handle any errors during the fetch
      print('Error fetching provinces or cities: $e');
      // Optionally, show a message to the user
    }
  }

// Fetch cities directly for regions like NCR
  Future<void> fetchCitiesForRegion(String regionCode) async {
    try {
      final response = await http.get(Uri.parse(
          'https://psgc.gitlab.io/api/regions/$regionCode/cities-municipalities/'));
      if (response.statusCode == 200) {
        setState(() {
          cities = List<Map<String, dynamic>>.from(jsonDecode(response.body));
          // Reset selections after fetching
          selectedCity = null; // Reset city
          selectedBarangay = null; // Reset barangay
          barangays = []; // Reset barangays
        });
      } else {
        throw Exception('Failed to load cities for NCR');
      }
    } catch (e) {
      print('Error fetching cities for NCR: $e');
    }
  }

// Fetch cities by province code
  Future<void> fetchCities(String provinceCode) async {
    try {
      final response = await http.get(Uri.parse(
          'https://psgc.gitlab.io/api/provinces/$provinceCode/cities-municipalities/'));
      if (response.statusCode == 200) {
        setState(() {
          cities = List<Map<String, dynamic>>.from(jsonDecode(response.body));
          // Reset selections after fetching
          selectedCity = null; // Reset city
          selectedBarangay = null; // Reset barangay
          barangays = []; // Clear barangays
        });
      } else {
        throw Exception('Failed to load cities for province');
      }
    } catch (e) {
      print('Error fetching cities for province: $e');
    }
  }

// Fetch barangays by city/municipality code
  Future<void> fetchBarangays(String cityCode) async {
    try {
      final response = await http.get(Uri.parse(
          'https://psgc.gitlab.io/api/cities-municipalities/$cityCode/barangays/'));
      if (response.statusCode == 200) {
        setState(() {
          barangays =
              List<Map<String, dynamic>>.from(jsonDecode(response.body));
          selectedBarangay = null; // Reset barangay
        });
      } else {
        throw Exception('Failed to load barangays');
      }
    } catch (e) {
      print('Error fetching barangays: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final loggedInUserId = Provider.of<UserProvider>(context).loggedInUserId;
    return ResponsiveBuilder(builder: (context, sizeInfo) {
      return MouseRegion(
        onEnter: (_) {
          setState(() {
            _isHovered = true;
          });
        },
        onExit: (_) {
          setState(() {
            _isHovered = false;
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 100),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: _isHovered
                    ? Color.fromARGB(17, 121, 121, 121)
                    : Colors.transparent,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                // Change Row to Column for proper wrapping
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Align items to the start
                children: [
                  Text(
                    "${widget.branch.branchName}",
                    style: TextStyle(
                      fontFamily: 'Galano',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  widget.branch.isMain
                      ? Text(
                          "Main Branch",
                          style: TextStyle(
                            fontSize: 14,
                            color: const Color.fromARGB(255, 18, 129, 21),
                            fontWeight: FontWeight.w700,
                          ),
                        )
                      : SizedBox(),
                  SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment
                        .start, // Align icons and text at the top
                    children: [
                      Icon(Icons.location_on, size: 16, color: Colors.grey),
                      SizedBox(width: 4),
                      Expanded(
                        // Use Expanded to allow wrapping
                        child: Text(
                          "${widget.branch.house} ${widget.branch.barangay}, ${widget.branch.city} ${widget.branch.zip}, ${widget.branch.province}, ${widget.branch.region}",
                          style: TextStyle(
                            fontFamily: 'Galano',
                            color: Colors.grey.shade500,
                            fontSize: 14,
                          ),
                          softWrap: true, // Ensure text wraps if needed
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment
                        .start, // Align icons and text at the top
                    children: [
                      Icon(Icons.date_range_rounded,
                          size: 16, color: Colors.grey),
                      SizedBox(width: 4),
                      Text(
                        'Est. ',
                        style: TextStyle(
                          fontFamily: 'Galano',
                          color: Colors.grey.shade500,
                          fontSize: 14,
                        ),
                      ),
                      Expanded(
                        // Use Expanded to allow wrapping
                        child: Text(
                          widget.branch.estDate,
                          style: TextStyle(
                            fontFamily: 'Galano',
                            color: Colors.grey.shade500,
                            fontSize: 14,
                          ),
                          softWrap: true, // Ensure text wraps if needed
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: Icon(
                  Icons.more_vert,
                  size: 20,
                  color: Colors.grey,
                ),
                onPressed: () async {
                  final RenderBox button =
                      context.findRenderObject() as RenderBox;
                  final RenderBox overlay = Overlay.of(context)
                      .context
                      .findRenderObject() as RenderBox;

                  final position =
                      button.localToGlobal(Offset.zero, ancestor: overlay);

                  await showMenu(
                    context: context,
                    position: RelativeRect.fromLTRB(
                      position.dx,
                      position.dy,
                      overlay.size.width - position.dx - button.size.width,
                      overlay.size.height - position.dy,
                    ),
                    items: [
                      PopupMenuItem(
                        value: 'edit_branch',
                        child: Row(
                          children: [
                            Icon(Icons.edit, color: Colors.grey),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'reactivate_branch',
                        child: Row(
                          children: [
                            Icon(Icons.archive_rounded, color: Colors.grey),
                            SizedBox(width: 8),
                            Text('Reactivate'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete_branch',
                        child: Row(
                          children: [
                            const Icon(Icons.archive_rounded,
                                color: Color.fromARGB(255, 165, 78, 78)),
                            SizedBox(width: 8),
                            Text('Delete',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 165, 78, 78))),
                          ],
                        ),
                      ),
                    ],
                  ).then((value) {
                    if (value == 'edit_branch') {
                      branchNameController.text = widget.branch.branchName;
                      regionController.text = widget.branch.region;
                      provinceController.text = widget.branch.province;
                      cityController.text = widget.branch.city;
                      barangayController.text = widget.branch.barangay;
                      zipController.text = widget.branch.zip;
                      houseController.text = widget.branch.house;
                      estdateController.text = widget.branch.estDate;
                      selectedestDate = DateFormat("MMMM dd, yyyy")
                          .parse(widget.branch.estDate);

                      isRegionValid = true;
                      isProvinceValid = true;
                      isCityValid = true;
                      isBarangayValid = true;
                      isZipValid = true;
                      isHouseValid = true;

                      isbranchNameValid = true;
                      selectedRegion = widget.branch.region;
                      selectedProvince = widget.branch.province;
                      selectedCity = widget.branch.city;
                      selectedBarangay = widget.branch.barangay;
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) {
                          return StatefulBuilder(
                            builder: (context, setState) {
                              return AlertDialog(
                                backgroundColor: Colors.white,
                                content: SizedBox(
                                  width: 400,
                                  height: 400,
                                  child: SingleChildScrollView(
                                    child: StatefulBuilder(
                                        builder: (context, setState) {
                                      return Form(
                                        key: addOneBranchFieldKey,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Editing '${widget.branch.branchName}'",
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: Color(0xff373030),
                                                fontFamily: 'Galano',
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            Gap(10),
                                            Text(
                                              "Branch Name",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Color(0xff373030),
                                                fontFamily: 'Galano',
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Gap(5),
                                            TextFormField(
                                              controller: branchNameController,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  borderSide: BorderSide(
                                                    color: Color(
                                                        0xFFD1E1FF), // Retained color
                                                    width: 1.5,
                                                  ),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  borderSide: BorderSide(
                                                    color: Color(
                                                        0xFFD1E1FF), // Retained color
                                                    width: 1.5,
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  borderSide: BorderSide(
                                                    color: Color(
                                                        0xFFD1E1FF), // Retained color
                                                    width: 1.5,
                                                  ),
                                                ),
                                              ),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Branch name is required.'; // Retained validator
                                                }
                                                return null;
                                              },
                                            ),
                                            Gap(15),
                                            Text(
                                              "Branch Location",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Color(0xff373030),
                                                fontFamily: 'Galano',
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Gap(10),

                                            // start ditooooooooooooooooo
                                            Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    // Region Dropdown
                                                    Expanded(
                                                      child:
                                                          DropDownSearchFormField<
                                                              String>(
                                                        key: regionFieldKey,
                                                        hideOnEmpty: true,
                                                        hideOnError: true,
                                                        hideOnLoading: true,
                                                        autoFlipDirection: true,
                                                        textFieldConfiguration:
                                                            TextFieldConfiguration(
                                                          controller:
                                                              regionController,
                                                          focusNode:
                                                              regionFocusNode, // Add FocusNode to listen for focus changes
                                                          decoration:
                                                              InputDecoration(
                                                            labelText: 'Region',
                                                            border:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                              borderSide:
                                                                  const BorderSide(
                                                                color: Color(
                                                                    0xFFD1E1FF),
                                                                width: 1.5,
                                                              ),
                                                            ),
                                                            errorText: isRegionValid
                                                                ? null
                                                                : 'Please select a valid region.', // Show error text if invalid
                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                              borderSide:
                                                                  const BorderSide(
                                                                color: Color(
                                                                    0xFFD1E1FF),
                                                                width: 1.5,
                                                              ),
                                                            ),
                                                            enabledBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                              borderSide:
                                                                  const BorderSide(
                                                                color: Color(
                                                                    0xFFD1E1FF),
                                                                width: 1.5,
                                                              ),
                                                            ),
                                                          ),
                                                          onChanged: (value) {
                                                            final formattedRegionName =
                                                                value
                                                                    .trim()
                                                                    .toCapitalCase();

                                                            String?
                                                                matchedRegionCode;
                                                            for (var region
                                                                in regions) {
                                                              if (region['name']
                                                                      .toLowerCase() ==
                                                                  formattedRegionName
                                                                      .toLowerCase()) {
                                                                matchedRegionCode =
                                                                    region[
                                                                        'code'];
                                                                break;
                                                              }
                                                            }

                                                            print(
                                                                matchedRegionCode);
                                                            print(
                                                                "HAHAHAHAHAHAHA");
                                                            setState(() {
                                                              if (matchedRegionCode !=
                                                                  null) {
                                                                regionController
                                                                        .text =
                                                                    formattedRegionName;
                                                                selectedRegion =
                                                                    formattedRegionName;
                                                                if (matchedRegionCode ==
                                                                    '130000000') {
                                                                  isProvinceVisible =
                                                                      false;
                                                                  provinceController
                                                                          .text =
                                                                      "Metro Manila";
                                                                  isProvinceValid =
                                                                      true;
                                                                  selectedProvince =
                                                                      "Metro Manila";
                                                                } else {
                                                                  isProvinceVisible =
                                                                      true;
                                                                  provinceController
                                                                      .clear();
                                                                  selectedProvince =
                                                                      null;
                                                                  fetchProvincesOrCities(
                                                                      matchedRegionCode);
                                                                  isRegionValid =
                                                                      true;
                                                                }
                                                              } else {
                                                                selectedRegion =
                                                                    null;
                                                                provinceController
                                                                    .clear();
                                                                selectedProvince =
                                                                    null;
                                                                provinces = [];
                                                                cityController
                                                                    .clear();
                                                                selectedCity =
                                                                    null;
                                                                cities = [];
                                                                barangayController
                                                                    .clear();
                                                                selectedBarangay =
                                                                    null;
                                                                barangays = [];
                                                                isRegionValid =
                                                                    false;
                                                                zipController
                                                                    .clear();
                                                                houseController
                                                                    .clear();
                                                              }
                                                            });
                                                          },
                                                          onEditingComplete:
                                                              () {
                                                            // When the user finishes editing, validate the region input
                                                            if (selectedRegion ==
                                                                null) {
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
                                                            (BuildContext
                                                                    context) =>
                                                                Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                            'No region found',
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                        ),
                                                        suggestionsCallback:
                                                            (pattern) {
                                                          return Future.value(
                                                            regions
                                                                .where((region) => region[
                                                                        'name']
                                                                    .toLowerCase()
                                                                    .contains(pattern
                                                                        .toLowerCase()
                                                                        .trim()))
                                                                .map((region) =>
                                                                    region[
                                                                        'name']),
                                                          );
                                                        },
                                                        itemBuilder:
                                                            (context, region) {
                                                          return ListTile(
                                                            title: Text(region),
                                                          );
                                                        },
                                                        onSuggestionSelected:
                                                            (regionName) {
                                                          setState(() {
                                                            selectedRegion =
                                                                regionName;
                                                            regionController
                                                                    .text =
                                                                regionName;
                                                            selectedProvince =
                                                                null;
                                                            selectedCity = null;
                                                            selectedBarangay =
                                                                null;
                                                            provinces = [];
                                                            cities = [];
                                                            barangays = [];
                                                            isRegionValid =
                                                                true; // Valid region selected
                                                          });

                                                          final selectedRegionData =
                                                              regions
                                                                  .firstWhere(
                                                            (region) =>
                                                                region[
                                                                    'name'] ==
                                                                regionName,
                                                            orElse: () => {
                                                              'code': '',
                                                              'name': ''
                                                            },
                                                          );

                                                          setState(() {
                                                            if (selectedRegionData[
                                                                    'code'] ==
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
                                                              isProvinceVisible =
                                                                  false;
                                                              provinceController
                                                                      .text =
                                                                  "Metro Manila";
                                                              isProvinceValid =
                                                                  true;
                                                              selectedProvince =
                                                                  "Metro Manila";
                                                            } else {
                                                              isProvinceVisible =
                                                                  true;
                                                            }
                                                          });

                                                          if (selectedRegionData[
                                                                  'code'] !=
                                                              '') {
                                                            String regionCode =
                                                                selectedRegionData[
                                                                    'code'];
                                                            fetchProvincesOrCities(
                                                                regionCode);
                                                          }
                                                        },
                                                        validator: (value) =>
                                                            value == null ||
                                                                    value
                                                                        .isEmpty
                                                                ? 'Region is required.'
                                                                : null,
                                                      ),
                                                    ),
                                                    if (isProvinceVisible)
                                                      Gap(20),
                                                    if (isProvinceVisible)
                                                      Expanded(
                                                        child:
                                                            DropDownSearchFormField<
                                                                String>(
                                                          key: provinceFieldKey,
                                                          textFieldConfiguration:
                                                              TextFieldConfiguration(
                                                            controller:
                                                                provinceController,
                                                            focusNode:
                                                                provinceFocusNode, // Add FocusNode to track focus changes
                                                            enabled:
                                                                selectedRegion !=
                                                                    null,
                                                            decoration:
                                                                InputDecoration(
                                                              labelText:
                                                                  'Province',
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                                borderSide:
                                                                    const BorderSide(
                                                                  color: Color(
                                                                      0xFFD1E1FF),
                                                                  width: 1.5,
                                                                ),
                                                              ),
                                                              errorText:
                                                                  isProvinceValid
                                                                      ? null
                                                                      : 'Please select a valid province.', // Show error message if invalid
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                                borderSide:
                                                                    const BorderSide(
                                                                  color: Color(
                                                                      0xFFD1E1FF),
                                                                  width: 1.5,
                                                                ),
                                                              ),
                                                              enabledBorder:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                                borderSide:
                                                                    const BorderSide(
                                                                  color: Color(
                                                                      0xFFD1E1FF),
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

                                                              String?
                                                                  matchedProvinceCode;
                                                              for (var province
                                                                  in provinces) {
                                                                if (province[
                                                                            'name']
                                                                        .toLowerCase() ==
                                                                    formattedProvinceName
                                                                        .toLowerCase()) {
                                                                  matchedProvinceCode =
                                                                      province[
                                                                          'code'];
                                                                  break;
                                                                }
                                                              }

                                                              setState(() {
                                                                if (matchedProvinceCode !=
                                                                    null) {
                                                                  selectedProvince =
                                                                      formattedProvinceName;
                                                                  provinceController
                                                                          .text =
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
                                                                  selectedProvince =
                                                                      null;
                                                                  cityController
                                                                      .clear();
                                                                  selectedCity =
                                                                      null;
                                                                  cities = [];

                                                                  barangayController
                                                                      .clear();
                                                                  selectedBarangay =
                                                                      null;
                                                                  barangays =
                                                                      [];
                                                                  isProvinceValid =
                                                                      false; // Set the field as invalid

                                                                  houseController
                                                                      .clear();
                                                                  zipController
                                                                      .clear();
                                                                }
                                                              });
                                                            },
                                                            onEditingComplete:
                                                                () {
                                                              // When the user finishes editing, validate the province input
                                                              if (selectedProvince ==
                                                                  null) {
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
                                                              (BuildContext
                                                                      context) =>
                                                                  Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Text(
                                                              'No province found',
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                            ),
                                                          ),
                                                          suggestionsCallback:
                                                              (pattern) {
                                                            return Future.value(
                                                              provinces
                                                                  .where((province) => province[
                                                                          'name']
                                                                      .toLowerCase()
                                                                      .contains(pattern
                                                                          .toLowerCase()
                                                                          .trim()))
                                                                  .map((province) =>
                                                                      province[
                                                                          'name']),
                                                            );
                                                          },
                                                          itemBuilder: (context,
                                                              province) {
                                                            return ListTile(
                                                              title: Text(
                                                                  province),
                                                            );
                                                          },
                                                          onSuggestionSelected:
                                                              (provinceName) {
                                                            // Capitalize the province name input to ensure consistency
                                                            String
                                                                formattedProvinceName =
                                                                provinceName
                                                                    .trim()
                                                                    .toCapitalCase();

                                                            setState(() {
                                                              selectedProvince =
                                                                  formattedProvinceName;
                                                              provinceController
                                                                      .text =
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
                                                                provinces
                                                                    .firstWhere(
                                                              (province) =>
                                                                  province[
                                                                          'name']
                                                                      .toLowerCase() ==
                                                                  formattedProvinceName
                                                                      .toLowerCase(),
                                                              orElse: () =>
                                                                  {}, // Provide a fallback if no match is found
                                                            );

                                                            // Only proceed if a valid province code was found
                                                            if (selectedProvinceData
                                                                .isNotEmpty) {
                                                              String
                                                                  provinceCode =
                                                                  selectedProvinceData[
                                                                      'code'];
                                                              fetchCities(
                                                                  provinceCode); // Fetch cities for the selected province
                                                            }
                                                          },
                                                          validator: (value) {
                                                            if (selectedRegion !=
                                                                    null &&
                                                                selectedRegion!
                                                                        .toUpperCase() ==
                                                                    "NCR") {
                                                              return null; // Valid when NCR is selected
                                                            }
                                                            if (value == null ||
                                                                value.isEmpty) {
                                                              return 'Province is required.';
                                                            }
                                                            return null;
                                                          },

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
                                                      child:
                                                          DropDownSearchFormField<
                                                              String>(
                                                        key: cityFieldKey,
                                                        textFieldConfiguration:
                                                            TextFieldConfiguration(
                                                          enabled:
                                                              selectedProvince !=
                                                                      null ||
                                                                  isProvinceVisible ==
                                                                      false,
                                                          controller:
                                                              cityController,
                                                          focusNode:
                                                              cityFocusNode, // Add FocusNode to track focus changes
                                                          decoration:
                                                              InputDecoration(
                                                            labelText:
                                                                'City/Municipality',
                                                            border:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                              borderSide:
                                                                  const BorderSide(
                                                                color: Color(
                                                                    0xFFD1E1FF),
                                                                width: 1.5,
                                                              ),
                                                            ),
                                                            errorText: isCityValid
                                                                ? null
                                                                : 'Please select a valid city/municipality.', // Show error message if invalid
                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                              borderSide:
                                                                  const BorderSide(
                                                                color: Color(
                                                                    0xFFD1E1FF),
                                                                width: 1.5,
                                                              ),
                                                            ),
                                                            enabledBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                              borderSide:
                                                                  const BorderSide(
                                                                color: Color(
                                                                    0xFFD1E1FF),
                                                                width: 1.5,
                                                              ),
                                                            ),
                                                          ),
                                                          onChanged: (value) {
                                                            // Trim the input and capitalize each word
                                                            final formattedCityName =
                                                                value
                                                                    .trim()
                                                                    .toCapitalCase();

                                                            String?
                                                                matchedCityCode;
                                                            for (var city
                                                                in cities) {
                                                              if (city['name']
                                                                      .toLowerCase() ==
                                                                  formattedCityName
                                                                      .toLowerCase()) {
                                                                matchedCityCode =
                                                                    city[
                                                                        'code'];
                                                                break;
                                                              }
                                                            }

                                                            setState(() {
                                                              if (matchedCityCode !=
                                                                  null) {
                                                                selectedCity =
                                                                    formattedCityName;
                                                                cityController
                                                                        .text =
                                                                    formattedCityName; // Update the controller's text
                                                                selectedBarangay =
                                                                    null; // Reset barangay selection
                                                                fetchBarangays(
                                                                    matchedCityCode); // Fetch barangays for the matched city
                                                                isCityValid =
                                                                    true; // Set the field as valid
                                                              } else {
                                                                selectedCity =
                                                                    null;
                                                                barangayController
                                                                    .clear();
                                                                selectedBarangay =
                                                                    null;
                                                                barangays = [];
                                                                isCityValid =
                                                                    false; // Set the field as invalid

                                                                zipController
                                                                    .clear();
                                                                houseController
                                                                    .clear();
                                                              }
                                                            });
                                                          },
                                                          onEditingComplete:
                                                              () {
                                                            // When the user finishes editing, validate the city input
                                                            if (selectedCity ==
                                                                null) {
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
                                                            (BuildContext
                                                                    context) =>
                                                                Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                            'No city/municipality found',
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                        ),
                                                        suggestionsCallback:
                                                            (pattern) {
                                                          return Future.value(
                                                            cities
                                                                .where((city) => city[
                                                                        'name']
                                                                    .toLowerCase()
                                                                    .contains(pattern
                                                                        .toLowerCase()
                                                                        .trim()))
                                                                .map((city) =>
                                                                    city[
                                                                        'name']),
                                                          );
                                                        },
                                                        itemBuilder:
                                                            (context, city) {
                                                          return ListTile(
                                                            title: Text(city),
                                                          );
                                                        },
                                                        onSuggestionSelected:
                                                            (cityName) {
                                                          // Capitalize the city name input to ensure consistency
                                                          String
                                                              formattedCityName =
                                                              cityName
                                                                  .trim()
                                                                  .toCapitalCase();

                                                          setState(() {
                                                            selectedCity =
                                                                formattedCityName;
                                                            cityController
                                                                    .text =
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
                                                                city['name']
                                                                    .toLowerCase() ==
                                                                formattedCityName
                                                                    .toLowerCase(),
                                                            orElse: () =>
                                                                {}, // Provide a fallback if no match is found
                                                          );

                                                          // Only proceed if a valid city code was found
                                                          if (selectedCityData
                                                              .isNotEmpty) {
                                                            String cityCode =
                                                                selectedCityData[
                                                                    'code'];
                                                            fetchBarangays(
                                                                cityCode); // Fetch barangays for the selected city
                                                          }
                                                        },
                                                        validator: (value) =>
                                                            value == null ||
                                                                    value
                                                                        .isEmpty
                                                                ? 'City/Municipality is required.'
                                                                : null,
                                                        enabled: selectedProvince !=
                                                                null ||
                                                            selectedRegion ==
                                                                'NCR', // Enable if province is selected or region is NCR
                                                      ),
                                                    ),
                                                    Gap(20),
                                                    Expanded(
                                                      child:
                                                          DropDownSearchFormField<
                                                              String>(
                                                        key: barangayFieldKey,
                                                        textFieldConfiguration:
                                                            TextFieldConfiguration(
                                                          controller:
                                                              barangayController,
                                                          enabled:
                                                              selectedCity !=
                                                                  null,
                                                          focusNode:
                                                              barangayFocusNode, // Add FocusNode to track focus changes
                                                          decoration:
                                                              InputDecoration(
                                                            labelText:
                                                                'Barangay',
                                                            border:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                              borderSide:
                                                                  const BorderSide(
                                                                color: Color(
                                                                    0xFFD1E1FF),
                                                                width: 1.5,
                                                              ),
                                                            ),
                                                            errorText:
                                                                isBarangayValid
                                                                    ? null
                                                                    : 'Please select a valid barangay.', // Show error message if invalid
                                                            focusedBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                              borderSide:
                                                                  const BorderSide(
                                                                color: Color(
                                                                    0xFFD1E1FF),
                                                                width: 1.5,
                                                              ),
                                                            ),
                                                            enabledBorder:
                                                                OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                              borderSide:
                                                                  const BorderSide(
                                                                color: Color(
                                                                    0xFFD1E1FF),
                                                                width: 1.5,
                                                              ),
                                                            ),
                                                          ),
                                                          onChanged: (value) {
                                                            // Trim the input and capitalize each word
                                                            final formattedBarangayName =
                                                                value
                                                                    .trim()
                                                                    .toCapitalCase();

                                                            // Check if the input matches any barangay
                                                            String?
                                                                matchedBarangayCode;
                                                            for (var barangay
                                                                in barangays) {
                                                              if (barangay[
                                                                          'name']
                                                                      .toLowerCase() ==
                                                                  formattedBarangayName
                                                                      .toLowerCase()) {
                                                                matchedBarangayCode =
                                                                    barangay[
                                                                        'code'];
                                                                break;
                                                              }
                                                            }

                                                            setState(() {
                                                              if (matchedBarangayCode !=
                                                                  null) {
                                                                selectedBarangay =
                                                                    formattedBarangayName;
                                                                barangayController
                                                                        .text =
                                                                    formattedBarangayName; // Update the controller's text
                                                                isBarangayValid =
                                                                    true; // Set the field as valid
                                                              } else {
                                                                selectedBarangay =
                                                                    null; // Reset barangay selection if no match
                                                                isBarangayValid =
                                                                    false; // Set the field as invalid

                                                                houseController
                                                                    .clear();
                                                                zipController
                                                                    .clear();
                                                              }
                                                            });
                                                          },
                                                          onEditingComplete:
                                                              () {
                                                            // When the user finishes editing, validate the barangay input
                                                            if (selectedBarangay ==
                                                                null) {
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
                                                            (BuildContext
                                                                    context) =>
                                                                Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                            'No barangay found',
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                        ),
                                                        suggestionsCallback:
                                                            (pattern) {
                                                          return Future.value(
                                                            barangays
                                                                .where((barangay) => barangay[
                                                                        'name']
                                                                    .toLowerCase()
                                                                    .contains(pattern
                                                                        .toLowerCase()
                                                                        .trim()))
                                                                .map((barangay) =>
                                                                    barangay[
                                                                        'name']),
                                                          );
                                                        },
                                                        itemBuilder: (context,
                                                            barangay) {
                                                          return ListTile(
                                                            title:
                                                                Text(barangay),
                                                          );
                                                        },
                                                        onSuggestionSelected:
                                                            (barangayName) {
                                                          // Capitalize the barangay name input to ensure consistency
                                                          String
                                                              formattedBarangayName =
                                                              barangayName
                                                                  .trim()
                                                                  .toCapitalCase();

                                                          setState(() {
                                                            selectedBarangay =
                                                                formattedBarangayName;
                                                            barangayController
                                                                    .text =
                                                                formattedBarangayName; // Update the controller's text
                                                            isBarangayValid =
                                                                true; // Valid barangay selected
                                                          });

                                                          // Find the selected barangay's code; consider case-insensitive matching
                                                          final selectedBarangayData =
                                                              barangays
                                                                  .firstWhere(
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
                                                            String
                                                                barangayCode =
                                                                selectedBarangayData[
                                                                    'code'];
                                                            // Do something with the barangay code if needed
                                                          }
                                                        },
                                                        validator: (value) =>
                                                            value == null ||
                                                                    value
                                                                        .isEmpty
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
                                                        key: zipFieldKey,
                                                        focusNode: zipFocusNode,
                                                        enabled: selectedBarangay !=
                                                            null, // Enable only if a barangay is selected
                                                        controller:
                                                            zipController,
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        decoration:
                                                            InputDecoration(
                                                          labelText:
                                                              "ZIP/Postal Code",
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                            borderSide:
                                                                BorderSide(
                                                              color: isHouseValid
                                                                  ? Color(
                                                                      0xFFD1E1FF)
                                                                  : Colors
                                                                      .red, // Normal or red depending on validation
                                                              width: 1.5,
                                                            ),
                                                          ),
                                                          enabledBorder:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                            borderSide:
                                                                BorderSide(
                                                              color: isHouseValid
                                                                  ? Color(
                                                                      0xFFD1E1FF)
                                                                  : Colors
                                                                      .red, // Red border if invalid
                                                              width: 1.5,
                                                            ),
                                                          ),
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                            borderSide:
                                                                BorderSide(
                                                              color: isHouseValid
                                                                  ? Color(
                                                                      0xFFD1E1FF)
                                                                  : Colors
                                                                      .red, // Red border if invalid
                                                              width: 1.5,
                                                            ),
                                                          ),
                                                          errorText: isZipValid
                                                              ? null
                                                              : 'ZIP/Postal Code is required.', // Display error message if invalid
                                                        ),
                                                        onChanged: (value) {
                                                          setState(() {
                                                            isZipValid = value
                                                                .trim()
                                                                .isNotEmpty; // Set to true if not empty
                                                          });
                                                        },
                                                        validator: (value) {
                                                          if (value == null ||
                                                              value.isEmpty) {
                                                            return 'ZIP/Postal Code is required.'; // Show error message
                                                          }
                                                          return null; // No error if valid
                                                        },
                                                      ),
                                                    ),
                                                    Gap(20),
                                                    Expanded(
                                                      child: TextFormField(
                                                        key: houseFieldKey,
                                                        focusNode:
                                                            houseFocusNode,
                                                        enabled: selectedBarangay !=
                                                            null, // Enable only if a barangay is selected
                                                        controller:
                                                            houseController,
                                                        decoration:
                                                            InputDecoration(
                                                          labelText:
                                                              "Building No., Street",
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                            borderSide:
                                                                BorderSide(
                                                              color: isHouseValid
                                                                  ? Color(
                                                                      0xFFD1E1FF)
                                                                  : Colors
                                                                      .red, // Normal or red depending on validation
                                                              width: 1.5,
                                                            ),
                                                          ),
                                                          enabledBorder:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                            borderSide:
                                                                BorderSide(
                                                              color: isHouseValid
                                                                  ? Color(
                                                                      0xFFD1E1FF)
                                                                  : Colors
                                                                      .red, // Red border if invalid
                                                              width: 1.5,
                                                            ),
                                                          ),
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                            borderSide:
                                                                BorderSide(
                                                              color: isHouseValid
                                                                  ? Color(
                                                                      0xFFD1E1FF)
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

                                            //last ditoooooooooooooooooo
                                            Gap(15),
                                            Text(
                                              "Date Established",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Color(0xff373030),
                                                fontFamily: 'Galano',
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Gap(5),
                                            InkWell(
                                              mouseCursor:
                                                  SystemMouseCursors.click,
                                              onTap: () => _selectDate(context),
                                              child: TextFormField(
                                                enabled: false,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                ),
                                                controller: estdateController,
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    borderSide: BorderSide(
                                                      color: Color(0xFFD1E1FF),
                                                      width: 1.5,
                                                    ),
                                                  ),
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    borderSide: BorderSide(
                                                      color: Color(0xFFb52a23),
                                                      width: 0.5,
                                                    ),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    borderSide: BorderSide(
                                                      color: Color(0xFFD1E1FF),
                                                      width: 1.5,
                                                    ),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    borderSide: BorderSide(
                                                      color: Color(0xFFD1E1FF),
                                                      width: 1.5,
                                                    ),
                                                  ),
                                                ),
                                                validator: (value) {
                                                  if (selectedestDate == null) {
                                                    return 'Establishment date is required.';
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                                actions: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          bool _areFieldsFilled() {
                                            return regionController
                                                    .text.isNotEmpty ||
                                                provinceController
                                                    .text.isNotEmpty ||
                                                cityController
                                                    .text.isNotEmpty ||
                                                barangayController
                                                    .text.isNotEmpty ||
                                                houseController
                                                    .text.isNotEmpty ||
                                                branchNameController
                                                    .text.isNotEmpty ||
                                                selectedestDate != null;
                                          }

                                          if (_areFieldsFilled()) {
                                            cancelAddingDialog(
                                                context, 'branch', 'updating');
                                          } else {
                                            Navigator.pop(context);
                                          }
                                        },
                                        style: TextButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 30, vertical: 8),
                                          backgroundColor: const Color.fromARGB(
                                              255, 180, 180, 180),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
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
                                          saveBranchChanges(loggedInUserId!);
                                        },
                                        style: TextButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 30, vertical: 8),
                                          backgroundColor:
                                              const Color(0xFF083af8),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: Text(
                                          'Save Changes',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      );
                    } else if (value == 'reactivate_branch') {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return AlertDialog(
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)),
                            ),
                            content: Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Confirm Reactivation",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "Are you sure to reactivate ${widget.branch.branchName}?",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Reactivating this branch will resume its operations. You can archive it again later if necessary.",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(
                                            context), // Close the dialog
                                        style: TextButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 30, vertical: 8),
                                          backgroundColor: const Color.fromARGB(
                                              255, 180, 180, 180),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: const Text(
                                          'Cancel',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      TextButton(
                                        onPressed: () async {
                                          try {
                                            await FirebaseFirestore.instance
                                                .collection('users')
                                                .doc(loggedInUserId)
                                                .collection('branches')
                                                .doc(widget.branch.id)
                                                .update({
                                              'isActive': true,
                                              'last_reactivated_at':
                                                  Timestamp.now(),
                                            });

                                            print(
                                                "Branch reactivated: ${widget.branch.id}");
                                            Provider.of<BranchProvider>(context,
                                                    listen: false)
                                                .toggleTabIndex();
                                            ControllerManager()
                                                    .searchManagerController
                                                    .text =
                                                widget.branch.branchName;

                                            await Future.delayed(
                                                Duration(seconds: 1));

                                            Provider.of<BranchProvider>(context,
                                                    listen: false)
                                                .searchActiveBranch(
                                                    widget.branch.branchName,
                                                    loggedInUserId)
                                                .then((_) {
                                              print(
                                                  "Branches fetched successfully.");
                                            }).catchError((e) {
                                              print(
                                                  "Error fetching branches: $e");
                                            });

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
                                              ..indicatorColor = Colors.white
                                              ..maskColor =
                                                  Colors.black.withOpacity(0.5)
                                              ..userInteractions = false
                                              ..dismissOnTap = true;

                                            EasyLoading.showToast(
                                              "${widget.branch.branchName} is successfully reactivated!",
                                              dismissOnTap: true,
                                              toastPosition:
                                                  EasyLoadingToastPosition.top,
                                              duration: Duration(seconds: 3),
                                            );

                                            Navigator.pop(context);
                                          } catch (e) {
                                            print(
                                                "Error reactivating branch: $e");
                                          }
                                        },
                                        style: TextButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 30, vertical: 8),
                                          backgroundColor:
                                              const Color(0xFF3b7dff),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: Text(
                                          'Yes, reactivate ${widget.branch.branchName}',
                                          style: TextStyle(color: Colors.white),
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
                    } else if (value == 'delete_branch') {
                      String typedBranchName = ''; // To store user input
                      bool isMatched =
                          false; // To track if the input matches the branch name

                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return StatefulBuilder(
                            builder: (context, setState) {
                              return AlertDialog(
                                backgroundColor: Colors.white,
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0)),
                                ),
                                content: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Confirm Deletion",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        "Are you sure to delete ${widget.branch.branchName}?",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "Deleting this branch will completely remove it from the company and any operations in this branch will be permanently removed. This action cannot be undone.",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontStyle: FontStyle.italic,
                                          color: Color(0xFF970f0f),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Text(
                                        "Please retype the branch name to confirm:",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 8),
                                      TextField(
                                        onChanged: (value) {
                                          setState(() {
                                            typedBranchName = value;
                                            isMatched = typedBranchName ==
                                                widget.branch.branchName;
                                          });
                                        },
                                        decoration: InputDecoration(
                                          hintText: "Enter branch name",
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: BorderSide(
                                              width: 1.5,
                                              color: isMatched
                                                  ? Colors.grey
                                                  : Color.fromARGB(255, 235, 15,
                                                      15), // Red border if not matched
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: BorderSide(
                                              width: 1.5,
                                              color: isMatched
                                                  ? Colors.green
                                                  : Color.fromARGB(255, 235, 15,
                                                      15), // Red border if not matched
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(
                                                context), // Close the dialog
                                            style: TextButton.styleFrom(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 30,
                                                      vertical: 8),
                                              backgroundColor:
                                                  Colors.transparent,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            child: Text(
                                              'Cancel',
                                              style: TextStyle(
                                                  color: Colors.grey[700]),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          TextButton(
                                            onPressed: isMatched
                                                ? () async {
                                                    try {
                                                      String branchId =
                                                          widget.branch.id;

                                                           CollectionReference staffsRef = FirebaseFirestore.instance
              .collection('users')
              .doc(loggedInUserId)
              .collection('branches')
              .doc(branchId)
              .collection('staffs');

          QuerySnapshot staffsSnapshot = await staffsRef.get();
          for (QueryDocumentSnapshot staffDoc in staffsSnapshot.docs) {
            await staffsRef.doc(staffDoc.id).delete(); // Delete each staff document
            print("Deleted staff with ID: ${staffDoc.id}");
          }
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection('users')
                                                          .doc(loggedInUserId)
                                                          .collection(
                                                              'branches')
                                                          .doc(branchId)
                                                          .delete();

                                                      print(
                                                          "Branch deleted: $branchId");

                                                      QuerySnapshot
                                                          usersSnapshot =
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'users')
                                                              .where('branchId',
                                                                  isEqualTo:
                                                                      branchId)
                                                              .get();

                                                      for (QueryDocumentSnapshot userDoc
                                                          in usersSnapshot
                                                              .docs) {
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection('users')
                                                            .doc(userDoc.id)
                                                            .delete();
                                                        print(
                                                            "Deleted user with ID: ${userDoc.id}");
                                                      }

                                                      Provider.of<BranchProvider>(
                                                              context,
                                                              listen: false)
                                                          .fetchArchiveBranches(
                                                              loggedInUserId!)
                                                          .then((_) {
                                                        print(
                                                            "Branches refreshed successfully.");
                                                      }).catchError((e) {
                                                        print(
                                                            "Error fetching branches: $e");
                                                      });

                                                      // Step 4: Show success message
                                                      EasyLoading.instance
                                                        ..displayDuration =
                                                            const Duration(
                                                                milliseconds:
                                                                    1500)
                                                        ..indicatorType =
                                                            EasyLoadingIndicatorType
                                                                .fadingCircle
                                                        ..loadingStyle =
                                                            EasyLoadingStyle
                                                                .custom
                                                        ..backgroundColor =
                                                            Color.fromARGB(255,
                                                                31, 150, 61)
                                                        ..textColor =
                                                            Colors.white
                                                        ..fontSize = 16.0
                                                        ..indicatorColor =
                                                            Colors.white
                                                        ..maskColor = Colors
                                                            .black
                                                            .withOpacity(0.5)
                                                        ..userInteractions =
                                                            false
                                                        ..dismissOnTap = true;

                                                      EasyLoading.showToast(
                                                        "${widget.branch.branchName} and associated hiring manager have been successfully deleted!",
                                                        dismissOnTap: true,
                                                        toastPosition:
                                                            EasyLoadingToastPosition
                                                                .top,
                                                        duration: Duration(
                                                            seconds: 3),
                                                      );

                                                      Navigator.pop(
                                                          context); // Close the dialog
                                                    } catch (e) {
                                                      // Step 5: Handle any errors
                                                      print(
                                                          "Error deleting branch or associated users: $e");

                                                      EasyLoading.showError(
                                                        "Failed to delete ${widget.branch.branchName}. Please try again.",
                                                        duration: Duration(
                                                            seconds: 3),
                                                      );
                                                    }
                                                  }
                                                : null, // Disabled if not matched
                                            style: TextButton.styleFrom(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 30,
                                                      vertical: 8),
                                              backgroundColor: isMatched
                                                  ? Color(0xFF970f0f)
                                                  : const Color.fromARGB(
                                                      255,
                                                      202,
                                                      202,
                                                      202), // Gray if not matched
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            child: Text(
                                              'Yes, delete ${widget.branch.branchName}',
                                              style: TextStyle(
                                                  color: Colors.white),
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
                  });
                },
              ),
            ),
          ]),
        ),
      );
    });
  }
}
