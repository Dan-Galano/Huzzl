import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/job%20seekers/controller/jobseeker_provider.dart';
import 'package:huzzl_web/views/job%20seekers/my_jobs/model/notification.dart';
import 'package:huzzl_web/views/recruiters/interview_tab/controller/interview_provider.dart';
import 'package:huzzl_web/widgets/buttons/blue/bluefilled_boxbutton.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class RecruiterNotifScreen extends StatefulWidget {
  const RecruiterNotifScreen({super.key});

  @override
  State<RecruiterNotifScreen> createState() => _RecruiterNotifScreenState();
}

class _RecruiterNotifScreenState extends State<RecruiterNotifScreen> {
  // late JobseekerProvider _jobseekerProvider;
  late InterviewProvider _interviewProvider;

  List<NotificationModel> myNotification = [];
  bool isLoading = true;
  bool isNotificationEmpty = false;

  @override
  void initState() {
    super.initState();
    _interviewProvider = Provider.of<InterviewProvider>(context, listen: false);
    fetchNotification();
  }

  Future<void> fetchNotification() async {
    try {
      final notifications = await _interviewProvider.fetchNotification();
      setState(() {
        myNotification = notifications;
        isNotificationEmpty = notifications.isEmpty;
      });
    } catch (e) {
      debugPrint("Error fetching notifications: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Notifications',
              style: TextStyle(
                fontSize: 32,
                color: Color(0xff373030),
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            if (isLoading)
              const Center(
                child: CircularProgressIndicator(),
              )
            else if (isNotificationEmpty)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/empty_box.png",
                      width: 140,
                    ),
                    const Gap(20),
                    const Text(
                      "You don't have any notifications.",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: myNotification.length,
                  itemBuilder: (context, index) {
                    final notification = myNotification[index];
                    return Card(
                      color: notification.status == "not read"
                          ? Colors.blue[50]
                          : Colors.white,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black38, // Black border color
                            width: 1.0, // Border width
                          ),
                          borderRadius: BorderRadius.circular(
                              15), // Match Card's default radius
                        ),
                        child: ListTile(
                          title: Text(
                            notification.notifTitle,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(notification.jobTitle),
                          trailing: Text(
                            timeago.format(notification.notifDate,
                                locale: 'en'),
                            // _jobseekerProvider
                            //     .formatDate(notification.notifDate),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          leading: Container(
                            height: 48,
                            width: 48,
                            decoration: BoxDecoration(
                              color: Colors.blue.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.business,
                                color: Colors.blue, size: 24),
                          ),
                          onTap: () {
                            // _jobseekerProvider.viewNotification(notification);
                            viewNotif(notification);
                            if (notification.status == "not read") {
                              _interviewProvider.viewNotification(notification);
                            }
                            for (int i = 0; i < myNotification.length; i++) {
                              if (myNotification[i].notificationId ==
                                  notification.notificationId) {
                                // Update only the `notifTitle` field of the matching notification
                                setState(() {
                                  myNotification[i].status = "read";
                                });
                              }
                            }
                            print(
                                "Selected notification: ${notification.notifTitle}");
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  void viewNotif(NotificationModel notif) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            notif.notifTitle,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Container(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width * 0.5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(),
                Gap(20),
                Text(
                  notif.notifMessage,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            BlueFilledBoxButton(
              onPressed: () {
                Navigator.pop(context);
              },
              text: "Ok",
              width: 80,
            ),
          ],
        );
      },
    );
  }
}
