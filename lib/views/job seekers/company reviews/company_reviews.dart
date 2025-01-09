import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/job%20seekers/company%20reviews/company_view.dart';
import 'package:huzzl_web/views/recruiters/company_profile/providers/companyProfileProvider.dart';
import 'package:provider/provider.dart';

class CompanyReviews extends StatefulWidget {
  const CompanyReviews({super.key});

  @override
  State<CompanyReviews> createState() => _CompanyReviewsState();
}

class _CompanyReviewsState extends State<CompanyReviews> {
  var searchController = TextEditingController();
  final borderSide = BorderSide(
    color: Color(0xFFD1E1FF),
    width: 1.5,
  );

    List<Map<String, dynamic>> companies = [];
  List<Map<String, dynamic>> companiesYouWorkedWith = [];
  List<Map<String, dynamic>> filteredCompanies = [];

  @override
  void initState() {
    super.initState();
    fetchRecruiterCompanies();
    fetchRecruiterCompaniesYouWorkedWith();
  }

  Future<void> fetchRecruiterCompanies() async {
    try {
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'recruiter')
          .get();

      List<Map<String, dynamic>> fetchedCompanies = [];

      final compProvider =
          Provider.of<CompanyProfileProvider>(context, listen: false);
      for (var userDoc in userSnapshot.docs) {
        QuerySnapshot companySnapshot =
            await userDoc.reference.collection('company_information').get();

        // Fetch reviews for the recruiter
        await compProvider.fetchAllReviews(userDoc.id);

        for (var companyDoc in companySnapshot.docs) {
          double rating = 0;

          // Check if there are reviews and set the rating accordingly
          if (compProvider.reviews.isNotEmpty) {
            rating = compProvider.reviewStarsAverage;
          }

          fetchedCompanies.add({
            'recruiterId': userDoc.id,
            'name': companyDoc['companyName'] ?? 'Unknown Company',
            'logo': Icons.business, // Update with a dynamic logo if available
            'rating': rating, // Set rating to 0 if no reviews
          });
        }
      }

      if (mounted) {
        setState(() {
          companies = fetchedCompanies;
          filteredCompanies = companies; // Initialize with all companies
        });
      }
    } catch (e) {
      print('Error fetching companies: $e');
    }
  }

  Future<void> fetchRecruiterCompaniesYouWorkedWith() async {
    try {
      // Get the logged-in user ID
      final String loggedInUserId =
          FirebaseAuth.instance.currentUser?.uid ?? '';

      if (loggedInUserId.isEmpty) {
        print('No logged-in user found.');
        return;
      }

      // Fetch job applications for the logged-in user where status is "Hired"
      QuerySnapshot jobApplicationSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(loggedInUserId)
          .collection('job_application')
          .where('status', isEqualTo: 'Hired')
          .get();

      // Use a set to store recruiter IDs to avoid duplicates
      Set<String> recruiterIds = jobApplicationSnapshot.docs
          .map((doc) => doc['recruiterId'] as String)
          .toSet();

      if (recruiterIds.isEmpty) {
        print('No hired applications found.');
        return;
      }

      List<Map<String, dynamic>> hiredCompanies = [];

      final compProvider =
          Provider.of<CompanyProfileProvider>(context, listen: false);

      // Loop through recruiter IDs to fetch their company information
      for (String recruiterId in recruiterIds) {
        DocumentSnapshot recruiterDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(recruiterId)
            .get();

        if (!recruiterDoc.exists) continue;

        QuerySnapshot companySnapshot = await recruiterDoc.reference
            .collection('company_information')
            .get();

        // Fetch reviews for the recruiter
        await compProvider.fetchAllReviews(recruiterId);

        for (var companyDoc in companySnapshot.docs) {
          double rating = 0;

          // Check if there are reviews and set the rating accordingly
          if (compProvider.reviews.isNotEmpty) {
            rating = compProvider.reviewStarsAverage;
          }

          hiredCompanies.add({
            'recruiterId': recruiterId,
            'name': companyDoc['companyName'] ?? 'Unknown Company',
            'logo': Icons.business, // Update with a dynamic logo if available
            'rating': rating, // Set rating to 0 if no reviews
          });
        }
      }

      if (mounted) {
        setState(() {
          companiesYouWorkedWith = hiredCompanies;
        });
      }
    } catch (e) {
      print('Error fetching companies you worked with: $e');
    }
  }
  // Filter companies based on the search query
  void _filterCompanies() {
    String query = searchController.text.toLowerCase();

    setState(() {
      filteredCompanies = companies
          .where((company) => company['name']
              .toLowerCase()
              .contains(query)) // Filter by company name
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: filteredCompanies.isEmpty
          ? Center(
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                backgroundColor: Colors.transparent,
                content: Container(
                  width: 105,
                  height: 160,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        Gap(10),
                        Image.asset(
                          'assets/images/gif/huzzl_loading.gif',
                          height: 100,
                          width: 100,
                        ),
                        Gap(10),
                        Text(
                          "Wait for a moment...",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            color: Color(0xFFfd7206),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          : SingleChildScrollView(
              child: Center(
                child: Container(
                  width: 900,
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Gap(20),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              style: TextStyle(fontFamily: 'Galano'),
                              controller: searchController,
                              cursorColor: Color.fromARGB(255, 58, 63, 76),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 16.0,
                                  horizontal: 14.0,
                                ),
                                isDense: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: borderSide,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: borderSide,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: borderSide,
                                ),
                                hintText: 'Search company...',
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Icon(
                                    Icons.search,
                                    size: 30,
                                    color: Color(0xFFFE9703),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          ElevatedButton(
                            onPressed:
                                _filterCompanies, // Trigger search when button is pressed
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF0038FF),
                              padding: EdgeInsets.all(20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Find company',
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.white,
                                fontFamily: 'Galano',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Gap(30),
                      Text(
                        "Review the Companies You've Worked With",
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Galano',
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3A3F4C),
                        ),
                      ),
                      Gap(20),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 2.5,
                        ),
                        itemCount: companiesYouWorkedWith.length,
                        itemBuilder: (context, index) {
                          var company = companiesYouWorkedWith[index];
                          return GestureDetector(
                            onTap: () =>
                                Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => CompanyViewScreen(
                                recruiterId: company['recruiterId'],
                                showReviewBtn: true,
                              ),
                            )),
                            child: Card(
                              color: Colors.white,
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(12),
                                child: Row(
                                  children: [
                                    Icon(
                                      company['logo'],
                                      size: 40,
                                      color: Color(0xFFFE9703),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            company['name'],
                                            style: TextStyle(
                                              fontFamily: 'Galano',
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                company['rating']
                                                    .toStringAsFixed(2),
                                                style: TextStyle(
                                                  fontFamily: 'Galano',
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              Gap(10),
                                              Row(
                                                children:
                                                    List.generate(5, (index) {
                                                  int flooredStars =
                                                      company['rating'].floor();

                                                  return Icon(
                                                    Icons.star,
                                                    color: index < flooredStars
                                                        ? Colors.amber
                                                        : Colors.grey,
                                                    size: 16,
                                                  );
                                                }),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      Gap(40),
                      Text(
                        "All Huzzl Companies",
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Galano',
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3A3F4C),
                        ),
                      ),
                      Gap(20),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 2.5,
                        ),
                        itemCount: filteredCompanies.length,
                        itemBuilder: (context, index) {
                          var company = filteredCompanies[index];
                          return GestureDetector(
                            onTap: () =>
                                Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => CompanyViewScreen(
                                recruiterId: company['recruiterId'],
                                showReviewBtn:  companiesYouWorkedWith.contains(company),
                              ),
                            )),
                            child: Card(
                              color: Colors.white,
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(12),
                                child: Row(
                                  children: [
                                    Icon(
                                      company['logo'],
                                      size: 40,
                                      color: Color(0xFFFE9703),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            company['name'],
                                            style: TextStyle(
                                              fontFamily: 'Galano',
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                company['rating']
                                                    .toStringAsFixed(2),
                                                style: TextStyle(
                                                  fontFamily: 'Galano',
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              Gap(10),
                                              Row(
                                                children:
                                                    List.generate(5, (index) {
                                                  int flooredStars =
                                                      company['rating'].floor();

                                                  return Icon(
                                                    Icons.star,
                                                    color: index < flooredStars
                                                        ? Colors.amber
                                                        : Colors.grey,
                                                    size: 16,
                                                  );
                                                }),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
