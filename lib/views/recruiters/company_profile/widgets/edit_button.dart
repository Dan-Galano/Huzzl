// edit_button.dart
import 'package:flutter/material.dart';
import 'package:huzzl_web/views/recruiters/company_profile/edit_profile_page.dart';

class EditButton extends StatelessWidget {
  const EditButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditProfilePage(),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          side: BorderSide(color: Color(0xFF0038FF), width: 1.5),
          padding: EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          backgroundColor: Colors.white,
        ),
        child: Text(
          'Edit Page',
          style: TextStyle(
            color: Color(0xFF0038FF),
            fontFamily: 'Galano',
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
