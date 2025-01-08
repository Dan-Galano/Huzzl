import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/user-provider.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/providers/appstate.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/providers/autobuild_resume_provider.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/providers/location_provider.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/providers/resume_provider.dart';
import 'package:huzzl_web/views/job%20seekers/profile/new_profile/02%20resumeManually.dart';
import 'package:huzzl_web/views/job%20seekers/profile/new_profile/functions/file_uploader.dart';
import 'package:huzzl_web/views/job%20seekers/profile/new_profile/models/user-profile_model.dart';
import 'package:huzzl_web/views/job%20seekers/profile/new_profile/preferencesDialogs/jobtitles_dialog.dart';
import 'package:huzzl_web/views/job%20seekers/profile/new_profile/preferencesDialogs/location_dialog.dart';
import 'package:huzzl_web/views/job%20seekers/profile/new_profile/preferencesDialogs/payrate_dialog.dart';
import 'package:huzzl_web/views/job%20seekers/profile/new_profile/providers/portfolio_provider.dart';
import 'package:huzzl_web/views/job%20seekers/profile/new_profile/providers/user-profile_provider.dart';
import 'package:huzzl_web/views/job%20seekers/profile/new_profile/resumeManualPages/resume_summary-autobuild.dart';
import 'package:huzzl_web/views/job%20seekers/profile/new_profile/resumeDialogs/setupresume_dialog.dart';
import 'package:huzzl_web/widgets/loading_dialog.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shimmer/shimmer.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/widgets/open_in_newtab.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/functions/string_formatter.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart' hide PdfDocument;

import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:html' as html;
import 'package:docx_to_text/docx_to_text.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppState()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => ResumeProvider()),
        ChangeNotifierProvider(create: (context) => LocationProvider()),
        ChangeNotifierProvider(create: (context) => AutoBuildResumeProvider()),
      ],
      child: MaterialApp(
        builder: EasyLoading.init(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Galano',
          scaffoldBackgroundColor: Colors.white,
        ),
        home: ProfileScreen(),
      ),
    ),
  );
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late PdfViewerController _pdfViewerController;
  final FileUploader fileUploader = FileUploader();
  // String _userFirstName = 'Allen';
  // String _userLastName = 'Alvaro';
  // String _userFullName = 'Allen Alvaro';
  // String _userPhone = '+639561670669';
  // String _userEmail = 'alllenjjames@gmail.com';
  // String _address = '123, Zone XV, San Vicente, Urdaneta City, Pangasinan';

  String portfolioFileName = '';
  final ScreenshotController _screenshotController = ScreenshotController();

  String _extractedText = '';
  String _selectedFileType = '';

  bool hasResume = false;
  bool isResumeLoading = true;
  @override
  void initState() {
    super.initState();
    _pdfViewerController = PdfViewerController();

    // Use addPostFrameCallback to prevent calling setState() during build
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      // Fetch the user profile
      await Provider.of<UserProfileProvider>(context, listen: false)
          .fetchUserProfile(userProvider.loggedInUserId!);

      // Fetch the resume status
      hasResume = await Provider.of<ResumeProvider>(context, listen: false)
          .getResumeByJobSeekerId(userProvider.loggedInUserId!);
      isResumeLoading = false;
      // Fetch the portfolio
      await _fetchPortfolio();

      // Call setState to reflect the updates in the UI
      setState(() {});
    });
  }

  Future<void> _fetchPortfolio() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final String userId = userProvider.loggedInUserId ?? '';

    if (userId.isNotEmpty) {
      await Provider.of<PortfolioProvider>(context, listen: false)
          .fetchPortfolio(userId);

      setState(() {
        portfolioFileName =
            Provider.of<PortfolioProvider>(context, listen: false)
                    .portfolioFileName ??
                'notset';
      });
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

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'docx', 'txt'],
    );

    if (result != null && result.files.isNotEmpty) {
      final Uint8List? fileBytes = result.files.single.bytes;
      final String? fileName = result.files.single.name;

      if (fileBytes != null && fileName != null) {
        if (fileName.endsWith('.pdf')) {
          _selectedFileType = 'PDF';
          _extractFromPdf(fileBytes);
        } else if (fileName.endsWith('.docx')) {
          _selectedFileType = 'DOCX';
          _extractFromDocx(fileBytes);
        } else if (fileName.endsWith('.txt')) {
          _selectedFileType = 'TXT';
          _extractFromTxt(fileBytes);
        }
      } else {
        EasyLoading.instance
          ..displayDuration = const Duration(milliseconds: 1500)
          ..indicatorType = EasyLoadingIndicatorType.fadingCircle
          ..loadingStyle = EasyLoadingStyle.custom
          ..backgroundColor = const Color(0xFfd74a4a)
          ..textColor = Colors.white
          ..fontSize = 16.0
          ..indicatorColor = Colors.white
          ..maskColor = Colors.black.withOpacity(0.5)
          ..userInteractions = false
          ..dismissOnTap = true;
        EasyLoading.showToast(
          "⚠︎ Unable to read the file. Please check the file format or try again.",
          dismissOnTap: true,
          toastPosition: EasyLoadingToastPosition.top,
          duration: Duration(seconds: 3),
          // maskType: EasyLoadingMaskType.black,
        );
        return;
      }
    } else {
      EasyLoading.instance
        ..displayDuration = const Duration(milliseconds: 1500)
        ..indicatorType = EasyLoadingIndicatorType.fadingCircle
        ..loadingStyle = EasyLoadingStyle.custom
        ..backgroundColor = const Color(0xFfd74a4a)
        ..textColor = Colors.white
        ..fontSize = 16.0
        ..indicatorColor = Colors.white
        ..maskColor = Colors.black.withOpacity(0.5)
        ..userInteractions = false
        ..dismissOnTap = true;
      EasyLoading.showToast(
        "⚠︎ No file selected.",
        dismissOnTap: true,
        toastPosition: EasyLoadingToastPosition.top,
        duration: Duration(seconds: 3),
        // maskType: EasyLoadingMaskType.black,
      );
      return;
    }
  }

  void _extractFromTxt(Uint8List fileBytes) async {
    try {
      _showLoadingDialog(context);
      String extractedText = String.fromCharCodes(fileBytes);

      setState(() {
        _extractedText = extractedText
            .split('\n')
            .map((line) => line.trim())
            .where((line) => line.isNotEmpty)
            .map((line) => '$line')
            .join('\n');
        ;
        print("EXTRACTED TEXT: ${_extractedText}");
      });
      final autoBuildResumeProvider =
          Provider.of<AutoBuildResumeProvider>(context, listen: false);
      bool isSucess = await autoBuildResumeProvider.generateResumeContent(
          context, _extractedText);
      Navigator.pop(context);
      if (isSucess == true) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ResumePageSummary2autoBuild(
            isInitialSetup: true,
            title: 'Review your Huzzl resume',
            subtitle:
                "Review and finalize the details of your Huzzl resume before submission.",
            previousPage: () {
              Navigator.pop(context);
            },
          ),
        ));
      }
    } catch (e) {
      setState(() {
        _extractedText = 'Error during TXT extraction: $e';
      });
    }
  }

  void _extractFromPdf(Uint8List fileBytes) async {
    try {
      _showLoadingDialog(context);
      PdfDocument document = PdfDocument(inputBytes: fileBytes);
      PdfTextExtractor extractor = PdfTextExtractor(document);
      String extractedText = extractor.extractText();

      document.dispose();

      setState(() {
        _extractedText = extractedText
            .split('\n')
            .map((line) => line.trim())
            .where((line) => line.isNotEmpty)
            .map((line) => '$line')
            .join('\n');
        print("EXTRACTED TEXT: ${_extractedText}");
      });
      final autoBuildResumeProvider =
          Provider.of<AutoBuildResumeProvider>(context, listen: false);
      bool isSucess = await autoBuildResumeProvider.generateResumeContent(
          context, _extractedText);
      Navigator.pop(context);
      if (isSucess == true) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ResumePageSummary2autoBuild(
            isInitialSetup: true,
            title: 'Review your Huzzl resume',
            subtitle:
                "Review and finalize the details of your Huzzl resume before submission.",
            previousPage: () {
              Navigator.pop(context);
            },
          ),
        ));
      }
    } catch (e) {
      setState(() {
        _extractedText = 'Error during PDF extraction: $e';
      });
    }
  }

  void _extractFromDocx(Uint8List fileBytes) async {
    try {
      _showLoadingDialog(context);
      String extractedText = await docxToText(fileBytes);

      setState(() {
        _extractedText = extractedText
            .split('\n')
            .map((line) => line.trim())
            .where((line) => line.isNotEmpty)
            .map((line) => '$line')
            .join('\n');
        print("EXTRACTED TEXT: ${_extractedText}");
      });
      final autoBuildResumeProvider =
          Provider.of<AutoBuildResumeProvider>(context, listen: false);
      bool isSucess = await autoBuildResumeProvider.generateResumeContent(
          context, _extractedText);
      Navigator.pop(context);
      if (isSucess == true) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ResumePageSummary2autoBuild(
            isInitialSetup: true,
            title: 'Review your Huzzl resume',
            subtitle:
                "Review and finalize the details of your Huzzl resume before submission.",
            previousPage: () {
              Navigator.pop(context);
            },
          ),
        ));
      }
    } catch (e) {
      setState(() {
        _extractedText = 'Error during DOCX extraction: $e';
      });
    }
  }

  void _showSetupResumeDialog(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final String userId = userProvider.loggedInUserId ?? '';
    showDialog(
      context: context,
      builder: (_) => SetupResumeDialog(
        onFillManually: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ResumeManuallyPageView(
              userUid: userId,
            ),
          ));
          print("Fill manually clicked");
        },
        onUploadResume: () {
          _pickFile();
          print("Upload resume clicked");
        },
      ),
    );
  }

  // Future<void> _generateAndDownloadPdf() async {
  //   try {
  //     // Capture the widget as an image
  //     final Uint8List? imageBytes = await _screenshotController.capture();
  //     if (imageBytes == null) {
  //       print("Failed to capture screenshot.");
  //       return;
  //     }

  //     // Create a PDF document
  //     final pdf = pw.Document();

  //     // Add the screenshot image to the PDF
  //     final image = pw.MemoryImage(imageBytes);
  //     pdf.addPage(
  //       pw.Page(
  //         build: (pw.Context context) => pw.Center(
  //           child: pw.Image(image),
  //         ),
  //       ),
  //     );

  //     // Save the PDF to Uint8List
  //     final Uint8List pdfBytes = await pdf.save();

  //     // Trigger download in Flutter Web
  //     final blob = html.Blob([pdfBytes], 'application/pdf');
  //     final url = html.Url.createObjectUrlFromBlob(blob);
  //     final anchor = html.AnchorElement(href: url)
  //       ..target = 'blank'
  //       ..download = 'example.pdf'
  //       ..click();
  //     html.Url.revokeObjectUrl(url);
  //   } catch (e) {
  //     print("Error generating PDF: $e");
  //   }
  // }

  Future<void> _deletePortFolio() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    String userId = userProvider.loggedInUserId ?? '';

    if (userId.isNotEmpty) {
      await Provider.of<PortfolioProvider>(context, listen: false)
          .deletePortfolio(userId);

      setState(() {
        portfolioFileName = "notset";
      });
    }
  }

  Future<bool> _showDeleteConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor:
                  Colors.white, // Set the background color to white
              title: const Text(
                'Delete Portfolio',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: const Text(
                'Are you sure you want to delete your portfolio file?',
                style: TextStyle(color: Colors.black),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false); // Return false
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true); // Return true
                  },
                  child: const Text(
                    'Delete',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            );
          },
        ) ??
        false; // If dismissed, return false
  }

  String _getLocationText(Map<String, dynamic>? selectedLocation) {
    if (selectedLocation == null) return 'Location not set';

    // Check if specific fields are null or empty and construct the location text
    final cityName = selectedLocation['cityName'];
    final provinceName = selectedLocation['provinceName'];
    final regionName = selectedLocation['regionName'];
    final barangayName = selectedLocation['barangayName'];
    final otherLocation = selectedLocation['otherLocation'];

    // If all fields are null or empty, return 'Location not set'
    if ([cityName, provinceName, regionName, barangayName, otherLocation]
        .every((field) => field == null || field.isEmpty)) {
      return 'Location not set';
    }

    // Build the location string based on available fields
    List<String> locationParts = [];
    if (otherLocation != null && otherLocation.isNotEmpty) {
      locationParts.add(otherLocation);
    }
    if (barangayName != null && barangayName.isNotEmpty) {
      locationParts.add(barangayName);
    }
    if (cityName != null && cityName.isNotEmpty) {
      locationParts.add(cityName);
    }
    if (provinceName != null && provinceName.isNotEmpty) {
      locationParts.add(provinceName);
    }
    if (regionName != null && regionName.isNotEmpty) {
      locationParts.add(regionName);
    }

    // If there are location parts, join them with commas
    return locationParts.isNotEmpty
        ? locationParts.join(', ')
        : 'Location not set';
  }

  String _getJobTitlesText(List<String>? jobTitles) {
    if (jobTitles == null || jobTitles.isEmpty) {
      return 'No job titles selected';
    }

    // Join the job titles with a comma
    return jobTitles.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = Provider.of<UserProfileProvider>(context).userProfile;

    return Scaffold(
      backgroundColor: Colors.white,
      body: userProfile == null
          ? LoadingDialog(
              message: 'Loading, please wait...',
            )
          : SingleChildScrollView(
              child: Consumer<ResumeProvider>(
                  builder: (context, resumeProvider, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 40),
                      child: Row(),
                    ),
                    Container(
                      width: 800,
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: CircleAvatar(
                                        radius: 70,
                                        backgroundColor: Colors.grey[700],
                                        foregroundColor: Colors.white,
                                        child: userProfile?.firstName != null &&
                                                userProfile?.lastName != null
                                            ? Text(
                                                "${userProfile!.firstName![0].toUpperCase()}${userProfile!.lastName![0].toUpperCase()}",
                                                style: TextStyle(
                                                  fontSize: 50,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                            : Icon(
                                                Icons.person,
                                                size: 80,
                                                color: Colors.white,
                                              ),
                                      ),
                                    ),
                                    const SizedBox(width: 40),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${userProfile?.firstName!.toLowerCaseTrimmed().toTitleCase() ?? ''} ${userProfile?.lastName!.toLowerCaseTrimmed().toTitleCase() ?? ''}',
                                            style: const TextStyle(
                                              fontFamily: 'Galano',
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xff202855),
                                            ),
                                            maxLines: 3,
                                            overflow: TextOverflow.visible,
                                          ),
                                          const SizedBox(height: 5),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.call,
                                                size: 15,
                                                color: Colors.grey,
                                              ),
                                              const SizedBox(width: 10),
                                              Flexible(
                                                child: Text(
                                                  userProfile?.phoneNumber ??
                                                      'Phone number not set',
                                                  style: const TextStyle(
                                                    fontFamily: 'Galano',
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.grey,
                                                  ),
                                                  maxLines: 3,
                                                  overflow:
                                                      TextOverflow.visible,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.email_rounded,
                                                size: 15,
                                                color: Colors.grey,
                                              ),
                                              const SizedBox(width: 10),
                                              Flexible(
                                                child: Text(
                                                  userProfile?.email!
                                                          .toLowerCaseTrimmed() ??
                                                      'Email not set',
                                                  style: const TextStyle(
                                                    fontFamily: 'Galano',
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.grey,
                                                  ),
                                                  maxLines: 3,
                                                  overflow:
                                                      TextOverflow.visible,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.location_on_rounded,
                                                size: 15,
                                                color: Colors.grey,
                                              ),
                                              const SizedBox(width: 10),
                                              Flexible(
                                                child: Text(
                                                  _getLocationText(userProfile
                                                      ?.selectedLocation),
                                                  style: const TextStyle(
                                                    fontFamily: 'Galano',
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.grey,
                                                  ),
                                                  maxLines: 3,
                                                  overflow:
                                                      TextOverflow.visible,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: const Divider(
                              thickness: 2,
                              color: Color(0xff6297ff),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Resume",
                            style: TextStyle(
                              fontFamily: 'Galano',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff202855),
                            ),
                          ),
                          const SizedBox(height: 10),
                          isResumeLoading
                              ? Shimmer.fromColors(
                                  baseColor: Colors.grey[200]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    padding: const EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[
                                          200], // Grey background for the shimmer
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    height: 80,
                                    width: double.infinity,
                                  ),
                                )
                              : !hasResume
                                  ? SizedBox(
                                      width: double.infinity,
                                      child: TextButton(
                                        onPressed: () =>
                                            _showSetupResumeDialog(context),
                                        style: TextButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            side: BorderSide(
                                                color: Color(0xff202855)
                                                    .withOpacity(0.3)),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 30),
                                        ),
                                        child: Text(
                                          "Build your huzzl resume",
                                          style: TextStyle(
                                            fontFamily: 'Galano',
                                            fontSize: 16,
                                            color: Color(0xff202855),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.grey, width: 0.5),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(children: [
                                              Image.asset(
                                                'assets/images/resume_icon.png',
                                                height: 60,
                                              ),
                                              Gap(20),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Huzzl Resume',
                                                    style: TextStyle(
                                                      fontFamily: 'Galano',
                                                      fontSize: 18,
                                                      color: Color(0xff202855),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  Gap(3),
                                                  Text(
                                                    resumeProvider.updatedAt ??
                                                        '',
                                                    style: TextStyle(
                                                      fontFamily: 'Galano',
                                                      fontSize: 14,
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ]),
                                            Row(
                                              children: [
                                                Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .push(
                                                              MaterialPageRoute(
                                                        builder: (context) =>
                                                            ResumePageSummary2autoBuild(
                                                          title:
                                                              'Your Huzzl Resume',
                                                          subtitle:
                                                              "The information displayed here will be visible to potential employers when you apply for jobs. You can update it at any time to keep it current.",
                                                          isInitialSetup: false,
                                                          previousPage:
                                                              () async {
                                                            WidgetsBinding
                                                                .instance
                                                                .addPostFrameCallback(
                                                                    (_) async {
                                                              final userProvider =
                                                                  Provider.of<
                                                                          UserProvider>(
                                                                      context,
                                                                      listen:
                                                                          false);

                                                              await Provider.of<
                                                                          UserProfileProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .fetchUserProfile(
                                                                      userProvider
                                                                          .loggedInUserId!);

                                                              hasResume = await Provider.of<
                                                                          ResumeProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .getResumeByJobSeekerId(
                                                                      userProvider
                                                                          .loggedInUserId!);
                                                              isResumeLoading =
                                                                  false;
                                                              setState(() {});
                                                            });
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        ),
                                                      ));
                                                    },
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          "See Resume",
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xff202855),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: 5),
                                                        Icon(
                                                          Icons
                                                              .arrow_forward_ios,
                                                          size: 16,
                                                          color:
                                                              Color(0xff202855),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                          const SizedBox(height: 40),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Portfolio",
                                style: TextStyle(
                                  fontFamily: 'Galano',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff202855),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    border: portfolioFileName.isEmpty
                                        ? null
                                        : portfolioFileName == "notset"
                                            ? null
                                            : Border.all(
                                                color: Colors.grey, width: 0.5),
                                    borderRadius: BorderRadius.circular(20)),
                                child: Center(
                                  child: portfolioFileName.isEmpty
                                      ? Shimmer.fromColors(
                                          baseColor: Colors.grey[200]!,
                                          highlightColor: Colors.grey[100]!,
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            padding: const EdgeInsets.all(10.0),
                                            decoration: BoxDecoration(
                                              color: Colors.grey[
                                                  200], // Grey background for the shimmer
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            height: 80,
                                            width: double.infinity,
                                          ),
                                        )
                                      : portfolioFileName == "notset"
                                          ? SizedBox(
                                              width: double.infinity,
                                              child: TextButton(
                                                onPressed: () async {
                                                  bool isSuccess =
                                                      await fileUploader
                                                          .uploadFile(context);
                                                  _fetchPortfolio();
                                                },
                                                style: TextButton.styleFrom(
                                                  backgroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    side: BorderSide(
                                                        color: Color(0xff202855)
                                                            .withOpacity(0.3)),
                                                  ),
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 30),
                                                ),
                                                child: Text(
                                                  "Upload your career portfolio",
                                                  style: TextStyle(
                                                    fontFamily: 'Galano',
                                                    fontSize: 16,
                                                    color: Color(0xff202855),
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.all(20.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  // ConstrainedBox(
                                                  //   constraints:
                                                  //       const BoxConstraints(
                                                  //     maxHeight: 900,
                                                  //     maxWidth: 800,
                                                  //   ),
                                                  //   child: SfPdfViewer.asset(
                                                  //     'assets/pdf/$portfolioFileName',
                                                  //     controller:
                                                  //         _pdfViewerController,
                                                  //     initialZoomLevel: 1.0,
                                                  //     canShowScrollHead: true,
                                                  //     canShowScrollStatus: true,
                                                  //     onDocumentLoaded: (details) {
                                                  //       print('Document loaded');
                                                  //       print(
                                                  //           'Portfolio Path: assets/pdf/$portfolioFileName');
                                                  //     },
                                                  //     onDocumentLoadFailed:
                                                  //         (details) {
                                                  //       print(
                                                  //           'Portfolio Path: assets/pdf/$portfolioFileName');

                                                  //       print(
                                                  //           'Document failed to load');
                                                  //     },
                                                  //   ),
                                                  // ),
                                                  Row(children: [
                                                    Image.asset(
                                                      'assets/images/portfolio_icon.png',
                                                      height: 30,
                                                    ),
                                                    Gap(10),
                                                    Text(
                                                      portfolioFileName,
                                                      style: TextStyle(
                                                        fontFamily: 'Galano',
                                                        fontSize: 16,
                                                        color:
                                                            Color(0xff202855),
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    if (portfolioFileName
                                                            .isNotEmpty &&
                                                        portfolioFileName !=
                                                            "notset") ...[
                                                      Gap(10),
                                                      IconButton(
                                                        icon: Icon(
                                                          Icons.delete,
                                                          size: 20,
                                                          color: const Color
                                                              .fromARGB(
                                                              255, 165, 66, 59),
                                                        ),
                                                        onPressed: () async {
                                                          final shouldDelete =
                                                              await _showDeleteConfirmationDialog(
                                                                  context);

                                                          if (shouldDelete) {
                                                            _deletePortFolio();
                                                          }
                                                        },
                                                      ),
                                                      Gap(5),
                                                      IconButton(
                                                        icon: Icon(
                                                          Icons.upload_file,
                                                          size: 20,
                                                          color: Colors
                                                              .amber.shade900,
                                                        ),
                                                        onPressed: () async {
                                                          bool isSuccess =
                                                              await fileUploader
                                                                  .uploadFile(
                                                                      context);
                                                          _fetchPortfolio();
                                                        },
                                                      )
                                                    ],
                                                  ]),

                                                  Row(
                                                    children: [
                                                      Align(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: TextButton(
                                                          onPressed: () =>
                                                              openPdfInNewTab(
                                                                  'assets/pdf/$portfolioFileName'),
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                "See Portfolio",
                                                                style:
                                                                    TextStyle(
                                                                  color: Color(
                                                                      0xff202855),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  width: 5),
                                                              Icon(
                                                                Icons
                                                                    .open_in_new_rounded,
                                                                size: 16,
                                                                color: Color(
                                                                    0xff202855),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 40),
                          Text(
                            "Job preferences",
                            style: TextStyle(
                              fontFamily: 'Galano',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff202855),
                            ),
                          ),
                          const SizedBox(height: 10),
                          PreferenceItem(
                            iconImage: AssetImage('assets/images/pay_rate.png'),
                            title: "Pay Rate",
                            value: userProfile.selectedPayRate?['minimum'] ==
                                        null &&
                                    userProfile.selectedPayRate?['maximum'] ==
                                        null
                                ? 'Pay rate not set'
                                : userProfile.selectedPayRate?['minimum'] ==
                                        null
                                    ? 'maximum of ${userProfile.selectedPayRate!['maximum']} ${userProfile.selectedPayRate!['rate']}'
                                    : userProfile.selectedPayRate?['maximum'] ==
                                            null
                                        ? 'minimum of ${userProfile.selectedPayRate!['minimum']} ${userProfile.selectedPayRate!['rate']}'
                                        : '${userProfile.selectedPayRate!['minimum']} - ${userProfile.selectedPayRate!['maximum']} ${userProfile.selectedPayRate!['rate']}',
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => PayRateDialog(
                                  initialRate:
                                      userProfile.selectedPayRate?['rate'] ??
                                          'per hour',
                                  initialMin: userProfile
                                          .selectedPayRate?['minimum']
                                          ?.toString() ??
                                      '',
                                  initialMax: userProfile
                                          .selectedPayRate?['maximum']
                                          ?.toString() ??
                                      '',
                                  onSave: (rate, min, max) {
                                    // Update pay rate in Firestore
                                    UserProfileProvider provider =
                                        Provider.of<UserProfileProvider>(
                                            context,
                                            listen: false);
                                    provider.updatePayRate(
                                        userProfile.uid!, rate, min, max);
                                  },
                                ),
                              );
                            },
                          ),
                          PreferenceItem(
                            iconImage: AssetImage(
                                'assets/images/location_profile.png'),
                            title: "Location",
                            value:
                                _getLocationText(userProfile?.selectedLocation),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => LocationDialog(
                                  initialLocation: {
                                    'regionName': userProfile
                                            .selectedLocation?['regionName'] ??
                                        '',
                                    'provinceName':
                                        userProfile.selectedLocation?[
                                                'provinceName'] ??
                                            '',
                                    'cityName': userProfile
                                            .selectedLocation?['cityName'] ??
                                        '',
                                    'barangayName':
                                        userProfile.selectedLocation?[
                                                'barangayName'] ??
                                            '',
                                    'otherLocation':
                                        userProfile.selectedLocation?[
                                                'otherLocation'] ??
                                            '',
                                  },
                                  onSave: (location) {
                                    // Update location in Firestore
                                    UserProfileProvider provider =
                                        Provider.of<UserProfileProvider>(
                                            context,
                                            listen: false);
                                    provider.updateLocation(
                                        userProfile.uid!, location);
                                  },
                                ),
                              );
                            },
                          ),
                          PreferenceItem(
                            iconImage:
                                AssetImage('assets/images/job_title.png'),
                            title: "Job Titles",
                            value: _getJobTitlesText(
                                userProfile?.currentSelectedJobTitles),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => JobTitlesDialog(
                                  initialJobTitles:
                                      userProfile.currentSelectedJobTitles ??
                                          [],
                                  onSave: (jobTitles) {
                                    // Update job titles in Firestore
                                    UserProfileProvider provider =
                                        Provider.of<UserProfileProvider>(
                                            context,
                                            listen: false);
                                    provider.updateJobTitles(
                                        userProfile.uid!, jobTitles);
                                  },
                                ),
                              );
                            },
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                    color: Colors.grey.shade300, width: 1),
                              ),
                            ),
                          ),
                          Gap(100),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ),
    );
  }

  // void _showModal(BuildContext context, String title, String value) {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: true,
  //     builder: (context) {
  //       return Dialog(
  //         backgroundColor: Colors.transparent,
  //         insetPadding:
  //             const EdgeInsets.symmetric(horizontal: 350, vertical: 200),
  //         child: ClipRRect(
  //           borderRadius: BorderRadius.circular(20),
  //           child: Container(
  //             padding: const EdgeInsets.all(30),
  //             color: Colors.white,
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 // Title Text
  //                 Text(
  //                   title,
  //                   style: const TextStyle(
  //                     fontFamily: 'Galano',
  //                     fontSize: 18,
  //                     fontWeight: FontWeight.bold,
  //                     color: Color(0xff202855),
  //                   ),
  //                 ),
  //                 const SizedBox(height: 10),

  //                 // Value Text
  //                 Text(
  //                   value,
  //                   style: TextStyle(
  //                     fontFamily: 'Galano',
  //                     fontSize: 16,
  //                     fontWeight: FontWeight.normal,
  //                     color: Colors.grey.shade600,
  //                   ),
  //                 ),
  //                 const SizedBox(height: 20),

  //                 const Spacer(),

  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.end,
  //                   children: [
  //                     ElevatedButton(
  //                       onPressed: () {
  //                         Navigator.of(context).pop();
  //                       },
  //                       child: const Text(
  //                         "Cancel",
  //                         style: TextStyle(
  //                           fontFamily: 'Galano',
  //                           fontSize: 16,
  //                           fontWeight: FontWeight.w600,
  //                         ),
  //                       ),
  //                       style: ElevatedButton.styleFrom(
  //                         elevation: 0,
  //                         backgroundColor: Colors.grey.shade300,
  //                         foregroundColor: Colors.black,
  //                         shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(10),
  //                         ),
  //                         padding: const EdgeInsets.symmetric(
  //                           vertical: 12,
  //                           horizontal: 20,
  //                         ),
  //                       ),
  //                     ),
  //                     const SizedBox(width: 10),
  //                     ElevatedButton(
  //                       onPressed: () {
  //                         // Add your save action here
  //                       },
  //                       child: const Text(
  //                         "Save",
  //                         style: TextStyle(
  //                           fontFamily: 'Galano',
  //                           fontSize: 16,
  //                           fontWeight: FontWeight.w600,
  //                         ),
  //                       ),
  //                       style: ElevatedButton.styleFrom(
  //                         elevation: 2,
  //                         backgroundColor: Color(0xff0038FF),
  //                         foregroundColor: Colors.white,
  //                         shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(10),
  //                         ),
  //                         padding: const EdgeInsets.symmetric(
  //                           vertical: 12,
  //                           horizontal: 30,
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
}

class PreferenceItem extends StatelessWidget {
  final ImageProvider iconImage;
  final String title;
  final String value;
  final VoidCallback onTap;

  const PreferenceItem({
    Key? key,
    required this.iconImage,
    required this.title,
    required this.value,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListTile(
            leading: Image(
              image: iconImage,
              width: 32,
              height: 32,
            ),
            title: Text(
              title,
              style: TextStyle(
                fontFamily: 'Galano',
                fontSize: 16,
                color: Color(0xff202855),
                fontWeight: FontWeight.w600,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    value.length > 25 ? value.substring(0, 25) + '...' : value,
                    style: TextStyle(
                      fontFamily: 'Galano',
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 20),
                Icon(Icons.arrow_forward_ios,
                    size: 16, color: Colors.grey.shade400),
              ],
            ),
          ),
        ),
      ),
    );
  }
}











//drafts

// Future<void> _fetchUserData() async {
  //   try {
  //     DocumentSnapshot userDoc = await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(widget.uid)
  //         .get();

  //     if (userDoc.exists) {
  //       var userData = userDoc.data() as Map<String, dynamic>?;

  //       setState(() {
  //         _userFullName =
  //             '${userData?['firstName'] ?? ''} ${userData?['lastName'] ?? ''}'
  //                 .trim();
  //         _userPhone = userData?['phoneNumber'] ?? 'No phone provided';
  //         _userEmail = userData?['email'] ?? 'No email provided';
  //         var location = userData?['location'] as Map<String, dynamic>? ?? {};
  //         _address =
  //             '${location['barangay'] ?? ''}, ${location['city'] ?? ''}, ${location['province'] ?? ''}, ${location['region'] ?? ''} ${location['otherLocation'] ?? ''}'
  //                 .trim();
  //       });
  //     }
  //   } catch (e) {
  //     print("Error fetching user data: $e");
  //   }
  // }