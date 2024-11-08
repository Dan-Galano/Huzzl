import 'package:flutter/material.dart';
import 'package:huzzl_web/views/job%20seekers/home/details_page.dart';
import 'package:url_launcher/url_launcher.dart';

void _launchURL(String url) async {
  final Uri uri = Uri.parse(url);
  final bool launched = await launchUrl(
    uri,
    mode: LaunchMode.externalApplication,
    webOnlyWindowName: '_blank',
  );
  if (!launched) {
    throw 'Could not launch $url';
  }
}

Widget buildJobCard({
  required String datePosted,
  required String title,
  required String location,
  required String rate,
  required String description,
  required String website,
  required List<String> tags,
  required String joblink,
  required BuildContext context,
}) {
  bool isHuzzlPost = website == 'assets/images/huzzl_logo_ulo.png';
  return Column(
    children: [
      ListTile(
        onTap: () {
          if (joblink.isNotEmpty) {
            _launchURL(joblink);
          } else {
            //Huzzl Job post view
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return JobPostApp(
                    jobTitle: title,
                    jobDescription: description,
                    jobDate: datePosted,
                    location: location,
                    rate: rate,
                    skills: tags,
                  );
                },
              ),
            );
          }
        },
        title: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(datePosted,
                  style: TextStyle(fontFamily: 'Galano', color: Colors.grey)),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontFamily: 'Galano',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: isHuzzlPost ? Colors.orange : Colors.black,
                          ),
                          softWrap: true, // Allow the text to wrap
                          overflow: TextOverflow
                              .visible, // Ensure it wraps instead of being truncated
                        ),
                        Row(
                          children: [
                            Icon(Icons.location_on,
                                size: 16, color: Colors.grey),
                            SizedBox(width: 4),
                            Text(location,
                                style: TextStyle(
                                    fontFamily: 'Galano',
                                    fontWeight: FontWeight.w500)),
                            SizedBox(width: 16),
                          ],
                        ),
                        Text("Rate: $rate",
                            style:
                                TextStyle(fontFamily: 'Galano', fontSize: 14)),
                      ],
                    ),
                  ),
                  Image.asset(
                    website,
                    width: 100,
                  ),
                ],
              ),

              SizedBox(height: 8),
              Text(description,
                  style: TextStyle(
                    fontFamily: 'Galano',
                  )),
              // Text("From: $website",
              //     style: TextStyle(
              //       fontFamily: 'Galano',
              //     )),
              SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: tags
                    .map((tag) => Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Chip(
                            label: Text(
                              tag,
                              style: TextStyle(
                                fontFamily: 'Galano',
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
      Divider(
        color: Colors.grey[400],
        thickness: 1,
        // indent: 16,
        // endIndent: 16,
      ),
    ],
  );
}

Widget buildProjectLengthFilter() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("Project Length"),
      CheckboxListTile(
        title: Text("Less than one month"),
        value: true,
        onChanged: (bool? value) {},
      ),
      CheckboxListTile(
        title: Text("1 to 3 months"),
        value: false,
        onChanged: (bool? value) {},
      ),
      CheckboxListTile(
        title: Text("3 to 6 months"),
        value: false,
        onChanged: (bool? value) {},
      ),
      CheckboxListTile(
        title: Text("More than 6 months"),
        value: false,
        onChanged: (bool? value) {},
      ),
    ],
  );
}

Widget buildSearchBar() {
  return Row(
    children: [
      Expanded(
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Job title, keywords, or company',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      SizedBox(width: 8),
      Container(
        // width: 100,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF0038FF),
            padding: EdgeInsets.all(20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            'Find Jobs',
            style: TextStyle(
              fontSize: 17,
              color: Colors.white,
              fontFamily: 'Galano',
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    ],
  );
}

Widget buildCategoryDropdown() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Category",
        style: TextStyle(
          fontFamily: 'Galano',
          fontWeight: FontWeight.w700,
        ),
      ),
      SizedBox(
        height: 10,
      ),
      DropdownButtonFormField<String>(
        decoration: InputDecoration(
          hintText: "Select Categories",
          hintStyle: TextStyle(
            height: 1,
            fontFamily: 'Galano',
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xffD1E1FF),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xffD1E1FF),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xffD1E1FF),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        style: TextStyle(
          fontFamily: 'Galano',
        ),
        items: ["Category 1", "Category 2"].map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (_) {},
      ),
    ],
  );
}

Widget buildJobTypeFilter() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("Job Type"),
      CheckboxListTile(
        title: Text("Hourly"),
        value: true,
        onChanged: (bool? value) {},
      ),
      Row(
        children: [
          Text("P Min"),
          SizedBox(width: 8),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(width: 8),
          Text("P Max"),
          SizedBox(width: 8),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
      CheckboxListTile(
        title: Text("Fixed - Price"),
        value: true,
        onChanged: (bool? value) {},
      ),
    ],
  );
}

Widget buildClientHistoryFilter() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("Client History"),
      CheckboxListTile(
        title: Text("No hires"),
        value: true,
        onChanged: (bool? value) {},
      ),
      CheckboxListTile(
        title: Text("1 to 9 hires"),
        value: false,
        onChanged: (bool? value) {},
      ),
      CheckboxListTile(
        title: Text("10+ hires"),
        value: false,
        onChanged: (bool? value) {},
      ),
    ],
  );
}

Widget buildClientLocationDropdown() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("Client Location"),
      DropdownButton<String>(
        hint: Text("Select client locations"),
        isExpanded: true,
        items: ["Location 1", "Location 2"].map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (_) {},
      ),
    ],
  );
}
