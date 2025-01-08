import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/widgets/textfield/lightblue_textfield.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // Controllers for each field
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController headquartersController = TextEditingController();
  final TextEditingController industryController = TextEditingController(); 
  final TextEditingController employeeController = TextEditingController(); 

  // Variables for the images
  String bannerImagePath = 'assets/images/banner.png';
  String profileImagePath = 'assets/images/profile_huzzl.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, 
      body: SingleChildScrollView( 
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Stack(
              children: [
                Container(
                  width: 800,
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Banner Image
                      GestureDetector(
                        onTap: () {}, // Allow editing the banner image
                        child: Image.asset(
                          bannerImagePath,
                          height: 180.0,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),

                      SizedBox(height: 20),

                      // Profile Image with Edit Icon
                      GestureDetector(
                        onTap: () {}, // Allow editing the profile image
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 4,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 36,
                                backgroundImage: AssetImage(profileImagePath),
                                backgroundColor: Colors.white,
                              ),
                            ),
                            // Edit Icon
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blue,
                              ),
                              child: Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 30), // Add space between images and form fields

                      // Company Name
                      Text(
                        "Company name",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff202855),
                          fontFamily: 'Galano',
                        ),
                      ),
                      LightBlueTextField(controller: companyNameController),
                      SizedBox(height: 20),

                      // Description
                      Text(
                        "Description",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff202855),
                          fontFamily: 'Galano',
                        ),
                      ),
                      LightBlueTextField(controller: descriptionController),
                      SizedBox(height: 20),

                      // Headquarters
                      Text(
                        "Headquarters",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff202855),
                          fontFamily: 'Galano',
                        ),
                      ),
                      LightBlueTextField(controller: headquartersController),
                      SizedBox(height: 20),

                      // Industry
                      Text(
                        "Industry",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff202855),
                          fontFamily: 'Galano',
                        ),
                      ),
                      LightBlueTextField(controller: industryController),
                      SizedBox(height: 20),

                      // Size
                      Text(
                        "Employee",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff202855),
                          fontFamily: 'Galano',
                        ),
                      ),
                      LightBlueTextField(controller: employeeController),
                      SizedBox(height: 40),

                      // Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              side:
                                  BorderSide(color: Color(0xFF0038FF),width: 1.5), // Blue border
                              padding: EdgeInsets.only(
                                  top: 15, bottom: 15, left: 30, right: 30),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF0038FF), // Blue text color
                                fontFamily: 'Galano',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Gap(20),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF0038FF),
                              padding: EdgeInsets.only(
                                  top: 15, bottom: 15, left: 30, right: 30),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              "Save changes",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontFamily: 'Galano',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Gap(30)
                    ],
                  ),
                ),
                
                // Outlined button on the top-right corner
                Positioned(
                  top: 220,
                  right: 16,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Color(0xFF0038FF),width: 1.5), // Blue border
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      "Change Background",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF0038FF), // Blue text color
                        fontFamily: 'Galano',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
