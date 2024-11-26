import 'dart:async';
import 'package:flutter/material.dart';

class Testimonial {
  final String name;
  final String title; // Added review title
  final String feedback;
  final String jobTitle;
  final String location;
  final String date;
  final int rating;

  const Testimonial({
    required this.name,
    required this.title, // Required title
    required this.feedback,
    required this.jobTitle,
    required this.location,
    required this.date,
    required this.rating,
  });
}

class TestimonialsSection extends StatefulWidget {
  const TestimonialsSection({super.key});
  @override
  _TestimonialsSectionState createState() => _TestimonialsSectionState();
}

class _TestimonialsSectionState extends State<TestimonialsSection> {
  late final ScrollController _scrollController;
  late Timer _autoScrollTimer;
  final ValueNotifier<int> _hoveredIndex = ValueNotifier<int>(-1);

  List<Testimonial> testimonials = [
    const Testimonial(
      name: 'Rasheeda O.',
      title: 'Life-Changing Job Finder!',
      feedback:
          'Huzzl\'s advanced job matching system helped me find the perfect opportunity based on my skills. The profile creation was easy, and the resume scanner made sure I was fully prepared. The notifications kept me updated every step of the way.',
      jobTitle: 'Software Engineer',
      location: 'New York, USA',
      date: '2020–2023',
      rating: 5,
    ),
    const Testimonial(
      name: 'John D.',
      title: 'Streamlined Hiring Process',
      feedback:
          'As a recruiter, I love how Huzzl makes the hiring process so streamlined. The teleconferencing tools and real-time notifications allow me to communicate effectively with candidates, and the application tracking helps me stay organized.',
      jobTitle: 'HR Manager',
      location: 'San Francisco, USA',
      date: '2018–2023',
      rating: 5,
    ),
    const Testimonial(
      name: 'Anna W.',
      title: 'Direct Connections with Recruiters',
      feedback:
          'The integrated chat feature on Huzzl made it so much easier to connect with recruiters directly. The company reviews also gave me great insights into potential employers, and the job aggregation provided me with numerous opportunities.',
      jobTitle: 'Graphic Designer',
      location: 'London, UK',
      date: '2021–2023',
      rating: 5,
    ),
    const Testimonial(
      name: 'Mike J.',
      title: 'Efficient Recruitment Tools',
      feedback:
          'Using Huzzl has been a game changer for our recruiting process. The ability to review candidates’ profiles and manage job postings has made everything more efficient. I can’t imagine working without it now.',
      jobTitle: 'Recruitment Consultant',
      location: 'Toronto, Canada',
      date: '2019–2023',
      rating: 5,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _startAutoScroll();
  }

  @override
  void dispose() {
    _autoScrollTimer.cancel();
    _scrollController.dispose();
    _hoveredIndex.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    const duration = Duration(seconds: 3);
    _autoScrollTimer = Timer.periodic(duration, (timer) {
      if (_scrollController.hasClients) {
        double maxScroll = _scrollController.position.maxScrollExtent;
        double currentScroll = _scrollController.position.pixels;
        double newScroll = currentScroll + 500;

        if (newScroll >= maxScroll) {
          _scrollController.jumpTo(0);
        } else {
          _scrollController.animateTo(
            newScroll,
            duration: const Duration(seconds: 1),
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF9F9F9),
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Hear from Our Happy Clients',
            style: TextStyle(
              fontSize: 30,
              fontFamily: 'Galano',
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Take a look at the glowing reviews and success stories from some of our happy customers to see how Huzzl can help your business achieve its goals.',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Galano',
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 350, // Adjusted height to fit the title
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: testimonials.length,
              itemBuilder: (context, index) {
                final testimonial = testimonials[index];
                return ValueListenableBuilder<int>(
                  valueListenable: _hoveredIndex,
                  builder: (context, hoveredIndex, child) {
                    bool isHovered = hoveredIndex == index;
                    return MouseRegion(
                      onEnter: (_) => _hoveredIndex.value = index,
                      onExit: (_) => _hoveredIndex.value = -1,
                      child: AnimatedScale(
                        scale: isHovered ? 1.05 : 1.0,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          child: Container(
                            width: 500,
                            margin: const EdgeInsets.only(right: 20),
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  offset: Offset(0, 4),
                                  blurRadius: 12,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  testimonial.title,
                                  style: const TextStyle(
                                    fontFamily: 'Galano',
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  testimonial.feedback,
                                  style: const TextStyle(
                                    fontFamily: 'Galano',
                                    fontStyle: FontStyle.italic,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Spacer(),
                                Row(
                                  children: List.generate(
                                    testimonial.rating,
                                    (index) => const Icon(
                                      Icons.star,
                                      color: Color(0xFFF39C12),
                                      size: 20,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  testimonial.name,
                                  style: const TextStyle(
                                    fontFamily: 'Galano',
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  '${testimonial.jobTitle} | ${testimonial.location}',
                                  style: const TextStyle(
                                    fontFamily: 'Galano',
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  testimonial.date,
                                  style: const TextStyle(
                                    fontFamily: 'Galano',
                                    fontSize: 14,
                                    color: Colors.grey,
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
              },
            ),
          ),
        ],
      ),
    );
  }
}
