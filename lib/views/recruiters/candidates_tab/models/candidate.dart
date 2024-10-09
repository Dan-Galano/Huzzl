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
}
