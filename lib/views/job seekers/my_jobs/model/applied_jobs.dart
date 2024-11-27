import 'package:cloud_firestore/cloud_firestore.dart';

class AppliedJobs {
  final String jobTitle;
  final String status;
  String? jobPostId;
  String? recruiterId;
  DateTime? appliedAt;

  AppliedJobs({
    required this.jobTitle,
    required this.status,
    this.jobPostId,
    this.recruiterId,
    this.appliedAt,
  });

  // Factory method to create an instance from Firestore document
  factory AppliedJobs.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AppliedJobs(
      jobPostId: doc.id,
      jobTitle: data['jobTitle'] ?? '',
      recruiterId: data['recruiterId'] ?? '',
      status: data['status'] ?? '',
      appliedAt: (data['applicationDate'] as Timestamp).toDate(),
    );
  }
}