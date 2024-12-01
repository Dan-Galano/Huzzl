import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/user-provider.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/providers/appstate.dart';
import 'package:huzzl_web/views/job%20seekers/main_screen.dart';
import 'package:huzzl_web/widgets/buttons/blue/bluefilled_circlebutton.dart';
import 'package:huzzl_web/widgets/dropdown/lightblue_dropdown.dart';
import 'package:huzzl_web/widgets/loading_dialog.dart';
import 'package:huzzl_web/widgets/textfield/lightblue_prefix.dart';
import 'package:provider/provider.dart';

class MinimumPayPage extends StatefulWidget {
  final VoidCallback nextPage;
  final VoidCallback previousPage;
  final Function(Map<String, dynamic>) onSavePay;
  final Map<String, dynamic>? currentPayRate;
  final int noOfPages;

  const MinimumPayPage({
    super.key,
    required this.nextPage,
    required this.previousPage,
    required this.onSavePay,
    required this.currentPayRate,
    required this.noOfPages,
  });

  @override
  _MinimumPayPageState createState() => _MinimumPayPageState();
}

class _MinimumPayPageState extends State<MinimumPayPage> {
  final TextEditingController minimum = TextEditingController();
  final TextEditingController maximum = TextEditingController();
  String selectedRate = 'per hour'; // Default dropdown value

  String? validateMinMax() {
    double min = double.tryParse(minimum.text) ?? 0;
    double max = double.tryParse(maximum.text) ?? 0;
    print("$min - $max");
    if (min > max) {
      return 'Maximum cannot be smaller than Minimum';
    }
    return null;
  }

  void _submitMinPayForm() {
    if (minimum.text.isEmpty && maximum.text.isEmpty) {
      return;
    }
    if (minimum.text.isNotEmpty && maximum.text.isNotEmpty) {
      String? error = validateMinMax();
      print(error);
      if (error != null) {
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
          "⚠︎ $error",
          dismissOnTap: true,
          toastPosition: EasyLoadingToastPosition.top,
          duration: Duration(seconds: 3),
          // maskType: EasyLoadingMaskType.black,
        );
        return;
      }
    }

    Map<String, dynamic> payData = {
      'rate': selectedRate,
      'minimum': double.tryParse(minimum.text) ?? 0,
      'maximum': double.tryParse(maximum.text) ?? 0,
    };
    final appState = Provider.of<AppState>(context, listen: false);
    appState.setSelectedPayRate(payData);
    widget.onSavePay(payData);
    widget.nextPage();
  }

  @override
  void initState() {
    super.initState();
    if (widget.currentPayRate != null) {
      final payRate = widget.currentPayRate!;
      selectedRate = payRate['rate'];
      minimum.text = payRate['minimum'];
      maximum.text = payRate['maximum'];
    }
  }

  void _submitPreferences() async {
    final appState = Provider.of<AppState>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    String? userId = userProvider.loggedInUserId;

    if (userId == null) {
      print('User not logged in!');
      return;
    }

    Map<String, dynamic> jobPreferences = {
      'selectedLocation': null,
      'selectedPayRate': null,
      'currentSelectedJobTitles': null,
      'uid': userId,
    };

    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      CollectionReference usersRef = firestore.collection('users');

      await usersRef.doc(userId).set(jobPreferences, SetOptions(merge: true));
      print('Job preferences saved successfully!');

      // Show loading dialog
      _showLoadingDialog(context);

      // Delay for 3 seconds to keep the dialog visible before navigating
      await Future.delayed(Duration(seconds: 3));

      // Navigate to the next screen after the delay
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) => JobseekerMainScreen(uid: userId)),
      );
    } catch (e) {
      print('Error saving job preferences: $e');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 400.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 80.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '2/${widget.noOfPages}',
                        style: TextStyle(
                          fontSize: 20,
                          color: Color(0xff373030),
                          fontFamily: 'Galano',
                          fontWeight: FontWeight.w100,
                        ),
                      ),
                      TextButton(
                        child: Text("Skip all",
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.orange,
                                fontWeight: FontWeight.bold)),
                        onPressed: _submitPreferences,
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    'What\'s the minimum pay you\'re looking for?',
                    style: TextStyle(
                      fontSize: 22,
                      color: Color(0xff373030),
                      fontFamily: 'Galano',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'We use this to match you with jobs that pay around and above this amount.',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xff373030),
                      fontFamily: 'Galano',
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Rate",
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xff202855),
                                fontFamily: 'Galano',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 8),
                            LightBlueTextFieldDropdown(
                              isDropdown: true,
                              dropdownValue: selectedRate,
                              dropdownItems: [
                                'per hour',
                                'per day',
                                'per month',
                              ],
                              onChanged: (value) {
                                setState(() {
                                  selectedRate = value ?? 'per hour';
                                });
                              },
                              controller: TextEditingController(),
                              obscureText: false,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Minimum",
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xff202855),
                                fontFamily: 'Galano',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 8),
                            LightBluePrefix(
                              controller: minimum,
                              hintText: 'Enter amount',
                              obscureText: false,
                              prefixText: '₱ ',
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Gap(30),
                          Text(
                            "To",
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xff8E8E8E),
                              fontFamily: 'Galano',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Maximum",
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xff202855),
                                fontFamily: 'Galano',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 8),
                            LightBluePrefix(
                              controller: maximum,
                              hintText: 'Enter amount',
                              obscureText: false,
                              prefixText: '₱ ',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 100),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        child: Text("Skip",
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[700],
                                fontWeight: FontWeight.bold)),
                        onPressed: () {
                          minimum.clear();
                          maximum.clear();
                          selectedRate = 'per hour';

                          Map<String, dynamic> payData = {
                            'rate': selectedRate,
                            'minimum': minimum.text,
                            'maximum': maximum.text,
                          };
                          widget.onSavePay(payData);
                          widget.nextPage();
                        },
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                          width: 130,
                          child: BlueFilledCircleButton(
                            onPressed: _submitMinPayForm,
                            text: 'Next',
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
          Positioned(
            top: 60,
            left: 350,
            child: IconButton(
              icon: Image.asset(
                'assets/images/backbutton.png',
                width: 20,
                height: 20,
              ),
              onPressed: widget.previousPage,
            ),
          ),
        ],
      ),
    );
  }
}
