import 'package:flutter/material.dart';
import 'package:huzzl_web/views/admins/constants.dart';
import 'package:huzzl_web/views/admins/controllers/menu_app_controller.dart';
import 'package:provider/provider.dart';

class AddIndustryDialog extends StatelessWidget {
  AddIndustryDialog({Key? key}) : super(key: key);

  final TextEditingController _industryController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Industry'),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.3,
        child: Form(
          key: _formKey,
          child: TextFormField(
            controller: _industryController,
            decoration: const InputDecoration(
              labelText: 'Industry Name',
              hintText: 'Enter industry name',
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
              final industryName = _industryController.text.trim();
              Provider.of<MenuAppController>(context, listen: false)
                  .addIndustry(industryName);
              Navigator.pop(context); // Close the dialog
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orangeAccent,
            foregroundColor: Colors.white,
          ),
          child: const Text(
            'Add',
            style: TextStyle(fontWeight: FontWeight.w300),
          ),
        ),
      ],
    );
  }
}
