import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class TalentCategoryWidget extends StatelessWidget {
  const TalentCategoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List<CategoryCard> categoryCards = [
      CategoryCard(title: 'Development & IT', rating: '4.8/5', skills: '1234 skills'),
      CategoryCard(title: 'AI Service', rating: '4.8/5', skills: '1234 skills'),
      CategoryCard(title: 'Design and Creative', rating: '4.8/5', skills: '1234 skills'),
      CategoryCard(title: 'Sales and Marketing', rating: '4.8/5', skills: '1234 skills'),
      CategoryCard(title: 'Writing and Translation', rating: '4.8/5', skills: '1234 skills'),
      CategoryCard(title: 'Admin Support', rating: '4.8/5', skills: '1234 skills'),
      CategoryCard(title: 'Finance and Accounting', rating: '4.8/5', skills: '1234 skills'),
      CategoryCard(title: 'Architecture', rating: '4.8/5', skills: '1234 skills'),
      CategoryCard(title: 'Another Category', rating: '4.8/5', skills: '1234 skills'),
    ];

    return Stack(
      children: [
        Container(
          color: const Color(0xFF256EFF),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    'Browse talent by category',
                    style: TextStyle(
                      fontFamily: 'Galano',
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, bottom: 16),
                  child: Row(
                    children: [
                      Text(
                        'Looking for work?',
                        style: TextStyle(
                          fontFamily: 'Galano',
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      const Gap(1),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Browse jobs',
                          style: TextStyle(
                            fontFamily: 'Galano',
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: const Color(0xFFFDC000),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 400, // Total height for the scrollable area
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: (categoryCards.length / 2).ceil(),
                    itemBuilder: (context, index) {
                      final firstRowIndex = index * 2;
                      final secondRowIndex = firstRowIndex + 1;

                      return Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Column(
                          children: [
                            categoryCards[firstRowIndex],
                            if (secondRowIndex < categoryCards.length)
                              const Gap(16),
                            if (secondRowIndex < categoryCards.length)
                              categoryCards[secondRowIndex],
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String title;
  final String rating;
  final String skills;

  const CategoryCard({
    super.key,
    required this.title,
    required this.rating,
    required this.skills,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350,
      height: 180, // Fixed width for each card
      child: InkWell(
        onTap: () {},
        child: Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Galano',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF202855),
                  ),
                ),
                const Gap(8),
                Row(
                  children: [
                    const Icon(
                      Icons.star_rate_rounded,
                      color: Colors.orange,
                    ),
                    Text(
                      rating,
                      style: TextStyle(
                        fontFamily: 'Galano',
                        fontSize: 14,
                        color: const Color(0xFF202855),
                      ),
                    ),
                  ],
                ),
                const Gap(8),
                Text(
                  skills,
                  style: TextStyle(
                    fontFamily: 'Galano',
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
