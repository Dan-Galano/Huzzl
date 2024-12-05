import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProfilePage(),
    ),
  );
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(
            left: 300, right: 300, top: 50), // Added padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Circular Image
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage(
                      'assets/images/profile_picture.png'), // Replace with your image path
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name and Pronouns
                      Text(
                        'Jane Doe',
                        style: TextStyle(
                          fontFamily: 'Galano',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF3B7DFF), // Blue color
                        ),
                      ),
                      const Text(
                        '(She / Her)',
                        style: TextStyle(
                          fontFamily: 'Galano',
                          fontSize: 14,
                          color: Color(0xFF757575), // Gray color
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Title and Badge
                      Row(
                        children: [
                          const Text(
                            'Chief of Party',
                            style: TextStyle(
                              fontFamily: 'Galano',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF181818), // Blackish color
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'RECRUITER PICK',
                              style: TextStyle(
                                fontFamily: 'Galano',
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Role: Admin',
                        style: TextStyle(
                          fontFamily: 'Galano',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Email
                      const Text(
                        'Email: jane.doe@example.com',
                        style: TextStyle(
                          fontFamily: 'Galano',
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Phone Number
                      const Text(
                        'Phone Number: +1 (555) 123-4567',
                        style: TextStyle(
                          fontFamily: 'Galano',
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Updated 16 hours ago',
                        style: TextStyle(
                          fontFamily: 'Galano',
                          fontSize: 12,
                          color: Color(0xFF757575), // Gray color
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Work Experience
            const Text(
              'Work Experience',
              style: TextStyle(
                fontFamily: 'Galano',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF181818),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '• Chief of Party - Sustainable Futures Foundation (Washington, D.C.)',
              style: TextStyle(
                fontFamily: 'Galano',
                fontSize: 14,
                color: Color(0xFF181818),
              ),
            ),
            const Text(
              '• Program Manager - International Aid Organization (Nairobi)',
              style: TextStyle(
                fontFamily: 'Galano',
                fontSize: 14,
                color: Color(0xFF181818),
              ),
            ),
            const SizedBox(height: 16),
            // Details Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDetailItem('Experience', '10 years'),
                _buildDetailItem('Citizenship', 'United States'),
                _buildDetailItem(
                  'Languages',
                  'English, French,\nSpanish',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String title, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Galano',
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF757575), // Gray color
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Galano',
              fontSize: 14,
              color: Color(0xFF181818), // Blackish color
            ),
          ),
        ],
      ),
    );
  }
}
