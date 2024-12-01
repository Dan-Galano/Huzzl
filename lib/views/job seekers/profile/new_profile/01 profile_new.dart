import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile Screen Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProfileScreen(uid: 'sampleUid'),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _extractedText = '';
  String _userFullName = '';
  String _userPhone = '';
  String _userEmail = '';
  String _address = '';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      if (userDoc.exists) {
        var userData = userDoc.data() as Map<String, dynamic>?;

        setState(() {
          _userFullName =
              '${userData?['firstName'] ?? ''} ${userData?['lastName'] ?? ''}'
                  .trim();
          _userPhone = userData?['phoneNumber'] ?? 'No phone provided';
          _userEmail = userData?['email'] ?? 'No email provided';
          var location = userData?['location'] as Map<String, dynamic>? ?? {};
          _address =
              '${location['barangay'] ?? ''}, ${location['city'] ?? ''}, ${location['province'] ?? ''}, ${location['region'] ?? ''} ${location['otherLocation'] ?? ''}'
                  .trim();
        });
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
              child: Row(),
            ),
            Container(
              width: 800,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 55,
                        ),
                        const SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _userFullName,
                              style: const TextStyle(
                                fontFamily: 'Galano',
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff202855),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              _userPhone,
                              style: const TextStyle(
                                fontFamily: 'Galano',
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              _userEmail,
                              style: const TextStyle(
                                fontFamily: 'Galano',
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              _address,
                              style: const TextStyle(
                                fontFamily: 'Galano',
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    thickness: 2,
                    color: Color(0xff6297ff),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Resume",
                    style: TextStyle(
                      fontFamily: 'Galano',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff202855),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 30),
                      ),
                      child: Text(
                        "Build your huzzl resume",
                        style: TextStyle(
                          fontFamily: 'Galano',
                          fontSize: 16,
                          color: Color(0xff202855),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Job preferences",
                    style: TextStyle(
                      fontFamily: 'Galano',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff202855),
                    ),
                  ),
                  const SizedBox(height: 10),
                  PreferenceItem(
                    iconImage: AssetImage('assets/images/pay_rate.png'),
                    title: "Pay Rate",
                    value: "10,000 - 20,000 per month",
                    onTap: () {
                      _showModal(
                          context, "Pay Rate", "10,000 - 20,000 per month");
                    },
                  ),
                  PreferenceItem(
                    iconImage: AssetImage('assets/images/location_profile.png'),
                    title: "Location",
                    value: "123, San Vicente, Urdaneta...",
                    onTap: () {
                      _showModal(
                          context, "Location", "123, San Vicente, Urdaneta...");
                    },
                  ),
                  PreferenceItem(
                    iconImage: AssetImage('assets/images/job_title.png'),
                    title: "Job Titles",
                    value: "Accountant, Developer...",
                    onTap: () {
                      _showModal(
                          context, "Job Titles", "Accountant, Developer...");
                    },
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.grey.shade300, width: 1),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  void _showModal(BuildContext context, String title, String value) {
  showDialog(
    context: context,
    barrierDismissible: true, 
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 350, vertical: 200),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20), 
          child: Container(
            padding: const EdgeInsets.all(30),
            color: Colors.white, 
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title Text
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Galano',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff202855),
                  ),
                ),
                const SizedBox(height: 10),

                // Value Text
                Text(
                  value,
                  style: TextStyle(
                    fontFamily: 'Galano',
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 20),

                const Spacer(),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          fontFamily: 'Galano',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.grey.shade300, 
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),

                    ElevatedButton(
                      onPressed: () {
                        // Add your save action here
                      },
                      child: const Text(
                        "Save",
                        style: TextStyle(
                          fontFamily: 'Galano',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        elevation: 2,
                        backgroundColor: Color(0xff0038FF), 
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

}

class PreferenceItem extends StatelessWidget {
  final ImageProvider iconImage;
  final String title;
  final String value;
  final VoidCallback onTap;

  const PreferenceItem({
    Key? key,
    required this.iconImage,
    required this.title,
    required this.value,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListTile(
            leading: Image(
              image: iconImage,
              width: 32,
              height: 32,
            ),
            title: Text(
              title,
              style: TextStyle(
                fontFamily: 'Galano',
                fontSize: 16,
                color: Color(0xff202855),
                fontWeight: FontWeight.w600,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontFamily: 'Galano',
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(width: 20),
                Icon(Icons.arrow_forward_ios,
                    size: 16, color: Colors.grey.shade400),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
