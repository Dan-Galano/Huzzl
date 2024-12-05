import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:huzzl_web/views/recruiters/home/00%20home.dart';

class AddCardModal extends StatefulWidget {
  @override
  State<AddCardModal> createState() => _AddCardModalState();
}

class _AddCardModalState extends State<AddCardModal> {
  String selectedPaymentMethod = "Gcash";

  // Function to upgrade subscription from Basic to Premium
  Future<void> upgradeToPremium(BuildContext context) async {
    try {
      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

      if (userId.isEmpty) {
        print('No user is logged in');
        return;
      }

      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      await Future.delayed(Duration(seconds: 2));

      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      String currentSubscription = userSnapshot['subscriptionType'];

      if (currentSubscription == 'basic') {
        await Future.delayed(Duration(seconds: 2));

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({
          'subscriptionType': 'premium',
        });

        Navigator.of(context).pop(); // Dismiss the loading dialog

        // Show a success message
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Upgrade Successful'),
              content: Text('You have been successfully upgraded to Premium!'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        Navigator.of(context).pop(); // Dismiss the loading dialog
        print('User $userId is already on Premium.');
      }
    } catch (e) {
      Navigator.of(context)
          .pop(); // Dismiss the loading dialog in case of error
      print('Error upgrading to Premium: $e');
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Upgrade Failed'),
            content: Text('An error occurred while upgrading to Premium.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
  

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 400.0),
      child: Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          padding: EdgeInsets.all(30),
          height: 550,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Add New Card",
                    style: TextStyle(
                      fontFamily: 'Galano', // Font style
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.close,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedPaymentMethod = "Gcash";
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: selectedPaymentMethod == "Gcash"
                                ? Color(0xffFD7206)
                                : Color(0xff202855),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 10),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedPaymentMethod = "Gcash";
                                  });
                                },
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: selectedPaymentMethod == "Gcash"
                                          ? Color(0xffFD7206)
                                          : Color(0xff202855),
                                      width: 2,
                                    ),
                                  ),
                                  child: selectedPaymentMethod == "Gcash"
                                      ? Center(
                                          child: Container(
                                            width: 12,
                                            height: 12,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Color(0xffFD7206),
                                            ),
                                          ),
                                        )
                                      : null,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Image.asset(
                              'assets/images/gcash.png',
                              width: 30,
                              height: 30,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              "Gcash",
                              style: TextStyle(
                                  fontFamily: 'Galano',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedPaymentMethod = "Paypal";
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: selectedPaymentMethod == "Paypal"
                                ? Color(0xffFD7206)
                                : Color(0xff202855),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 10),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedPaymentMethod = "Paypal";
                                  });
                                },
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: selectedPaymentMethod == "Paypal"
                                          ? Color(0xffFD7206)
                                          : Color(0xff202855),
                                      width: 2,
                                    ),
                                  ),
                                  child: selectedPaymentMethod == "Paypal"
                                      ? Center(
                                          child: Container(
                                            width: 12,
                                            height: 12,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Color(0xffFD7206),
                                            ),
                                          ),
                                        )
                                      : null,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Image.asset(
                              'assets/images/paypal.png',
                              width: 24,
                              height: 24,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              "Paypal",
                              style: TextStyle(
                                  fontFamily: 'Galano',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),
              // Card Number
              TextField(
                decoration: InputDecoration(
                  labelText: "Card Number",
                  labelStyle: TextStyle(
                    fontFamily: 'Galano',
                    color: Color(0xff202855), // Updated color
                  ),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 255, 255, 255),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              // Name on Card
              TextField(
                decoration: InputDecoration(
                  labelText: "Name on Card",
                  labelStyle: TextStyle(
                    fontFamily: 'Galano',
                    color: Color(0xff202855), // Updated color
                  ),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 255, 255, 255),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Expiration Date and CVC
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: "MM / YY",
                        labelStyle: TextStyle(
                          fontFamily: 'Galano',
                          color: Color(0xff202855),
                        ),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 255, 255, 255),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                      keyboardType: TextInputType.datetime,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: "CVC",
                        labelStyle: TextStyle(
                          fontFamily: 'Galano',
                          color: Color(0xff202855),
                        ),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 255, 255, 255),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              Spacer(),
              // Continue Button
              Container(
                width: double.infinity,
                height: 55,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: [
                      Color(0xffFD7206),
                      Color(0xffFD7206),
                    ],
                  ),
                ),
                child: TextButton(
                  onPressed: () async {
                    // Upgrade the user's subscription when the button is pressed
                    await upgradeToPremium(context);
                    congratsModel(context);

                    // Navigator.pop(context); // Close the modal after upgrade
                    // Navigator.pop(context); // Close the modal after upgrade
                  },
                  child: const Text(
                    "Continue",
                    style: TextStyle(
                      fontFamily: 'Galano',
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void congratsModel(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Center(
          child: Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 60,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Congratulations!",
              style: TextStyle(
                fontFamily: 'Galano', // Use your custom font if desired
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "You've successfully upgraded to Premium.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Galano',
                fontSize: 16,
                color: Colors.black.withOpacity(0.7),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                Navigator.pop(context); // Close the dialog

                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) {
                      return RecruiterHomeScreen();
                    },
                  ),
                );
                // Optionally, navigate to another screen or perform an action here
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xffFD7206), // Customize color if needed
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              ),
              child: Text(
                "Continue",
                style: TextStyle(
                  fontFamily: 'Galano',
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
