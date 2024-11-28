import 'package:flutter/material.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/calendar_ui/applicant_model.dart';

class InterviewEvent {
  String? applicant;
  String? title;
  String? type;
  List<String>? interviewers;
  DateTime? date;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  String? notes;
  String? location;
  String? profession;
  String? status;
  String? jobPostId;
  String? jobseekerId;
  String? interviewId;

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
    this.profession,
    this.status,
    this.jobPostId,
    this.jobseekerId,
    this.interviewId,
  });
}
