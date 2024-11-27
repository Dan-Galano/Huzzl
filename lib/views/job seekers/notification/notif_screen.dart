import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/job%20seekers/controller/jobseeker_provider.dart';
import 'package:huzzl_web/views/job%20seekers/my_jobs/model/notification.dart';
import 'package:huzzl_web/widgets/buttons/blue/bluefilled_boxbutton.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotifScreen extends StatefulWidget {
  const NotifScreen({super.key});

  @override
  State<NotifScreen> createState() => _NotifScreenState();
}

class _NotifScreenState extends State<NotifScreen> {
  late JobseekerProvider _jobseekerProvider;

  List<NotificationModel> myNotification = [];
  bool isLoading = true;
  bool isNotificationEmpty = false;

  @override
  void initState() {
    super.initState();
    _jobseekerProvider = Provider.of<JobseekerProvider>(context, listen: false);
    fetchNotification();
  }

  Future<void> fetchNotification() async {
    try {
      final notifications = await _jobseekerProvider.fetchNotification();
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
                            color: Colors.black, // Black border color
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
                              _jobseekerProvider.viewNotification(notification);
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
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width * 0.5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(),
                Text(
                  notif.jobTitle,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Gap(20),
                Text(notif.notifMessage),
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
