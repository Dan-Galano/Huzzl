import 'package:cloud_firestore/cloud_firestore.dart';

class Subscriber{ 
  String uid;
  String hiringManagerFirstName;
  String hiringManagerLastName;
  String phone;
  Timestamp dateSubscribed;
  int jobPostsCount;
  Subscriber({
    required this.uid,
    required this.hiringManagerFirstName,
    required this.hiringManagerLastName,
    required this.phone,
    required this.dateSubscribed,
    required this.jobPostsCount,
  });
}