import 'package:flutter/material.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/widgets/resume_option.dart';

class SetupResumeDialog extends StatefulWidget {
  final VoidCallback onFillManually;
  final VoidCallback onUploadResume;

  const SetupResumeDialog({
    Key? key,
    required this.onFillManually,
    required this.onUploadResume,
  }) : super(key: key);

  @override
  State<SetupResumeDialog> createState() => _SetupResumeDialogState();
}

class _SetupResumeDialogState extends State<SetupResumeDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        height: MediaQuery.of(context).size.height * 0.5,
        child: Padding(
          padding: EdgeInsets.all(40.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text(
                      "Let's set up your ",
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xff373030),
                        fontFamily: 'Galano',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'huzzl ',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.orange,
                        fontFamily: 'Galano',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'resume',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xff373030),
                        fontFamily: 'Galano',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                Text(
                  'This helps us create a personalized resume to match you with the best job opportunities.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xff373030),
                    fontFamily: 'Galano',
                    fontWeight: FontWeight.w100,
                  ),
                ),
                SizedBox(height: 50),
                ButtonList(
                  buttonData: [
                    {
                      'icon': Icons.upload_file,
                      'label': 'Upload your resume',
                      'sublabel': '(pdf/docx/txt)',
                      'onPressed': (BuildContext context) {
                        widget.onUploadResume();
                      },
                    },
                    {
                      'icon': Icons.edit,
                      'label': 'Fill up huzzl resume manually',
                      'onPressed': (BuildContext context) {
                        widget.onFillManually();
                      },
                    },
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
