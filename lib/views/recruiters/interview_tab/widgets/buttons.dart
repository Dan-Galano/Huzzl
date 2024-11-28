import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/responsive_sizes.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class StartInterviewButton extends StatelessWidget {
  const StartInterviewButton({
    super.key,
    required this.startTime,
    required this.endTime,
    required this.onPressed,
  });

  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final VoidCallback? onPressed;

  // Helper function to convert TimeOfDay to DateTime
  DateTime _timeOfDayToDateTime(TimeOfDay time) {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, time.hour, time.minute);
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        final now = DateTime.now();
        final startDateTime = _timeOfDayToDateTime(startTime);
        final endDateTime = _timeOfDayToDateTime(endTime);

        if (now.isBefore(startDateTime) || now.isAfter(endDateTime)) {
          // Optionally show a message if the time is outside the range
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'You can only start the interview during the scheduled time.'),
            ),
          );
          return; // Exit early if the current time is not within the range
        }

        // Proceed with the action if within the time range
        onPressed!();
      },
      style: ButtonStyle(
        fixedSize: WidgetStateProperty.all(
          Size(MediaQuery.of(context).size.width * 0.15, 40),
        ),
        foregroundColor: WidgetStateProperty.all(Colors.white),
        backgroundColor: WidgetStateProperty.all(
          onPressed == null ? Colors.grey : const Color(0xff3B7DFF),
        ),
        // Optionally, set the elevation or other properties if needed
        elevation: WidgetStateProperty.all(4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/camera_icon.png',
            height: 20,
          ),
          const Gap(15),
          const Text(
            'Start interview',
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class RescheduleInterviewButton extends StatelessWidget {
  const RescheduleInterviewButton({super.key, required this.onPressed});
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
          fixedSize: WidgetStateProperty.all(
              Size(MediaQuery.of(context).size.width * 0.15, 40)),
          foregroundColor: WidgetStateProperty.all(Colors.white),
          backgroundColor: WidgetStateProperty.all(const Color(0xff3B7DFF))),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_month,
            size: 24,
            color: Colors.white,
          ),
          Gap(15),
          Text(
            'Reschedule',
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class ScheduleInterviewButton extends StatelessWidget {
  const ScheduleInterviewButton({super.key, required this.onPressed});
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        fixedSize: WidgetStateProperty.all(
            Size(MediaQuery.of(context).size.width * 0.15, 40)),
        foregroundColor: WidgetStateProperty.all(Colors.white),
        backgroundColor: onPressed == null
            ? WidgetStateProperty.all(Colors.grey)
            : WidgetStateProperty.all(const Color(0xfffd7206)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_month,
            color: Colors.white,
            size: 18,
          ),
          Gap(15),
          Text(
            'Schedule interview',
            style: TextStyle(
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class InterviewCalendarButton extends StatelessWidget {
  const InterviewCalendarButton({super.key, required this.onPressed});
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        fixedSize: WidgetStateProperty.all(
            Size(MediaQuery.of(context).size.width * 0.15, 40)),
        foregroundColor: WidgetStateProperty.all(Colors.white),
        backgroundColor: onPressed == null
            ? WidgetStateProperty.all(Colors.grey)
            : WidgetStateProperty.all(const Color(0xffe0e8f9)),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_month,
            color: Color(0xff3B7DFF),
            size: 18,
          ),
          Gap(15),
          Text(
            'Interview Calendar',
            style: TextStyle(color: Color(0xff3B7DFF), fontSize: 12),
          ),
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
        fixedSize: WidgetStateProperty.all(
            Size(MediaQuery.of(context).size.width * 0.15, 40)),
        side:
            const WidgetStatePropertyAll(BorderSide(color: Color(0xff3B7DFF))),
        foregroundColor: const WidgetStatePropertyAll(Color(0xff3B7DFF)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Gap(10),
          Image.asset(
            'assets/images/chitchat_icon.png',
            height: 16,
          ),
          const Gap(15),
          const Text(
            'Mark as done',
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
