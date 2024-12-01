import 'package:flutter/material.dart';
import 'package:huzzl_web/views/admins/constants.dart';
import 'package:huzzl_web/views/admins/controllers/menu_app_controller.dart';
import 'package:provider/provider.dart';

class EditIndustryDialog extends StatelessWidget {
  final String industryToEdit; // Industry to be edited
  final TextEditingController _newIndustryController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  EditIndustryDialog({Key? key, required this.industryToEdit})
      : super(key: key) {
    // Initialize the controller with the current industry name
    _newIndustryController.text = industryToEdit;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Industry'),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.4,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Original industry name (non-editable)
              TextFormField(
                initialValue: industryToEdit,
                enabled: false,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Original Industry Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              // Editable input field for the new industry title
              TextFormField(
                controller: _newIndustryController,
                decoration: const InputDecoration(
                  labelText: 'New Industry Name',
                  hintText: 'Enter new industry name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Industry name cannot be empty';
                  }
                  if (value.length < 3) {
                    return 'Industry name must be at least 3 characters long';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context), // Close dialog
          child: const Text(
            'Cancel',
            style: TextStyle(
              color: defaultTextColor,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              // Form is valid
              final updatedIndustryName = _newIndustryController.text.trim();
              if (updatedIndustryName != industryToEdit) {
                // Only update if the name has changed
                Provider.of<MenuAppController>(context, listen: false)
                    .editIndustry(industryToEdit, updatedIndustryName);
              }
              Navigator.pop(context); // Close the dialog
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orangeAccent,
            foregroundColor: Colors.white,
          ),
          child: const Text(
            'Update',
            style: TextStyle(fontWeight: FontWeight.w300),
          ),
        ),
      ],
    );
  }
}
