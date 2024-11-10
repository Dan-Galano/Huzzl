class Candidate {
  String id;
  String jobPostId;
  String companyAppliedTo;
  String name;
  String profession;
  DateTime applicationDate;
  DateTime dateLastInterviewed;
  int interviewCount;
  DateTime dateRejected;
  String status;

  Candidate({
    required this.id,
    required this.name,
    required this.profession,
    required this.companyAppliedTo,
    required this.jobPostId,
    required this.applicationDate,
    required this.dateLastInterviewed,
    required this.interviewCount,
    required this.dateRejected,
    required this.status,
  });

  Candidate copyWith({
    String? id,
    String? name,
    String? profession,
    String? jobPostId,
    String? companyAppliedTo,
    DateTime? applicationDate,
    String? status,
    DateTime? dateLastInterviewed,
    DateTime? dateRejected,
    int? interviewCount,
  }) {
    return Candidate(
      id: id ?? this.id,
      name: name ?? this.name,
      profession: profession ?? this.profession,
      jobPostId: jobPostId ?? this.jobPostId,
      companyAppliedTo: companyAppliedTo ?? this.companyAppliedTo,
      applicationDate: applicationDate ?? this.applicationDate,
      status: status ?? this.status,
      dateLastInterviewed: dateLastInterviewed ?? this.dateLastInterviewed,
      dateRejected: dateRejected ?? this.dateRejected,
      interviewCount: interviewCount ?? this.interviewCount,
    );
  }
}
