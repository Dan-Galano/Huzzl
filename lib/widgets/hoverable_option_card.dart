import 'package:flutter/material.dart';

class HoverableOptionCard extends StatefulWidget {
  final String title;
  final String assetPath;
  final Color color;
  final Color borderColor;

  const HoverableOptionCard({
    required this.title,
    required this.assetPath,
    required this.color,
    required this.borderColor,
  });

  @override
  _HoverableOptionCardState createState() => _HoverableOptionCardState();
}

class _HoverableOptionCardState extends State<HoverableOptionCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        setState(() {
          _isHovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          _isHovered = false;
        });
      },
      child: GestureDetector(
        onTap: () {
          print('${widget.title} selected');
        },
        child: Container(
          height: 180,
          width: 250,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(color: widget.borderColor, width: 2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                child: Image.asset(widget.assetPath, width: 40, height: 40),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color:  widget.color, width: 2),
                    color: _isHovered ? widget.color : Colors.transparent,
                  ),
                  child: _isHovered
                      ? Icon(Icons.check, size: 16, color: Colors.white)
                      : null,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "I'm a ",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontFamily: 'Galano',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextSpan(
                        text: widget.title.contains('recruiter')
                            ? 'recruiter'
                            : 'job-seeker',
                        style: TextStyle(
                          fontSize: 20,
                          color: widget.color,
                          fontFamily: 'Galano',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextSpan(
                        text: widget.title.contains('recruiter')
                            ? ', hiring for a project'
                            : ', looking for work',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontFamily:'Galano',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}