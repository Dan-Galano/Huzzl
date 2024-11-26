import 'package:flutter/material.dart';
import 'package:huzzl_web/views/job%20seekers/write_your_review/tell_us_about_you.dart';

class WriteReviewPage extends StatefulWidget {
  const WriteReviewPage({super.key});

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
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      const TellUsPage(),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                const begin =
                                    Offset(1.0, 0.0); 
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
