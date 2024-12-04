import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/widgets/buttons/blue/bluefilled_circlebutton.dart';

class PayRateDialog extends StatefulWidget {
  final String initialRate;
  final String initialMin;
  final String initialMax;
  final Function(String, int?, int?)
      onSave; // Updated to pass `int?` for min and max

  PayRateDialog({
    required this.initialRate,
    required this.initialMin,
    required this.initialMax,
    required this.onSave,
  });

  @override
  _PayRateDialogState createState() => _PayRateDialogState();
}

class _PayRateDialogState extends State<PayRateDialog> {
  late TextEditingController minController;
  late TextEditingController maxController;
  late String selectedRate;

  @override
  void initState() {
    super.initState();
    minController = TextEditingController(text: widget.initialMin);
    maxController = TextEditingController(text: widget.initialMax);
    selectedRate = widget.initialRate;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 350, vertical: 200),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: EdgeInsets.all(30),
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'What\'s the minimum pay you\'re looking for?',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 10),
              Text(
                'We use this to match you with jobs that pay around and above this amount.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w100),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Rate",
                            style: TextStyle(fontWeight: FontWeight.w700)),
                        SizedBox(height: 8),
                        DropdownButton<String>(
                          value: selectedRate,
                          items: ['per hour', 'per day', 'per month']
                              .map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedRate = newValue!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Minimum",
                            style: TextStyle(fontWeight: FontWeight.w700)),
                        SizedBox(height: 8),
                        TextField(
                          controller: minController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ], // Restricts input to digits only
                          decoration: InputDecoration(prefixText: '₱ '),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  Text("To", style: TextStyle(fontWeight: FontWeight.w700)),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Maximum",
                            style: TextStyle(fontWeight: FontWeight.w700)),
                        SizedBox(height: 8),
                        TextField(
                          controller: maxController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ], // Restricts input to digits only
                          decoration: InputDecoration(prefixText: '₱ '),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Cancel"),
                  ),
                  SizedBox(width: 10),
                  BlueFilledCircleButton(
                    width: 100,
                    onPressed: () {
                      // Convert min and max to integers, or null if empty
                      int? min = int.tryParse(minController.text);
                      int? max = int.tryParse(maxController.text);
                      widget.onSave(
                        selectedRate,
                        min,
                        max,
                      );
                      Navigator.of(context).pop();
                    },
                    text: "Save",
                  ),
                ],
              ),
              Gap(20),
            ],
          ),
        ),
      ),
    );
  }
}
