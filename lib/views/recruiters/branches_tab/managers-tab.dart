import 'package:change_case/change_case.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drop_down_search_field/drop_down_search_field.dart';
import 'package:email_validator/email_validator.dart';
import 'package:excel/excel.dart' hide Border;
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/responsive_sizes.dart';
import 'package:huzzl_web/user-provider.dart';
import 'package:huzzl_web/views/recruiters/branches_tab/branch-manager-staff-model.dart';
import 'package:huzzl_web/views/recruiters/branches_tab/branch-provider.dart';
import 'package:huzzl_web/views/recruiters/branches_tab/hiringmanager-provider.dart';
import 'package:huzzl_web/views/recruiters/branches_tab/logic/date-converter.dart';
import 'package:huzzl_web/views/recruiters/branches_tab/staff-provider.dart';
import 'package:huzzl_web/views/recruiters/branches_tab/tab-bars/activebranches.dart';
import 'package:huzzl_web/views/recruiters/branches_tab/tab-bars/archivedbranches.dart';
import 'package:huzzl_web/views/recruiters/branches_tab/widgets/candidates_widgets.dart';
import 'package:huzzl_web/views/recruiters/branches_tab/widgets/cards/activebranchCard.dart';
import 'package:huzzl_web/views/recruiters/branches_tab/widgets/dialogs/confirmCancelAddingBranch.dart';
import 'package:huzzl_web/views/recruiters/branches_tab/widgets/dialogs/confirmCancelMultipleBranch.dart';
import 'package:huzzl_web/views/recruiters/branches_tab/widgets/filterrow.dart';
import 'package:huzzl_web/views/recruiters/branches_tab/widgets/searchmanager.dart';
import 'package:huzzl_web/views/recruiters/branches_tab/widgets/tabbar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shimmer/shimmer.dart';
import 'package:side_panel/side_panel.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:html' as html;

class BuildManagersTabContent extends StatefulWidget {
  const BuildManagersTabContent({super.key});

  @override
  State<BuildManagersTabContent> createState() =>
      BuildManagersTabContentState();
}

class BuildManagersTabContentState extends State<BuildManagersTabContent>
    with TickerProviderStateMixin {
  late TabController _tabController;

  Branch? selectedBranch;
  final rightpanelController = SidePanelController();
  bool _isRightPanelVisible = false;

  bool isProvinceVisible = true;
  final branchNameController = TextEditingController();
  final hrFnameController = TextEditingController();
  final hrLnameController = TextEditingController();
  final hrPhoneController = TextEditingController();
  final hrEmailController = TextEditingController();
  final hrPasswordController = TextEditingController();
  final hrConfirmPasswordController = TextEditingController();

  TextEditingController staffFnameController = TextEditingController();
  TextEditingController staffLnameController = TextEditingController();
  TextEditingController staffPhoneController = TextEditingController();
  TextEditingController staffEmailController = TextEditingController();
  TextEditingController staffPassController = TextEditingController();
  TextEditingController staffCPassController = TextEditingController();

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  bool isPasswordVisible_staff = false;
  bool isConfirmPasswordVisible_staff = false;

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
  final GlobalKey<FormState> addOneStaffFieldKey = GlobalKey<FormState>();

  bool isRegionValid = true;
  bool isProvinceValid = true;
  bool isCityValid = true;
  bool isBarangayValid = true;
  bool isZipValid = true;
  bool isHouseValid = true;

  bool isbranchNameValid = true;
  bool ishrFnameValid = true;
  bool ishrLnameValid = true;
  bool ishrPhoneValid = true;
  bool ishrEmailValid = true;
  bool ishrPasswordValid = true;
  bool ishrConfirmPasswordValid = true;

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

  String? pickedFileName;
  Uint8List? pickedFileBytes;

  String? pickedFileName_staff;
  Uint8List? pickedFileBytes_staff;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        // Clear the searchManagerController when the tab changes
        ControllerManager().searchManagerController.clear();
      }
    });
    Provider.of<BranchProvider>(context, listen: false)
        .setTabController(_tabController);

    fetchRegions();
    estdateController.text = "Select a date";
    regionFocusNode = FocusNode();
    provinceFocusNode = FocusNode();
    cityFocusNode = FocusNode();
    barangayFocusNode = FocusNode();
    zipFocusNode = FocusNode();
    houseFocusNode = FocusNode();
    ControllerManager().searchManagerController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
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

  void saveBranchesFromFile(String loggedInUserId) async {
    if (pickedFileName != null) {
      var excel = Excel.decodeBytes(pickedFileBytes!.toList());

      showDialog(
        context: context,
        barrierDismissible: false, // Prevent dismissing by tapping outside
        builder: (BuildContext context) {
          return Center(
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              backgroundColor: Colors.transparent,
              content: Container(
                width: 105,
                height: 160,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Image.asset(
                        'assets/images/huzzl_loading.gif',
                        height: 100,
                        width: 100,
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Almost there...",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          color: Color(0xFFfd7206),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );

      int savedBranchCount = 0; // Counter for saved branches
      int totalRows = 0;
      for (var table in excel.tables.keys) {
        print(table); // sheet Name
        totalRows = excel.tables[table]!.rows.length - 1;
        var headerRow = excel.tables[table]!.rows.first;

        if (headerRow[0]?.value.toString() != "Branch Name" ||
            headerRow[1]?.value.toString() !=
                "Branch Location-Region (ex. NCR, Ilocos Region)" ||
            headerRow[2]?.value.toString() !=
                "Branch Location-Province (if NCR, put 'Metro Manila')" ||
            headerRow[3]?.value.toString() != "Branch Location-City" ||
            headerRow[4]?.value.toString() != "Branch Location-Barangay" ||
            headerRow[5]?.value.toString() !=
                "Branch Location-ZIP/Postal Code" ||
            headerRow[6]?.value.toString() != "Building No., Street" ||
            headerRow[7]?.value.toString() !=
                "Date Established (Accepted Format: [MMMM d, yyyy][ex. July 24, 2019])" ||
            headerRow[8]?.value.toString() !=
                "Branch Hiring Manager - First Name" ||
            headerRow[9]?.value.toString() !=
                "Branch Hiring Manager - Last Name" ||
            headerRow[10]?.value.toString() !=
                "Branch Hiring Manager - Phone Number" ||
            headerRow[11]?.value.toString() !=
                "Branch Hiring Manager - Work Email Address" ||
            headerRow[12]?.value.toString() !=
                "Branch Hiring Manager - Password") {
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
            "Invalid File. Please use the provided template.",
            dismissOnTap: true,
            toastPosition: EasyLoadingToastPosition.top,
            duration: Duration(seconds: 4),
          );
          Navigator.pop(context);
          return;
        }

        if (excel.tables[table]?.rows != null) {
          var rows = excel.tables[table]!.rows.sublist(1); // Skip header row

          for (var row in rows) {
            var rowData = row.map((cell) => cell?.value).toList();

            // Check if rowData has enough columns before accessing
            if (rowData.length >= 12) {
              // Trim whitespace and ensure fields are not empty
              String branchName = rowData[0]?.toString().trim() ?? '';
              String region = rowData[1]?.toString().trim() ?? '';
              String province = rowData[2]?.toString().trim() ?? '';
              String city = rowData[3]?.toString().trim() ?? '';
              String barangay = rowData[4]?.toString().trim() ?? '';
              String zip = rowData[5]?.toString().trim() ?? '';
              String buildingNoAndStreet = rowData[6]?.toString().trim() ?? '';
              String dateEstablished = rowData[7]?.toString().trim() ?? '';
              String firstName = rowData[8]?.toString().trim() ?? '';
              String lastName = rowData[9]?.toString().trim() ?? '';
              String phone = rowData[10]?.toString().trim() ?? '';
              String email = rowData[11]?.toString().trim() ?? '';
              String password = rowData[12]?.toString().trim() ?? '';

              // Check if any required field is empty
              if (branchName.isEmpty ||
                  region.isEmpty ||
                  province.isEmpty ||
                  city.isEmpty ||
                  barangay.isEmpty ||
                  zip.isEmpty ||
                  buildingNoAndStreet.isEmpty ||
                  dateEstablished.isEmpty ||
                  firstName.isEmpty ||
                  lastName.isEmpty ||
                  phone.isEmpty ||
                  email.isEmpty ||
                  password.isEmpty) {
                print("Skipping row due to incomplete data: $rowData");
                continue; // Skip this row if any required field is empty
              }

              try {
                // Format the date using the existing function
                String formattedDateEstablished =
                    parseAndFormatDate(dateEstablished);

                // Save data to Firestore
                final docRef = await FirebaseFirestore.instance
                    .collection('users')
                    .doc(loggedInUserId)
                    .collection('branches')
                    .add({
                  'branchName': branchName,
                  'firstName': firstName,
                  'lastName': lastName,
                  'phone': phone,
                  'email': email.toLowerCase(),
                  'password': password,
                  'region': region,
                  'province': province,
                  'city': city,
                  'barangay': barangay,
                  'zip': zip,
                  'house': buildingNoAndStreet,
                  'estDate':
                      formattedDateEstablished, // Use formatted date here
                  'created_at': Timestamp.now(),
                  'created_by': loggedInUserId,
                  'isMain': false,
                  'isActive': true,
                });

                savedBranchCount++; // Increment the counter for each saved branch
                print("Branch added: ${docRef.id}");

                // Save the hiring manager
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(email)
                    .set({
                  'firstName': firstName,
                  'lastName': lastName,
                  'phone': phone,
                  'email': email,
                  'password': password,
                  'role': 'hiringManager',
                  'branchId': docRef.id,
                  'created_at': Timestamp.now(),
                  'created_by': loggedInUserId,
                });

                print(
                    "User created with branch ID: ${docRef.id} and role: hiringManager");
              } catch (e) {
                print("Error adding branch or hiring manager: $e");
              }
            } else {
              print("Row does not have enough columns: $rowData");
            }
          }
        }
      }
      setState(() {
        _isRightPanelVisible = false;
      });
      rightpanelController.hideRightPanel();
      if (_tabController.index == 1) {
        _tabController.index = 0;
        Provider.of<BranchProvider>(context, listen: false).changeTabIndex(0);
      }
      // Fetch branches after adding
      await Provider.of<BranchProvider>(context, listen: false)
          .fetchActiveBranches(loggedInUserId)
          .then((_) {
        print("Branches fetched successfully.");
      }).catchError((e) {
        print("Error fetching branches: $e");
      });
      Provider.of<HiringManagerProvider>(context, listen: false)
          .fetchAllHiringManagers()
          .then((_) {
        print("Hiring managers fetched successfully.");
      }).catchError((e) {
        print("Error fetching hiring managers: $e");
      });

      Navigator.pop(context);

      Navigator.pop(context);
      if (savedBranchCount > 0) {
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
          "$savedBranchCount branche(s) from the file have been successfully added!",
          dismissOnTap: true,
          toastPosition: EasyLoadingToastPosition.top,
          duration: Duration(seconds: 3),
        );
      } else {
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
          "No branches were added. Please check the filled data for any mistakes.",
          dismissOnTap: true,
          toastPosition: EasyLoadingToastPosition.top,
          duration: Duration(seconds: 4),
        );
      }
    } else {
      print("No file to save branches from.");
    }
  }

  void saveBranch(String loggedInUserId) async {
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

    String formattedEstDate =
        DateFormat('MMMM dd, yyyy').format(selectedestDate!);

    try {
      final docRef = await FirebaseFirestore.instance
          .collection('users')
          .doc(loggedInUserId)
          .collection('branches')
          .add({
        'branchName': branchNameController.text.trim(),
        'firstName': hrFnameController.text.trim(),
        'lastName': hrLnameController.text.trim(),
        'phone': hrPhoneController.text.trim(),
        'email': hrEmailController.text.trim().toLowerCase(),
        'password': hrPasswordController.text.trim(),
        'region': regionController.text.trim(),
        'province': provinceController.text.trim(),
        'city': cityController.text.trim(),
        'barangay': barangayController.text.trim(),
        'zip': zipController.text.trim(),
        'house': houseController.text.trim(),
        'created_at': Timestamp.now(),
        'created_by': loggedInUserId,
        'isMain': false,
        'estDate': formattedEstDate,
        'isActive': true,
      });

      print("Branch added: ${docRef.id}");

      String email = hrEmailController.text.trim().toLowerCase();
      String password = hrPasswordController.text.trim();

      final userdocRef =
          await FirebaseFirestore.instance.collection('users').add({
        'firstName': hrFnameController.text.trim(),
        'lastName': hrLnameController.text.trim(),
        'phone': hrPhoneController.text.trim(),
        'email': email,
        'password': password,
        'role': 'hiringManager',
        'branchId': docRef.id,
        'created_at': Timestamp.now(),
        'created_by': loggedInUserId,
      });

      print(
          "User created (${userdocRef.id}) with branch ID: ${docRef.id} and role: hiringManager");
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
        "${branchNameController.text.trim()} is successfully added!",
        dismissOnTap: true,
        toastPosition: EasyLoadingToastPosition.top,
        duration: Duration(seconds: 3),
      );
      setState(() {
        _isRightPanelVisible = false;
      });

      rightpanelController.hideRightPanel();

      Provider.of<HiringManagerProvider>(context, listen: false)
          .fetchAllHiringManagers()
          .then((_) {
        print("Hiring managers fetched successfully.");
      }).catchError((e) {
        print("Error fetching hiring managers: $e");
      });
      ControllerManager().searchManagerController.text =
          branchNameController.text.trim();
      Navigator.of(context).pop();
      if (_tabController.index == 1) {
        _tabController.index = 0;
        Provider.of<BranchProvider>(context, listen: false).changeTabIndex(0);
        await Future.delayed(Duration(seconds: 3));
      }

      Provider.of<BranchProvider>(context, listen: false)
          .searchActiveBranch(branchNameController.text.trim(), loggedInUserId)
          .then((_) {
        print("Branches fetched successfully.");
      }).catchError((e) {
        print("Error fetching branches: $e");
      });
    } catch (e) {
      print("Error adding branch: $e");
    }
  }

  void saveStaff(String loggedInUserId) async {
    final isValidAll = addOneStaffFieldKey.currentState!.validate();

    if (!isValidAll) {
      print("Validation failed: One or more fields are invalid.");
      return;
    }

    try {
      final docRef = await FirebaseFirestore.instance
          .collection('users')
          .doc(loggedInUserId)
          .collection('branches')
          .doc(selectedBranch!.id)
          .collection('staffs')
          .add({
        'firstName': staffFnameController.text.trim(),
        'lastName': staffLnameController.text.trim(),
        'phone': staffPhoneController.text.trim(),
        'email': staffEmailController.text.trim().toLowerCase(),
        'password': staffPassController.text.trim(),
        'created_at': Timestamp.now(),
        'created_by': loggedInUserId,
        'branchId': selectedBranch!.id,
      });

      print("Staff added: ${docRef.id}");

      String email = staffEmailController.text.trim().toLowerCase();
      String password = staffPassController.text.trim();

      await FirebaseFirestore.instance.collection('users').add({
        'firstName': staffFnameController.text.trim(),
        'lastName': staffLnameController.text.trim(),
        'phone': staffPhoneController.text.trim(),
        'email': email,
        'password': password,
        'role': 'staff',
        'branchId': selectedBranch!.id,
        'created_at': Timestamp.now(),
        'created_by': loggedInUserId,
      });

      print(
          "User created with branch ID: ${selectedBranch!.id} and role: staff");

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
        "${staffFnameController.text.trim()} ${staffLnameController.text.trim()} is successfully added!",
        dismissOnTap: true,
        toastPosition: EasyLoadingToastPosition.top,
        duration: Duration(seconds: 3),
      );

      Provider.of<BranchProvider>(context, listen: false)
          .fetchActiveBranches(loggedInUserId)
          .then((_) {
        print("Branches fetched successfully.");
      }).catchError((e) {
        print("Error fetching branches: $e");
      });

      Provider.of<StaffProvider>(context, listen: false)
          .fetchStaffByBranch(loggedInUserId, selectedBranch!.id)
          .then((_) {
        print("Staffs fetched successfully.");
      }).catchError((e) {
        print("Error fetching staff: $e");
      });

      Navigator.of(context).pop();
    } catch (e) {
      print("Error adding staff: $e");
    }
  }

  void saveStaffsFromFile(String loggedInUserId) async {
    if (pickedFileName_staff != null) {
      var excel = Excel.decodeBytes(pickedFileBytes_staff!.toList());

      showDialog(
        context: context,
        barrierDismissible: false, // Prevent dismissing by tapping outside
        builder: (BuildContext context) {
          return Center(
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              backgroundColor: Colors.transparent,
              content: Container(
                width: 105,
                height: 160,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Image.asset(
                        'assets/images/huzzl_loading.gif',
                        height: 100,
                        width: 100,
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Almost there...",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          color: Color(0xFFfd7206),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );

      int savedStaffCount = 0; // Counter for saved branches
      int totalRows = 0;
      for (var table in excel.tables.keys) {
        print(table); // sheet Name
        totalRows = excel.tables[table]!.rows.length - 1;
        var headerRow = excel.tables[table]!.rows.first;

        if (headerRow[0]?.value.toString() != "Staff's First Name" ||
            headerRow[1]?.value.toString() != "Staff's Last Name" ||
            headerRow[2]?.value.toString() != "Staff's Phone Number" ||
            headerRow[3]?.value.toString() != "Staff's Work Email Address" ||
            headerRow[4]?.value.toString() != "Staff's Password") {
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
            "Invalid File. Please use the provided template.",
            dismissOnTap: true,
            toastPosition: EasyLoadingToastPosition.top,
            duration: Duration(seconds: 4),
          );
          Navigator.pop(context);
          return;
        }
        if (excel.tables[table]?.rows != null) {
          var rows = excel.tables[table]!.rows.sublist(1); // Skip header row

          for (var row in rows) {
            var rowData = row.map((cell) => cell?.value).toList();

            // Check if rowData has enough columns before accessing
            if (rowData.length >= 5) {
              // Trim whitespace and ensure fields are not empty
              String firstName = rowData[0]?.toString().trim() ?? '';
              String lastName = rowData[1]?.toString().trim() ?? '';
              String phone = rowData[2]?.toString().trim() ?? '';
              String email = rowData[3]?.toString().trim() ?? '';
              String password = rowData[4]?.toString().trim() ?? '';

              // Check if any required field is empty
              if (password.isEmpty ||
                  firstName.isEmpty ||
                  lastName.isEmpty ||
                  email.isEmpty ||
                  phone.isEmpty) {
                print("Skipping row due to incomplete data: $rowData");

                continue; // Skip this row if any required field is empty
              }

              try {
                // Save data to Firestore
                final docRef = await FirebaseFirestore.instance
                    .collection('users')
                    .doc(loggedInUserId)
                    .collection('branches')
                    .doc(selectedBranch!.id)
                    .collection('staffs')
                    .add({
                  'firstName': firstName,
                  'lastName': lastName,
                  'phone': phone,
                  'email': email,
                  'password': password,
                  'created_at': Timestamp.now(),
                  'created_by': loggedInUserId,
                  'branchId': selectedBranch!.id,
                });

                print("Staff added: ${docRef.id}");

                await FirebaseFirestore.instance.collection('users').add({
                  'firstName': staffFnameController.text.trim(),
                  'lastName': staffLnameController.text.trim(),
                  'phone': staffPhoneController.text.trim(),
                  'email': email,
                  'password': password,
                  'role': 'staff',
                  'branchId': selectedBranch!.id,
                  'created_at': Timestamp.now(),
                  'created_by': loggedInUserId,
                });

                print(
                    "User created with branch ID: ${selectedBranch!.id} and role: staff");

                savedStaffCount++;
              } catch (e) {
                print("Error adding staffs: $e");
              }
            } else {
              print("Row does not have enough columns: $rowData");
            }
          }
        }
      }

      Provider.of<StaffProvider>(context, listen: false)
          .fetchStaffByBranch(loggedInUserId, selectedBranch!.id)
          .then((_) {
        print("Staffs fetched successfully.");
      }).catchError((e) {
        print("Error fetching staff: $e");
      });

      Navigator.pop(context);

      Navigator.pop(context);
      if (savedStaffCount > 0) {
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
          "$savedStaffCount staff(s) from the file have been successfully added!",
          dismissOnTap: true,
          toastPosition: EasyLoadingToastPosition.top,
          duration: Duration(seconds: 3),
        );
      } else {
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
          "No staffs were added. Please check the filled data for any mistakes.",
          dismissOnTap: true,
          toastPosition: EasyLoadingToastPosition.top,
          duration: Duration(seconds: 4),
        );
      }
    } else {
      print("No file to save staffs from.");
    }
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

  void showAddNewBranchDialog(BuildContext context, String loggedInUserId) {
    setState(() {
      isProvinceVisible = true;
      regionController.clear();
      provinceController.clear();
      cityController.clear();
      barangayController.clear();
      houseController.clear();
      zipController.clear();
      selectedRegion = null;
      selectedProvince = null;
      selectedCity = null;
      selectedBarangay = null;
      branchNameController.clear();
      hrFnameController.clear();
      hrLnameController.clear();
      hrPhoneController.clear();
      hrEmailController.clear();
      hrPasswordController.clear();
      hrConfirmPasswordController.clear();

      estdateController.text = "Select a date";
      selectedestDate = null;

      pickedFileName = null;
      pickedFileBytes = null;
    });

    int toggleValue =
        0; // Initialize toggle state (0 for Add One Branch, 1 for Bulk Upload)
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Container(
                  width: 400,
                  child: ToggleSwitch(
                    minWidth: 200, // Set a minimum width for each switch
                    minHeight: 40, // Set a minimum height for the toggle
                    fontSize: 16,
                    activeBgColor: [Color(0xFFff9800)],
                    activeFgColor: Colors.white,
                    inactiveBgColor: Colors.white,
                    inactiveFgColor: Colors.grey[900],
                    borderWidth: 1.0,
                    borderColor: [Color(0xFFff9800)],
                    initialLabelIndex: toggleValue,
                    totalSwitches: 2,
                    labels: ['Add One Branch', 'Bulk Upload Branches'],
                    onToggle: (index) {
                      setState(() {
                        toggleValue = index ?? 0;
                      });
                    },
                  ),
                ),
              ),
              content: SizedBox(
                width: 400,
                height: 400,
                child: SingleChildScrollView(
                  child: toggleValue == 1
                      ? _buildBulkUploadForm(setState)
                      : _buildSingleBranchForm(context),
                ),
              ),
              actions: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        if (toggleValue == 0) {
                          bool _areFieldsFilled() {
                            return regionController.text.isNotEmpty ||
                                provinceController.text.isNotEmpty ||
                                cityController.text.isNotEmpty ||
                                barangayController.text.isNotEmpty ||
                                houseController.text.isNotEmpty ||
                                branchNameController.text.isNotEmpty ||
                                hrFnameController.text.isNotEmpty ||
                                hrLnameController.text.isNotEmpty ||
                                hrPhoneController.text.isNotEmpty ||
                                hrEmailController.text.isNotEmpty ||
                                hrPasswordController.text.isNotEmpty ||
                                hrConfirmPasswordController.text.isNotEmpty ||
                                selectedestDate != null;
                          }

                          if (_areFieldsFilled()) {
                            cancelAddingDialog(context, 'branch', 'adding');
                          } else {
                            Navigator.pop(context);
                          }
                        } else {
                          if (pickedFileBytes != null) {
                            cancelAddingMultipleDialog(context, 'branches');
                          } else {
                            Navigator.pop(context);
                          }
                        }
                      },
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
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Gap(10),
                    TextButton(
                      onPressed: () {
                        if (toggleValue == 1) {
                          if (pickedFileName != null) {
                            saveBranchesFromFile(loggedInUserId);
                          } else {
                            EasyLoading.instance
                              ..displayDuration =
                                  const Duration(milliseconds: 1500)
                              ..indicatorType =
                                  EasyLoadingIndicatorType.fadingCircle
                              ..loadingStyle = EasyLoadingStyle.custom
                              ..backgroundColor = Color(0xFfd74a4a)
                              ..textColor = Colors.white
                              ..fontSize = 16.0
                              ..indicatorColor = Colors.white
                              ..maskColor = Colors.black.withOpacity(0.5)
                              ..userInteractions = false
                              ..dismissOnTap = true;
                            EasyLoading.showToast(
                              "Please upload a file before saving branches.",
                              dismissOnTap: true,
                              toastPosition: EasyLoadingToastPosition.top,
                              duration: Duration(seconds: 4),
                            );
                          }
                        } else {
                          saveBranch(loggedInUserId);
                        }
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 8),
                        backgroundColor: const Color(0xFF083af8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        toggleValue == 1
                            ? 'Save Branches from File'
                            : 'Save Branch',
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
  }

  Widget _buildSingleBranchForm(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return Form(
        key: addOneBranchFieldKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
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
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Color(0xFFD1E1FF), // Retained color
                    width: 1.5,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Color(0xFFD1E1FF), // Retained color
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Color(0xFFD1E1FF), // Retained color
                    width: 1.5,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
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
                      child: DropDownSearchFormField<String>(
                        key: regionFieldKey,
                        hideOnEmpty: true,
                        hideOnError: true,
                        hideOnLoading: true,
                        autoFlipDirection: true,
                        textFieldConfiguration: TextFieldConfiguration(
                          controller: regionController,
                          focusNode:
                              regionFocusNode, // Add FocusNode to listen for focus changes
                          decoration: InputDecoration(
                            labelText: 'Region',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color(0xFFD1E1FF),
                                width: 1.5,
                              ),
                            ),
                            errorText: isRegionValid
                                ? null
                                : 'Please select a valid region.', // Show error text if invalid
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
                            final formattedRegionName =
                                value.trim().toCapitalCase();

                            String? matchedRegionCode;
                            for (var region in regions) {
                              if (region['name'].toLowerCase() ==
                                  formattedRegionName.toLowerCase()) {
                                matchedRegionCode = region['code'];
                                break;
                              }
                            }

                            print(matchedRegionCode);
                            print("HAHAHAHAHAHAHA");
                            setState(() {
                              if (matchedRegionCode != null) {
                                regionController.text = formattedRegionName;
                                selectedRegion = formattedRegionName;
                                if (matchedRegionCode == '130000000') {
                                  isProvinceVisible = false;
                                  provinceController.text = "Metro Manila";
                                  isProvinceValid = true;
                                  selectedProvince = "Metro Manila";
                                } else {
                                  isProvinceVisible = true;
                                  provinceController.clear();
                                  selectedProvince = null;
                                  fetchProvincesOrCities(matchedRegionCode);
                                  isRegionValid = true;
                                }
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
                                zipController.clear();
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
                        noItemsFoundBuilder: (BuildContext context) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'No region found',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        suggestionsCallback: (pattern) {
                          return Future.value(
                            regions
                                .where((region) => region['name']
                                    .toLowerCase()
                                    .contains(pattern.toLowerCase().trim()))
                                .map((region) => region['name']),
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
                            regionController.text = regionName;
                            selectedProvince = null;
                            selectedCity = null;
                            selectedBarangay = null;
                            provinces = [];
                            cities = [];
                            barangays = [];
                            isRegionValid = true; // Valid region selected
                          });

                          final selectedRegionData = regions.firstWhere(
                            (region) => region['name'] == regionName,
                            orElse: () => {'code': '', 'name': ''},
                          );

                          setState(() {
                            if (selectedRegionData['code'] == '130000000') {
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
                              provinceController.text = "Metro Manila";
                              isProvinceValid = true;
                              selectedProvince = "Metro Manila";
                            } else {
                              isProvinceVisible = true;
                            }
                          });

                          if (selectedRegionData['code'] != '') {
                            String regionCode = selectedRegionData['code'];
                            fetchProvincesOrCities(regionCode);
                          }
                        },
                        validator: (value) => value == null || value.isEmpty
                            ? 'Region is required.'
                            : null,
                      ),
                    ),
                    if (isProvinceVisible) Gap(20),
                    if (isProvinceVisible)
                      Expanded(
                        child: DropDownSearchFormField<String>(
                          key: provinceFieldKey,
                          textFieldConfiguration: TextFieldConfiguration(
                            controller: provinceController,
                            focusNode:
                                provinceFocusNode, // Add FocusNode to track focus changes
                            enabled: selectedRegion != null,
                            decoration: InputDecoration(
                              labelText: 'Province',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Color(0xFFD1E1FF),
                                  width: 1.5,
                                ),
                              ),
                              errorText: isProvinceValid
                                  ? null
                                  : 'Please select a valid province.', // Show error message if invalid
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
                              // Trim the input and capitalize each word
                              final formattedProvinceName =
                                  value.trim().toCapitalCase();

                              String? matchedProvinceCode;
                              for (var province in provinces) {
                                if (province['name'].toLowerCase() ==
                                    formattedProvinceName.toLowerCase()) {
                                  matchedProvinceCode = province['code'];
                                  break;
                                }
                              }

                              setState(() {
                                if (matchedProvinceCode != null) {
                                  selectedProvince = formattedProvinceName;
                                  provinceController.text =
                                      formattedProvinceName; // Update the controller's text
                                  selectedCity = null; // Reset city selection
                                  selectedBarangay =
                                      null; // Reset barangay selection
                                  barangays.clear(); // Clear barangays list
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
                                  zipController.clear();
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
                          noItemsFoundBuilder: (BuildContext context) =>
                              Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'No province found',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          suggestionsCallback: (pattern) {
                            return Future.value(
                              provinces
                                  .where((province) => province['name']
                                      .toLowerCase()
                                      .contains(pattern.toLowerCase().trim()))
                                  .map((province) => province['name']),
                            );
                          },
                          itemBuilder: (context, province) {
                            return ListTile(
                              title: Text(province),
                            );
                          },
                          onSuggestionSelected: (provinceName) {
                            // Capitalize the province name input to ensure consistency
                            String formattedProvinceName =
                                provinceName.trim().toCapitalCase();

                            setState(() {
                              selectedProvince = formattedProvinceName;
                              provinceController.text =
                                  formattedProvinceName; // Update the controller's text
                              selectedCity = null; // Reset city selection
                              selectedBarangay =
                                  null; // Reset barangay selection
                              barangays.clear(); // Clear barangays list
                              isProvinceValid = true; // Valid province selected
                            });

                            // Find the selected province's code; consider case-insensitive matching
                            final selectedProvinceData = provinces.firstWhere(
                              (province) =>
                                  province['name'].toLowerCase() ==
                                  formattedProvinceName.toLowerCase(),
                              orElse: () =>
                                  {}, // Provide a fallback if no match is found
                            );

                            // Only proceed if a valid province code was found
                            if (selectedProvinceData.isNotEmpty) {
                              String provinceCode =
                                  selectedProvinceData['code'];
                              fetchCities(
                                  provinceCode); // Fetch cities for the selected province
                            }
                          },
                          validator: (value) {
                            if (selectedRegion != null &&
                                selectedRegion!.toUpperCase() == "NCR") {
                              return null; // Valid when NCR is selected
                            }
                            if (value == null || value.isEmpty) {
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
                      child: DropDownSearchFormField<String>(
                        key: cityFieldKey,
                        textFieldConfiguration: TextFieldConfiguration(
                          enabled: selectedProvince != null ||
                              isProvinceVisible == false,
                          controller: cityController,
                          focusNode:
                              cityFocusNode, // Add FocusNode to track focus changes
                          decoration: InputDecoration(
                            labelText: 'City/Municipality',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color(0xFFD1E1FF),
                                width: 1.5,
                              ),
                            ),
                            errorText: isCityValid
                                ? null
                                : 'Please select a valid city/municipality.', // Show error message if invalid
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
                            // Trim the input and capitalize each word
                            final formattedCityName =
                                value.trim().toCapitalCase();

                            String? matchedCityCode;
                            for (var city in cities) {
                              if (city['name'].toLowerCase() ==
                                  formattedCityName.toLowerCase()) {
                                matchedCityCode = city['code'];
                                break;
                              }
                            }

                            setState(() {
                              if (matchedCityCode != null) {
                                selectedCity = formattedCityName;
                                cityController.text =
                                    formattedCityName; // Update the controller's text
                                selectedBarangay =
                                    null; // Reset barangay selection
                                fetchBarangays(
                                    matchedCityCode); // Fetch barangays for the matched city
                                isCityValid = true; // Set the field as valid
                              } else {
                                selectedCity = null;
                                barangayController.clear();
                                selectedBarangay = null;
                                barangays = [];
                                isCityValid = false; // Set the field as invalid

                                zipController.clear();
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
                        noItemsFoundBuilder: (BuildContext context) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'No city/municipality found',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        suggestionsCallback: (pattern) {
                          return Future.value(
                            cities
                                .where((city) => city['name']
                                    .toLowerCase()
                                    .contains(pattern.toLowerCase().trim()))
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
                            selectedBarangay = null; // Reset barangay selection
                            isCityValid = true; // Valid city selected
                          });

                          // Find the selected city's code; consider case-insensitive matching
                          final selectedCityData = cities.firstWhere(
                            (city) =>
                                city['name'].toLowerCase() ==
                                formattedCityName.toLowerCase(),
                            orElse: () =>
                                {}, // Provide a fallback if no match is found
                          );

                          // Only proceed if a valid city code was found
                          if (selectedCityData.isNotEmpty) {
                            String cityCode = selectedCityData['code'];
                            fetchBarangays(
                                cityCode); // Fetch barangays for the selected city
                          }
                        },
                        validator: (value) => value == null || value.isEmpty
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
                        textFieldConfiguration: TextFieldConfiguration(
                          controller: barangayController,
                          enabled: selectedCity != null,
                          focusNode:
                              barangayFocusNode, // Add FocusNode to track focus changes
                          decoration: InputDecoration(
                            labelText: 'Barangay',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color(0xFFD1E1FF),
                                width: 1.5,
                              ),
                            ),
                            errorText: isBarangayValid
                                ? null
                                : 'Please select a valid barangay.', // Show error message if invalid
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
                            // Trim the input and capitalize each word
                            final formattedBarangayName =
                                value.trim().toCapitalCase();

                            // Check if the input matches any barangay
                            String? matchedBarangayCode;
                            for (var barangay in barangays) {
                              if (barangay['name'].toLowerCase() ==
                                  formattedBarangayName.toLowerCase()) {
                                matchedBarangayCode = barangay['code'];
                                break;
                              }
                            }

                            setState(() {
                              if (matchedBarangayCode != null) {
                                selectedBarangay = formattedBarangayName;
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
                                zipController.clear();
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
                        noItemsFoundBuilder: (BuildContext context) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'No barangay found',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        suggestionsCallback: (pattern) {
                          return Future.value(
                            barangays
                                .where((barangay) => barangay['name']
                                    .toLowerCase()
                                    .contains(pattern.toLowerCase().trim()))
                                .map((barangay) => barangay['name']),
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
                              barangayName.trim().toCapitalCase();

                          setState(() {
                            selectedBarangay = formattedBarangayName;
                            barangayController.text =
                                formattedBarangayName; // Update the controller's text
                            isBarangayValid = true; // Valid barangay selected
                          });

                          // Find the selected barangay's code; consider case-insensitive matching
                          final selectedBarangayData = barangays.firstWhere(
                            (barangay) =>
                                barangay['name'].toLowerCase() ==
                                formattedBarangayName.toLowerCase(),
                            orElse: () =>
                                {}, // Provide a fallback if no match is found
                          );

                          // Only proceed if a valid barangay code was found
                          if (selectedBarangayData.isNotEmpty) {
                            String barangayCode = selectedBarangayData['code'];
                            // Do something with the barangay code if needed
                          }
                        },
                        validator: (value) => value == null || value.isEmpty
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
                        controller: zipController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "ZIP/Postal Code",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: isHouseValid
                                  ? Color(0xFFD1E1FF)
                                  : Colors
                                      .red, // Normal or red depending on validation
                              width: 1.5,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: isHouseValid
                                  ? Color(0xFFD1E1FF)
                                  : Colors.red, // Red border if invalid
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: isHouseValid
                                  ? Color(0xFFD1E1FF)
                                  : Colors.red, // Red border if invalid
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
                          if (value == null || value.isEmpty) {
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
                        focusNode: houseFocusNode,
                        enabled: selectedBarangay !=
                            null, // Enable only if a barangay is selected
                        controller: houseController,
                        decoration: InputDecoration(
                          labelText: "Building No., Street",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: isHouseValid
                                  ? Color(0xFFD1E1FF)
                                  : Colors
                                      .red, // Normal or red depending on validation
                              width: 1.5,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: isHouseValid
                                  ? Color(0xFFD1E1FF)
                                  : Colors.red, // Red border if invalid
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: isHouseValid
                                  ? Color(0xFFD1E1FF)
                                  : Colors.red, // Red border if invalid
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
                          if (value == null || value.isEmpty) {
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
              mouseCursor: SystemMouseCursors.click,
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
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Color(0xFFD1E1FF),
                      width: 1.5,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Color(0xFFb52a23),
                      width: 0.5,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Color(0xFFD1E1FF),
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
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

            Gap(15),
            Text(
              "Branch Hiring Manager",
              style: TextStyle(
                fontSize: 12,
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
                        controller: hrFnameController,
                        decoration: InputDecoration(
                          labelText: "First Name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Color(0xFFD1E1FF), // Retained color
                              width: 1.5,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Color(0xFFD1E1FF), // Retained color
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Color(0xFFD1E1FF), // Retained color
                              width: 1.5,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'First name is required.'; // Show error message
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
                        controller: hrLnameController,
                        decoration: InputDecoration(
                          labelText: "Last Name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Color(0xFFD1E1FF), // Retained color
                              width: 1.5,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Color(0xFFD1E1FF), // Retained color
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Color(0xFFD1E1FF), // Retained color
                              width: 1.5,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Last name is required.'; // Show error message
                          }
                          return null; // No error if valid
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Gap(15),
            Text(
              "Branch Hiring Manager's Phone Number",
              style: TextStyle(
                fontSize: 12,
                color: Color(0xff373030),
                fontFamily: 'Galano',
                fontWeight: FontWeight.w500,
              ),
            ),
            Gap(5),
            TextFormField(
              controller: hrPhoneController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Color(0xFFD1E1FF), // Retained color
                    width: 1.5,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Color(0xFFD1E1FF), // Retained color
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Color(0xFFD1E1FF), // Retained color
                    width: 1.5,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Phone number is required.'; // Show error message
                }
                return null; // No error if valid
              },
            ),
            Gap(15),

            Text(
              "Branch Hiring Manager's Account",
              style: TextStyle(
                fontSize: 12,
                color: Color(0xff373030),
                fontFamily: 'Galano',
                fontWeight: FontWeight.w500,
              ),
            ),
            Gap(10),
            TextFormField(
              controller: hrEmailController,
              decoration: InputDecoration(
                labelText: "Work Email Address",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Color(0xFFD1E1FF), // Retained color
                    width: 1.5,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Color(0xFFD1E1FF), // Retained color
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Color(0xFFD1E1FF), // Retained color
                    width: 1.5,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Email Address is required."; // Show error message
                }
                if (!EmailValidator.validate(value)) {
                  return "Please provide a valid email address."; // Show error message for invalid email
                }
                return null; // No error if valid
              },
            ),
            Gap(10),
            TextFormField(
              controller: hrPasswordController,
              style: const TextStyle(
                fontFamily: 'Galano',
              ),
              obscureText: isPasswordVisible ? false : true,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      isPasswordVisible =
                          !isPasswordVisible; // Retain the visibility toggle
                    });
                  },
                  icon: isPasswordVisible
                      ? const Icon(Icons.visibility)
                      : const Icon(Icons.visibility_off),
                ),
                labelText: "Password (8 or more characters)",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Color(0xFFD1E1FF), // Retained color
                    width: 1.5,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Color(0xFFD1E1FF), // Retained color
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Color(0xFFD1E1FF), // Retained color
                    width: 1.5,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Password is required."; // Show error message
                }
                if (value.length < 8) {
                  return 'Password must be at least 8 characters long'; // Show error for length
                }
                return null; // No error if valid
              },
            ),
            Gap(10),
            TextFormField(
              controller: hrConfirmPasswordController,
              style: const TextStyle(
                fontFamily: 'Galano',
              ),
              obscureText: isConfirmPasswordVisible ? false : true,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      isConfirmPasswordVisible =
                          !isConfirmPasswordVisible; // Retain the visibility toggle
                    });
                  },
                  icon: isConfirmPasswordVisible
                      ? const Icon(Icons.visibility)
                      : const Icon(Icons.visibility_off),
                ),
                labelText: "Confirm Password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Color(0xFFD1E1FF), // Retained color
                    width: 1.5,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Color(0xFFD1E1FF), // Retained color
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Color(0xFFD1E1FF), // Retained color
                    width: 1.5,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Confirm Password is required.'; // Show error if empty
                }
                if (value != hrPasswordController.text) {
                  return 'Passwords do not match'; // Show error if passwords do not match
                }
                return null; // No error if valid
              },
            ),
          ],
        ),
      );
    });
  }

// Bulk Upload Form
  Widget _buildBulkUploadForm(StateSetter setState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Text(
          'Bulk upload branches through excel (xlsx) file',
          style: TextStyle(
            fontSize: 14,
            // fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 30),
        Text(
          'Step 1: Download Sample Template',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        SizedBox(height: 10),
        Text(
          'Download the sample template by clicking the button below.',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        SizedBox(height: 5),
        Text(
          'You can add branch details according to the format in the template file.',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        SizedBox(height: 10),
        TextButton.icon(
          onPressed: () async {
            try {
              html.AnchorElement(
                  href: 'assets/templates/huzzl_bulk-upload-branches.xlsx')
                ..setAttribute('download', 'huzzl_bulk-upload-branches.xlsx')
                ..click();

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
                "The template is now downloading!",
                dismissOnTap: true,
                toastPosition: EasyLoadingToastPosition.top,
                duration: Duration(seconds: 3),
              );
            } catch (e) {
              EasyLoading.instance
                ..displayDuration = const Duration(milliseconds: 1500)
                ..indicatorType = EasyLoadingIndicatorType.fadingCircle
                ..loadingStyle = EasyLoadingStyle.custom
                ..backgroundColor = Color(0xFF23294F)
                ..textColor = Colors.white
                ..fontSize = 16.0
                ..indicatorColor = Colors.white
                ..maskColor = Colors.black.withOpacity(0.5)
                ..userInteractions = false
                ..dismissOnTap = true;
              EasyLoading.showToast(
                "Cannot download the file. Please check your internet connection.",
                dismissOnTap: true,
                toastPosition: EasyLoadingToastPosition.top,
                duration: Duration(seconds: 3),
              );
              print('Error downloading file: $e');
            }
          },
          icon: Image.asset('assets/images/download-icon.png', height: 20),
          label: Text('Download Template',
              style: TextStyle(color: Color(0xFF23294f))),
          style: TextButton.styleFrom(
            backgroundColor: Colors.transparent,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: Color(0xFF23294f), width: 0.5),
            ),
          ),
        ),
        SizedBox(height: 30),
        Text(
          'Step 2: Upload excel file',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        SizedBox(height: 10),
        Text(
          'Upload the edited template by clicking the button below.',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        SizedBox(height: 10),
        TextButton.icon(
          onPressed: () async {
            final userProvider =
                Provider.of<UserProvider>(context, listen: false);
            final loggedInUserId = userProvider.loggedInUserId;

            // Check if loggedInUserId is valid
            if (loggedInUserId == null || loggedInUserId.trim().isEmpty) {
              print("User is not logged in.");
              return; // Exit if the user is not logged in
            }

            FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
              type: FileType.custom,
              allowedExtensions: ['xlsx'],
              allowMultiple: false,
            );

            if (pickedFile != null) {
              setState(() {
                pickedFileName = pickedFile.files.single.name;
                pickedFileBytes = pickedFile.files.single.bytes;
              });
            } else {
              print("No file was picked.");
            }
          },
          icon: Image.asset('assets/images/upload-icon.png', height: 20),
          label: Text(
            pickedFileName != null
                ? (pickedFileName!.length > 20
                    ? '${pickedFileName!.substring(0, 20)}...'
                    : pickedFileName!)
                : 'Upload File',
            style: TextStyle(color: Color(0xFF23294f)),
          ),
          style: TextButton.styleFrom(
            backgroundColor: Colors.transparent,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: Color(0xFF23294f), width: 0.5),
            ),
          ),
        ),
      ],
    );
  }

  void showAddNewStaffDialog(BuildContext context, String loggedInUserId) {
    setState(() {
      staffFnameController.clear();
      staffLnameController.clear();
      staffPhoneController.clear();
      staffEmailController.clear();
      staffPassController.clear();
      staffCPassController.clear();
      pickedFileName_staff = null;
      pickedFileBytes_staff = null;
    });

    int toggleValue =
        0; // Initialize toggle state (0 for Add One Branch, 1 for Bulk Upload)
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Container(
                  width: 400,
                  child: ToggleSwitch(
                    minWidth: 200, // Set a minimum width for each switch
                    minHeight: 40, // Set a minimum height for the toggle
                    fontSize: 16,
                    activeBgColor: [Color(0xFFff9800)],
                    activeFgColor: Colors.white,
                    inactiveBgColor: Colors.white,
                    inactiveFgColor: Colors.grey[900],
                    borderWidth: 1.0,
                    borderColor: [Color(0xFFff9800)],
                    initialLabelIndex: toggleValue,
                    totalSwitches: 2,
                    labels: ['Add One Staff', 'Bulk Upload Staffs'],
                    onToggle: (index) {
                      setState(() {
                        toggleValue = index ?? 0;
                      });
                    },
                  ),
                ),
              ),
              content: SizedBox(
                width: 400,
                height: 400,
                child: SingleChildScrollView(
                  child: toggleValue == 0
                      ? _buildSingleStaffForm(context)
                      : _buildBulkStaffForm(setState),
                ),
              ),
              actions: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        if (toggleValue == 0) {
                          bool _areFieldsFilled() {
                            return staffFnameController.text.isNotEmpty ||
                                staffLnameController.text.isNotEmpty ||
                                staffPhoneController.text.isNotEmpty ||
                                staffEmailController.text.isNotEmpty ||
                                staffPassController.text.isNotEmpty ||
                                staffCPassController.text.isNotEmpty;
                          }

                          if (_areFieldsFilled()) {
                            cancelAddingDialog(context, 'staff', 'adding');
                          } else {
                            Navigator.pop(context);
                          }
                        } else {
                          if (pickedFileBytes_staff != null) {
                            cancelAddingMultipleDialog(context, 'staffs');
                          } else {
                            Navigator.pop(context);
                          }
                        }
                      },
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
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Gap(10),
                    TextButton(
                      onPressed: () {
                        if (toggleValue == 1) {
                          if (pickedFileName_staff != null) {
                            saveStaffsFromFile(loggedInUserId);
                          } else {
                            EasyLoading.instance
                              ..displayDuration =
                                  const Duration(milliseconds: 1500)
                              ..indicatorType =
                                  EasyLoadingIndicatorType.fadingCircle
                              ..loadingStyle = EasyLoadingStyle.custom
                              ..backgroundColor = Color(0xFfd74a4a)
                              ..textColor = Colors.white
                              ..fontSize = 16.0
                              ..indicatorColor = Colors.white
                              ..maskColor = Colors.black.withOpacity(0.5)
                              ..userInteractions = false
                              ..dismissOnTap = true;
                            EasyLoading.showToast(
                              "Please upload a file before saving staffs.",
                              dismissOnTap: true,
                              toastPosition: EasyLoadingToastPosition.top,
                              duration: Duration(seconds: 4),
                            );
                          }
                        } else {
                          saveStaff(loggedInUserId);
                        }
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 8),
                        backgroundColor: const Color(0xFF083af8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        toggleValue == 1
                            ? 'Save Staffs from File'
                            : 'Save Staff',
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
  }

  Widget _buildSingleStaffForm(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return Form(
        key: addOneStaffFieldKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Staff's Full Name",
              style: TextStyle(
                fontSize: 12,
                color: Color(0xff373030),
                fontFamily: 'Galano',
                fontWeight: FontWeight.w500,
              ),
            ),
            Gap(10),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: staffFnameController,
                    decoration: InputDecoration(
                      labelText: "First Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Color(0xFFD1E1FF), // Retained color
                          width: 1.5,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Color(0xFFD1E1FF), // Retained color
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Color(0xFFD1E1FF), // Retained color
                          width: 1.5,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'First name is required.'; // Show error message
                      }
                      return null; // No error if valid
                    },
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: TextFormField(
                    controller: staffLnameController,
                    decoration: InputDecoration(
                      labelText: "Last Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Color(0xFFD1E1FF), // Retained color
                          width: 1.5,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Color(0xFFD1E1FF), // Retained color
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Color(0xFFD1E1FF), // Retained color
                          width: 1.5,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Last name is required.'; // Show error message
                      }
                      return null; // No error if valid
                    },
                  ),
                ),
              ],
            ),
            Gap(15),
            Text(
              "Staff's Phone Number",
              style: TextStyle(
                fontSize: 12,
                color: Color(0xff373030),
                fontFamily: 'Galano',
                fontWeight: FontWeight.w500,
              ),
            ),
            Gap(5),
            TextFormField(
              controller: staffPhoneController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Color(0xFFD1E1FF), // Retained color
                    width: 1.5,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Color(0xFFD1E1FF), // Retained color
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Color(0xFFD1E1FF), // Retained color
                    width: 1.5,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Phone number is required.'; // Show error message
                }
                return null; // No error if valid
              },
            ),
            Gap(15),
            Text(
              "Staff's Account",
              style: TextStyle(
                fontSize: 12,
                color: Color(0xff373030),
                fontFamily: 'Galano',
                fontWeight: FontWeight.w500,
              ),
            ),
            Gap(10),
            TextFormField(
              controller: staffEmailController,
              decoration: InputDecoration(
                labelText: "Work Email Address",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Color(0xFFD1E1FF), // Retained color
                    width: 1.5,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Color(0xFFD1E1FF), // Retained color
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Color(0xFFD1E1FF), // Retained color
                    width: 1.5,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Email Address is required."; // Show error message
                }
                if (!EmailValidator.validate(value)) {
                  return "Please provide a valid email address."; // Show error message for invalid email
                }
                return null; // No error if valid
              },
            ),
            Gap(10),
            TextFormField(
              controller: staffPassController,
              style: const TextStyle(
                fontFamily: 'Galano',
              ),
              obscureText: isPasswordVisible_staff ? false : true,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      isPasswordVisible_staff =
                          !isPasswordVisible_staff; // Retain the visibility toggle
                    });
                  },
                  icon: isPasswordVisible_staff
                      ? const Icon(Icons.visibility)
                      : const Icon(Icons.visibility_off),
                ),
                labelText: "Password (8 or more characters)",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Color(0xFFD1E1FF), // Retained color
                    width: 1.5,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Color(0xFFD1E1FF), // Retained color
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Color(0xFFD1E1FF), // Retained color
                    width: 1.5,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Password is required."; // Show error message
                }
                if (value.length < 8) {
                  return 'Password must be at least 8 characters long'; // Show error for length
                }
                return null; // No error if valid
              },
            ),
            Gap(10),
            TextFormField(
              controller: staffCPassController,
              style: const TextStyle(
                fontFamily: 'Galano',
              ),
              obscureText: isConfirmPasswordVisible_staff ? false : true,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      isConfirmPasswordVisible_staff =
                          !isConfirmPasswordVisible_staff; // Retain the visibility toggle
                    });
                  },
                  icon: isConfirmPasswordVisible_staff
                      ? const Icon(Icons.visibility)
                      : const Icon(Icons.visibility_off),
                ),
                labelText: "Confirm Password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Color(0xFFD1E1FF), // Retained color
                    width: 1.5,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Color(0xFFD1E1FF), // Retained color
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Color(0xFFD1E1FF), // Retained color
                    width: 1.5,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Confirm Password is required.'; // Show error if empty
                }
                if (value != staffPassController.text) {
                  return 'Passwords do not match'; // Show error if passwords do not match
                }
                return null; // No error if valid
              },
            ),
          ],
        ),
      );
    });
  }

// Bulk Upload Form
  Widget _buildBulkStaffForm(StateSetter setState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Text(
          'Bulk upload staffs through excel (xlsx) file',
          style: TextStyle(
            fontSize: 14,
            // fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 30),
        Text(
          'Step 1: Download Sample Template',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        SizedBox(height: 10),
        Text(
          'Download the sample template by clicking the button below.',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        SizedBox(height: 5),
        Text(
          'You can add staff details according to the format in the template file.',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        SizedBox(height: 10),
        TextButton.icon(
          onPressed: () async {
            try {
              html.AnchorElement(
                  href: 'assets/templates/huzzl_bulk-upload-staffs.xlsx')
                ..setAttribute('download', 'huzzl_bulk-upload-staffs.xlsx')
                ..click();

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
                "The template is now downloading!",
                dismissOnTap: true,
                toastPosition: EasyLoadingToastPosition.top,
                duration: Duration(seconds: 3),
              );
            } catch (e) {
              EasyLoading.instance
                ..displayDuration = const Duration(milliseconds: 1500)
                ..indicatorType = EasyLoadingIndicatorType.fadingCircle
                ..loadingStyle = EasyLoadingStyle.custom
                ..backgroundColor = Color(0xFF23294F)
                ..textColor = Colors.white
                ..fontSize = 16.0
                ..indicatorColor = Colors.white
                ..maskColor = Colors.black.withOpacity(0.5)
                ..userInteractions = false
                ..dismissOnTap = true;
              EasyLoading.showToast(
                "Cannot download the file. Please check your internet connection.",
                dismissOnTap: true,
                toastPosition: EasyLoadingToastPosition.top,
                duration: Duration(seconds: 3),
              );
              print('Error downloading file: $e');
            }
          },
          icon: Image.asset('assets/images/download-icon.png', height: 20),
          label: Text('Download Template',
              style: TextStyle(color: Color(0xFF23294f))),
          style: TextButton.styleFrom(
            backgroundColor: Colors.transparent,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: Color(0xFF23294f), width: 0.5),
            ),
          ),
        ),
        SizedBox(height: 30),
        Text(
          'Step 2: Upload excel file',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        SizedBox(height: 10),
        Text(
          'Upload the edited template by clicking the button below.',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        SizedBox(height: 10),
        TextButton.icon(
          onPressed: () async {
            final userProvider =
                Provider.of<UserProvider>(context, listen: false);
            final loggedInUserId = userProvider.loggedInUserId;

            // Check if loggedInUserId is valid
            if (loggedInUserId == null || loggedInUserId.trim().isEmpty) {
              print("User is not logged in.");
              return; // Exit if the user is not logged in
            }

            FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
              type: FileType.custom,
              allowedExtensions: ['xlsx'],
              allowMultiple: false,
            );

            if (pickedFile != null) {
              setState(() {
                pickedFileName_staff = pickedFile.files.single.name;
                pickedFileBytes_staff = pickedFile.files.single.bytes;
              });
            } else {
              print("No file was picked.");
            }
          },
          icon: Image.asset('assets/images/upload-icon.png', height: 20),
          label: Text(
            pickedFileName_staff != null
                ? (pickedFileName_staff!.length > 20
                    ? '${pickedFileName_staff!.substring(0, 20)}...'
                    : pickedFileName_staff!)
                : 'Upload File',
            style: TextStyle(color: Color(0xFF23294f)),
          ),
          style: TextButton.styleFrom(
            backgroundColor: Colors.transparent,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: Color(0xFF23294f), width: 0.5),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final loggedInUserId = Provider.of<UserProvider>(context).loggedInUserId;
    final hiringManagerProvider = Provider.of<HiringManagerProvider>(context);
    final staffProvider = Provider.of<StaffProvider>(context);

    // TabController _tabController =
    //     TabController(length: 2, vsync: Scaffold.of(context));

    return ResponsiveBuilder(builder: (context, sizeInfo) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: sizeInfo.isDesktop || sizeInfo.isTablet
            ? SidePanel(
                controller: rightpanelController,
                right: Panel(
                  size: sizeInfo.isDesktop ? 400 : 300,
                  child: Container(
                    padding: EdgeInsets.all(20.0),

                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          width: 0.5,
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(10)),
                    // color: Color.fromARGB(255, 255, 228, 202),
                    child: selectedBranch != null
                        ? Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        selectedBranch!.branchName,
                                        style: TextStyle(
                                            fontSize: ResponsiveSizes
                                                .subtitleTextSize(sizeInfo),
                                            fontWeight: FontWeight.bold),
                                      ),
                                      selectedBranch!.isMain
                                          ? Text(
                                              "Main Branch",
                                              style: TextStyle(
                                                fontSize: ResponsiveSizes
                                                        .noteTextSize(
                                                            sizeInfo) *
                                                    0.9,
                                                color: const Color.fromARGB(
                                                    255, 18, 129, 21),
                                                fontWeight: FontWeight.w700,
                                              ),
                                            )
                                          : SizedBox(),
                                    ],
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        rightpanelController.hideRightPanel();

                                        _isRightPanelVisible = false;
                                      });
                                    },
                                    icon: Icon(Icons.close_rounded, size: 16),
                                  )
                                ],
                              ),
                              Gap(20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "Hiring Manager",
                                    style: TextStyle(
                                      fontSize: ResponsiveSizes.noteTextSize(
                                          sizeInfo),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Gap(5),
                              Consumer<HiringManagerProvider>(builder:
                                  (context, hiringManagerProvider, child) {
                                // Fetch all hiring managers
                                List<HiringManager> hiringManagers =
                                    hiringManagerProvider.hiringManagers;

                                // Find the hiring manager that matches the selected branch's id
                                HiringManager? matchingHiringManager =
                                    hiringManagers.firstWhere(
                                  (manager) =>
                                      manager.branchId == selectedBranch?.id,
                                  orElse: () => HiringManager(
                                    // Provide a default instance here
                                    fname: '',
                                    lname: '',
                                    email: '',
                                    password: '',
                                    phoneNum: '',
                                    branchId: '',
                                    created_at: Timestamp.now(),
                                    created_by: '',
                                  ),
                                );

                                // Conditional check to handle null
                                if (matchingHiringManager == null) {
                                  return Center(
                                      child: Text(
                                          "No hiring manager found for this branch"));
                                }
                                return Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            CircleAvatar(
                                              backgroundColor: Color(0xFF083af8)
                                                  .withOpacity(0.3),
                                              foregroundColor:
                                                  Color(0xFF083af8),
                                              child: Text(
                                                "${matchingHiringManager.fname[0]}${matchingHiringManager.lname[0]}",
                                              ),
                                            ),
                                            Gap(10),
                                            Expanded(
                                              // Added Expanded here to make the column occupy available space
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          "${matchingHiringManager.fname} ${matchingHiringManager.lname}",
                                                          style: TextStyle(
                                                            fontSize:
                                                                ResponsiveSizes
                                                                    .bodyTextSize(
                                                                        sizeInfo),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                          softWrap: true,
                                                          overflow: TextOverflow
                                                              .visible, // Ensures proper text wrap
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Gap(5),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.email_rounded,
                                                        color: Colors.grey,
                                                        size: ResponsiveSizes
                                                            .noteTextSize(
                                                                sizeInfo),
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          " ${matchingHiringManager.email}",
                                                          style: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize:
                                                                ResponsiveSizes
                                                                    .noteTextSize(
                                                                        sizeInfo),
                                                          ),
                                                          softWrap: true,
                                                          overflow: TextOverflow
                                                              .visible, // Ensures proper text wrap
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  if (matchingHiringManager
                                                          .phoneNum![0] !=
                                                      null)
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons.phone,
                                                          color: Colors.grey,
                                                          size: ResponsiveSizes
                                                              .noteTextSize(
                                                                  sizeInfo),
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            " ${matchingHiringManager.phoneNum!}",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: ResponsiveSizes
                                                                  .noteTextSize(
                                                                      sizeInfo),
                                                            ),
                                                            softWrap: true,
                                                            overflow: TextOverflow
                                                                .visible, // Ensures proper text wrap
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Positioned(
                                        top: 2,
                                        right: 2,
                                        child: PopupMenuButton(
                                          icon: Icon(
                                            Icons.more_vert,
                                            color: Colors.grey,
                                            size: 14,
                                          ), // Icon for the popup menu
                                          itemBuilder: (BuildContext context) =>
                                              <PopupMenuEntry>[
                                            PopupMenuItem(
                                              value: 'edit_hr',
                                              child: Row(
                                                children: [
                                                  Icon(Icons.edit,
                                                      color: Colors.grey),
                                                  SizedBox(width: 8),
                                                  Text('Edit'),
                                                ],
                                              ),
                                            ),
                                          ],
                                          onSelected: (value) {
                                            if (value == 'edit_hr') {
                                              // Handle edit action here
                                              print('Edit option selected');
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Staff Members",
                                    style: TextStyle(
                                      fontSize: ResponsiveSizes.noteTextSize(
                                          sizeInfo),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  IconButton(
                                      tooltip: "Add new staff",
                                      onPressed: () => showAddNewStaffDialog(
                                          context, loggedInUserId!),
                                      icon:
                                          Icon(Icons.add, color: Colors.black))
                                ],
                              ),
                              Gap(5),
                              Expanded(
                                child: Consumer<StaffProvider>(
                                    builder: (context, staffProvider, child) {
                                  if (staffProvider.isLoading) {
                                    return Expanded(
                                      child: ListView.builder(
                                        itemCount:
                                            4, // Show 5 shimmer loading items
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Shimmer.fromColors(
                                            baseColor: Colors.grey[200]!,
                                            highlightColor: Colors.grey[100]!,
                                            child: Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5),
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              decoration: BoxDecoration(
                                                color: Colors.grey[
                                                    200], // Grey background for the shimmer
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              height:
                                                  80, // Height of each placeholder card
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  }

                                  if (staffProvider.staffMembers.isEmpty) {
                                    return Center(
                                        child: Text("No staff added yet",
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12)));
                                  }
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    itemCount:
                                        staffProvider.staffMembers.length,
                                    itemBuilder: (context, index) {
                                      final staff = staffProvider.staffMembers[
                                          index]; // Access each staff member
                                      return Container(
                                        margin: EdgeInsets.only(bottom: 5),
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          border: Border.all(
                                              color: Colors.grey.shade300),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Stack(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  CircleAvatar(
                                                    backgroundColor:
                                                        Color(0xFFff9800)
                                                            .withOpacity(0.3),
                                                    foregroundColor:
                                                        Color(0xFFfd7206),
                                                    child: Text(
                                                      "${staff.fname[0]}${staff.lname[0]}",
                                                    ),
                                                  ),
                                                  Gap(10),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "${staff.fname} ${staff.lname}",
                                                          style: TextStyle(
                                                            fontSize:
                                                                ResponsiveSizes
                                                                    .bodyTextSize(
                                                                        sizeInfo),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                          softWrap: true,
                                                          overflow: TextOverflow
                                                              .visible, // Allow text wrapping
                                                        ),
                                                        Gap(5),
                                                        Row(
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .email_rounded,
                                                              color:
                                                                  Colors.grey,
                                                              size: ResponsiveSizes
                                                                  .noteTextSize(
                                                                      sizeInfo),
                                                            ),
                                                            Expanded(
                                                              child: Text(
                                                                " ${staff.email}",
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontSize: ResponsiveSizes
                                                                      .noteTextSize(
                                                                          sizeInfo),
                                                                ),
                                                                softWrap: true,
                                                                overflow:
                                                                    TextOverflow
                                                                        .visible, // Allow text wrapping
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        if (staff.phoneNum !=
                                                            null)
                                                          Row(
                                                            children: [
                                                              Icon(
                                                                Icons.phone,
                                                                color:
                                                                    Colors.grey,
                                                                size: ResponsiveSizes
                                                                    .noteTextSize(
                                                                        sizeInfo),
                                                              ),
                                                              Expanded(
                                                                child: Text(
                                                                  " ${staff.phoneNum}",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .grey,
                                                                    fontSize: ResponsiveSizes
                                                                        .noteTextSize(
                                                                            sizeInfo),
                                                                  ),
                                                                  softWrap:
                                                                      true,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .visible, // Allow text wrapping
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Positioned(
                                              top: 2,
                                              right: 2,
                                              child: PopupMenuButton(
                                                icon: Icon(
                                                  Icons.more_vert,
                                                  color: Colors.grey,
                                                  size: 14,
                                                ),
                                                itemBuilder:
                                                    (BuildContext context) =>
                                                        <PopupMenuEntry>[
                                                  PopupMenuItem(
                                                    value: 'edit_staff',
                                                    child: Row(
                                                      children: [
                                                        Icon(Icons.edit,
                                                            color: Colors.grey),
                                                        SizedBox(width: 8),
                                                        Text('Edit'),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                                onSelected: (value) {
                                                  if (value == 'edit_staff') {
                                                    // Handle edit action here
                                                    print(
                                                        'Edit option selected');
                                                  }
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                }),
                              ),
                            ],
                          )
                        : Text(''),
                  ),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            sizeInfo.isDesktop
                                ? Row(
                                    children: [
                                      Gap(20),
                                      Text(
                                        'Managers',
                                        style: TextStyle(
                                          decoration: TextDecoration.none,
                                          fontSize: 32,
                                          color: Color(0xff373030),
                                          fontFamily: 'Galano',
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Gap(20),
                                      Expanded(
                                        child: TextField(
                                          controller: ControllerManager()
                                              .searchManagerController,
                                          decoration: InputDecoration(
                                            suffixIcon: ControllerManager()
                                                    .searchManagerController
                                                    .text
                                                    .isNotEmpty
                                                ? IconButton(
                                                    icon: Icon(Icons.close,
                                                        color: Colors.black),
                                                    onPressed: () {
                                                      // Clear the text field
                                                      setState(() {
                                                        ControllerManager()
                                                            .searchManagerController
                                                            .clear();
                                                        final branchProvider =
                                                            Provider.of<
                                                                    BranchProvider>(
                                                                context,
                                                                listen: false);
                                                        // When clearing the search, reset the results to the full list
                                                        if (_tabController
                                                                .index ==
                                                            0) {
                                                          branchProvider
                                                              .searchActiveBranch(
                                                                  '',
                                                                  loggedInUserId);
                                                        } else if (_tabController
                                                                .index ==
                                                            1) {
                                                          branchProvider
                                                              .searchArchiveBranch(
                                                                  '',
                                                                  loggedInUserId);
                                                        }
                                                      });
                                                    },
                                                  )
                                                : null,
                                            hintText: 'Search',
                                            prefixIcon: Icon(Icons.search),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 8.0,
                                                    horizontal: 16.0),
                                            isDense: true,
                                            border: OutlineInputBorder(
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
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              borderSide: const BorderSide(
                                                color: Color(0xFFD1E1FF),
                                                width: 1.5,
                                              ),
                                            ),
                                          ),
                                          onChanged: (value) {
                                            setState(() {
                                              // Update the search with the current input
                                              final branchProvider =
                                                  Provider.of<BranchProvider>(
                                                      context,
                                                      listen: false);
                                              if (_tabController.index == 0) {
                                                branchProvider
                                                    .searchActiveBranch(
                                                        value, loggedInUserId);
                                              } else if (_tabController.index ==
                                                  1) {
                                                branchProvider
                                                    .searchArchiveBranch(
                                                        value, loggedInUserId);
                                              }
                                            });
                                          },
                                        ),
                                      ),
                                      Gap(20),
                                      _isRightPanelVisible == false
                                          ? ElevatedButton(
                                              onPressed: () =>
                                                  showAddNewBranchDialog(
                                                      context, loggedInUserId!),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Color(0xFF0038FF),
                                                padding: EdgeInsets.all(20),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              child: Text(
                                                'Add new branch',
                                                style: TextStyle(
                                                  fontSize: 17,
                                                  color: Colors.white,
                                                  fontFamily: 'Galano',
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            )
                                          : Tooltip(
                                              message: 'Add new branch',
                                              child: IconButton(
                                                onPressed: () =>
                                                    showAddNewBranchDialog(
                                                        context,
                                                        loggedInUserId!),
                                                icon: Icon(Icons.add,
                                                    color: Colors.white),
                                                style: IconButton.styleFrom(
                                                  backgroundColor:
                                                      Color(0xFF0038FF),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8), // Rounded square shape
                                                  ),
                                                ),
                                              ),
                                            ),
                                    ],
                                  )
                                : Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Managers',
                                            style: TextStyle(
                                              decoration: TextDecoration.none,
                                              fontSize:
                                                  ResponsiveSizes.titleTextSize(
                                                      sizeInfo),
                                              color: Color(0xff373030),
                                              fontFamily: 'Galano',
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          Tooltip(
                                            message: 'Add new branch',
                                            child: IconButton(
                                              onPressed: () =>
                                                  showAddNewBranchDialog(
                                                      context, loggedInUserId!),
                                              icon: Icon(Icons.add,
                                                  color: Colors.white),
                                              style: IconButton.styleFrom(
                                                backgroundColor:
                                                    Color(0xFF0038FF),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8), // Rounded square shape
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      Gap(10),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: TextField(
                                              controller: ControllerManager()
                                                  .searchManagerController,
                                              decoration: InputDecoration(
                                                suffixIcon: ControllerManager()
                                                        .searchManagerController
                                                        .text
                                                        .isNotEmpty
                                                    ? IconButton(
                                                        icon: Icon(Icons.close,
                                                            color:
                                                                Colors.black),
                                                        onPressed: () {
                                                          // Clear the text field
                                                          setState(() {
                                                            ControllerManager()
                                                                .searchManagerController
                                                                .clear();
                                                            final branchProvider =
                                                                Provider.of<
                                                                        BranchProvider>(
                                                                    context,
                                                                    listen:
                                                                        false);
                                                            // When clearing the search, reset the results to the full list
                                                            if (_tabController
                                                                    .index ==
                                                                0) {
                                                              branchProvider
                                                                  .searchActiveBranch(
                                                                      '',
                                                                      loggedInUserId);
                                                            } else if (_tabController
                                                                    .index ==
                                                                1) {
                                                              branchProvider
                                                                  .searchArchiveBranch(
                                                                      '',
                                                                      loggedInUserId);
                                                            }
                                                          });
                                                        },
                                                      )
                                                    : null,
                                                hintText: 'Search',
                                                prefixIcon: Icon(Icons.search),
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 8.0,
                                                        horizontal: 16.0),
                                                isDense: true,
                                                border: OutlineInputBorder(
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
                                                focusedBorder:
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
                                                setState(() {
                                                  // Update the search with the current input
                                                  final branchProvider =
                                                      Provider.of<
                                                              BranchProvider>(
                                                          context,
                                                          listen: false);
                                                  if (_tabController.index ==
                                                      0) {
                                                    branchProvider
                                                        .searchActiveBranch(
                                                            value,
                                                            loggedInUserId);
                                                  } else if (_tabController
                                                          .index ==
                                                      1) {
                                                    branchProvider
                                                        .searchArchiveBranch(
                                                            value,
                                                            loggedInUserId);
                                                  }
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                            Gap(10),
                            CustomTabBar(tabController: _tabController),
                            Expanded(
                              child: TabBarView(
                                controller: _tabController,
                                children: [
                                  ActiveBranchesCategory(
                                    onCardTap: (Branch branch) {
                                      // Pass the branch ID directly
                                      rightpanelController.showRightPanel();
                                      selectedBranch = branch;

                                      // Find the matching hiring manager from the local list
                                      var matchingHiringManagers =
                                          hiringManagerProvider.hiringManagers
                                              .where((manager) =>
                                                  manager.branchId ==
                                                  selectedBranch!.id)
                                              .toList();

                                      if (matchingHiringManagers.isNotEmpty) {
                                        // Handle the case where a matching hiring manager is found
                                        var matchingManager =
                                            matchingHiringManagers.first;
                                        print(
                                            "Hiring Manager: ${matchingManager.fname} ${matchingManager.lname} - Email: ${matchingManager.email}");
                                      } else {
                                        print(
                                            "No hiring manager found for branch ${selectedBranch!.branchName}.");
                                      }

                                      // Fetch staff for the selected branch
                                      staffProvider
                                          .fetchStaffByBranch(loggedInUserId!,
                                              selectedBranch!.id)
                                          .then((_) {
                                        // Handle successful fetch if necessary
                                      }).catchError((error) {
                                        print("Error fetching staff: $error");
                                      });

                                      _isRightPanelVisible = true;
                                    },
                                  ),
                                  ArchiveBranchesCategory(
                                    onCardTap: (Branch branch) {
                                      // Pass the branch ID directly
                                      rightpanelController.showRightPanel();
                                      selectedBranch = branch;

                                      // Find the matching hiring manager from the local list
                                      var matchingHiringManagers =
                                          hiringManagerProvider.hiringManagers
                                              .where((manager) =>
                                                  manager.branchId ==
                                                  selectedBranch!.id)
                                              .toList();

                                      if (matchingHiringManagers.isNotEmpty) {
                                        // Handle the case where a matching hiring manager is found
                                        var matchingManager =
                                            matchingHiringManagers.first;
                                        print(
                                            "Hiring Manager: ${matchingManager.fname} ${matchingManager.lname} - Email: ${matchingManager.email}");
                                      } else {
                                        print(
                                            "No hiring manager found for branch ${selectedBranch!.branchName}.");
                                      }

                                      // Fetch staff for the selected branch
                                      staffProvider
                                          .fetchStaffByBranch(loggedInUserId!,
                                              selectedBranch!.id)
                                          .then((_) {
                                        // Handle successful fetch if necessary
                                      }).catchError((error) {
                                        print("Error fetching staff: $error");
                                      });

                                      _isRightPanelVisible = true;
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LayoutBuilder(
                            builder: (context, constraints) {
                              double screenWidth = constraints.maxWidth;
                              double textFieldWidth = screenWidth * 0.7;
                              double spacing = screenWidth > 600 ? 20 : 10;

                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Managers',
                                        style: TextStyle(
                                          decoration: TextDecoration.none,
                                          fontSize:
                                              ResponsiveSizes.titleTextSize(
                                                  sizeInfo),
                                          color: Color(0xff373030),
                                          fontFamily: 'Galano',
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Tooltip(
                                        message: 'Add new branch',
                                        child: IconButton(
                                          onPressed: () =>
                                              showAddNewBranchDialog(
                                                  context, loggedInUserId!),
                                          icon: Icon(Icons.add,
                                              color: Colors.white),
                                          style: IconButton.styleFrom(
                                            backgroundColor: Color(0xFF0038FF),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      8), // Rounded square shape
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Gap(10),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: ControllerManager()
                                              .searchManagerController,
                                          decoration: InputDecoration(
                                            suffixIcon: ControllerManager()
                                                    .searchManagerController
                                                    .text
                                                    .isNotEmpty
                                                ? IconButton(
                                                    icon: Icon(Icons.close,
                                                        color: Colors.black),
                                                    onPressed: () {
                                                      setState(() {
                                                        ControllerManager()
                                                            .searchManagerController
                                                            .clear();
                                                      });
                                                      final branchProvider =
                                                          Provider.of<
                                                                  BranchProvider>(
                                                              context,
                                                              listen: false);
                                                      if (_tabController
                                                              .index ==
                                                          0) {
                                                        branchProvider
                                                            .searchActiveBranch(
                                                                '',
                                                                loggedInUserId);
                                                      } else if (_tabController
                                                              .index ==
                                                          1) {
                                                        branchProvider
                                                            .searchArchiveBranch(
                                                                '',
                                                                loggedInUserId);
                                                      }
                                                    },
                                                  )
                                                : null,
                                            hintText: 'Search',
                                            prefixIcon:
                                                const Icon(Icons.search),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 8.0,
                                                    horizontal: 16.0),
                                            isDense: true,
                                            border: OutlineInputBorder(
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
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              borderSide: const BorderSide(
                                                color: Color(0xFFD1E1FF),
                                                width: 1.5,
                                              ),
                                            ),
                                          ),
                                          onChanged: (value) {
                                            setState(() {});
                                            final branchProvider =
                                                Provider.of<BranchProvider>(
                                                    context,
                                                    listen: false);
                                            if (_tabController.index == 0) {
                                              branchProvider.searchActiveBranch(
                                                  value, loggedInUserId);
                                            } else if (_tabController.index ==
                                                1) {
                                              branchProvider
                                                  .searchArchiveBranch(
                                                      value, loggedInUserId);
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                          Gap(10),
                          CustomTabBar(tabController: _tabController),
                          Expanded(
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                ActiveBranchesCategory(
                                  onCardTap: (Branch branch) {
                                    selectedBranch = branch;
                                    // Fetch staff for the selected branch
                                    staffProvider
                                        .fetchStaffByBranch(
                                            loggedInUserId!, selectedBranch!.id)
                                        .then((_) {
                                      // Handle successful fetch if necessary
                                    }).catchError((error) {
                                      print("Error fetching staff: $error");
                                    });
                                    showModalBottomSheet(
                                      scrollControlDisabledMaxHeightRatio: 0.9,
                                      showDragHandle: true,
                                      backgroundColor: Colors.white,
                                      enableDrag: true,
                                      elevation: 1,
                                      context: context,
                                      builder: (context) {
                                        return Container(
                                          padding: const EdgeInsets.all(20.0),
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                          ),
                                          child:
                                              Consumer<HiringManagerProvider>(
                                            builder: (context,
                                                hiringManagerProvider, child) {
                                              // Fetch all hiring managers
                                              List<HiringManager>
                                                  hiringManagers =
                                                  hiringManagerProvider
                                                      .hiringManagers;

                                              // Find the hiring manager that matches the selected branch's id
                                              HiringManager?
                                                  matchingHiringManager =
                                                  hiringManagers.firstWhere(
                                                (manager) =>
                                                    manager.branchId ==
                                                    selectedBranch?.id,
                                                orElse: () => HiringManager(
                                                  // Provide a default instance here
                                                  fname: '',
                                                  lname: '',
                                                  email: '',
                                                  password: '',
                                                  phoneNum: '',
                                                  branchId: '',
                                                  created_at: Timestamp.now(),
                                                  created_by: '',
                                                ),
                                              );

                                              // Conditional check to handle null
                                              if (matchingHiringManager ==
                                                  null) {
                                                return Center(
                                                    child: Text(
                                                        "No hiring manager found for this branch"));
                                              }

                                              return Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            selectedBranch!
                                                                .branchName,
                                                            style: TextStyle(
                                                                fontSize: ResponsiveSizes
                                                                    .titleTextSize(
                                                                        sizeInfo),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          selectedBranch!.isMain
                                                              ? Text(
                                                                  "Main Branch",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        ResponsiveSizes.bodyTextSize(sizeInfo) *
                                                                            0.9,
                                                                    color: const Color
                                                                        .fromARGB(
                                                                        255,
                                                                        18,
                                                                        129,
                                                                        21),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                  ),
                                                                )
                                                              : SizedBox(),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Gap(20),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        "Hiring Manager",
                                                        style: TextStyle(
                                                          fontSize:
                                                              ResponsiveSizes
                                                                  .bodyTextSize(
                                                                      sizeInfo),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Gap(5),
                                                  Container(
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                      color: Colors.transparent,
                                                      border: Border.all(
                                                          color: Colors
                                                              .grey.shade300),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: Stack(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10.0),
                                                          child: Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              CircleAvatar(
                                                                backgroundColor:
                                                                    Color(0xFF083af8)
                                                                        .withOpacity(
                                                                            0.3),
                                                                foregroundColor:
                                                                    Color(
                                                                        0xFF083af8),
                                                                child: Text(
                                                                  "${matchingHiringManager.fname[0]}${matchingHiringManager.lname[0]}",
                                                                ),
                                                              ),
                                                              Gap(10),
                                                              Expanded(
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        Expanded(
                                                                          child:
                                                                              Text(
                                                                            "${matchingHiringManager.fname} ${matchingHiringManager.lname}",
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: ResponsiveSizes.bodyTextSize(sizeInfo),
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                            softWrap:
                                                                                true,
                                                                            overflow:
                                                                                TextOverflow.visible, // Ensures proper text wrap
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Gap(5),
                                                                    Row(
                                                                      children: [
                                                                        Icon(
                                                                          Icons
                                                                              .email_rounded,
                                                                          color:
                                                                              Colors.grey,
                                                                          size:
                                                                              ResponsiveSizes.bodyTextSize(sizeInfo),
                                                                        ),
                                                                        Expanded(
                                                                          child:
                                                                              Text(
                                                                            " ${matchingHiringManager.email}",
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.grey,
                                                                              fontSize: ResponsiveSizes.bodyTextSize(sizeInfo),
                                                                            ),
                                                                            softWrap:
                                                                                true,
                                                                            overflow:
                                                                                TextOverflow.visible,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    if (matchingHiringManager
                                                                            .phoneNum !=
                                                                        null)
                                                                      Row(
                                                                        children: [
                                                                          Icon(
                                                                            Icons.phone,
                                                                            color:
                                                                                Colors.grey,
                                                                            size:
                                                                                ResponsiveSizes.bodyTextSize(sizeInfo),
                                                                          ),
                                                                          Expanded(
                                                                            child:
                                                                                Text(
                                                                              " ${matchingHiringManager.phoneNum}",
                                                                              style: TextStyle(
                                                                                color: Colors.grey,
                                                                                fontSize: ResponsiveSizes.bodyTextSize(sizeInfo),
                                                                              ),
                                                                              softWrap: true,
                                                                              overflow: TextOverflow.visible, // Ensures proper text wrap
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Positioned(
                                                          top: 2,
                                                          right: 2,
                                                          child:
                                                              PopupMenuButton(
                                                            icon: Icon(
                                                              Icons.more_vert,
                                                              color:
                                                                  Colors.grey,
                                                              size: 14,
                                                            ), // Icon for the popup menu
                                                            itemBuilder: (BuildContext
                                                                    context) =>
                                                                <PopupMenuEntry>[
                                                              PopupMenuItem(
                                                                value:
                                                                    'edit_hr',
                                                                child: Row(
                                                                  children: [
                                                                    Icon(
                                                                        Icons
                                                                            .edit,
                                                                        color: Colors
                                                                            .grey),
                                                                    SizedBox(
                                                                        width:
                                                                            8),
                                                                    Text(
                                                                        'Edit'),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                            onSelected:
                                                                (value) {
                                                              if (value ==
                                                                  'edit_hr') {
                                                                // Handle edit action here
                                                                print(
                                                                    'Edit option selected');
                                                              }
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(height: 20),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "Staff Members",
                                                        style: TextStyle(
                                                          fontSize:
                                                              ResponsiveSizes
                                                                  .bodyTextSize(
                                                                      sizeInfo),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      IconButton(
                                                          tooltip:
                                                              "Add new staff",
                                                          onPressed: () =>
                                                              showAddNewStaffDialog(
                                                                  context,
                                                                  loggedInUserId!),
                                                          icon: Icon(Icons.add,
                                                              color:
                                                                  Colors.black))
                                                    ],
                                                  ),
                                                  Gap(5),
                                                  Expanded(
                                                    child:
                                                        Consumer<StaffProvider>(
                                                            builder: (context,
                                                                staffProvider,
                                                                child) {
                                                      if (staffProvider
                                                          .isLoading) {
                                                        return Expanded(
                                                          child:
                                                              ListView.builder(
                                                            itemCount:
                                                                4, // Show 5 shimmer loading items
                                                            itemBuilder:
                                                                (BuildContext
                                                                        context,
                                                                    int index) {
                                                              return Shimmer
                                                                  .fromColors(
                                                                baseColor:
                                                                    Colors.grey[
                                                                        200]!,
                                                                highlightColor:
                                                                    Colors.grey[
                                                                        100]!,
                                                                child:
                                                                    Container(
                                                                  margin: const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          5),
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          16.0),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                            .grey[
                                                                        200], // Grey background for the shimmer
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10.0),
                                                                  ),
                                                                  height:
                                                                      80, // Height of each placeholder card
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        );
                                                      }

                                                      if (staffProvider
                                                          .staffMembers
                                                          .isEmpty) {
                                                        return Center(
                                                            child: Text(
                                                                "No staff added yet",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .grey,
                                                                    fontSize:
                                                                        12)));
                                                      }
                                                      return ListView.builder(
                                                        shrinkWrap: true,
                                                        itemCount: staffProvider
                                                            .staffMembers
                                                            .length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          final staff = staffProvider
                                                                  .staffMembers[
                                                              index]; // Access each staff member
                                                          return Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    bottom: 5),
                                                            width:
                                                                double.infinity,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors
                                                                  .transparent,
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .grey
                                                                      .shade300),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                            child: Stack(
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          10.0),
                                                                  child: Row(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      CircleAvatar(
                                                                        backgroundColor:
                                                                            Color(0xFFff9800).withOpacity(0.3),
                                                                        foregroundColor:
                                                                            Color(0xFFfd7206),
                                                                        child:
                                                                            Text(
                                                                          "${staff.fname[0]}${staff.lname[0]}",
                                                                        ),
                                                                      ),
                                                                      Gap(10),
                                                                      Expanded(
                                                                        child:
                                                                            Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              "${staff.fname} ${staff.lname}",
                                                                              style: TextStyle(
                                                                                fontSize: ResponsiveSizes.bodyTextSize(sizeInfo),
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                              softWrap: true,
                                                                              overflow: TextOverflow.visible, // Allow text wrapping
                                                                            ),
                                                                            Gap(5),
                                                                            Row(
                                                                              children: [
                                                                                Icon(
                                                                                  Icons.email_rounded,
                                                                                  color: Colors.grey,
                                                                                  size: ResponsiveSizes.noteTextSize(sizeInfo),
                                                                                ),
                                                                                Expanded(
                                                                                  child: Text(
                                                                                    " ${staff.email}",
                                                                                    style: TextStyle(
                                                                                      color: Colors.grey,
                                                                                      fontSize: ResponsiveSizes.noteTextSize(sizeInfo),
                                                                                    ),
                                                                                    softWrap: true,
                                                                                    overflow: TextOverflow.visible, // Allow text wrapping
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            if (staff.phoneNum !=
                                                                                null)
                                                                              Row(
                                                                                children: [
                                                                                  Icon(
                                                                                    Icons.phone,
                                                                                    color: Colors.grey,
                                                                                    size: ResponsiveSizes.noteTextSize(sizeInfo),
                                                                                  ),
                                                                                  Expanded(
                                                                                    child: Text(
                                                                                      " ${staff.phoneNum}",
                                                                                      style: TextStyle(
                                                                                        color: Colors.grey,
                                                                                        fontSize: ResponsiveSizes.noteTextSize(sizeInfo),
                                                                                      ),
                                                                                      softWrap: true,
                                                                                      overflow: TextOverflow.visible, // Allow text wrapping
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Positioned(
                                                                  top: 2,
                                                                  right: 2,
                                                                  child:
                                                                      PopupMenuButton(
                                                                    icon: Icon(
                                                                      Icons
                                                                          .more_vert,
                                                                      color: Colors
                                                                          .grey,
                                                                      size: 14,
                                                                    ),
                                                                    itemBuilder:
                                                                        (BuildContext
                                                                                context) =>
                                                                            <PopupMenuEntry>[
                                                                      PopupMenuItem(
                                                                        value:
                                                                            'edit_staff',
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Icon(Icons.edit,
                                                                                color: Colors.grey),
                                                                            SizedBox(width: 8),
                                                                            Text('Edit'),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                    onSelected:
                                                                        (value) {
                                                                      if (value ==
                                                                          'edit_staff') {
                                                                        // Handle edit action here
                                                                        print(
                                                                            'Edit option selected');
                                                                      }
                                                                    },
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    }),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                                ArchiveBranchesCategory(
                                  onCardTap: (Branch branch) {
                                    selectedBranch = branch;
                                      staffProvider
                                        .fetchStaffByBranch(
                                            loggedInUserId!, selectedBranch!.id)
                                        .then((_) {
                                      // Handle successful fetch if necessary
                                    }).catchError((error) {
                                      print("Error fetching staff: $error");
                                    });
                                    showModalBottomSheet(
                                      scrollControlDisabledMaxHeightRatio: 0.9,
                                      showDragHandle: true,
                                      backgroundColor: Colors.white,
                                      enableDrag: true,
                                      elevation: 1,
                                      context: context,
                                      builder: (context) {
                                        return Container(
                                          padding: const EdgeInsets.all(20.0),
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                          ),
                                          child:
                                              Consumer<HiringManagerProvider>(
                                            builder: (context,
                                                hiringManagerProvider, child) {
                                              // Fetch all hiring managers
                                              List<HiringManager>
                                                  hiringManagers =
                                                  hiringManagerProvider
                                                      .hiringManagers;

                                              // Find the hiring manager that matches the selected branch's id
                                              HiringManager?
                                                  matchingHiringManager =
                                                  hiringManagers.firstWhere(
                                                (manager) =>
                                                    manager.branchId ==
                                                    selectedBranch?.id,
                                                orElse: () => HiringManager(
                                                  // Provide a default instance here
                                                  fname: '',
                                                  lname: '',
                                                  email: '',
                                                  password: '',
                                                  phoneNum: '',
                                                  branchId: '',
                                                  created_at: Timestamp.now(),
                                                  created_by: '',
                                                ),
                                              );

                                              // Conditional check to handle null
                                              if (matchingHiringManager ==
                                                  null) {
                                                return Center(
                                                    child: Text(
                                                        "No hiring manager found for this branch"));
                                              }

                                              return Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            selectedBranch!
                                                                .branchName,
                                                            style: TextStyle(
                                                                fontSize: ResponsiveSizes
                                                                    .titleTextSize(
                                                                        sizeInfo),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          selectedBranch!.isMain
                                                              ? Text(
                                                                  "Main Branch",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        ResponsiveSizes.bodyTextSize(sizeInfo) *
                                                                            0.9,
                                                                    color: const Color
                                                                        .fromARGB(
                                                                        255,
                                                                        18,
                                                                        129,
                                                                        21),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                  ),
                                                                )
                                                              : SizedBox(),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Gap(20),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        "Hiring Manager",
                                                        style: TextStyle(
                                                          fontSize:
                                                              ResponsiveSizes
                                                                  .bodyTextSize(
                                                                      sizeInfo),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Gap(5),
                                                  Container(
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                      color: Colors.transparent,
                                                      border: Border.all(
                                                          color: Colors
                                                              .grey.shade300),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: Stack(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10.0),
                                                          child: Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              CircleAvatar(
                                                                backgroundColor:
                                                                    Color(0xFF083af8)
                                                                        .withOpacity(
                                                                            0.3),
                                                                foregroundColor:
                                                                    Color(
                                                                        0xFF083af8),
                                                                child: Text(
                                                                  "${matchingHiringManager.fname[0]}${matchingHiringManager.lname[0]}",
                                                                ),
                                                              ),
                                                              Gap(10),
                                                              Expanded(
                                                                // Added Expanded here to make the column occupy available space
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        Expanded(
                                                                          child:
                                                                              Text(
                                                                            "${matchingHiringManager.fname} ${matchingHiringManager.lname}",
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: ResponsiveSizes.bodyTextSize(sizeInfo),
                                                                              fontWeight: FontWeight.bold,
                                                                            ),
                                                                            softWrap:
                                                                                true,
                                                                            overflow:
                                                                                TextOverflow.visible, // Ensures proper text wrap
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Gap(5),
                                                                    Row(
                                                                      children: [
                                                                        Icon(
                                                                          Icons
                                                                              .email_rounded,
                                                                          color:
                                                                              Colors.grey,
                                                                          size:
                                                                              ResponsiveSizes.bodyTextSize(sizeInfo),
                                                                        ),
                                                                        Expanded(
                                                                          child:
                                                                              Text(
                                                                            " ${matchingHiringManager.email}",
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.grey,
                                                                              fontSize: ResponsiveSizes.bodyTextSize(sizeInfo),
                                                                            ),
                                                                            softWrap:
                                                                                true,
                                                                            overflow:
                                                                                TextOverflow.visible, // Ensures proper text wrap
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    if (matchingHiringManager
                                                                            .phoneNum !=
                                                                        null)
                                                                      Row(
                                                                        children: [
                                                                          Icon(
                                                                            Icons.phone,
                                                                            color:
                                                                                Colors.grey,
                                                                            size:
                                                                                ResponsiveSizes.bodyTextSize(sizeInfo),
                                                                          ),
                                                                          Expanded(
                                                                            child:
                                                                                Text(
                                                                              " ${matchingHiringManager.phoneNum}",
                                                                              style: TextStyle(
                                                                                color: Colors.grey,
                                                                                fontSize: ResponsiveSizes.bodyTextSize(sizeInfo),
                                                                              ),
                                                                              softWrap: true,
                                                                              overflow: TextOverflow.visible, // Ensures proper text wrap
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Positioned(
                                                          top: 2,
                                                          right: 2,
                                                          child:
                                                              PopupMenuButton(
                                                            icon: Icon(
                                                              Icons.more_vert,
                                                              color:
                                                                  Colors.grey,
                                                              size: 14,
                                                            ), // Icon for the popup menu
                                                            itemBuilder: (BuildContext
                                                                    context) =>
                                                                <PopupMenuEntry>[
                                                              PopupMenuItem(
                                                                value:
                                                                    'edit_hr',
                                                                child: Row(
                                                                  children: [
                                                                    Icon(
                                                                        Icons
                                                                            .edit,
                                                                        color: Colors
                                                                            .grey),
                                                                    SizedBox(
                                                                        width:
                                                                            8),
                                                                    Text(
                                                                        'Edit'),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                            onSelected:
                                                                (value) {
                                                              if (value ==
                                                                  'edit_hr') {
                                                                // Handle edit action here
                                                                print(
                                                                    'Edit option selected');
                                                              }
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(height: 20),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "Staff Members",
                                                        style: TextStyle(
                                                          fontSize:
                                                              ResponsiveSizes
                                                                  .bodyTextSize(
                                                                      sizeInfo),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      IconButton(
                                                          tooltip:
                                                              "Add new staff",
                                                          onPressed: () =>
                                                              showAddNewStaffDialog(
                                                                  context,
                                                                  loggedInUserId!),
                                                          icon: Icon(Icons.add,
                                                              color:
                                                                  Colors.black))
                                                    ],
                                                  ),
                                                  Gap(5),
                                                 Expanded(
                                                    child:
                                                        Consumer<StaffProvider>(
                                                            builder: (context,
                                                                staffProvider,
                                                                child) {
                                                      if (staffProvider
                                                          .isLoading) {
                                                        return Expanded(
                                                          child:
                                                              ListView.builder(
                                                            itemCount:
                                                                4, // Show 5 shimmer loading items
                                                            itemBuilder:
                                                                (BuildContext
                                                                        context,
                                                                    int index) {
                                                              return Shimmer
                                                                  .fromColors(
                                                                baseColor:
                                                                    Colors.grey[
                                                                        200]!,
                                                                highlightColor:
                                                                    Colors.grey[
                                                                        100]!,
                                                                child:
                                                                    Container(
                                                                  margin: const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          5),
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          16.0),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                            .grey[
                                                                        200], // Grey background for the shimmer
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10.0),
                                                                  ),
                                                                  height:
                                                                      80, // Height of each placeholder card
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        );
                                                      }

                                                      if (staffProvider
                                                          .staffMembers
                                                          .isEmpty) {
                                                        return Center(
                                                            child: Text(
                                                                "No staff added yet",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .grey,
                                                                    fontSize:
                                                                        12)));
                                                      }
                                                      return ListView.builder(
                                                        shrinkWrap: true,
                                                        itemCount: staffProvider
                                                            .staffMembers
                                                            .length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          final staff = staffProvider
                                                                  .staffMembers[
                                                              index]; // Access each staff member
                                                          return Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    bottom: 5),
                                                            width:
                                                                double.infinity,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors
                                                                  .transparent,
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .grey
                                                                      .shade300),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                            child: Stack(
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          10.0),
                                                                  child: Row(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      CircleAvatar(
                                                                        backgroundColor:
                                                                            Color(0xFFff9800).withOpacity(0.3),
                                                                        foregroundColor:
                                                                            Color(0xFFfd7206),
                                                                        child:
                                                                            Text(
                                                                          "${staff.fname[0]}${staff.lname[0]}",
                                                                        ),
                                                                      ),
                                                                      Gap(10),
                                                                      Expanded(
                                                                        child:
                                                                            Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              "${staff.fname} ${staff.lname}",
                                                                              style: TextStyle(
                                                                                fontSize: ResponsiveSizes.bodyTextSize(sizeInfo),
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                              softWrap: true,
                                                                              overflow: TextOverflow.visible, // Allow text wrapping
                                                                            ),
                                                                            Gap(5),
                                                                            Row(
                                                                              children: [
                                                                                Icon(
                                                                                  Icons.email_rounded,
                                                                                  color: Colors.grey,
                                                                                  size: ResponsiveSizes.noteTextSize(sizeInfo),
                                                                                ),
                                                                                Expanded(
                                                                                  child: Text(
                                                                                    " ${staff.email}",
                                                                                    style: TextStyle(
                                                                                      color: Colors.grey,
                                                                                      fontSize: ResponsiveSizes.noteTextSize(sizeInfo),
                                                                                    ),
                                                                                    softWrap: true,
                                                                                    overflow: TextOverflow.visible, // Allow text wrapping
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            if (staff.phoneNum !=
                                                                                null)
                                                                              Row(
                                                                                children: [
                                                                                  Icon(
                                                                                    Icons.phone,
                                                                                    color: Colors.grey,
                                                                                    size: ResponsiveSizes.noteTextSize(sizeInfo),
                                                                                  ),
                                                                                  Expanded(
                                                                                    child: Text(
                                                                                      " ${staff.phoneNum}",
                                                                                      style: TextStyle(
                                                                                        color: Colors.grey,
                                                                                        fontSize: ResponsiveSizes.noteTextSize(sizeInfo),
                                                                                      ),
                                                                                      softWrap: true,
                                                                                      overflow: TextOverflow.visible, // Allow text wrapping
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Positioned(
                                                                  top: 2,
                                                                  right: 2,
                                                                  child:
                                                                      PopupMenuButton(
                                                                    icon: Icon(
                                                                      Icons
                                                                          .more_vert,
                                                                      color: Colors
                                                                          .grey,
                                                                      size: 14,
                                                                    ),
                                                                    itemBuilder:
                                                                        (BuildContext
                                                                                context) =>
                                                                            <PopupMenuEntry>[
                                                                      PopupMenuItem(
                                                                        value:
                                                                            'edit_staff',
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Icon(Icons.edit,
                                                                                color: Colors.grey),
                                                                            SizedBox(width: 8),
                                                                            Text('Edit'),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                    onSelected:
                                                                        (value) {
                                                                      if (value ==
                                                                          'edit_staff') {
                                                                        // Handle edit action here
                                                                        print(
                                                                            'Edit option selected');
                                                                      }
                                                                    },
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    }),
                                                  ),
                                                 ],
                                              );
                                            },
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      );
    });
  }
}
