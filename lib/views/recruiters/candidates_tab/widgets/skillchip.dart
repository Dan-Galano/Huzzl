import 'package:flutter/material.dart';

class SkillChip extends StatelessWidget {
  final String skill;

  SkillChip({required this.skill});

  @override
  Widget build(BuildContext context) {
    return InputChip(
      label: Text(skill),
      onSelected: (value) {},
      shape: StadiumBorder(
        side: BorderSide(
          color: Colors.grey,
          width: 0.5,
        ),
      ),
      backgroundColor: Colors.white,
      labelStyle: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }
}
