import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:huzzl_web/widgets/buttons/blue/bluefilled_boxbutton.dart';

class AddNewStaffModal extends StatefulWidget {
  final bool isStandaloneCompany;
  const AddNewStaffModal({required this.isStandaloneCompany, super.key});
  @override
  _AddNewStaffModalState createState() => _AddNewStaffModalState();
}

class _AddNewStaffModalState extends State<AddNewStaffModal> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  //Adding user
  String? selectedUserTitle;
  String? sampleSelectedBranch;
  List<String> sampleBranches = [
    "Urdaneta",
    "Rosales",
  ];

  bool isPasswordVisible = false;
  void togglePasswordVisibility() {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              // Wrap the TextFormField with Expanded to make it responsive
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'First Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required field.';
                    }
                    return null;
                  },
                  onSaved: (value) => _email = value ?? '',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Last Name',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required field.';
                    }
                    return null;
                  },
                  onSaved: (value) => _password = value ?? '',
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (!widget.isStandaloneCompany)
            DropdownButtonFormField<String>(
              value: sampleSelectedBranch,
              decoration: InputDecoration(
                labelText: 'Select branch',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: const BorderSide(
                    color: Colors.black,
                    width: 2.0,
                  ),
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
              ),
              icon: Icon(Icons.arrow_drop_down),
              isExpanded: true,
              items: sampleBranches.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  sampleSelectedBranch = newValue;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please choose a branch.';
                }
                return null;
              },
            ),
          if (!widget.isStandaloneCompany) const SizedBox(height: 10),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Required field.';
              }
              if (!EmailValidator.validate(value)) {
                return 'Please enter a valid email.';
              }
              return null;
            },
            onSaved: (value) => _password = value ?? '',
          ),
          const SizedBox(height: 10),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Password',
              suffixIcon: IconButton(
                  onPressed: togglePasswordVisibility,
                  icon: isPasswordVisible
                      ? const Icon(Icons.visibility)
                      : const Icon(Icons.visibility_off)),
              hintText: "Password (8 or more characters)",
              border: OutlineInputBorder(),
            ),
            obscureText: isPasswordVisible ? false : true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Required field.';
              }
              if (value.length < 8) {
                return 'Password must be at least 8 characters long';
              }
              return null;
            },
            onSaved: (value) => _password = value ?? '',
          ),
          const SizedBox(height: 10),
          TextFormField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Phone number',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Required field.';
              }
              return null;
            },
            onSaved: (value) => _password = value ?? '',
          ),
          const SizedBox(height: 30),
          // SizedBox(
          //   width: double.infinity,
          //   child: ElevatedButton(
          //     onPressed: () {
          //       if (_formKey.currentState?.validate() ?? false) {
          //         _formKey.currentState?.save();
          //         Navigator.pop(context); // Close the modal
          //         print('Email: $_email, Password: $_password');
          //       }
          //     },
          //     child: Text('Submit'),
          //   ),
          // ),
          BlueFilledBoxButton(
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                _formKey.currentState?.save();
                Navigator.pop(context); // Close the modal
                print('Email: $_email, Password: $_password');
              }
            },
            text: "Add staff",
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}
