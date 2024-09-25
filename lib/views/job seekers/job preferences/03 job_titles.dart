import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:huzzl_web/widgets/buttons/blue/bluefilled_circlebutton.dart';
import 'package:huzzl_web/widgets/dropdown/DropdownWithCheckboxes.dart';

class JobTitlesPage extends StatefulWidget {
  final VoidCallback nextPage;
  final VoidCallback previousPage;
  JobTitlesPage({super.key, required this.nextPage, required this.previousPage});

  @override
  _JobTitlesPageState createState() => _JobTitlesPageState();
}

class _JobTitlesPageState extends State<JobTitlesPage> {
  var minimum = TextEditingController();
  var maximum = TextEditingController();

  void _submitJobTitlesForm() {
    // if (_formKey.currentState!.validate()) {
    //   widget.nextPage();
    // }
    widget.nextPage();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Image.asset(
            'assets/images/huzzl.png',
            width: 80,
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: IconButton(
                icon: Image.asset(
                  'assets/images/account.png',
                  width: 25,
                  height: 25,
                ),
                onPressed: () {
                  // action
                },
              ),
            ),
          ],
          flexibleSpace: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Color(0xffD9D9D9),
                  width: 3.0,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 400.0),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 80.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 40),
                    Text(
                      '3/3',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xff373030),
                        fontFamily: 'Galano',
                        fontWeight: FontWeight.w100,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'What kind of job are you looking for?',
                      style: TextStyle(
                        fontSize: 22,
                        color: Color(0xff373030),
                        fontFamily: 'Galano',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'This helps us match you with relevant jobs.',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xff373030),
                        fontFamily: 'Galano',
                        fontWeight: FontWeight.w100,
                      ),
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/info.png',
                          width: 20,
                          height: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Select up to 3 specialties.',
                          style: TextStyle(
                            fontSize: 15,
                            color: Color(0xff929292),
                            fontFamily: 'Galano',
                            fontWeight: FontWeight.w100,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    DropdownWithCheckboxes(
                      sections: [
                        DropdownSection(
                          title: 'Accounting & Consulting',
                          items: [
                            'Personal & Professional Coaching',
                            'Accounting & Bookkeeping',
                            'Financial Planning',
                            'Recruiting & Human Resources',
                            'Management Consulting & Analysis',
                            'Other - Accounting & Consulting',
                          ],
                        ),
                        DropdownSection(
                          title: 'Admin Support',
                          items: [
                            'Data Entry & Transcription Services',
                            'Virtual Assistance',
                            'Project Management',
                            'Market Research & Product Reviews',
                          ],
                        ),
                        DropdownSection(
                          title: 'Customer Service',
                          items: [
                            'Community Management & Tagging',
                            'Customer Service & Tech Support',
                          ],
                        ),
                        DropdownSection(
                          title: 'Data Science & Analytics',
                          items: [
                            'Data Analysis & Testing',
                            'Data Extraction/ETL',
                            'Data Mining & Management',
                            'AI & Machine Learning',
                          ],
                        ),
                        DropdownSection(
                          title: 'Design & Creative',
                          items: [
                            'Art & Illustration',
                            'Audio & Music Production',
                            'Branding & Logo Design',
                            'NFT, AR/VR & Game Art',
                            'Graphic, Editorial & Presentation Design',
                            'Performing Arts',
                            'Photography',
                            'Product Design',
                            'Video & Animation',
                          ],
                        ),
                        DropdownSection(
                          title: 'Engineering & Architecture',
                          items: [
                            'Building & Landscape Architecture',
                            'Chemical Engineering',
                            'Civil & Structural Engineering',
                            'Contract Manufacturing',
                            'Electrical & Electronic Engineering',
                            'Interior & Trade Show Design',
                            'Energy & Mechanical Engineering',
                            'Physical Sciences',
                            '3D Modeling & CAD',
                          ],
                        ),
                        DropdownSection(
                          title: 'IT & Networking',
                          items: [
                            'Database Management & Administration',
                            'ERP/CRM Software',
                            'Information Security & Compliance',
                            'Network & System Administration',
                            'DevOps & Solution Architecture',
                          ],
                        ),
                        DropdownSection(
                          title: 'Legal',
                          items: [
                            'Corporate & Contract Law',
                            'International & Immigration Law',
                            'Finance & Tax Law',
                            'Public Law',
                          ],
                        ),
                        DropdownSection(
                          title: 'Sales & Marketing',
                          items: [
                            'Digital Marketing',
                            'Lead Generation & Telemarketing',
                            'Marketing, PR & Brand Strategy',
                          ],
                        ),
                        DropdownSection(
                          title: 'Translation',
                          items: [
                            'Language Tutoring & Interpretation',
                            'Translation & Localization Services',
                          ],
                        ),
                        DropdownSection(
                          title: 'Web, Mobile & Software Dev',
                          items: [
                            'Blockchain, NFT & Cryptocurrency',
                            'AI Apps & Integration',
                            'Desktop Application Development',
                            'Ecommerce Development',
                            'Game Design & Development',
                            'Mobile Development',
                            'Other - Software Development',
                            'Product Management & Scrum',
                            'QA Testing',
                            'Scripts & Utilities',
                            'Web & Mobile Design',
                            'Web Development',
                          ],
                        ),
                        DropdownSection(
                          title: 'Writing',
                          items: [
                            'Sales & Marketing Copywriting',
                            'Content Writing',
                            'Editing & Proofreading Services',
                            'Professional & Business Writing',
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        width: 130,
                        child: BlueFilledCircleButton(
                          onPressed: () => _submitJobTitlesForm(),
                          text: 'Continue',
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 60,
            left: 350,
            child: IconButton(
              icon: Image.asset(
                'assets/images/backbutton.png',
                width: 20,
                height: 20,
              ),
              onPressed: () {
                //For debugging and UI only
                //Use PageController
                // Navigator.of(context).pop();
                widget.previousPage();
              },
            ),
          ),
        ],
      ),
    );
  }
}
