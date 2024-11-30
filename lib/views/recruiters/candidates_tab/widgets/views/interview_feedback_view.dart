import 'package:flutter/material.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/views/evaluation_candidate_model.dart';

class InterviewFeedbackView extends StatelessWidget {
  final EvaluatedCandidateModel evaluationDetails;
  const InterviewFeedbackView({
    super.key,
    required this.evaluationDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          readOnly: true,
          style: const TextStyle(fontSize: 14),
          controller: TextEditingController(
            text: """
Interview Points: ${evaluationDetails.totalPoints}
Top Evaluation Area/Aspect: ${evaluationDetails.topEvaluationArea}
Evaluation: ${evaluationDetails.evaluation}

Comment:
${evaluationDetails.comment}
            
            """,
          ),
          maxLines: 10,
          decoration: const InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),
      ],
    );
  }
}
