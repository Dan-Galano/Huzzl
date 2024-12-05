import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class SavedView extends StatefulWidget {
  SavedView({super.key});

  @override
  State<SavedView> createState() => _SavedViewState();
}

class _SavedViewState extends State<SavedView> {
  List<Map<String, dynamic>> mySavedJobs = [];
  bool isLoading = true;

  Future<void> fetchSavedJobs() async {
    try {
      final jobseekerId = FirebaseAuth.instance.currentUser!.uid;

      debugPrint("Jobseeker ID: $jobseekerId");

      // Fetch the collection data
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(jobseekerId)
          .collection('save_jobs') // Ensure the collection name is correct
          .get();

      // Update the list and UI
      setState(() {
        mySavedJobs = querySnapshot.docs.map((doc) {
          final data = doc.data();
          return {
            'email': data['email'] ?? '',
            'firstName': data['firstName'] ?? '',
            'lastName': data['lastName'] ?? '',
            'jobPostId': data['jobPostId'] ?? '',
            'jobTitle': data['jobTitle'] ?? '',
            'phoneNumber': data['phoneNumber'] ?? '',
            'preScreenAnswer': data['preScreenAnswer'],
            'recruiterId': data['recruiterId'] ?? '',
            'saveDate': (data['saveDate'] as Timestamp?)?.toDate(),
            'id': doc.id,
          };
        }).toList();
        isLoading = false;
      });

      print('Saved jobs fetched successfully: $mySavedJobs');
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching saved jobs: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchSavedJobs();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return mySavedJobs.isNotEmpty
        ? ListView.builder(
            itemCount: mySavedJobs.length,
            itemBuilder: (context, index) {
              final job = mySavedJobs[index];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  color: Colors.white,
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Icon or image placeholder
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.work, color: Colors.blue),
                        ),
                        const SizedBox(width: 16),
                        // Job details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                job['jobTitle'] ?? 'Unknown Job',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              // Text(
                              //   'Hourly: ${job["firstName"]} ${job["lastName"]}',
                              //   style: const TextStyle(
                              //     fontSize: 14,
                              //     color: Colors.grey,
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Actions (e.g., Apply now, Bookmark, Menu)
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.indigo, // Button color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Apply now',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.bookmark,
                                  color: Colors.orange),
                            ),
                            // IconButton(
                            //   onPressed: () {},
                            //   icon: const Icon(Icons.more_vert),
                            // ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/empty_box.png",
                width: 140,
              ),
              const Gap(20),
              const Text(
                "You don't have any saved jobs.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          );
  }
}
