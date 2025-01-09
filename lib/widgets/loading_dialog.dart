// loading_dialog.dart
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class LoadingDialog extends StatefulWidget {
  final String message;
  const LoadingDialog({Key? key, this.message = "Loading..."})
      : super(key: key);

  @override
  State<LoadingDialog> createState() => _LoadingDialogState();
}

class _LoadingDialogState extends State<LoadingDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      backgroundColor: Colors.transparent,
      content: Container(
        width: 105,
        height: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        child: Center(
          child: Column(
            children: [
              Gap(10),
              Image.asset(
                'assets/images/gif/huzzl_loading.gif',
                height: 100,
                width: 100,
              ),
              Gap(10),
              Text(
                widget.message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  color: Color(0xFFfd7206),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
