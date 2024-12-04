import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/recruiters/subscription/add_cart.dart';
import 'package:huzzl_web/widgets/buttons/orange/iconbutton_back.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: MembershipPlansPage(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

class MembershipPlansPage extends StatefulWidget {
  @override
  State<MembershipPlansPage> createState() => _MembershipPlansPageState();
}

class _MembershipPlansPageState extends State<MembershipPlansPage> {
  bool isSubscribe = false;

  Future<void> fetchSubscriptionStatus() async {
    try {
      var recruiterId = FirebaseAuth.instance.currentUser!.uid;

      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(recruiterId)
          .get();

      if (snapshot.exists) {
        String subscriptionType = snapshot['subscriptionType'];
        if (subscriptionType == "premium") {
          setState(() {
            isSubscribe = true;
          });
        }
        print('Subscription Type: $subscriptionType');
      } else {
        print('User document does not exist.');
      }
    } catch (e) {
      print('Error fetching subscription status: $e');
    }
  }

  void getStatus() async {
    await fetchSubscriptionStatus();
  }

  @override
  void initState() {
    super.initState();
    getStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 200),
            child: Column(
              children: [
                Gap(100),
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButtonback(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    iconImage: const AssetImage('assets/images/backbutton.png'),
                  ),
                ),
                Gap(50),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Membership Plans",
                    style: TextStyle(
                      fontFamily: 'Galano',
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                ),
                Gap(50),
                Row(
                  children: [
                    Expanded(
                      child: MembershipCard(
                        title: "Basic",
                        price: "Free",
                        description: [
                          "Access essential job postings",
                          "Limited communication tools",
                          "Manage up to 5 active applications",
                          "Basic analytics on application status",
                          "Limited talent discovery",
                        ],
                        highlight: isSubscribe
                            ? "Back to basic plan"
                            : "This is your current plan",
                        color: Color(0xff3B7DFF),
                        textColor: Colors.white,
                        buttonColor: Colors.white,
                        borderColor: Colors.transparent,
                        isButtonDisabled: true,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: MembershipCard(
                        title: "Plus",
                        price: "\₱499 per month*",
                        description: [
                          "Includes everything in Basic and:",
                          "Unlimited access to job postings",
                          "Priority talent discovery and recommendations",
                          "Advanced analytics and reports",
                          "Integration with Huzzl AI tools for job matching",
                          "Exclusive discounts on partner services",
                        ],
                        highlight: isSubscribe
                            ? "This is your current plan"
                            : "Upgrade to Plus",
                        color: Colors.white,
                        textColor: Color(0xffFD7206),
                        buttonColor: isSubscribe
                            ? Color.fromARGB(255, 255, 180, 122)
                            : Color(0xffFD7206),
                        borderColor: Color(0xffFD7206),
                        // isButtonDisabled: isSubscribe ? true : false,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Spacer(),
          // Footer(),
        ],
      ),
    );
  }
}

class MembershipCard extends StatelessWidget {
  final String title;
  final String price;
  final List<String> description;
  final String highlight;
  final Color color;
  final Color textColor;
  final Color buttonColor;
  final Color borderColor;
  final bool isButtonDisabled;

  MembershipCard({
    required this.title,
    required this.price,
    required this.description,
    required this.highlight,
    required this.color,
    required this.textColor,
    required this.buttonColor,
    required this.borderColor,
    this.isButtonDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      padding: EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.bold,
              fontFamily: 'Galano',
              color: textColor,
            ),
          ),
          SizedBox(height: 8),
          Text(
            price,
            style: TextStyle(
              fontSize: 16,
              color: textColor,
              fontFamily: 'Galano',
            ),
          ),
          SizedBox(height: 5),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: description.map((text) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Icon(Icons.check, size: 16, color: textColor),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        text,
                        style: TextStyle(
                          fontFamily: 'Galano',
                          color: textColor,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 16),
          Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              onPressed: isButtonDisabled
                  ? null
                  : () {
                      showDialog(
                        context: context,
                        builder: (context) => AddCardModal(),
                      );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: isButtonDisabled
                    ? const Color.fromARGB(255, 223, 223, 223).withOpacity(0.8)
                    : buttonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                highlight,
                style: TextStyle(
                  fontFamily: 'Galano',
                  color: isButtonDisabled
                      ? const Color.fromARGB(255, 236, 236, 236)
                          .withOpacity(0.9)
                      : color,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(30),
      color: Color(0xFF181818),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "About Us   •   Feedback   •   Community   •   Privacy Policy   •   Terms of Service",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontFamily: 'Galano',
              color: const Color.fromARGB(255, 255, 255, 255),
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Educational purposes only. Copyright © 2024 Huzzl Inc. Capstone Project 2 - PSU Urdaneta",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontFamily: 'Galano',
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
