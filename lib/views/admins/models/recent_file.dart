import 'package:cloud_firestore/cloud_firestore.dart';

class RecentUser {
  final String? uid, icon, role, fname, lname, email, status, subscriptionType; 
  final Timestamp? dateSubscribed;

  RecentUser({this.uid, this.icon, this.role, this.email, this.fname, this.lname, this.status, this.subscriptionType, this.dateSubscribed});
}

// List demoRecentFiles = [
//   RecentFile(
//     icon: "assets/icons/xd_file.svg",
//     title: "XD File",
//     date: "01-03-2021",
//     size: "3.5mb",
//   ),
//   RecentFile(
//     icon: "assets/icons/Figma_file.svg",
//     title: "Figma File",
//     date: "27-02-2021",
//     size: "19.0mb",
//   ),
//   RecentFile(
//     icon: "assets/icons/doc_file.svg",
//     title: "Document",
//     date: "23-02-2021",
//     size: "32.5mb",
//   ),
//   RecentFile(
//     icon: "assets/icons/sound_file.svg",
//     title: "Sound File",
//     date: "21-02-2021",
//     size: "3.5mb",
//   ),
//   RecentFile(
//     icon: "assets/icons/media_file.svg",
//     title: "Media File",
//     date: "23-02-2021",
//     size: "2.5gb",
//   ),
//   RecentFile(
//     icon: "assets/icons/pdf_file.svg",
//     title: "Sales PDF",
//     date: "25-02-2021",
//     size: "3.5mb",
//   ),
//   RecentFile(
//     icon: "assets/icons/excel_file.svg",
//     title: "Excel File",
//     date: "25-02-2021",
//     size: "34.5mb",
//   ),
// ];
