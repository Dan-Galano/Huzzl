import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/calendar_ui/interview_model.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/controller/interview_provider.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/views/evaluation_model.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/views/rangelimitingformatter.dart';
import 'package:huzzl_web/widgets/buttons/blue/bluefilled_circlebutton.dart';
import 'package:provider/provider.dart';

class EvaluationScreen extends StatefulWidget {
  final InterviewEvent interviewDetails;
  EvaluationScreen({
    super.key,
    required this.interviewDetails,
  });

  @override
  _EvaluationScreenState createState() => _EvaluationScreenState();
}

class _EvaluationScreenState extends State<EvaluationScreen> {
  List<EvaluationModel> evaluationData = [
    EvaluationModel(
      evaluationArea: "Communication Skills",
      totalPoints: 20,
      criteriaList: [
        Criteria(
          title: "Clarity & Articulation",
          comment: "Ability to speak clearly and organize thoughts.",
          maxPoints: 5,
        ),
        Criteria(
          title: "Listening & Response Quality",
          comment: "Active listening and appropriate responses.",
          maxPoints: 5,
        ),
      ],
    ),
    EvaluationModel(
      evaluationArea: "Professionalism & Presentation",
      totalPoints: 15,
      criteriaList: [
        Criteria(
          title: "Appearance",
          comment: "Grooming and attire appropriate for the interview.",
          maxPoints: 5,
        ),
        Criteria(
          title: "Punctuality & Technical Setup",
          comment: "On-time, no technical issues, clear video/audio.",
          maxPoints: 5,
        ),
        Criteria(
          title: "Attitude & Respect",
          comment: "Polite, positive, and engaged throughout.",
          maxPoints: 5,
        ),
      ],
    ),
    EvaluationModel(
      evaluationArea: "Job Knowledge & Expertise",
      totalPoints: 25,
      criteriaList: [
        Criteria(
          title: "Industry Knowledge",
          comment: "Knowledge of industry trends and company specifics.",
          maxPoints: 10,
        ),
        Criteria(
          title: "Role-specific Expertise",
          comment: "Demonstrates relevant skills and experience.",
          maxPoints: 10,
        ),
        Criteria(
          title: "Problem Solving",
          comment: "Ability to analyze challenges and provide solutions.",
          maxPoints: 5,
        ),
      ],
    ),
    EvaluationModel(
      evaluationArea: "Behavioral & Soft Skills",
      totalPoints: 20,
      criteriaList: [
        Criteria(
          title: "Teamwork & Collaboration",
          comment:
              "Ability to work with others and contribute to team efforts.",
          maxPoints: 5,
        ),
        Criteria(
          title: "Adaptability",
          comment: "Ability to adjust to new situations and challenges.",
          maxPoints: 5,
        ),
        Criteria(
          title: "Conflict Resolution",
          comment: "Ability to handle conflicts professionally.",
          maxPoints: 5,
        ),
        Criteria(
          title: "Self-Motivation",
          comment: "Demonstrates initiative and drive.",
          maxPoints: 5,
        ),
      ],
    ),
    EvaluationModel(
      evaluationArea: "Cultural Fit & Alignment with Company Values",
      totalPoints: 15,
      criteriaList: [
        Criteria(
          title: "Understanding of Company Culture",
          comment: "Demonstrates knowledge of company values.",
          maxPoints: 7,
        ),
        Criteria(
          title: "Commitment to Long-term Growth",
          comment: "Interest in growing with the company.",
          maxPoints: 8,
        ),
      ],
    ),
    EvaluationModel(
      evaluationArea: "Motivation & Interest in the Role",
      totalPoints: 15,
      criteriaList: [
        Criteria(
          title: "Interest in Role",
          comment: "Enthusiasm and motivation for the role.",
          maxPoints: 10,
        ),
        Criteria(
          title: "Career Goals Alignment",
          comment: "Alignment of personal career goals with the role.",
          maxPoints: 5,
        ),
      ],
    ),
  ];
  TextEditingController commentController = TextEditingController();

  double totalPoints = 0;
  String evaluation = '';
  String topEvaluationArea = '';

// Generate the total points and evaluation result
  void generateResults() {
    totalPoints = evaluationData.fold(0, (sum, area) {
      return sum +
          area.criteriaList.fold(0,
              (criteriaSum, criteria) => criteriaSum + criteria.currentScore);
    });

    // Determine evaluation level
    evaluation = totalPoints >= 80
        ? 'Excellent (80-100)'
        : totalPoints >= 60
            ? 'Good (60-79)'
            : totalPoints >= 40
                ? 'Fair (40-59)'
                : 'Not Suitable (<40)';

    // Identify the highest scored evaluation areas
    int maxScore = 0;
    List<String> topAreas = [];

    for (var area in evaluationData) {
      final int areaScore = area.criteriaList.fold(
          0, (criteriaSum, criteria) => criteriaSum + criteria.currentScore);

      if (areaScore > maxScore) {
        maxScore = areaScore;
        topAreas = [area.evaluationArea];
      } else if (areaScore == maxScore) {
        topAreas.add(area.evaluationArea);
      }
    }

    topEvaluationArea = topAreas.join(', '); // Handle ties
  }

  // Function to save the feedback
  void saveFeedback() {
    print('Feedback Saved: $evaluation');
    print('Total Points: $totalPoints');
    print('Top Evaluation Area: $topEvaluationArea');
    print('Comments: ${commentController.text}');
    // Here you would save the feedback to the database or backend
  }

  @override
  Widget build(BuildContext context) {
    var interviewProvider = Provider.of<InterviewProvider>(context);
    return Scaffold(
      appBar: AppBar(
        // title: Text('Interview Feedback'),
        backgroundColor: Colors.white,
        forceMaterialTransparency: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(20),
              Center(
                  child: Container(
                width: MediaQuery.of(context).size.width * 0.50,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Center(
                      child: Text(
                        "Interview Evaluation & Feedback Form",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors
                              .black, // You can change the color if needed
                        ),
                      ),
                    ),
                    SizedBox(
                        height:
                            10), // Adds some space between the header and description

                    // Description
                    Center(
                      child: Text(
                        textAlign: TextAlign.center,
                        "Please rate the interviewer's performance based on various criteria to provide valuable feedback. Your feedback will play a crucial role in the decision-making process to select the best candidate for the role.",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[
                              700], // Light grey color for the description
                        ),
                      ),
                    ),
                  ],
                ),
              )),
              Gap(20),
              Center(
                child: Container(
                    width: MediaQuery.of(context).size.width * 0.60,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 0.5),
                        borderRadius: BorderRadius.circular(30)),
                    padding: EdgeInsets.all(50),
                    child: Column(
                      children: [
                        Column(
                          children:
                              List.generate(evaluationData.length, (index) {
                            final evaluation = evaluationData[index];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Evaluation Area Header
                                Text(
                                  "${evaluation.evaluationArea} (${evaluation.totalPoints} pts)",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.amber[900]),
                                ),
                                Gap(20),
                                // Criteria Cards
                                ...List.generate(evaluation.criteriaList.length,
                                    (criteriaIndex) {
                                  final criteria =
                                      evaluation.criteriaList[criteriaIndex];
                                  return Card(
                                    elevation: 0,
                                    margin: EdgeInsets.only(bottom: 20),
                                    color: Colors.grey.withOpacity(0.1),
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            flex: 10,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "${criteria.title} (${criteria.maxPoints})",
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Gap(5),
                                                Text(
                                                  criteria.comment,
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                                Gap(20),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: TextFormField(
                                              controller: TextEditingController(
                                                text: criteria.currentScore
                                                    .toString(),
                                              ),
                                              textAlign: TextAlign.center,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  borderSide: BorderSide(
                                                    color: const Color.fromARGB(
                                                        255, 59, 59, 59),
                                                    width: 1.5,
                                                  ),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  borderSide: const BorderSide(
                                                    color: const Color.fromARGB(
                                                        255, 59, 59, 59),
                                                    width: 1.5,
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  borderSide: const BorderSide(
                                                    color: const Color.fromARGB(
                                                        255, 59, 59, 59),
                                                    width: 1.5,
                                                  ),
                                                ),
                                              ),
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .digitsOnly,
                                                RangeLimitingTextInputFormatter(
                                                    criteria.maxPoints),
                                              ],
                                              onChanged: (value) {
                                                final score =
                                                    int.tryParse(value);
                                                if (score != null &&
                                                    score >= 0 &&
                                                    score <=
                                                        criteria.maxPoints) {
                                                  setState(() {
                                                    criteria.currentScore =
                                                        score;
                                                  });
                                                }
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                                Gap(30),
                              ],
                            );
                          }),
                        ),
                        Gap(10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              generateResults();
                              setState(
                                  () {}); // Trigger a rebuild to show results
                            },
                            child: Text(
                              'See Results',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0038FF)),
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
              Gap(10),
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.60,
                  child: Column(
                    children: [
                      // Generate Results Button

                      // Display Evaluation Results
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey, width: 1.5),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: totalPoints > 0
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Total Points:',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                              Text(
                                                '${totalPoints} / 100',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 8),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Top Evaluation Area/Aspect:',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                              Text(
                                                '$topEvaluationArea',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 8),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Evaluation:',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                              Text(
                                                '$evaluation',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: totalPoints >= 80
                                                      ? Colors.green
                                                      : totalPoints >= 60
                                                          ? Colors.blue
                                                          : totalPoints >= 40
                                                              ? Colors.orange
                                                              : Colors
                                                                  .red, // Color based on totalPoints
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    : Center(
                                        child: Text(
                                          "Results will appear here",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Gap(30),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Comments/feedback about the interview",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Gap(5),
                      // Comment Box
                      TextField(
                        controller: commentController,
                        decoration: InputDecoration(
                          hintText: "Put your comments here...",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1.5,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                              width: 1.5,
                            ),
                          ),
                        ),
                        maxLines: 10,
                      ),
                      // Save Feedback Button
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30.0),
                        child: BlueFilledCircleButton(
                          onPressed: () {
                            saveFeedback();
                            debugPrint(
                                "interview details used in evaluationnnnnn: ${widget.interviewDetails.interviewId} ${widget.interviewDetails.applicant}");
                            interviewProvider.saveInterviewEvaluation(
                              widget.interviewDetails,
                              evaluation,
                              totalPoints.toString(),
                              topEvaluationArea,
                              commentController.text,
                            );
                            interviewProvider.toggleShowEvaluation();
                          },
                          text: 'Save Feedback',
                        ),
                      ),
                      Gap(100),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
