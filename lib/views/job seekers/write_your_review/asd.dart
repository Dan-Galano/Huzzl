import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WriteReviewPage extends StatefulWidget {
  final String companyId; // Pass the selected company ID
  final String companyName;

  const WriteReviewPage(
      {super.key, required this.companyId, required this.companyName});

  @override
  _WriteReviewPageState createState() => _WriteReviewPageState();
}

class _WriteReviewPageState extends State<WriteReviewPage> {
  int _rating = 0;
  final _reviewSummaryController = TextEditingController();
  final _reviewDetailsController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  void _onStarTapped(int index) {
    setState(() {
      _rating = index + 1;
    });
  }

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

      // Add review to Firestore
      await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('company_reviews')
          .add({
        'companyId': widget.companyId,
        'companyName': widget.companyName,
        'rating': _rating,
        'reviewSummary': _reviewSummaryController.text,
        'reviewDetails': _reviewDetailsController.text,
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Review submitted successfully!"),
        ),
      );

      // Navigate back or clear fields
      Navigator.pop(context);
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
      appBar: AppBar(
        title: Text("Write a Review for ${widget.companyName}"),
        backgroundColor: const Color(0xff0038FF),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                  borderSide: const BorderSide(color: Color(0xffD1E1FF)),
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
            TextFormField(
              controller: _reviewDetailsController,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: "Write your review here...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xffD1E1FF)),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: _submitReview,
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
                  "Submit",
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Galano',
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
