import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/widgets/open_in_newtab.dart';
import 'package:huzzl_web/views/recruiters/candidates_tab/widgets/skillchip.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';


class ApplicationView extends StatelessWidget {
  ApplicationView({super.key});

  final List<String> skills = [
    'Communication Skills',
    'Problem-Solving',
    'Customer Service',
    'Adaptability',
    'Critical Thinking',
    'Design',
    'Work under Pressure',
    'Project Management',
    'Conflict Resolution',
    'Attention to Detail',
    'Time-management',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Applicant Qualifications",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Color(0xFF202855),
            ),
          ),
          Gap(10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'How many years of vocalist experience do you have?',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        'Your requirement: ',
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        'at least 1 year',
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(10),
                constraints: BoxConstraints(
                  minWidth: 80,
                ),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(5),
                  ),
                  border: Border.all(color: Colors.grey),
                ),
                child: Text(
                  textAlign: TextAlign.center,
                  '3 years',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          Gap(10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "How many live performances you've done?",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        'Your requirement: ',
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        'at least 5',
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(10),
                constraints: BoxConstraints(
                  minWidth: 80,
                ),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(5),
                  ),
                  border: Border.all(color: Colors.grey),
                ),
                child: Text(
                  textAlign: TextAlign.center,
                  '16',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          Divider(
            thickness: 1,
            color: Colors.grey,
            height: 60,
          ),
          Text(
            "Skills",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Color(0xFF202855),
            ),
          ),
          Gap(20),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: skills.map((skill) => SkillChip(skill: skill)).toList(),
          ),
          Divider(
            thickness: 1,
            color: Colors.grey,
            height: 60,
          ),
          Text(
            "Portfolio",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Color(0xFF202855),
            ),
          ),
          Gap(20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => openPdfInNewTab('assets/pdf/portfolio.pdf'),
                child: Text(
                  "Open Portfolio in New Tab",
                  style: TextStyle(
                    color: Color(0xFFff9800),
                  ),
                ),
              ),
              Container(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 800,
                    maxWidth: 800,
                  ),
                  child: SfPdfViewer.asset(
                    'assets/pdf/portfolio.pdf',
                    canShowScrollHead: true,
                    canShowScrollStatus: true,
                    onDocumentLoaded: (details) => print('Document loaded'),
                    onDocumentLoadFailed: (details) =>
                        print('Document failed to load'),
                  ),
                ),
              ),
            ],
          ),
          Divider(
            thickness: 2,
            color: Color(0xFFff9800),
            height: 60,
          ),
        ],
      ),
    );
  }
}
