import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class ForReviewCard extends StatelessWidget {
  final String reviewBranch;
  final String reviewDescription;
  final String reviewPosition;
  final String reviewStars;
  final String reviewSummary;
  final DateTime createdAt;
  final DateTime reviewJobDate;

  ForReviewCard({
    required this.reviewBranch,
    required this.reviewDescription,
    required this.reviewPosition,
    required this.reviewStars,
    required this.reviewSummary,
    required this.createdAt,
    required this.reviewJobDate,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(width: 25),
              Text(
                reviewStars,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[900],
                  fontFamily: 'Galano',
                ),
              ),
              const SizedBox(width: 40),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reviewSummary,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900],
                        fontFamily: 'Galano',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          reviewPosition,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                            fontFamily: 'Galano',
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '- ${DateFormat('MMMM dd, yyyy').format(reviewJobDate)}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                            fontFamily: 'Galano',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.topRight,
            child: Text(
              timeago.format(createdAt),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
                fontFamily: 'Galano',
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(0, -20),
            child: Row(
              children: List.generate(5, (index) {
                int flooredStars = (double.parse(reviewStars)).floor();

                return Icon(
                  Icons.star,
                  color: index < flooredStars ? Colors.amber : Colors.grey,
                  size: 16,
                );
              }),
            ),
          ),

          // Review Text
          Text(
            reviewDescription,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
              fontFamily: 'Galano',
            ),
          ),
          const SizedBox(height: 12),
          Divider(color: Colors.grey[300], thickness: 1),
        ],
      ),
    );
  }
}

class ReviewsListView extends StatelessWidget {
  final List<Map<String, dynamic>>
      reviews; // This will be passed from the provider

  ReviewsListView({required this.reviews});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: reviews.length, // The number of items in the reviews list
        itemBuilder: (context, index) {
          final reviewData = reviews[index];

          return ForReviewCard(
            reviewBranch: reviewData['review_branch'] ?? "",
            reviewDescription: reviewData['review_description'] ?? "",
            reviewPosition: reviewData['review_position'] ?? "",
            reviewStars: reviewData['review_stars'].toString(),
            reviewSummary: reviewData['review_summary'] ?? "",
            createdAt: reviewData['created_at'],
            reviewJobDate: reviewData['review_job_date'],
          );
        },
      ),
    );
  }
}
