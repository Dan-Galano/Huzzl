class Candidate {
  String id;
  String jobPostId;
  String email;
  String companyAppliedTo;
  String name;
  String profession;
  DateTime applicationDate;
  DateTime? dateLastInterviewed;
  int? interviewCount;
  DateTime? dateRejected;
  String status;
  String? jobApplicationDocId;

  Candidate({
    required this.id,
    required this.email,
    required this.name,
    required this.profession,
    required this.companyAppliedTo,
    required this.jobPostId,
    required this.applicationDate,
    this.dateLastInterviewed,
    this.interviewCount,
    this.dateRejected,
    required this.status,
    this.jobApplicationDocId,
  });

  Candidate copyWith({
    String? id,
    String? name,
    String? email,
    String? profession,
    String? jobPostId,
    String? companyAppliedTo,
    DateTime? applicationDate,
    String? status,
    DateTime? dateLastInterviewed,
    DateTime? dateRejected,
    int? interviewCount,
    String? jobApplicationDocId,
  }) {
    return Candidate(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profession: profession ?? this.profession,
      jobPostId: jobPostId ?? this.jobPostId,
      companyAppliedTo: companyAppliedTo ?? this.companyAppliedTo,
      applicationDate: applicationDate ?? this.applicationDate,
      status: status ?? this.status,
      dateLastInterviewed: dateLastInterviewed ?? this.dateLastInterviewed,
      dateRejected: dateRejected ?? this.dateRejected,
      interviewCount: interviewCount ?? this.interviewCount,
      jobApplicationDocId: jobApplicationDocId  ?? this.jobApplicationDocId
    );
  }
}
