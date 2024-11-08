import 'package:flutter/material.dart';

class CompanyDetails extends StatelessWidget {
  final String ceo = 'Dan Galiano';
  final String headquarters = 'Urdaneta';
  final String industry = 'Technology';
  final String size = "It's just me";
  final String websiteLink = 'huzzl.com';

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start, 
      children: [
        CompanyInfo(
          iconImage: AssetImage('assets/images/CEO.png'),
          label: 'CEO',
          value: ceo,
        ),
        SizedBox(width: 20),
        CompanyInfo(
          iconImage: AssetImage('assets/images/headquarters.png'),
          label: 'Headquarters',
          value: headquarters,
        ),
        SizedBox(width: 40),
        CompanyInfo(
          iconImage: AssetImage('assets/images/industry.png'),
          label: 'Industry',
          value: industry,
        ),
        SizedBox(width: 40),
        CompanyInfo(
          iconImage: AssetImage('assets/images/size.png'),
          label: 'Size',
          value: size,
        ),
        SizedBox(width: 35),
        CompanyInfo(
          iconImage: AssetImage('assets/images/link.png'),
          label: 'Website Link',
          value: websiteLink,
        ),
      ],
    );
  }
}

class CompanyInfo extends StatelessWidget {
  final ImageProvider iconImage;
  final String label;
  final String value;

  CompanyInfo(
      {required this.iconImage, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Image(
            image: iconImage,
            height: 20,
            width: 20,
          ),
        ),
        SizedBox(height: 50),
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Color(0xff202855),
                  fontSize: 16,
                  fontFamily: 'Galano',
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  fontFamily: 'Galano',
                  color: Color(0xff6D6D6D),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
