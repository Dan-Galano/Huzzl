class EvaluationModel {
  String evaluationArea; // Example: "Communication Skills"
  int totalPoints; // Example: 20
  List<Criteria> criteriaList; // List of criteria under the evaluation area

  EvaluationModel({
    required this.evaluationArea,
    required this.totalPoints,
    required this.criteriaList,
  });
}

class Criteria {
  String title; // Example: "Clarity & Articulation"
  String comment; // Example: "Ability to speak clearly and organize thoughts."
  int maxPoints; // Maximum points for this criterion (e.g., 10)
  int currentScore; // Score given by the evaluator

  Criteria({
    required this.title,
    required this.comment,
    required this.maxPoints,
    this.currentScore = 0, // Initialize with 0
  });
}

