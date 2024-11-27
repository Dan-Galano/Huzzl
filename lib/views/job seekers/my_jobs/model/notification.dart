import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  String? notificationId;
  final String jobTitle;
  final String jobpostId;
  final String jobseekerId;
  final DateTime notifDate;
  final String notifMessage;
  final String notifTitle;
  final String recruiterId;
  String status;

  NotificationModel({
    this.notificationId,
    required this.jobTitle,
    required this.jobpostId,
    required this.jobseekerId,
    required this.notifDate,
    required this.notifMessage,
    required this.notifTitle,
    required this.recruiterId,
    required this.status,
  });

  factory NotificationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NotificationModel(
      notificationId: doc.id,
      jobTitle: data['jobTitle'] ?? '',
      jobpostId: data['jobpostId'] ?? '',
      jobseekerId: data['jobseekerId'] ?? '',
      notifDate: (data['notifDate'] as Timestamp).toDate(),
      notifMessage: data['notifMessage'] ?? '',
      notifTitle: data['notifTitle'] ?? '',
      recruiterId: data['recruiterId'] ?? '',
      status: data['status'],
    );
  }
}
