import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:huzzl_web/views/chat/screens/chat_home.dart';
import 'package:huzzl_web/views/job%20seekers/notification/notif_screen.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/user-provider.dart';
import 'package:huzzl_web/views/login/login_register.dart';
import 'package:huzzl_web/views/recruiters/home/PopupMenuItem/closeAccount.dart';
import 'package:huzzl_web/widgets/buttons/blue/bluefilled_circlebutton.dart';
import 'package:provider/provider.dart';

class NavBarHome extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  NavBarHome({required this.selectedIndex, required this.onItemTapped});
  @override
  _NavBarHomeState createState() => _NavBarHomeState();
}

class _NavBarHomeState extends State<NavBarHome> {
  User? currentUser;
  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    currentUser = userProvider.user;
  }
  // int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left side: Logo
            SizedBox(
              child: Image.asset('assets/images/huzzl.png', width: 80),
            ),

            // Spacer to push the center content to the middle
            Spacer(),

            // Centered buttons (Home and Company Reviews)
            Row(
              mainAxisSize: MainAxisSize
                  .min, // This ensures the row takes only as much space as needed
              children: [
                _buildNavButton(0, 'Home'),
                const SizedBox(width: 20),
                _buildNavButton(1, 'Company Reviews'),
              ],
            ),

            // Spacer to push icons to the right
            Spacer(),

            // Right side: Icons
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatHomePage()));
                  },
                  icon: Image.asset(
                    'assets/images/message-icon.png',
                    width: 20,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    switchScreen(5);
                  },
                  icon: Image.asset(
                    'assets/images/notif-icon.png',
                    width: 20,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    final RenderBox button =
                        context.findRenderObject() as RenderBox;
                    final RenderBox overlay = Overlay.of(context)
                        .context
                        .findRenderObject() as RenderBox;
                    final position =
                        button.localToGlobal(Offset.zero, ancestor: overlay);
                    await showMenu(
                      context: context,
                      position: RelativeRect.fromLTRB(
                        overlay.size.width - position.dx,
                        position.dy + 55,
                        position.dx + 30,
                        overlay.size.height - position.dy,
                      ),
                      items: [
                        PopupMenuItem(
                          value: 'view_profile',
                          child: Row(
                            children: [
                              Icon(Icons.person, color: Color(0xff373030)),
                              SizedBox(width: 8),
                              Text(
                                'Profile',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xff373030),
                                  fontFamily: 'Galano',
                                ),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'my_jobs',
                          child: Row(
                            children: [
                              Icon(Icons.work, color: Color(0xff373030)),
                              SizedBox(width: 8),
                              Text(
                                'My Jobs',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xff373030),
                                  fontFamily: 'Galano',
                                ),
                              ),
                            ],
                          ),
                        ),
                        // PopupMenuItem(
                        //   value: 'my_reviews',
                        //   child: Row(
                        //     children: [
                        //       Icon(Icons.star, color: Color(0xff373030)),
                        //       SizedBox(width: 8),
                        //       Text(
                        //         'My Reviews',
                        //         style: TextStyle(
                        //           fontSize: 14,
                        //           color: Color(0xff373030),
                        //           fontFamily: 'Galano',
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        PopupMenuItem(
                          value: 'close_account',
                          child: Row(
                            children: [
                              Icon(Icons.cancel, color: Color(0xff373030)),
                              SizedBox(width: 8),
                              Text(
                                'Close Account',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xff373030),
                                  fontFamily: 'Galano',
                                ),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'logout',
                          child: Row(
                            children: [
                              Icon(Icons.logout, color: Color(0xff373030)),
                              SizedBox(width: 8),
                              Text(
                                'Logout',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xff373030),
                                  fontFamily: 'Galano',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ).then((value) {
                      switch (value) {
                        case 'view_feedback':
                          showFeedbackViewDialog(context);
                          break;
                        case 'view_profile':
                          switchScreen(4);
                          break;
                        case 'my_jobs':
                          switchScreen(2);
                          break;
                        case 'my_reviews':
                          switchScreen(3);
                          break;
                        case 'close_account':
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CloseAccountDialog();
                            },
                          );
                          break;
                        case 'logout':
                          showLogoutDialog(context);
                          break;
                      }
                    });
                  },
                  icon: Image.asset(
                    'assets/images/user-icon.png',
                    width: 20,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void switchScreen(int index) {
    widget.onItemTapped(index);
  }

  Widget _buildNavButton(int index, String title) {
    return Column(
      children: [
        Gap(20),
        TextButton(
          onPressed: () {
            // setState(() {
            //   selectedIndex = index;
            // });
            widget.onItemTapped(index);
          },
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              // color: selectedIndex == index ? Colors.blue : Color(0xff373030),
              color: widget.selectedIndex == index
                  ? Colors.blue
                  : Color(0xff373030),
              fontFamily: 'Galano',
              fontWeight: widget.selectedIndex == index
                  ? FontWeight.bold
                  : FontWeight.w300,
            ),
          ),
        ),
        // if (selectedIndex == index)
        if (widget.selectedIndex == index)
          Container(
            height: 2,
            width: _getTextWidth(title),
            color: Colors.blue,
          ),
      ],
    );
  }

  double _getTextWidth(String text) {
    final textStyle = TextStyle(
      fontSize: 14,
      fontFamily: 'Galano',
    );

    final textPainter = TextPainter(
      text: TextSpan(text: text, style: textStyle),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();

    return textPainter.size.width;
  }
}

void showFeedbackViewDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Feedback"),
        content: const Text("Here is the feedback view."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Close"),
          ),
        ],
      );
    },
  );
}

void showProfileDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Profile"),
        content: const Text("This is the profile view."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Close"),
          ),
        ],
      );
    },
  );
}

void showMyJobsDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("My Jobs"),
        content: const Text("Here are your jobs."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Close"),
          ),
        ],
      );
    },
  );
}

void showMyReviewsDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("My Reviews"),
        content: const Text("Here are your reviews."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Close"),
          ),
        ],
      );
    },
  );
}

void logOut(BuildContext context) async {
  try {
    await FirebaseAuth.instance.signOut();
    print("User logged out successfully.");
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => LoginRegister(),
    ));
  } catch (e) {
    print("Error signing out: $e");
  }
}

void showLogoutDialog(BuildContext context) {
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
                          "Log Out of Huzzl?",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Galano',
                          ),
                        ),
                        Text(
                          "Are you sure you want to log out?",
                          style: TextStyle(
                            fontSize: 15,
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
                      onPressed: () => logOut(context),
                      text: "Log Out", // Button text
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
