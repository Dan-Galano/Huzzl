import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:huzzl_web/user-provider.dart';
import 'package:provider/provider.dart';

class FileUploader {
  // Firebase Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> uploadFile(BuildContext context) async {
    try {
      // Step 1: Pick a PDF file
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'], // Allow only PDF files
      );

      if (result != null) {
        // Step 2: Get file bytes and file name
        Uint8List? fileBytes = result.files.single.bytes; // File data
        String fileName = result.files.single.name; // File name

        if (fileBytes != null) {
          // Step 3: Get user ID from the provider (assuming the user is logged in)
          final userProvider = Provider.of<UserProvider>(context, listen: false);
          String? userId = userProvider.loggedInUserId;

          if (userId == null) {
            print('User not logged in!');
            return false; // User not logged in, return false
          }

          // Step 4: Store the filename in Firestore (under the user's document)
          await _firestore.collection('users').doc(userId).set({
            'portfolioFileName': fileName,
          }, SetOptions(merge: true)); // Merge to avoid overwriting other fields

          // Step 5: Show success message using EasyLoading
          EasyLoading.instance
            ..displayDuration = const Duration(milliseconds: 1500)
            ..indicatorType = EasyLoadingIndicatorType.fadingCircle
            ..loadingStyle = EasyLoadingStyle.custom
            ..backgroundColor = const Color.fromARGB(255, 38, 135, 57)
            ..textColor = Colors.white
            ..fontSize = 16.0
            ..indicatorColor = Colors.white
            ..maskColor = Colors.black.withOpacity(0.5)
            ..userInteractions = false
            ..dismissOnTap = true;
          EasyLoading.showToast(
            "✓ File successfully uploaded.",
            dismissOnTap: true,
            toastPosition: EasyLoadingToastPosition.top,
            duration: Duration(seconds: 3),
          );

          return true; // Success
        } else {
          // Error if file bytes are not available
          String message = ' ⚠︎ Failed to read file bytes.';
          EasyLoading.instance
            ..displayDuration = const Duration(milliseconds: 1500)
            ..indicatorType = EasyLoadingIndicatorType.fadingCircle
            ..loadingStyle = EasyLoadingStyle.custom
            ..backgroundColor = const Color.fromARGB(255, 206, 56, 56)
            ..textColor = Colors.white
            ..fontSize = 16.0
            ..indicatorColor = Colors.white
            ..maskColor = Colors.black.withOpacity(0.5)
            ..userInteractions = false
            ..dismissOnTap = true;
          EasyLoading.showToast(
            "⚠︎ $message",
            dismissOnTap: true,
            toastPosition: EasyLoadingToastPosition.top,
            duration: Duration(seconds: 3),
          );

          return false; // Return false if file bytes are not available
        }
      } else {
        // No file selected
        String message = ' ⚠︎ No file selected.';
        EasyLoading.instance
          ..displayDuration = const Duration(milliseconds: 1500)
          ..indicatorType = EasyLoadingIndicatorType.fadingCircle
          ..loadingStyle = EasyLoadingStyle.custom
          ..backgroundColor = const Color.fromARGB(255, 206, 56, 56)
          ..textColor = Colors.white
          ..fontSize = 16.0
          ..indicatorColor = Colors.white
          ..maskColor = Colors.black.withOpacity(0.5)
          ..userInteractions = false
          ..dismissOnTap = true;
        EasyLoading.showToast(
          "⚠︎ $message",
          dismissOnTap: true,
          toastPosition: EasyLoadingToastPosition.top,
          duration: Duration(seconds: 3),
        );

        return false; // Return false if no file is selected
      }
    } catch (e) {
      // Handle error during file upload
      print('Error during file upload: $e');
      EasyLoading.instance
        ..displayDuration = const Duration(milliseconds: 1500)
        ..indicatorType = EasyLoadingIndicatorType.fadingCircle
        ..loadingStyle = EasyLoadingStyle.custom
        ..backgroundColor = const Color.fromARGB(255, 206, 56, 56)
        ..textColor = Colors.white
        ..fontSize = 16.0
        ..indicatorColor = Colors.white
        ..maskColor = Colors.black.withOpacity(0.5)
        ..userInteractions = false
        ..dismissOnTap = true;
      EasyLoading.showToast(
        "⚠︎ Error during file upload: $e",
        dismissOnTap: true,
        toastPosition: EasyLoadingToastPosition.top,
        duration: Duration(seconds: 3),
      );

      return false; // Return false if an error occurred
    }
  }

}
