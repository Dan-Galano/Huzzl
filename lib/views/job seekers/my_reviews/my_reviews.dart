import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/job%20seekers/my_jobs/views/applied_view.dart';
import 'package:huzzl_web/views/job%20seekers/my_jobs/views/archived_view.dart';
import 'package:huzzl_web/views/job%20seekers/my_jobs/views/interviews_view.dart';
import 'package:huzzl_web/views/job%20seekers/my_jobs/views/saved_view.dart';
import 'package:huzzl_web/views/job%20seekers/my_reviews/views/reviews_view.dart';

class MyReviewsView extends StatefulWidget {
  const MyReviewsView({super.key});

  @override
  State<MyReviewsView> createState() => _MyReviewsViewState();
}

class _MyReviewsViewState extends State<MyReviewsView>
    with SingleTickerProviderStateMixin {
  List<String> datePostedOptions = [
    '5 stars',
    '4 stars',
    '3 stars',
    '2 stars',
    '1 star'
  ];

  String myReviews = 'All reviews';

  Widget _buildCustomDropdown<T>({
    required T value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xffD9D9D9), width: 2),
        borderRadius: BorderRadius.circular(10), // Rounded border
      ),
      child: DropdownButton<T>(
        value: value,
        icon: const Icon(Icons.arrow_drop_down),
        underline: const SizedBox(), // Remove default underline
        isExpanded: false, // Prevent the dropdown from covering itself
        style: const TextStyle(color: Colors.black),
        onChanged: onChanged,
        items: items.map<DropdownMenuItem<T>>((T value) {
          return DropdownMenuItem<T>(
            value: value,
            child: Text(
              value.toString(),
              style: const TextStyle(fontFamily: 'Galano'),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //==================================== Header ====================================
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    double screenWidth = constraints.maxWidth;
                    double textFieldWidth = screenWidth * 0.7;
                    double spacing = screenWidth > 600 ? 20 : 10;

                    return Row(
                      children: [
                        SizedBox(width: spacing),
                        const Text(
                          'My Reviews',
                          style: TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: 32,
                            color: Color(0xff373030),
                            fontFamily: 'Galano',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildCustomDropdown<String>(
                    value: myReviews,
                    items: [
                      'All reviews',
                      '5 stars',
                      '4 stars',
                      '3 stars',
                      '2 stars',
                      '1 star'
                    ],
                    onChanged: (String? newValue) {
                      setState(() {
                        myReviews = newValue!;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          // const MyReviewsView(),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.1),
            child: Column(
              children: [
                Divider(
                  color: Color(0xff669AFF),
                ),
                const Gap(80),
                MyReviews(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
