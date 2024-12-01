import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/widgets/buttons/blue/bluefilled_boxbutton.dart';

class MyFormModal extends StatefulWidget {
  final User user;
  final String recruiterEmail;
  final String recruiterPassword;
  const MyFormModal({
    required this.user,
    required this.recruiterEmail,
    required this.recruiterPassword,
    super.key,
  });
  @override
  _MyFormModalState createState() => _MyFormModalState();
}

class _MyFormModalState extends State<MyFormModal> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstname = TextEditingController();
  final TextEditingController _lastname = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();

  // String _email = '';
  // String _password = '';

  //Adding user
  String? selectedUserTitle;

  //New Code
  bool _allowUsertoManageAmin = false;
  bool _allowUsertoManageBranch = false;
  bool _allowUsertoManageJob = false;
  bool _allowUsertoManageInterview = false;

  //List of permission
  List<String> subAdminPermission = [];

  //Error handler
  String errorMessage = "";

  //Password toggle
  bool isPasswordVisible = false;
  togglePasswordVisibility() {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }

  void submit() async {
    if (_formKey.currentState!.validate() && subAdminPermission.isNotEmpty) {
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
                    Gap(10),
                    Image.asset(
                      'assets/images/gif/huzzl_loading.gif',
                      height: 100,
                      width: 100,
                    ),
                    Gap(10),
                    Text(
                      "Creating sub-admin...",
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
      try {
        UserCredential usercredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: _email.text, password: _password.text);
        //Signout the sub-admin account (Kasi after mag create user auto log in siay so need ilogout)
        await FirebaseAuth.instance.signOut(); // Sign out the sub-admin
        // Sign the recruiter back in with stored credentials
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: widget.recruiterEmail,
          password: widget.recruiterPassword,
        );
        //Store in database (sub-admin) sub collection
        FirebaseFirestore.instance
            .collection("users")
            .doc(widget.user.uid)
            .collection("sub_admins")
            .add({
          "subAdminFirstName": _firstname.text,
          "subAdminLastName": _lastname.text,
          "subAdminEmail": _email.text,
          "subAdminPassword": _password.text,
          "subAdminPhoneNumber": _phoneNumber.text,
          "permissions": subAdminPermission,
          "assigned_by": widget.user.uid,
          'status' : 'active',
          "created_at": DateTime.now(),
        });
        // Check if the user creation was successful
        if (usercredential.user != null) {
          //Get the company information document id
          String? companyId;
          QuerySnapshot querySnapshot = await FirebaseFirestore.instance
              .collection('users')
              .doc(widget.user.uid)
              .collection('company_information')
              .get();

          // Assuming there's only one document in 'company_information'
          if (querySnapshot.docs.isNotEmpty) {
            companyId = querySnapshot.docs.first.id; // Get the first doc ID
            print('Company ID: $companyId');
          } else {
            print('No company information found!');
            // Handle this case if needed
          }

          // Store sub-admin details in Firestore
          FirebaseFirestore.instance
              .collection("users")
              .doc(usercredential.user!.uid)
              .set({
            "subAdminFirstName": _firstname.text,
            "subAdminLastName": _lastname.text,
            "subAdminEmail": _email.text,
            "subAdminPassword": _password.text,
            "subAdminPhoneNumber": _phoneNumber.text,
            "role": "sub-admin",
            "permissions": subAdminPermission,
            "assigned_by": widget.user.uid,
            "assigned_company": companyId ?? 'No Company ID',
            "created_at": DateTime.now(),
          });
        } else {
          print('User creation failed!');
        }

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
                child: TextFormField(
                  controller: _firstname,
                  decoration: InputDecoration(
                    hintText: "First name",
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
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
                  // onSaved: (value) => _email = value ?? '',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  controller: _lastname,
                  decoration: InputDecoration(
                    hintText: "Last name",
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
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
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _email,
            decoration: InputDecoration(
              hintText: "Email",
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
              if (!EmailValidator.validate(value)) {
                return "Provide a valid email address";
              }
              return null;
            },
            // onSaved: (value) => _password = value ?? '',
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
          if (subAdminPermission.isEmpty)
            Text(
              errorMessage,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.red,
              ),
            ),
          // const SizedBox(height: 10),
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
                      subAdminPermission.add("manage_subadmin");
                    });
                  } else {
                    setState(() {
                      subAdminPermission.remove("manage_subadmin");
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
                      subAdminPermission.add("manage_branch");
                    });
                  } else {
                    setState(() {
                      subAdminPermission.remove("manage_branch");
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
                      subAdminPermission.add("manage_job");
                    });
                  } else {
                    setState(() {
                      subAdminPermission.remove("manage_job");
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
                      subAdminPermission.add("manage_interview");
                    });
                  } else {
                    setState(() {
                      subAdminPermission.remove("manage_interview");
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
            onPressed: submit,
            text: "Add sub-admin",
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}
