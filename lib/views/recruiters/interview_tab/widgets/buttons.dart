import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class StartInterviewButton extends StatelessWidget {
  const StartInterviewButton({super.key, required this.onPressed});
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
          fixedSize: WidgetStateProperty.all(const Size(200, 40)),
          foregroundColor: WidgetStateProperty.all(Colors.white),
          backgroundColor: WidgetStateProperty.all(const Color(0xff3B7DFF))),
      child: Row(
        children: [
          Image.asset(
            'assets/images/camera_icon.png',
            height: 20,
          ),
          const Gap(15),
          Text('Start interview'),
        ],
      ),
    );
  }
}

class MarkAsDoneButton extends StatelessWidget {
  const MarkAsDoneButton({super.key, required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        fixedSize: WidgetStateProperty.all(const Size(200, 40)),
        side:
            const WidgetStatePropertyAll(BorderSide(color: Color(0xff3B7DFF))),
        foregroundColor: const WidgetStatePropertyAll(Color(0xff3B7DFF)),
      ),
      child: Row(
        children: [
          const Gap(10),
          Image.asset(
            'assets/images/chitchat_icon.png',
            height: 20,
          ),
          const Gap(15),
          Text('Mark as done'),
        ],
      ),
    );
  }
}
