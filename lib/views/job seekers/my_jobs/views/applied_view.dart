import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/job%20seekers/controller/jobseeker_provider.dart';
import 'package:huzzl_web/views/job%20seekers/my_jobs/model/applied_jobs.dart';
import 'package:huzzl_web/views/job%20seekers/my_jobs/widgets/status_ui.dart';
import 'package:provider/provider.dart';

class AppliedView extends StatefulWidget {
  AppliedView({super.key});

  @override
  State<AppliedView> createState() => _AppliedViewState();
}

class _AppliedViewState extends State<AppliedView> {
  late List<AppliedJobs> myLateAppliedJobs;
  late JobseekerProvider _jobseekerProvider;

  List<AppliedJobs> myAppliedJobs = [];

  @override
  void initState() {
    _jobseekerProvider = Provider.of<JobseekerProvider>(context, listen: false);
    fetchAppliedJobs();
    super.initState();
  }

  void fetchAppliedJobs() async {
    myLateAppliedJobs = await _jobseekerProvider.fetchAppliedJobs();
    setState(() {
      myAppliedJobs = myLateAppliedJobs;
    });
    print("My applied jobs: ${myAppliedJobs.length}");
  }

  @override
  Widget build(BuildContext context) {
    if (myAppliedJobs.isNotEmpty) {
      return ListView.builder(
        itemCount: myAppliedJobs.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: EdgeInsets.all(20),
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
                        myAppliedJobs[index].jobTitle,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                    ],
                  ),
                ),

                SizedBox(width: 16),

                // Status button
                StatusUi(myAppliedJob: myAppliedJobs[index]),
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
          const Gap(20),
          const Text(
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
