import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:huzzl_web/views/admins/constants.dart';
import 'package:huzzl_web/views/admins/controllers/menu_app_controller.dart';
import 'package:huzzl_web/views/admins/models/subscriber.dart';
import 'package:intl/intl.dart';

void showEditSubscriptionModal(
    BuildContext context, Subscriber subscriber, MenuAppController provider) {
  // Local variable for editing the date
  DateTime? selectedDate = subscriber.dateSubscribed.toDate();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Edit Subscription Date'),
        content: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Editing subscription for ${subscriber.hiringManagerFirstName} ${subscriber.hiringManagerLastName}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  // Show a date picker
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: selectedDate ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    selectedDate = pickedDate;
                  }
                },
                child: const Text(
                  'Select New Date',
                  style: TextStyle(color: defaultTextColor),
                ),
              ),
              const SizedBox(height: 8),
              if (selectedDate != null)
                Text(
                  'Selected Date: ${DateFormat('MM/dd/yyyy').format(selectedDate!)}',
                  style: const TextStyle(color: Colors.black54),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            style: const ButtonStyle(
              foregroundColor: WidgetStatePropertyAll(defaultTextColor),
            ),
            onPressed: () {
              Navigator.pop(context); // Close the modal
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (selectedDate != null) {
                try {
                  // Update Firestore
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(subscriber.uid)
                      .update({
                    'dateSubscribed': Timestamp.fromDate(selectedDate!),
                  });

                  // Refresh local data
                  await provider.fetchSubscribers();

                  // Close modal
                  Navigator.pop(context);
                  EasyLoading.instance
                    ..displayDuration = const Duration(milliseconds: 1500)
                    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
                    ..loadingStyle = EasyLoadingStyle.custom
                    ..backgroundColor = const Color.fromARGB(255, 31, 150, 61)
                    ..textColor = Colors.white
                    ..fontSize = 16.0
                    ..indicatorColor = Colors.white
                    ..maskColor = Colors.black.withOpacity(0.5)
                    ..userInteractions = false
                    ..dismissOnTap = true;
                  EasyLoading.showSuccess(
                      'Subscription date updated successfully!');
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error updating subscription: $e'),
                    ),
                  );
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
                  EasyLoading.showError('Error updating subscription: $e');
                }
              }
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.blueAccent),
              foregroundColor: WidgetStateProperty.all(Colors.white),
            ),
            child: const Text('Save'),
          ),
        ],
      );
    },
  );
}
