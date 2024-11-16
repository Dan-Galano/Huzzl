import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ExpertProfessionalsWidget extends StatefulWidget {
  const ExpertProfessionalsWidget({super.key});

  @override
  _ExpertProfessionalsWidgetState createState() =>
      _ExpertProfessionalsWidgetState();
}

class _ExpertProfessionalsWidgetState extends State<ExpertProfessionalsWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _fadeAnimation;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: Offset(0.0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (info.visibleFraction >= 0.33 && !_isVisible) {
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
      key: Key('expert-professionals-widget'),
      onVisibilityChanged: _onVisibilityChanged,
      child: Stack(
        clipBehavior:
            Clip.none,
        children: [
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.only(top: 60, left: 130, bottom: 60, right: 750),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SlideTransition(
                        position: _offsetAnimation,
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: Text(
                            'Expert Professionals',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Galano',
                              color: Color(0xFFFDC000),
                            ),
                          ),
                        ),
                      ),
                      Gap(12),
                      SlideTransition(
                        position: _offsetAnimation,
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: Text(
                            "Unlock opportunities to grow your career or business by connecting with the right talent and opportunities.",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Galano',
                              color: Color(0xFF202855),
                            ),
                          ),
                        ),
                      ),
                      Gap(30),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Color(0xFF256EFF),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 50,
                            vertical: 20,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Get Started',
                          style: TextStyle(
                            fontFamily: 'Galano',
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            right: 100,
            top: -100, 
            child: Image.asset(
              'assets/images/3D_EP.png',
              fit: BoxFit.contain,
              width: 600,
            ),
          ),
        ],
      ),
    );
  }
}
