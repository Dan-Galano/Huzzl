import 'package:flutter/material.dart';

class AddCardModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 400.0),
      child: Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          padding: EdgeInsets.all(30),
          height: 480, // Modal height
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Add New Card",
                    style: TextStyle(
                      fontFamily: 'Galano', // Font style
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.close,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Card Number
              TextField(
                decoration: InputDecoration(
                  labelText: "Card Number",
                  labelStyle: TextStyle(
                    fontFamily: 'Galano',
                    color: Color(0xff202855), // Updated color
                  ),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 255, 255, 255),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              // Name on Card
              TextField(
                decoration: InputDecoration(
                  labelText: "Name on Card",
                  labelStyle: TextStyle(
                    fontFamily: 'Galano',
                    color: Color(0xff202855), // Updated color
                  ),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 255, 255, 255),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Expiration Date and CVC
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: "MM / YY",
                        labelStyle: TextStyle(
                          fontFamily: 'Galano',
                          color: Color(0xff202855), // Updated color
                        ),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 255, 255, 255),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                      keyboardType: TextInputType.datetime,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: "CVC",
                        labelStyle: TextStyle(
                          fontFamily: 'Galano',
                          color: Color(0xff202855), // Updated color
                        ),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 255, 255, 255),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      obscureText: true,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Checkbox
              Row(
                children: [
                  Checkbox(
                    value: true,
                    onChanged: (bool? value) {},
                    activeColor: Colors.blue,
                  ),
                  Expanded(
                    child: Text(
                      "Set this card as default for Auto-Pay",
                      style: TextStyle(
                        fontFamily: 'Galano',
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Spacer(),
              // Continue Button
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Center(
                  child: Text(
                    "Continue",
                    style: TextStyle(
                      fontFamily: 'Galano',
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Footer
              Text(
                "By clicking on continue you agree to our Terms of Service. For more info on our data processing see our Privacy Policy.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Galano',
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
