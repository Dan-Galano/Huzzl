import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

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

  final List<Map<String, dynamic>> companies = [
    {"name": "Huzzl", "logo": Icons.business, "rating": 3.4},
    {"name": "Dell", "logo": Icons.computer, "rating": 3.4},
    {"name": "Accenture", "logo": Icons.corporate_fare, "rating": 3.4},
    {"name": "Apple", "logo": Icons.phone_iphone, "rating": 3.4},
    {"name": "Salesforce", "logo": Icons.cloud, "rating": 3.4},
    {"name": "Razer", "logo": Icons.videogame_asset, "rating": 3.4},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff8f8f8),
      body: SingleChildScrollView(
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
                      onPressed: () {},
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
                  "Popular Companies",
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
                    crossAxisCount: 3, // 3 columns
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 2.5, // Aspect ratio of the cards
                  ),
                  itemCount: companies.length,
                  itemBuilder: (context, index) {
                    var company = companies[index];
                    return Card(
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
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
                                        company['rating'].toString(),
                                        style: TextStyle(
                                          fontFamily: 'Galano',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Gap(10),
                                      Row(
                                        children: List.generate(5, (starIndex) {
                                          return Icon(
                                            Icons.star,
                                            size: 18,
                                            color: starIndex < company['rating']
                                                ? Colors.amber
                                                : Colors.grey,
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
