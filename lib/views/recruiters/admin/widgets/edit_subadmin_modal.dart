import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/recruiters/admin/widgets/textField.dart';
import 'package:huzzl_web/widgets/buttons/blue/bluefilled_boxbutton.dart';

class EditSubadminModal extends StatefulWidget {
  final User user;
  String firstName;
  String lastName;
  String password;
  String email;
  String phoneNumber;
  List permissions;
  String documentId;
  EditSubadminModal({
    required this.user,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.permissions,
    required this.documentId,
    super.key,
  });

  @override
  State<EditSubadminModal> createState() => _EditSubadminModalState();
}

class _EditSubadminModalState extends State<EditSubadminModal> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstname = TextEditingController();
  final TextEditingController _lastname = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();

  //Password toggle
  bool isPasswordVisible = false;

  List permissionToHandle = [];

  togglePasswordVisibility() {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }

  //Error handler
  String errorMessage = "";

  bool _allowUsertoManageAmin = false;
  bool _allowUsertoManageBranch = false;
  bool _allowUsertoManageJob = false;
  bool _allowUsertoManageInterview = false;

  void assigningPermissionValue() {
    for (var e in widget.permissions) {
      if (e == "manage_subadmin") {
        setState(() {
          _allowUsertoManageAmin = true;
        });
      } else if (e == "manage_branch") {
        setState(() {
          _allowUsertoManageBranch = true;
        });
      } else if (e == "manage_job") {
        setState(() {
          _allowUsertoManageJob = true;
        });
      } else if (e == "manage_interview") {
        setState(() {
          _allowUsertoManageInterview = true;
        });
      }
    }
  }

  void submitEditForm() async {
    if (_formKey.currentState!.validate() && permissionToHandle.isNotEmpty) {
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
        DocumentReference userDoc = FirebaseFirestore.instance
            .collection("users")
            .doc(widget.user.uid)
            .collection("sub_admins")
            .doc(widget.documentId);

        await userDoc.update({
          "subAdminFirstName": _firstname.text,
          "subAdminLastName": _lastname.text,
          "subAdminEmail": _email.text,
          "subAdminPassword": _password.text,
          "subAdminPhoneNumber": _phoneNumber.text,
          "permissions": permissionToHandle,
          "edited_at": DateTime.now(),
        });

        Navigator.of(context).pop();
        Navigator.of(context).pop();
      } on FirebaseAuthException catch (e) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text("Error: ${e.message}")),
        // );
        EasyLoading.showToast(
          "⚠︎ ${e.message}",
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
  void initState() {
    super.initState();
    _firstname.text = widget.firstName;
    _lastname.text = widget.lastName;
    _email.text = widget.email;
    _phoneNumber.text = widget.phoneNumber;
    _password.text = widget.password;

    assigningPermissionValue();

    permissionToHandle = widget.permissions;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Wrap the TextFormField with Expanded to make it responsive
              Expanded(
                child: TextFieldConstant(
                  controller: _firstname,
                  hintText: "First Name",
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFieldConstant(
                  controller: _lastname,
                  hintText: "Last Name",
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextFieldConstant(
            controller: _email,
            hintText: "Email",
            isEmail: true,
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _password,
            obscureText: isPasswordVisible ? false : true,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                  onPressed: () {
                    togglePasswordVisibility();
                  },
                  icon: isPasswordVisible
                      ? const Icon(Icons.visibility_off)
                      : const Icon(Icons.visibility)),
              hintText: "Password (8 or more characters)",
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(0xFFD1E1FF),
                  width: 1.5,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(0xFFD1E1FF),
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(0xFFD1E1FF),
                  width: 1.5,
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Required field.';
              }
              if (value.length <= 7) {
                return "Password should at least 8 characters.";
              }
              return null;
            },
            // onSaved: (value) => _password = value ?? '',
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _phoneNumber,
            decoration: InputDecoration(
              hintText: "Phone number",
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(0xFFD1E1FF),
                  width: 1.5,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(0xFFD1E1FF),
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(0xFFD1E1FF),
                  width: 1.5,
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Required field.';
              }
              return null;
            },
            // onSaved: (value) => _password = value ?? '',
          ),
          const SizedBox(height: 10),
          const Text(
            "Permissions",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (permissionToHandle.isEmpty)
            Text(
              errorMessage,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.red,
              ),
            ),
          const SizedBox(height: 10),
          Column(
            children: [
              CheckboxListTile(
                title: const Text('Allow this user to manage sub-admins'),
                subtitle: const Text('Add, Edit, and delete sub-admin.'),
                controlAffinity: ListTileControlAffinity.leading,
                value: _allowUsertoManageAmin,
                onChanged: (bool? value) {
                  setState(() {
                    _allowUsertoManageAmin = value ?? false;
                  });
                  if (_allowUsertoManageAmin) {
                    setState(() {
                      permissionToHandle.add("manage_subadmin");
                    });
                  } else {
                    setState(() {
                      permissionToHandle.remove("manage_subadmin");
                    });
                  }
                },
              ),
              const SizedBox(height: 10),
              CheckboxListTile(
                title: const Text('Allow this user to manage branch'),
                subtitle: const Text('Add, Edit, and delete branch.'),
                controlAffinity: ListTileControlAffinity.leading,
                value: _allowUsertoManageBranch,
                onChanged: (bool? value) {
                  setState(() {
                    _allowUsertoManageBranch = value ?? false;
                  });
                  if (_allowUsertoManageBranch) {
                    setState(() {
                      permissionToHandle.add("manage_branch");
                    });
                  } else {
                    setState(() {
                      permissionToHandle.remove("manage_branch");
                    });
                  }
                },
              ),
              const SizedBox(height: 10),
              CheckboxListTile(
                title: const Text('Allow this user to manage jobs'),
                subtitle: const Text('Add, Edit, and delete jobs.'),
                controlAffinity: ListTileControlAffinity.leading,
                value: _allowUsertoManageJob,
                onChanged: (bool? value) {
                  setState(() {
                    _allowUsertoManageJob = value ?? false;
                  });
                  if (_allowUsertoManageJob) {
                    setState(() {
                      permissionToHandle.add("manage_job");
                    });
                  } else {
                    setState(() {
                      permissionToHandle.remove("manage_job");
                    });
                  }
                },
              ),
              const SizedBox(height: 10),
              CheckboxListTile(
                title: const Text('Allow this user to manage interviews'),
                subtitle: const Text('Add, Edit, and delete interview.'),
                controlAffinity: ListTileControlAffinity.leading,
                value: _allowUsertoManageInterview,
                onChanged: (bool? value) {
                  setState(() {
                    _allowUsertoManageInterview = value ?? false;
                  });
                  if (_allowUsertoManageInterview) {
                    setState(() {
                      permissionToHandle.add("manage_interview");
                    });
                  } else {
                    setState(() {
                      permissionToHandle.remove("manage_interview");
                    });
                  }
                },
              ),
            ],
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
              submitEditForm();
            },
            text: "Edit sub-admin",
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}
