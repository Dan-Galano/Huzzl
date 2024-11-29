import 'package:flutter/material.dart';

class InterviewFeedbackScreen extends StatefulWidget {
  @override
  _InterviewFeedbackScreenState createState() =>
      _InterviewFeedbackScreenState();
}

class _InterviewFeedbackScreenState extends State<InterviewFeedbackScreen> {
  // Define the scores for each evaluation area and their max points
  Map<String, Map<String, dynamic>> evaluationCriteria = {
    'Clarity & Articulation': {
      'Max Points': 10,
      'Score': 0,
      'Comment': 'Clear communication, logical flow of ideas.',
    },
    'Listening & Response Quality': {
      'Max Points': 10,
      'Score': 0,
      'Comment': 'How well they listened and responded to questions.',
    },
    'Appearance': {
      'Max Points': 5,
      'Score': 0,
      'Comment': 'Professional attire, neatness, and presentation.',
    },
    'Punctuality & Technical Setup': {
      'Max Points': 5,
      'Score': 0,
      'Comment':
          'Was the interview started on time and without technical issues?',
    },
    'Attitude & Respect': {
      'Max Points': 10,
      'Score': 0,
      'Comment': 'How respectful, courteous, and positive was the applicant?',
    },
    'Industry Knowledge': {
      'Max Points': 10,
      'Score': 0,
      'Comment':
          'Understanding of industry trends, company culture, and job requirements.',
    },
    'Role-specific Expertise': {
      'Max Points': 10,
      'Score': 0,
      'Comment':
          'Experience and knowledge specific to the role being applied for.',
    },
    'Problem Solving': {
      'Max Points': 10,
      'Score': 0,
      'Comment': 'Ability to think critically and solve complex problems.',
    },
    'Teamwork & Collaboration': {
      'Max Points': 10,
      'Score': 0,
      'Comment': 'How well the applicant worked in a team environment.',
    },
    'Adaptability': {
      'Max Points': 10,
      'Score': 0,
      'Comment':
          'Ability to adjust to new situations, flexibility in approach.',
    },
    'Conflict Resolution': {
      'Max Points': 10,
      'Score': 0,
      'Comment': 'How the applicant handles disagreements and challenges.',
    },
    'Self-Motivation': {
      'Max Points': 10,
      'Score': 0,
      'Comment':
          'Initiative, drive, and willingness to take on responsibilities.',
    },
    'Understanding of Company Culture': {
      'Max Points': 5,
      'Score': 0,
      'Comment':
          'How well the applicant aligns with the company’s values and culture.',
    },
    'Commitment to Long-term Growth': {
      'Max Points': 5,
      'Score': 0,
      'Comment': 'Long-term potential and career goals alignment.',
    },
    'Interest in Role': {
      'Max Points': 5,
      'Score': 0,
      'Comment': 'Genuine interest in the role and the company.',
    },
    'Career Goals Alignment': {
      'Max Points': 5,
      'Score': 0,
      'Comment':
          'How the applicant’s career goals align with the company’s objectives.',
    },
  };

  // Store the overall score and evaluation
  double totalPoints = 0;
  String evaluation = '';
  String topEvaluationArea = '';

  TextEditingController commentController = TextEditingController();

  // Generate the total points and evaluation result
  void generateResults() {
    totalPoints = evaluationCriteria.values
        .fold(0, (sum, criterion) => sum + criterion['Score']!);

    evaluation = totalPoints >= 80
        ? 'Excellent (80-100)'
        : totalPoints >= 60
            ? 'Good (60-79)'
            : totalPoints >= 40
                ? 'Fair (40-59)'
                : 'Not Suitable (<40)';

    // Find the top evaluation area
    int maxScore = evaluationCriteria.values
        .map((criterion) => criterion['Score']!)
        .reduce((a, b) => a > b ? a : b);

    List<String> topAreas = evaluationCriteria.entries
        .where((entry) => entry.value['Score'] == maxScore)
        .map((entry) => entry.key)
        .toList();

    topEvaluationArea =
        topAreas.join(', '); // Multiple areas with the same max score
  }

  // Function to save the feedback (for now, it's a placeholder function)
  void saveFeedback() {
    print('Feedback Saved: $evaluation');
    print('Total Points: $totalPoints');
    print('Top Evaluation Area: $topEvaluationArea');
    print('Comments: ${commentController.text}');
    // Here you would save the feedback to the database or backend
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Interview Feedback'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Table Form for Evaluation Criteria
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: evaluationCriteria.keys.map((area) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 200,
                            child: Text(
                              area,
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              initialValue: evaluationCriteria[area]!['Score']
                                  ?.toString(),
                              decoration: InputDecoration(
                                labelText:
                                    'Score (0 - ${evaluationCriteria[area]!['Max Points']})',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                // Validate the input score (0 <= score <= max score)
                                int score = int.tryParse(value) ?? 0;
                                if (score >= 0 &&
                                    score <=
                                        evaluationCriteria[area]![
                                            'Max Points']!) {
                                  setState(() {
                                    evaluationCriteria[area]!['Score'] = score;
                                  });
                                }
                              },
                            ),
                          ),
                          SizedBox(width: 10),
                          Container(
                            width: 120,
                            child: Text(
                              'Max: ${evaluationCriteria[area]!['Max Points']}',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            // Generate Results Button
            ElevatedButton(
              onPressed: () {
                generateResults();
                setState(() {});
              },
              child: Text('Generate Results'),
            ),

            // Display Evaluation Results
            if (totalPoints > 0)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Points: ${totalPoints.toStringAsFixed(2)}'),
                    SizedBox(height: 8),
                    Text('Top Evaluation Area/Aspect: $topEvaluationArea'),
                    SizedBox(height: 8),
                    Text('Evaluation: $evaluation'),
                  ],
                ),
              ),

            // Comment Box
            TextField(
              controller: commentController,
              decoration: InputDecoration(
                labelText: 'Comments',
                border: OutlineInputBorder(),
                hintText: 'Add any additional comments here...',
              ),
              maxLines: 4,
            ),

            // Save Feedback Button
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: saveFeedback,
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Colors.green, // Green button color
                ),
                child: Text('Save Feedback'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
