import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/login/login_register.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
              top: 60,
              child: SingleChildScrollView(
                child: Stack(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Image.asset(
                        'assets/images/herobg.png',
                        fit: BoxFit.fitWidth,
                        alignment: Alignment.topCenter,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Gap(100),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: JobSearchWidget(),
                        ),
                        Gap(210),
                        Padding(
                          padding: const EdgeInsets.only(right: 100),
                          child: ExpertProfessionalsWidget(),
                        ),
                        Gap(80),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: FeatureCard(),
                        ),
                        Gap(80),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: TalentCategoryWidget(),
                        ),
                      ],
                    ),
                  ],
                ),
              )),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Image.asset(
                      'assets/images/huzzl.png',
                      height: 20,
                    ),
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Features',
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
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  const FeatureCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: EdgeInsets.symmetric(horizontal: 100),
        color: Colors.white,
        elevation: 4,
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: ClipRRect(
                borderRadius:
                    BorderRadius.horizontal(left: Radius.circular(16)),
                child: Image.asset(
                  'assets/images/featurecard.png',
                  fit: BoxFit.cover,
                  height: 700,
                ),
              ),
            ),
            Gap(100),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Up your work game',
                      style: TextStyle(
                        fontFamily: 'Galano',
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    Gap(25),
                    Row(
                      children: [
                        Icon(Icons.lock_open, color: Colors.orange),
                        Gap(8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Skilled Professionals at Your Service',
                                style: TextStyle(
                                  fontFamily: 'Galano',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                'Unlock your business\'s potential by partnering with the right expert for your needs.',
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
                    ),
                    Gap(25),
                    Row(
                      children: [
                        Icon(Icons.work_outline, color: Colors.orange),
                        Gap(8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Job Posting Made Simple',
                                style: TextStyle(
                                  fontFamily: 'Galano',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                'Create a job listing and reach out to talented specialists ready to work on your project.',
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
                    ),
                    Gap(25),
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined, color: Colors.orange),
                        Gap(8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hire the Best Talent Today',
                                style: TextStyle(
                                  fontFamily: 'Galano',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                'Achieve your business objectives by hiring the best expert for your specific requirements.',
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
                    ),
                    Gap(50),
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
                        'Sign up',
                        style: TextStyle(
                          fontFamily: 'Galano',
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class JobSearchWidget extends StatelessWidget {
  const JobSearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        children: [
          Text(
            'Your One-Stop Job Solution.',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              fontFamily: 'Galano',
              color: Colors.white,
            ),
          ),
          Gap(50),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 200),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Icon(Icons.search, color: Colors.grey),
                  ),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Job title, keywords, or company',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontFamily: 'Galano',
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFE9703),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      child: Text(
                        'Find Jobs',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Galano',
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ExpertProfessionalsWidget extends StatelessWidget {
  const ExpertProfessionalsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        width: 500,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Expert Professionals',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                fontFamily: 'Galano',
                color: Color(0xFFFDC000),
              ),
            ),
            Gap(16),
            Text(
              "Maximize your business's potential by hiring the perfect expert for your specific needs.",
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'Galano',
                color: Color(0xFF202855),
              ),
            ),
            Gap(24),
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
    );
  }
}

class TalentCategoryWidget extends StatelessWidget {
  const TalentCategoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              'Browse talent by category',
              style: TextStyle(
                fontFamily: 'Galano',
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 16),
            child: Row(
              children: [
                Text(
                  'Looking for work?',
                  style: TextStyle(
                    fontFamily: 'Galano',
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                Gap(1),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Browse jobs',
                    style: TextStyle(
                      fontFamily: 'Galano',
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xFFFDC000),
                    ),
                  ),
                ),
              ],
            ),
          ),
          GridView.count(
            crossAxisCount: 4,
            childAspectRatio: 4 / 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            shrinkWrap: true,
            children: [
              CategoryCard(
                title: 'Development & IT',
                rating: '4.8/5',
                skills: '1234 skills',
              ),
              CategoryCard(
                title: 'AI Service',
                rating: '4.8/5',
                skills: '1234 skills',
              ),
              CategoryCard(
                title: 'Design and Creative',
                rating: '4.8/5',
                skills: '1234 skills',
              ),
              CategoryCard(
                title: 'Sales and Marketing',
                rating: '4.8/5',
                skills: '1234 skills',
              ),
              CategoryCard(
                title: 'Writing and Translation',
                rating: '4.8/5',
                skills: '1234 skills',
              ),
              CategoryCard(
                title: 'Admin Support',
                rating: '4.8/5',
                skills: '1234 skills',
              ),
              CategoryCard(
                title: 'Finance and Accounting',
                rating: '4.8/5',
                skills: '1234 skills',
              ),
              CategoryCard(
                title: 'Architecture',
                rating: '4.8/5',
                skills: '1234 skills',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String title;
  final String rating;
  final String skills;

  const CategoryCard({
    super.key,
    required this.title,
    required this.rating,
    required this.skills,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Galano',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF202855),
                ),
              ),
              Gap(8),
              Row(
                children: [
                  Icon(
                    Icons.star_rate_rounded,
                    color: Color(0xFFFDC000),
                  ),
                  Text(
                    rating,
                    style: TextStyle(
                      fontFamily: 'Galano',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
              Gap(8),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  skills,
                  style: TextStyle(
                    fontFamily: 'Galano',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF202855),
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
