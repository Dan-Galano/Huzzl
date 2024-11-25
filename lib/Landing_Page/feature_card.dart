import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:visibility_detector/visibility_detector.dart';

class FeatureCard extends StatelessWidget {
  const FeatureCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 50),
      color: Colors.grey[200], 
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          margin: EdgeInsets.symmetric(horizontal: 80),
          color: Colors.white,
          elevation: 8,
          child: Row(
            children: [
              Gap(20),
              Expanded(
                flex: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.horizontal(left: Radius.circular(24)),
                  child: Image.asset(
                    'assets/images/3D_EP2.png',
                    fit: BoxFit.cover,
                    height: 450,
                  ),
                ),
              ),
              Gap(10),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FeatureTitle(text: 'Explore Huzzl’s Top Features'),
                      Gap(30),
                      FeatureItem(
                        icon: Icons.search,
                        title: 'Advanced Job Matching',
                        description:
                            'Find the most relevant job opportunities with targeted filters by keywords, job titles, and companies.',
                      ),
                      Gap(20),
                      FeatureItem(
                        icon: Icons.account_circle,
                        title: 'Profile Creation & Management',
                        description:
                            'Create and manage detailed profiles to highlight skills, experience, and connect with recruiters effortlessly.',
                      ),
                      Gap(20),
                      FeatureItem(
                        icon: Icons.video_call,
                        title: 'Teleconferencing for Virtual Interviews',
                        description:
                            'Conduct seamless virtual interviews within the platform, simplifying the remote hiring process.',
                      ),
                      Gap(20),
                      FeatureItem(
                        icon: Icons.assignment,
                        title: 'Job Aggregation',
                        description:
                            'Access a wide range of job listings from multiple sources, making Huzzl a comprehensive job search platform.',
                      ),
                      Gap(20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FeatureTitle extends StatefulWidget {
  final String text;

  const FeatureTitle({super.key, required this.text});

  @override
  _FeatureTitleState createState() => _FeatureTitleState();
}

class _FeatureTitleState extends State<FeatureTitle> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _underlineAnimation;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _underlineAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (info.visibleFraction >= 0.55 && !_isVisible) {
      _controller.forward();
      setState(() {
        _isVisible = true;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('feature-title'),
      onVisibilityChanged: _onVisibilityChanged,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.text,
            style: TextStyle(
              fontFamily: 'Galano',
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
          Gap(4),
          Padding(
            padding: const EdgeInsets.only(left: 310.0),
            child: AnimatedBuilder(
              animation: _underlineAnimation,
              builder: (context, child) {
                return Container(
                  width: _underlineAnimation.value * 260,
                  height: 5,
                  color: Colors.orange,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const FeatureItem({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.blueAccent, size: 32),
        Gap(12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Galano',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Gap(4),
              Text(
                description,
                style: TextStyle(
                  fontFamily: 'Galano',
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
