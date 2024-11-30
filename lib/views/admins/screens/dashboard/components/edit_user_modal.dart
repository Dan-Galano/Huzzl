import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/admins/constants.dart';
import 'package:huzzl_web/widgets/buttons/blue/bluefilled_boxbutton.dart';

class EditUserModal extends StatefulWidget {
  final String uid;
  final String firstName;
  final String lastName;
  final String email;
  const EditUserModal({
    super.key,
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  @override
  State<EditUserModal> createState() => _EditUserModalState();
}

class _EditUserModalState extends State<EditUserModal> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _uid = TextEditingController();
  final TextEditingController _firstname = TextEditingController();
  final TextEditingController _lastname = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();

  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    _uid.text = widget.uid;
    _firstname.text = widget.firstName;
    _lastname.text = widget.lastName;
    _email.text = widget.email;
  }

  void submitEditForm() async {
    if (_formKey.currentState!.validate()) {
      //Loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
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
                    const Gap(10),
                    Image.asset(
                      'assets/images/gif/huzzl_loading.gif',
                      height: 100,
                      width: 100,
                    ),
                    const Gap(10),
                    const Text(
                      "Editing information...",
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
        },
      );
      //Create sub-admin account
      // print("Edit form is goods: ${widget.documentId}");

      try {
        //Edit Here
        Navigator.of(context).pop();
      } on FirebaseAuthException catch (e) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text("Error: ${e.message}")),
        // );
        EasyLoading.showToast(
          "⚠️ ${e.message}",
          dismissOnTap: true,
          toastPosition: EasyLoadingToastPosition.top,
          duration: Duration(seconds: 3),
          // maskType: EasyLoadingMaskType.black,
        );
        // Navigator.pop(context);
        Navigator.of(context).pop();
      } catch (e) {
        EasyLoading.showToast(
          "An unexpected error occurred.",
          dismissOnTap: true,
          toastPosition: EasyLoadingToastPosition.top,
          duration: Duration(seconds: 3),
          // maskType: EasyLoadingMaskType.black,
        );
        Navigator.pop(context);
      }

      // print("SUBMITTED FORM");
      // print("Permissions: $subAdminPermission");
      // print(
      //     "Data: ${_firstname.text} ${_lastname.text} ${_email.text} ${_password.text} ${_phoneNumber.text}");
    } else {
      setState(() {
        errorMessage = "Sub-admin permission is required";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          textFormFieldName(_uid, "UID", false),
          const Gap(10),
          Row(
            children: [
              // Wrap the TextFormField with Expanded to make it responsive
              Expanded(
                child: textFormFieldName(_firstname, "First name", true),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: textFormFieldName(_lastname, "Last name", true),
              ),
            ],
          ),
          const Gap(10),
          textFormFieldEmail(_email),
          const Gap(20),
          BlueFilledBoxButton(
            onPressed: submitEditForm,
            text: "Edit",
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}
