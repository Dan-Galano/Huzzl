import 'package:flutter/material.dart';
import 'package:huzzl_web/widgets/buttons/blue/bluefilled_circlebutton.dart';

void showCompanyProfile(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          width: 600, // Set a specific width
          height: 250, // Set a specific height
          child: Card(
            color: Colors.white, // Set the card color to white
            elevation: 4, // Optional elevation for shadow effect
            margin: EdgeInsets.zero, // Remove default margin
            child: Padding(
              padding: const EdgeInsets.all(20), // Add padding inside the card
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Top right close button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10), // Spacing
                  // Centered content
                  Center(
                    child: Column(
                      children: const [
                        Text(
                          "Company Profile",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Galano',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30), // Spacing
                  // Button centered below text
                  Center(
                    child: BlueFilledCircleButton(
                      onPressed: () {},
                      text: "Company Profile", // Button text
                      width: 470, // Optional width for the button
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
}
