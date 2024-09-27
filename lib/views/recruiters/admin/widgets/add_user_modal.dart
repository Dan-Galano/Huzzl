import 'package:flutter/material.dart';
import 'package:huzzl_web/widgets/buttons/blue/bluefilled_boxbutton.dart';

class MyFormModal extends StatefulWidget {
  const MyFormModal({super.key});
  @override
  _MyFormModalState createState() => _MyFormModalState();
}

class _MyFormModalState extends State<MyFormModal> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  //Adding user
  String? selectedUserTitle;

  void submit() {
    if (_formKey.currentState!.validate()) {}
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
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Email',
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
          const SizedBox(height: 10),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Password',
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
          const SizedBox(height: 10),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Phone number',
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
            onPressed: submit,
            text: "Add sub-admin",
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}
