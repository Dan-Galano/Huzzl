import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/recruiters/company_profile/providers/companyProfileProvider.dart';
import 'package:provider/provider.dart';
import 'dart:html' as html;

class CompanyDetailsJobSeeker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CompanyProfileProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CompanyInfo(
                iconImage: AssetImage('assets/images/CEO.png'),
                label: 'CEO',
                value: '${provider.ceoFirstName} ${provider.ceoLastName}',
              ),
            ),
            Gap(40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CompanyInfo(
                  iconImage: AssetImage('assets/images/headquarters.png'),
                  label: 'Headquarters',
                  value:
                      '${provider.city}, ${provider.province.isEmpty ? provider.region : provider.province}, ${provider.region}',
                ),
                CompanyInfo(
                  iconImage: AssetImage('assets/images/industry.png'),
                  label: 'Industry',
                  value: provider.industry,
                ),
              ],
            ),
            Gap(40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CompanyInfo(
                  iconImage: AssetImage('assets/images/size.png'),
                  label: 'Size',
                  value: provider.companySize,
                ),
                CompanyInfo(
                  iconImage: AssetImage('assets/images/link.png'),
                  label: 'Website Link',
                  value: provider.companyWebsite.isNotEmpty
                      ? provider.companyWebsite
                      : 'No Website provided.',
                  isLink: true,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class CompanyInfo extends StatelessWidget {
  final ImageProvider iconImage;
  final String label;
  final String value;
  final bool isLink;

  CompanyInfo({
    required this.iconImage,
    required this.label,
    required this.value,
    this.isLink = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minWidth: 100, maxWidth: 250),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Image(
              image: iconImage,
              height: 20,
              width: 20,
            ),
          ),
          SizedBox(width: 10),
          Flexible(
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
                isLink
                    ? GestureDetector(
                        onTap: () {
                          final String url = value.startsWith('http://') ||
                                  value.startsWith('https://')
                              ? value
                              : 'https://$value';
                          html.window.open(url, '_blank');
                        },
                        child: Text(
                          value,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            fontFamily: 'Galano',
                            color: Colors.blue,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    : Text(
                        value,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          fontFamily: 'Galano',
                          color: Color(0xff6D6D6D),
                        ),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
