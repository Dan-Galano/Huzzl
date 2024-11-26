import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/job%20seekers/apply/application_prov.dart';
import 'package:huzzl_web/views/job%20seekers/apply/question_fr_recruiter.dart';
import 'package:huzzl_web/views/job%20seekers/main_screen.dart';
import 'package:huzzl_web/views/job%20seekers/profile/01%20profile.dart';
import 'package:huzzl_web/widgets/buttons/blue/bluefilled_circlebutton.dart';
import 'package:huzzl_web/widgets/buttons/orange/iconbutton_back.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class ReviewDetailsScreen extends StatefulWidget {
  final String uid;
  const ReviewDetailsScreen({super.key, required this.uid});

  @override
  State<ReviewDetailsScreen> createState() => _ReviewDetailsScreenState();
}

class _ReviewDetailsScreenState extends State<ReviewDetailsScreen> {
  // Declare TextEditingControllers
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  // Function to fetch user details from Firestore
  Future<void> fetchUserDetails(String uid) async {
    try {
      // Assuming you're storing user details in a 'users' collection
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userDoc.exists) {
        // Set the values in the text controllers
        _fullNameController.text =
            (userDoc['firstName'] ?? '') + " " + (userDoc['lastName'] ?? '');
        _emailController.text = userDoc['email'] ?? '';
        _addressController.text =
            '${userDoc['location']['barangay']}, ${userDoc['location']['city']}, ${userDoc['location']['province']}, ${userDoc['location']['region']} ${userDoc['location']['otherLocation'] ?? ''}';

        _phoneController.text = userDoc['phoneNumber'] ?? '';
      }
    } catch (e) {
      // Handle any errors (e.g., network issues)
      print('Error fetching user details: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserDetails(widget.uid); // Fetch user details when the screen loads
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Gap(60),
          Center(
            child: Container(
              alignment: Alignment.centerLeft,
              width: 860,
              child: IconButtonback(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => JobseekerMainScreen(uid: widget.uid)));
                },
                iconImage: const AssetImage('assets/images/backbutton.png'),
              ),
            ),
          ),
          Center(
            child: Container(
              width: 670,
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Please review your details',
                      style: TextStyle(
                        fontSize: 24,
                        color: Color(0xff202855),
                        fontFamily: 'Galano',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Gap(5),
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Contact information',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xff202855),
                        fontFamily: 'Galano',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Text(
                          'Full name',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xff202855),
                            fontFamily: 'Galano',
                          ),
                        ),
                        Text(
                          '*',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xffFF3D3D),
                            fontFamily: 'Galano',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _fullNameController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Color(0xFFD1E1FF),
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Text(
                          'Email',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xff202855),
                            fontFamily: 'Galano',
                          ),
                        ),
                        Text(
                          '*',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xffFF3D3D),
                            fontFamily: 'Galano',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Color(0xFFD1E1FF),
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Text(
                          'Address',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xff202855),
                            fontFamily: 'Galano',
                          ),
                        ),
                        Text(
                          '*',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xffFF3D3D),
                            fontFamily: 'Galano',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Color(0xFFD1E1FF),
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Phone number',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xff202855),
                        fontFamily: 'Galano',
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Color(0xFFD1E1FF),
                          width: 1.5,
                        ),
                      ),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/images/phflag.png',
                              width: 30,
                            ),
                            SizedBox(width: 8),
                            // Text('+63', style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                      prefixIconConstraints: BoxConstraints(
                        minWidth: 0, // You can adjust these values
                        minHeight: 0,
                      ),
                    ),
                  ),
                  Gap(15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: const Text('Cancel',
                            style: TextStyle(
                              fontSize: 17,
                              color: Color(0xffFE9703),
                              fontFamily: 'Galano',
                              fontWeight: FontWeight.w700,
                            )),
                      ),
                      Gap(10),
                      ElevatedButton(
                        onPressed: () {
                          // final applicationProvider =
                          //     Provider.of<ApplicationProvider>(context,
                          //         listen: false);
                          // applicationProvider.saveReviewDetails(context);
                          // final saveToRec = Provider.of<ApplicationProvider>(
                          //     context,
                          //     listen: false);
                          // saveToRec.saveReviewDetailsInRec(context);
                          // Navigator.pushReplacement(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (_) => QuestionFromRecScreen(
                          //               uid: widget.uid,
                          //             )));
                          try {
                            // Set the values from the text controllers into the ApplicationProvider
                            final applicationProvider =
                                Provider.of<ApplicationProvider>(context,
                                    listen: false);
                            applicationProvider.fullName =
                                _fullNameController.text;
                            applicationProvider.email = _emailController.text;
                            applicationProvider.address =
                                _addressController.text;
                            applicationProvider.phoneNumber =
                                _phoneController.text;

                            // Now, call the save functions
                            applicationProvider.saveReviewDetails(context);
                            applicationProvider.saveReviewDetailsInRec(context);

                            // If saving is successful, navigate to the next screen
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      QuestionFromRecScreen(uid: widget.uid)),
                            );
                          } catch (e) {
                            // Handle error (e.g., show a Snackbar or dialog)
                            print("Error: $e");
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF0038FF),
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 15)),
                        child: const Text('Next',
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                              fontFamily: 'Galano',
                              fontWeight: FontWeight.w700,
                            )),
                      ),
                    ],
                  ),
                  Gap(20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
