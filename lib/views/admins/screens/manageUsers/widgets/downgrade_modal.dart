import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:huzzl_web/views/admins/constants.dart';
import 'package:huzzl_web/views/admins/controllers/menu_app_controller.dart';
import 'package:huzzl_web/views/admins/models/recent_file.dart';
import 'package:huzzl_web/views/admins/models/subscriber.dart';

void showDowngradeModal(
    BuildContext context, RecentUser subscriber, MenuAppController provider) {
  // Local variable for editing the date

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Change subscription to basic?'),
        content: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'You are about to downgrade ${subscriber.fname} ${subscriber.lname}\'s subscription to basic.',
                style: const TextStyle(fontSize: 16),
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
              try {
                // Update Firestore
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(subscriber.uid)
                    .update({
                  'subscriptionType': 'basic',
                });

                // Refresh local data
                await provider.fetchRecentUsers();

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
                EasyLoading.showSuccess('Subscription upgraded to premium!');
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error updating subscription type: $e'),
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
                EasyLoading.showError('Error updating subscription type: $e');
              }
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.redAccent),
              foregroundColor: WidgetStateProperty.all(Colors.white),
            ),
            child: const Text('Downgrade'),
          ),
        ],
      );
    },
  );
}
