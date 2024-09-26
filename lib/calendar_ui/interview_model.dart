import 'package:flutter/material.dart';
import 'package:huzzl_web/calendar_ui/applicant_model.dart';

class InterviewEvent {
  Applicant? applicant;
  String? title;
  String? type;
  List<String>? interviewers;
  DateTime? date;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  String? notes;
  String? location;

  InterviewEvent({
    required this.applicant,
    required this.title,
    required this.type,
    required this.interviewers,
    required this.date,
    required this.startTime,
    required this.endTime,
    this.notes,
    this.location,
  });
}
