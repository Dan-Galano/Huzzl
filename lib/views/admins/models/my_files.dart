import 'package:flutter/material.dart';
import 'package:huzzl_web/views/admins/constants.dart';

class CloudStorageInfo {
  final String? svgSrc, title;
  final Color? color;

  CloudStorageInfo({
    this.svgSrc,
    this.title,
    this.color,
  });
}



List demoMyFiles = [
  
  CloudStorageInfo(
    title: "Recruiter",
    svgSrc: "assets/images/company-black.png",
    color: primaryColor,
  ),
  CloudStorageInfo(
    title: "Job-seeker",
    svgSrc: "assets/images/job-seeker-black.png",
    color: Color(0xFFFFA113),
  ),
  CloudStorageInfo(
    title: "Job Post",
    svgSrc: "assets/images/job-black.png",
    color: Colors.red,
  ),
  // CloudStorageInfo(
  //   title: "Documents",
  //   numOfFiles: 5328,
  //   svgSrc: "assets/icons/drop_box.svg",
  //   totalStorage: "7.3GB",
  //   color: Color(0xFF007EE5),
  //   percentage: 78,
  // ),
];
