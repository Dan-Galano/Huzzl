import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:huzzl_web/user-provider.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/providers/appstate.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/providers/autobuild_resume_provider.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/providers/location_provider.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/providers/resume_provider.dart';
import 'package:huzzl_web/views/job%20seekers/profile/new_profile/02%20resumeManually.dart';
import 'package:huzzl_web/views/job%20seekers/profile/new_profile/resumeManualPages/resume_summary-autobuild.dart';
import 'package:huzzl_web/views/job%20seekers/profile/new_profile/widgets/setupresume_dialog.dart';
import 'package:provider/provider.dart';

import 'package:huzzl_web/widgets/loading_dialog.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shimmer/shimmer.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/widgets/open_in_newtab.dart';
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
          home: SampleScreen(),
        ),
     ),
  );
}

class SampleScreen extends StatefulWidget {
  const SampleScreen({super.key});

  @override
  State<SampleScreen> createState() => _SampleScreenState();
}

class _SampleScreenState extends State<SampleScreen> {

     String _extractedText = '';
  String _selectedFileType = '';

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
        
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => ResumePageSummary2autoBuild(
         previousPage: (){Navigator.pop(context);},
        ),));
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
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ResumePageSummary2autoBuild(
          previousPage: (){Navigator.pop(context);},
        ),));
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
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ResumePageSummary2autoBuild(
          previousPage: (){Navigator.pop(context);},
        ),));
      }
    } catch (e) {
      setState(() {
        _extractedText = 'Error during DOCX extraction: $e';
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

   void _showSetupResumeDialog(BuildContext context) {
    showDialog(
      
      context: context,
      builder: (_) => SetupResumeDialog(
        onFillManually: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => ResumeManuallyPageView(
          userUid: 'sampleUID',
        ),));
          print("Fill manually clicked");
        },
        onUploadResume: () {
          _pickFile();
          print("Upload resume clicked");
        },
      ),
    );
  }
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
      child: SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () => _showSetupResumeDialog(context),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                              color: Color(0xff202855).withOpacity(0.3)),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 50),
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
                  ),
      ),
    );
  }
}