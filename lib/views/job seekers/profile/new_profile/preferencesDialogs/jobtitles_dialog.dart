import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/03b%20%20jobtitle_chip.dart';
import 'package:huzzl_web/widgets/buttons/blue/bluefilled_circlebutton.dart';
import 'package:huzzl_web/widgets/dropdown/DropdownWithCheckboxes.dart';

class JobTitlesDialog extends StatefulWidget {
  final List<String> initialJobTitles;
  final Function(List<String>) onSave;

  JobTitlesDialog({required this.initialJobTitles, required this.onSave});

  @override
  _JobTitlesDialogState createState() => _JobTitlesDialogState();
}

class _JobTitlesDialogState extends State<JobTitlesDialog> {
  late List<String> selectedJobTitles;

  @override
  void initState() {
    super.initState();
    selectedJobTitles = List.from(widget.initialJobTitles);
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 350, vertical: 50),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: EdgeInsets.all(30),
              color: Colors.white,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'What kind of jobs are you looking for?',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'This helps us match you with relevant jobs.',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w100),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Select up to 3 classifications.',
                      style: TextStyle(fontSize: 15, color: Color(0xff929292)),
                    ),
                    SizedBox(height: 20),
                    SelectedJobTitlesWrap(
                      selectedJobTitles: selectedJobTitles,
                      onRemoveJobTitle: (jobTitle) {
                        setState(() {
                          selectedJobTitles.remove(jobTitle);
                        });
                      },
                    ),
                    SizedBox(height: 10),
                    DropdownWithCheckboxes(
                      sections: [
                        DropdownSection(
                          title: 'Accounting and Finance',
                          items: [
                            'Accountant',
                            'Auditor',
                            'Bookkeeper',
                            'Budget Analyst',
                            'Chief Financial Officer',
                            'Controller',
                            'Financial Analyst',
                            'Payroll Specialist',
                            'Tax Specialist',
                            'Treasurer',
                          ],
                        ),
                        DropdownSection(
                          title: 'Administration and Office Support',
                          items: [
                            'Administrative Assistant',
                            'Clerk',
                            'Data Entry Specialist',
                            'Executive Assistant',
                            'Office Manager',
                            'Receptionist',
                            'Secretary',
                            'Virtual Assistant',
                          ],
                        ),
                        DropdownSection(
                          title: 'Agriculture and Forestry',
                          items: [
                            'Agricultural Engineer',
                            'Agronomist',
                            'Farm Manager',
                            'Forester',
                            'Horticulturist',
                            'Soil Scientist',
                          ],
                        ),
                        DropdownSection(
                          title: 'Arts, Design and Creative',
                          items: [
                            'Animator',
                            'Art Director',
                            'Graphic Designer',
                            'Illustrator',
                            'Interior Designer',
                            'Multimedia Artist',
                            'Photographer',
                            'UI UX Designer',
                            'Videographer',
                            'Visual Effects Artist',
                          ],
                        ),
                        DropdownSection(
                          title: 'Construction and Real Estate',
                          items: [
                            'Architect',
                            'Bricklayer',
                            'Carpenter',
                            'Construction Manager',
                            'Electrician',
                            'Plumber',
                            'Project Manager',
                            'Quantity Surveyor',
                            'Real Estate Agent',
                            'Surveyor',
                          ],
                        ),
                        DropdownSection(
                          title: 'Customer Service and Support',
                          items: [
                            'Call Center Agent',
                            'Client Relations Specialist',
                            'Customer Service Representative',
                            'Help Desk Specialist',
                            'Technical Support Specialist',
                          ],
                        ),
                        DropdownSection(
                          title: 'Education and Training',
                          items: [
                            'Curriculum Developer',
                            'Elementary School Teacher',
                            'High School Teacher',
                            'Librarian',
                            'Professor',
                            'Special Education Teacher',
                            'Trainer',
                            'Tutor',
                          ],
                        ),
                        DropdownSection(
                          title: 'Engineering',
                          items: [
                            'Aerospace Engineer',
                            'Biomedical Engineer',
                            'Chemical Engineer',
                            'Civil Engineer',
                            'Electrical Engineer',
                            'Environmental Engineer',
                            'Industrial Engineer',
                            'Mechanical Engineer',
                            'Software Engineer',
                            'Structural Engineer',
                          ],
                        ),
                        DropdownSection(
                          title: 'Healthcare and Medicine',
                          items: [
                            'Dentist',
                            'Medical Assistant',
                            'Nurse',
                            'Paramedic',
                            'Pharmacist',
                            'Physical Therapist',
                            'Physician',
                            'Radiologist',
                            'Surgeon',
                            'Veterinarian',
                          ],
                        ),
                        DropdownSection(
                          title: 'Hospitality and Tourism',
                          items: [
                            'Bartender',
                            'Chef',
                            'Event Planner',
                            'Hotel Manager',
                            'Housekeeper',
                            'Reservation Agent',
                            'Tour Guide',
                            'Travel Agent',
                            'Waiter Waitress',
                          ],
                        ),
                        DropdownSection(
                          title: 'Human Resources and Recruitment',
                          items: [
                            'HR Manager',
                            'Recruiter',
                            'Training Coordinator',
                            'Compensation Specialist',
                            'Talent Acquisition Specialist',
                          ],
                        ),
                        DropdownSection(
                          title: 'Information Technology',
                          items: [
                            'Data Analyst',
                            'Database Administrator',
                            'IT Support Specialist',
                            'Network Administrator',
                            'Software Developer',
                            'Systems Analyst',
                            'Web Developer',
                          ],
                        ),
                        DropdownSection(
                          title: 'Legal and Compliance',
                          items: [
                            'Attorney',
                            'Compliance Officer',
                            'Corporate Lawyer',
                            'Legal Assistant',
                            'Paralegal',
                          ],
                        ),
                        DropdownSection(
                          title: 'Manufacturing and Production',
                          items: [
                            'Assembly Line Worker',
                            'Machine Operator',
                            'Manufacturing Engineer',
                            'Production Manager',
                            'Quality Assurance Specialist',
                          ],
                        ),
                        DropdownSection(
                          title: 'Marketing and Advertising',
                          items: [
                            'Brand Manager',
                            'Content Strategist',
                            'Copywriter',
                            'Digital Marketing Specialist',
                            'Market Research Analyst',
                            'Marketing Manager',
                            'Public Relations Specialist',
                            'SEO Specialist',
                            'Social Media Manager',
                          ],
                        ),
                        DropdownSection(
                          title: 'Media and Communication',
                          items: [
                            'Broadcast Journalist',
                            'Content Creator',
                            'Editor',
                            'Journalist',
                            'Producer',
                            'Public Relations Officer',
                            'Reporter',
                            'Translator',
                          ],
                        ),
                        DropdownSection(
                          title: 'Retail and Sales',
                          items: [
                            'Cashier',
                            'Merchandiser',
                            'Retail Manager',
                            'Sales Associate',
                            'Sales Manager',
                            'Store Manager',
                          ],
                        ),
                        DropdownSection(
                          title: 'Science and Research',
                          items: [
                            'Biochemist',
                            'Geologist',
                            'Laboratory Technician',
                            'Research Scientist',
                            'Statistician',
                          ],
                        ),
                        DropdownSection(
                          title: 'Skilled Trades and Craft',
                          items: [
                            'Blacksmith',
                            'Machinist',
                            'Mechanic',
                            'Tailor',
                            'Welder',
                          ],
                        ),
                        DropdownSection(
                          title: 'Transportation and Logistics',
                          items: [
                            'Delivery Driver',
                            'Logistics Coordinator',
                            'Supply Chain Manager',
                            'Truck Driver',
                            'Warehouse Manager',
                          ],
                        ),
                        DropdownSection(
                          title: 'Other',
                          items: [
                            'Entrepreneur',
                            'Freelancer',
                          ],
                        ),
                      ],
                      maxSelections: 3,
                      preSelectedItems: widget.initialJobTitles,
                      onSelectionChanged: (selectedItems) {
                        setState(() {
                          selectedJobTitles = selectedItems;
                        });
                      },
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("Cancel"),
                        ),
                        SizedBox(width: 10),
                        BlueFilledCircleButton(
                          width: 100,
                          onPressed: () {
                            widget.onSave(selectedJobTitles);
                            Navigator.of(context).pop();
                          },
                          text: "Save",
                        ),
                      ],
                    ),
                    Gap(20),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
