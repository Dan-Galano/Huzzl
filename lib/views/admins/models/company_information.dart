import 'package:cloud_firestore/cloud_firestore.dart';

class CompanyInformation {
  String uid;
  String companyName;
  String ceoFirstName;
  String ceoLastName;
  String industry;
  String companyDescription;
  String locationOtherInformation;
  String city;
  String region;
  String province;
  Timestamp createdAt;
  List<String> businessDocuments;

  CompanyInformation({
    required this.uid,
    required this.companyName,
    required this.ceoFirstName,
    required this.ceoLastName,
    required this.industry,
    required this.companyDescription,
    required this.locationOtherInformation,
    required this.city,
    required this.region,
    required this.province,
    required this.createdAt,
    required this.businessDocuments,
  });
}