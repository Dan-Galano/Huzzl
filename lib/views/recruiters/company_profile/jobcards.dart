import 'package:flutter/material.dart';

class JobSection extends StatefulWidget {
  @override
  _JobSectionState createState() => _JobSectionState();
}

class _JobSectionState extends State<JobSection> {
  final ScrollController _scrollController = ScrollController();
  bool showRightArrow = false;
  bool showLeftArrow = false;

  @override
  void initState() {
    super.initState();

    // Listen to the scroll controller to detect when to show the arrows
    _scrollController.addListener(() {
      setState(() {
        // Show the right arrow if not at the end of the list
        showRightArrow = _scrollController.position.maxScrollExtent >
            _scrollController.offset;

        // Show the left arrow if scrolled away from the start
        showLeftArrow = _scrollController.offset > 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onHorizontalDragUpdate: (details) {
            // Handle horizontal dragging
            _scrollController.jumpTo(_scrollController.offset - details.delta.dx);
          },
          child: SizedBox(
            height: 250,
            child: ListView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              children: [
                JobCard(),
                JobCard(),
                JobCard(),
                JobCard(), 
              ],
            ),
          ),
        ),
        if (showLeftArrow)
          Positioned(
            left: 20,
            top: 90,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white, 
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back, // Change to arrow_back for the left arrow
                  size: 20,
                  color: Colors.grey,
                ),
                onPressed: () {
                  // Scroll the list to the left
                  _scrollController.animateTo(
                    _scrollController.offset - 300, 
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              ),
            ),
          ),
    
        if (showRightArrow)
          Positioned(
            right: 20,
            top: 90, 
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white, 
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_forward,
                  size: 20,
                  color: Colors.grey,
                ),
                onPressed: () {
                  // Scroll the list to the right
                  _scrollController.animateTo(
                    _scrollController.offset + 300, // Adjust value as needed
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
}

class JobCard extends StatelessWidget {
  final String jobTitle = 'Architect / Engineer Drafter';
  final String location = 'Philippines';
  final String hourlyRate = 'Hourly: PHP, 5k';
  final String level = 'Level: Expert';
  final String timeCommitment = 'Time: Less than 30 hrs/week';
  final String viewJobButtonText = 'View Job';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 400,
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Color(0xffACACAC)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // Soft shadow color
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3), // Shadow position
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(jobTitle,
                style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Galano',
                    fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            Row(
              children: [
                Icon(Icons.location_on, color: Color(0xff3B7DFF), size: 16),
                SizedBox(width: 5),
                Text(location,
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Galano',
                        color: Color(0xff3B7DFF))),
              ],
            ),
            SizedBox(height: 5),
            Text(hourlyRate,
                style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'Galano',
                    color: Color(0xff6A6A6A),
                    fontWeight: FontWeight.w500)),
            Text(level,
                style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'Galano',
                    color: Color(0xff6A6A6A),
                    fontWeight: FontWeight.w500)),
            Text(timeCommitment,
                style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'Galano',
                    color: Color(0xff6A6A6A),
                    fontWeight: FontWeight.w500)),
            Spacer(),
            SizedBox(
              width: double.infinity, 
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF202855),
                  padding: EdgeInsets.all(20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  viewJobButtonText,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontFamily: 'Galano',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
