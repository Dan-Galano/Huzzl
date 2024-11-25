import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/Landing_Page/footer_widget.dart';
import 'package:huzzl_web/Landing_Page/testimonials_page.dart';
import 'package:huzzl_web/views/login/login_register.dart';
import 'feature_card.dart';
import 'job_search_widget.dart';
import 'expert_professionals_widget.dart';
import 'talent_category_widget.dart';
import 'contact_page.dart';

class LandingPageNew extends StatefulWidget {
  const LandingPageNew({super.key});

  @override
  _LandingPageNewState createState() => _LandingPageNewState();
}

class _LandingPageNewState extends State<LandingPageNew> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _featuresKey = GlobalKey();
  final GlobalKey _testimonialsKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  void _scrollToSection(GlobalKey key) {
    final RenderBox? renderBox =
        key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final offset = renderBox
          .localToGlobal(
            Offset.zero,
            ancestor: _scrollController.position.context.storageContext
                .findRenderObject(),
          )
          .dy;

      // Animate scrolling to the target offset
      _scrollController.animateTo(
        _scrollController.offset + offset,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Stack(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Image.asset(
                        'assets/images/background_blur.png',
                        fit: BoxFit.fitWidth,
                        alignment: Alignment.topCenter,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Gap(30),
                        JobSearchWidget(),
                        Gap(30),
                        ExpertProfessionalsWidget(),
                        FeatureCard(key: _featuresKey),
                        TestimonialsSection(key: _testimonialsKey),
                        TalentCategoryWidget(),
                        ContactPage(key: _contactKey),
                        Footer(),
                      ],
                    ),
                    Positioned(
                      top: 2380,
                      left: 900,
                      child: Container(
                        width: 600,
                        height: 350,
                        child: Image.asset(
                          'assets/images/3D_EP3.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 60,
                child: ClipRRect(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.white.withOpacity(0.6)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(1),
                          offset: Offset(6, 6),
                          blurRadius: 12,
                          spreadRadius: 6,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: Image.asset(
                            'assets/images/huzzl_logo_ulo.png',
                            height: 30,
                          ),
                        ),
                        Row(
                          children: [
                            TextButton(
                              onPressed: () => _scrollToSection(_featuresKey),
                              child: const Text(
                                'Features',
                                style: TextStyle(
                                  fontFamily: 'Galano',
                                  fontSize: 15,
                                  color: Color(0xFFFD7206),
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () =>
                                  _scrollToSection(_testimonialsKey),
                              child: const Text(
                                'Testimonials',
                                style: TextStyle(
                                  fontFamily: 'Galano',
                                  fontSize: 15,
                                  color: Color(0xFFFD7206),
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () => _scrollToSection(_contactKey),
                              child: const Text(
                                'Contact',
                                style: TextStyle(
                                  fontFamily: 'Galano',
                                  fontSize: 15,
                                  color: Color(0xFFFD7206),
                                ),
                              ),
                            ),
                            const Gap(30),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => LoginRegister(),
                                ));
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Color(0xFF256EFF),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 30,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              child: Text(
                                'Log in',
                                style: TextStyle(
                                  fontFamily: 'Galano',
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            const Gap(16),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                'Sign up',
                                style: TextStyle(
                                  fontFamily: 'Galano',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Color(0xFFFD7206),
                                ),
                              ),
                            ),
                            const Gap(16),
                          ],
                        ),
                      ],
                    ),
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
