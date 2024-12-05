import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:huzzl_web/views/job%20seekers/write_your_review/tell_us_about_you.dart';

class WriteReviewPage extends StatefulWidget {
  final String companyId; // Pass the selected company ID
  final String companyName;
  WriteReviewPage(
      {super.key, required this.companyId, required this.companyName});

  @override
  _WriteReviewPageState createState() => _WriteReviewPageState();
}

class _WriteReviewPageState extends State<WriteReviewPage> {
  int _rating = 0;
  void _onStarTapped(int index) {
    setState(() {
      _rating = index + 1;
    });
  }

  final _reviewSummaryController = TextEditingController();
  final _reviewDetailsController = TextEditingController();

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<void> _submitReview() async {
    if (_rating == 0 ||
        _reviewSummaryController.text.isEmpty ||
        _reviewDetailsController.text.length < 150) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text("Please complete all required fields before submitting."),
        ),
      );
      return;
    }

    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception("User not logged in.");
      }
      final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
      // Add review to Firestore
      await _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('company_information')
          .doc(widget.companyId) // The specific company document ID
          .collection('company_reviews')
          .add({
        'companyId': widget.companyId, // Adding the company ID for reference
        'companyName': widget.companyName,
        'rating': _rating,
        'reviewSummary': _reviewSummaryController.text,
        'reviewDetails': _reviewDetailsController.text,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(
      //     content: Text("Review submitted successfully!"),
      //   ),
      // );

      // Navigate back or clear fields
      // Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to submit review: $e"),
        ),
      );
    }
  }

  @override
  void dispose() {
    _reviewSummaryController.dispose();
    _reviewDetailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 350.0, vertical: 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Write your review",
                    style: TextStyle(
                      fontSize: 24,
                      fontFamily: 'Galano',
                      fontWeight: FontWeight.bold,
                      color: Color(0xff202855),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Your anonymous feedback will help fellow jobseekers",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Galano',
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Overall Rating *",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Galano',
                      fontWeight: FontWeight.bold,
                      color: Color(0xff202855),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      5,
                      (index) => IconButton(
                        onPressed: () => _onStarTapped(index),
                        icon: Icon(
                          Icons.star,
                          color: index < _rating
                              ? const Color(0xFFF39C12)
                              : Colors.grey.shade300,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Poor",
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Galano',
                            color: Colors.grey),
                      ),
                      Text(
                        "Excellent",
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Galano',
                            color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Review Summary *",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Galano',
                      fontWeight: FontWeight.bold,
                      color: Color(0xff202855),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _reviewSummaryController,
                    decoration: InputDecoration(
                      hintText: "Enter a summary of your review",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Color(0xffD1E1FF)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Your Review *",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Galano',
                      fontWeight: FontWeight.bold,
                      color: Color(0xff202855),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Give us your opinion about:\n"
                    "- a typical day at work,\n"
                    "- what you believe you learned,\n"
                    "- management,\n"
                    "- workplace culture,\n"
                    "- the hardest part of the job,\n"
                    "- the most enjoyable part of the job\n"
                    "(150 characters minimum)",
                    style: TextStyle(
                        fontSize: 14, fontFamily: 'Galano', color: Colors.grey),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _reviewDetailsController,
                    maxLines: 6,
                    decoration: InputDecoration(
                      hintText: "Write your review here...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Color(0xffD1E1FF)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                        onPressed: () {
                          _submitReview();
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      const TellUsPage(),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                const begin = Offset(1.0, 0.0);
                                const end = Offset.zero;
                                const curve = Curves.easeInOut;
                                var tween = Tween(begin: begin, end: end)
                                    .chain(CurveTween(curve: curve));
                                var offsetAnimation = animation.drive(tween);
                                return SlideTransition(
                                  position: offsetAnimation,
                                  child: child,
                                );
                              },
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff0038FF),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                            side: const BorderSide(color: Color(0xff0038FF)),
                          ),
                        ),
                        child: const Text(
                          "Next",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Galano',
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          Positioned(
            left: 240,
            top: 100,
            child: IconButton(
              icon: Image.asset(
                'assets/images/backbutton.png',
                width: 24,
                height: 24,
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
