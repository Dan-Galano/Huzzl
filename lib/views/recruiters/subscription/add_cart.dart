import 'package:flutter/material.dart';

class AddCardModal extends StatefulWidget {
  @override
  State<AddCardModal> createState() => _AddCardModalState();
}

class _AddCardModalState extends State<AddCardModal> {
  String selectedPaymentMethod = "Gcash";

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
          height: 550,
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
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedPaymentMethod = "Gcash";
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: selectedPaymentMethod == "Gcash"
                                ? Color(0xffFD7206)
                                : Color(0xff202855),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 10),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedPaymentMethod = "Gcash";
                                  });
                                },
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: selectedPaymentMethod == "Gcash"
                                          ? Color(0xffFD7206)
                                          : Color(0xff202855),
                                      width: 2,
                                    ),
                                  ),
                                  child: selectedPaymentMethod == "Gcash"
                                      ? Center(
                                          child: Container(
                                            width: 12,
                                            height: 12,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Color(0xffFD7206),
                                            ),
                                          ),
                                        )
                                      : null,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Image.asset(
                              'assets/images/gcash.png',
                              width: 30,
                              height: 30,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              "Gcash",
                              style: TextStyle(
                                  fontFamily: 'Galano',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedPaymentMethod = "Paypal";
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: selectedPaymentMethod == "Paypal"
                                ? Color(0xffFD7206)
                                : Color(0xff202855),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 10),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedPaymentMethod = "Paypal";
                                  });
                                },
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: selectedPaymentMethod == "Paypal"
                                          ? Color(0xffFD7206)
                                          : Color(0xff202855),
                                      width: 2,
                                    ),
                                  ),
                                  child: selectedPaymentMethod == "Paypal"
                                      ? Center(
                                          child: Container(
                                            width: 12,
                                            height: 12,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Color(0xffFD7206),
                                            ),
                                          ),
                                        )
                                      : null,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Image.asset(
                              'assets/images/paypal.png',
                              width: 24,
                              height: 24,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              "Paypal",
                              style: TextStyle(
                                  fontFamily: 'Galano',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
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
                          color: Color(0xff202855),
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
                          color: Color(0xff202855),
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
