import 'package:flutter/material.dart';

// A custom button widget that takes an icon, label,
// and a callback function for press actions.
class CustomButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final String? sublabel;
  final void Function(BuildContext context) onPressed;

  const CustomButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.sublabel,
  }) : super(key: key);

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _isHovered = false; // Tracks whether the button is hovered or not

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: ElevatedButton(
        onPressed: () => widget.onPressed(context),
        style: ButtonStyle(
          elevation: WidgetStatePropertyAll(0),
          padding: WidgetStateProperty.all<EdgeInsets>(
            EdgeInsets.symmetric(vertical: 25, horizontal: 25),
          ),
          side: WidgetStateProperty.all<BorderSide>(
            BorderSide(color: Colors.orange, width: 2),
          ),
          backgroundColor: WidgetStateProperty.all<Color>(
            _isHovered ? Colors.orange : Colors.white,
          ),
          foregroundColor: WidgetStateProperty.all<Color>(
            _isHovered ? Colors.white : Colors.orange,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(widget.icon, color: _isHovered ? Colors.white : Colors.orange),
            SizedBox(width: 8),
            Text(
              widget.label,
              style: TextStyle(
                fontSize: 20,
                color: _isHovered ? Colors.white : Colors.orange,
              ),
            ),
            widget.sublabel!.isNotEmpty
                ? Text(
                    " ${widget.sublabel!}",
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 16,
                      fontWeight: FontWeight.w100,
                      color: _isHovered ? Colors.white : Colors.orange,
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }

  void _onHover(bool isHovered) {
    setState(() {
      _isHovered = isHovered; // Update hover state
    });
  }
}

class ButtonList extends StatelessWidget {
  final List<Map<String, dynamic>> buttonData;

  const ButtonList({
    Key? key,
    required this.buttonData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: buttonData.map((data) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: CustomButton(
            icon: data['icon'],
            label: data['label'],
            sublabel: data['sublabel'] ?? '',
            onPressed: data['onPressed'],
          ),
        );
      }).toList(),
    );
  }
}
