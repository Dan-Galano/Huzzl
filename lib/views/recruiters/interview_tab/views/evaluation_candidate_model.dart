class EvaluatedCandidateModel {
  String? jobPostId;
  String? interviewId;
  String? jobApplicationId;
  String? jobseekerId;
  String applicant;
  String evaluation;
  String totalPoints;
  String topEvaluationArea;
  String comment;
  DateTime? evaluationDate;

  EvaluatedCandidateModel({
    this.jobPostId,
    this.interviewId,
    this.jobApplicationId,
    this.jobseekerId,
    required this.applicant,
    required this.evaluation,
    required this.totalPoints,
    required this.topEvaluationArea,
    required this.comment,
    this.evaluationDate,
  });
}