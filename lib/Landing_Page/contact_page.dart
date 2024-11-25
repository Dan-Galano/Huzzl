import 'package:flutter/material.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.grey[850],
        padding: const EdgeInsets.only(right: 300, left: 300, top: 50),
        child: Column(
          children: [
            Card(
              elevation: 8, 
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20), 
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'We’d love to hear from you!',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        fontFamily: 'Galano',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Feel free to reach out with any questions or feedback.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                        fontFamily: 'Galano',
                      ),
                    ),
                    const SizedBox(height: 30),
                    _buildTextField('Email Address'),
                    const SizedBox(height: 16),
                    _buildTextField('Your Message', maxLines: 5),
                    const SizedBox(height: 30),
                    Center(
                      child: _buildSubmitButton(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'Team',
              style: TextStyle(
                fontSize: 14,
                color: const Color.fromARGB(221, 255, 255, 255),
                fontFamily: 'Galano',
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              'Dan Galano  •  Allen Alvaro  •  Patrick John Tomas  •  Monica Ave  •  Dessamine Almuete',
              style: TextStyle(
                fontSize: 12,
                color: const Color.fromARGB(221, 255, 255, 255),
                fontFamily: 'Galano',
                fontWeight: FontWeight.normal,
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, {int maxLines = 1}) {
    return TextField(
      maxLines: maxLines,
      style: TextStyle(
        fontSize: 14,
        color: Colors.black87,
        fontFamily: 'Galano',
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.grey[700],
          fontFamily: 'Galano',
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueAccent, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[400]!, width: 1.5),
        ),
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 30),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: () {

      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange, 
        foregroundColor: Colors.white, 
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 5, 
      ),
      child: Text(
        'Send Message',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          fontFamily: 'Galano',
        ),
      ),
    );
  }
}
