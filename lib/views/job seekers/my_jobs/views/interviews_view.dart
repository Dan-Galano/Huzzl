import 'package:flutter/material.dart';
import 'package:huzzl_web/views/job%20seekers/controller/jobseeker_provider.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/calendar_ui/interview_model.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/controller/interview_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class InterviewsView extends StatefulWidget {
  InterviewsView({super.key});

  @override
  State<InterviewsView> createState() => _InterviewsViewState();
}

class _InterviewsViewState extends State<InterviewsView> {
  late List<InterviewEvent> myLateForInterviewJobs;
  late JobseekerProvider _jobseekerProvider;

  List<InterviewEvent> myForInterviewJobs = [];

  @override
  void initState() {
    _jobseekerProvider = Provider.of<JobseekerProvider>(context, listen: false);
    fetchForInterviewJobs();
    super.initState();
  }

  void fetchForInterviewJobs() async {
    myLateForInterviewJobs = await _jobseekerProvider.fetchForInterviewJobs();
    setState(() {
      myForInterviewJobs = myLateForInterviewJobs;
    });
    print("My applied jobs: ${myForInterviewJobs.length}");
  }

  String formatTimeOfDay(TimeOfDay timeOfDay) {
    final hour = timeOfDay.hour;
    final minute = timeOfDay.minute;
    final period = hour >= 12 ? 'PM' : 'AM';
    final formattedHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    final formattedMinute =
        minute.toString().padLeft(2, '0'); // Ensures two digits for minutes
    return '$formattedHour:$formattedMinute $period';
  }

  @override
  Widget build(BuildContext context) {
    var interviewProvider = Provider.of<InterviewProvider>(context);
    if (myForInterviewJobs.isNotEmpty) {
      return ListView.builder(
        itemCount: myForInterviewJobs.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                // Icon or Image
                Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.business, color: Colors.blue, size: 24),
                ),

                SizedBox(width: 16),

                // Job details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        myForInterviewJobs[index].title!,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Text(
                        myForInterviewJobs[index].type!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),

                // SizedBox(width: 10),

                // Date and time
                Row(
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today,
                              color: Colors.orange, size: 16),
                          SizedBox(width: 4),
                          Text(
                            // Format the date
                            DateFormat('MMMM d, yyyy')
                                .format(myForInterviewJobs[index].date!),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange.shade800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      '${formatTimeOfDay(myForInterviewJobs[index].startTime!)} - ${formatTimeOfDay(myForInterviewJobs[index].endTime!)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),

                SizedBox(width: 16),

                // Join Call button
                ElevatedButton.icon(
                  onPressed: () {
                    // Handle join call action
                    if(myForInterviewJobs[index].status == 'not started'){
                      return;
                    }

                    interviewProvider.startInterviewFunction(context, 'jobseeker');
                    
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        myForInterviewJobs[index].status == "not started"
                            ? Colors.grey.shade200
                            : const Color(0xff3B7DFF),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: Icon(Icons.video_call,
                      color: Colors.grey.shade700, size: 20),
                  label: Text(
                    "Join call",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/empty_box.png",
            width: 140,
          ),
          SizedBox(height: 20),
          Text(
            "You did not apply to any jobs.",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      );
    }
  }
}
