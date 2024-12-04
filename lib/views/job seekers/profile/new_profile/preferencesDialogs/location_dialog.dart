import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/widgets/buttons/blue/bluefilled_circlebutton.dart';

class LocationDialog extends StatefulWidget {
  final Map<String, String> initialLocation;
  final Function(Map<String, String>) onSave;

  LocationDialog({required this.initialLocation, required this.onSave});

  @override
  _LocationDialogState createState() => _LocationDialogState();
}

class _LocationDialogState extends State<LocationDialog> {
  late TextEditingController regionController;
  late TextEditingController provinceController;
  late TextEditingController cityController;
  late TextEditingController barangayController;
  late TextEditingController otherLocationController;

  @override
  void initState() {
    super.initState();
    regionController = TextEditingController(text: widget.initialLocation['regionName']);
    provinceController = TextEditingController(text: widget.initialLocation['provinceName']);
    cityController = TextEditingController(text: widget.initialLocation['cityName']);
    barangayController = TextEditingController(text: widget.initialLocation['barangayName']);
    otherLocationController = TextEditingController(text: widget.initialLocation['otherLocation']);
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
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
                  Text('Location', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: regionController,
                          decoration: InputDecoration(labelText: 'Region'),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: provinceController,
                          decoration: InputDecoration(labelText: 'Province (leave blank if NCR)'),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: cityController,
                          decoration: InputDecoration(labelText: 'City'),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: barangayController,
                          decoration: InputDecoration(labelText: 'Barangay'),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: otherLocationController,
                          decoration: InputDecoration(labelText: 'House/Building No., Street'),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),   Row(
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
                          widget.onSave({
                            'regionName': regionController.text,
                            'provinceName': provinceController.text,
                            'cityName': cityController.text,
                            'barangayName': barangayController.text,
                            'otherLocation': otherLocationController.text,
                          });
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
      },
    );
  }
}
