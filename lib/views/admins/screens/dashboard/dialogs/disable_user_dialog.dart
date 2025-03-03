import 'package:flutter/material.dart';
import 'package:huzzl_web/views/admins/constants.dart';
import 'package:huzzl_web/views/admins/controllers/menu_app_controller.dart';

Future showDisableUserDialog(BuildContext context, String email, String uid,
    MenuAppController controller) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Disable User'),
      content: RichText(
        text: TextSpan(
          text: 'Are you sure you want to disable this account "',
          style: const TextStyle(fontSize: 16),
          children: [
            TextSpan(
              text: email,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const TextSpan(text: '"?'),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context), // Cancel action
          child: const Text(
            'Cancel',
            style: TextStyle(color: defaultTextColor),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            // Delete the industry using the provider
            controller.disableUserAcc(uid);
            Navigator.pop(context); // Close the dialog
          },
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(Colors.redAccent),
            foregroundColor: WidgetStateProperty.all(Colors.white),
          ),
          child: const Text('Disable'),
        ),
      ],
    ),
  );
}
