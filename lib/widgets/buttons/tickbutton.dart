import 'package:flutter/material.dart';

class TickButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String text;
  final double width;

  TickButton({
    required this.onPressed,
    required this.text,
    this.width = double.infinity,
  });

  @override
  _TickButtonState createState() => _TickButtonState();
}

class _TickButtonState extends State<TickButton> {
  bool _isClicked = false;

  void _handlePress() {
    setState(() {
      _isClicked = !_isClicked; 
    });
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: _handlePress,
      style: OutlinedButton.styleFrom(
        backgroundColor: _isClicked ? Color(0xFF202855) : Colors.transparent,
        side: BorderSide(color: Color(0xFF202855)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: EdgeInsets.all(8.0),
        fixedSize: Size(widget.width, 38),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: AssetImage(_isClicked ? 'assets/images/whitecheck.png' : 'assets/images/add.png'),
            width: 15.0,
            height: 15.0,
          ),
          SizedBox(width: 8.0),
          Text(
            widget.text,
            style: TextStyle(
              fontSize: 14,
              color: _isClicked ? Colors.white : Color(0xFF202855),
              fontFamily: 'Galano',
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
