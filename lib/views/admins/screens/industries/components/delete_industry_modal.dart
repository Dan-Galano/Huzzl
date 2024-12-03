import 'package:flutter/material.dart';
import 'package:huzzl_web/views/admins/constants.dart';
import 'package:huzzl_web/views/admins/controllers/menu_app_controller.dart';
import 'package:provider/provider.dart';

Future showDeleteIndustryModal(BuildContext context, String industry) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Delete Industry'),
      content: Text('Are you sure you want to delete "$industry"?'),
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
            Provider.of<MenuAppController>(context, listen: false)
                .deleteIndustry(industry);
            Navigator.pop(context); // Close the dialog
          },
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(Colors.redAccent),
            foregroundColor: WidgetStateProperty.all(Colors.white),
          ),
          child: const Text('Delete'),
        ),
      ],
    ),
  );
}
