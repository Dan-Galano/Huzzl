import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:huzzl_web/views/recruiters/register/01%20company_profile.dart';
import 'package:huzzl_web/views/recruiters/register/03%20hiring_manager.dart';
import 'package:huzzl_web/views/recruiters/register/05%20details_hiring_manager.dart';
import 'package:huzzl_web/views/recruiters/register/06%20congrats.dart';
import 'package:huzzl_web/widgets/navbar/navbar_login_registration.dart';

class RecruiterRegistrationScreen extends StatefulWidget {
  RecruiterRegistrationScreen({super.key});

  @override
  State<RecruiterRegistrationScreen> createState() =>
      _RecruiterRegistrationScreenState();
}

class _RecruiterRegistrationScreenState
    extends State<RecruiterRegistrationScreen> {
  PageController _pageController = PageController();
  int _currentPage = 0;

  // controllrs
  // company prfile
  final _companyNameController = TextEditingController();
  final _companyEmailController = TextEditingController();
  final _ceoFirstnameController = TextEditingController();
  final _ceoLastnameController = TextEditingController();
  final _numEmployeesController = TextEditingController();
  final _companyHeadquarterController = TextEditingController();
  final _companyIndustryController = TextEditingController();
  final _companyDescriptionController = TextEditingController();
  final _companyWebsiteController = TextEditingController();
  // hiring manager profile
  final _hiringManFirstnameController = TextEditingController();
  final _hiringManLastnameController = TextEditingController();
  final _howHeardAbtUsController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  // complete acc/3rd screen
  final _hiringManEmailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.animateToPage(
        _currentPage - 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

   void register() async {
    
    if (_hiringManEmailController.text.isNotEmpty && _passwordController.text.isNotEmpty && _passwordController.text == _confirmPasswordController.text) {

      final companyName = _companyNameController.text;
      final companyEmail = _companyEmailController.text;
      final ceoFirstname = _ceoFirstnameController.text;
      final ceoLastname = _ceoLastnameController.text;
      final numEmployees = _numEmployeesController.text;
      final companyHeadquarter = _companyHeadquarterController.text;
      final companyIndustry = _companyIndustryController.text;
      final companyDescription = _companyDescriptionController.text;
      final companyWebsite = _companyWebsiteController.text;
      final hiringManFirstname = _hiringManFirstnameController.text;
      final hiringManLastname = _hiringManLastnameController.text;
      final howHeardAbtUs = _howHeardAbtUsController.text;
      final phoneNumber = _phoneNumberController.text;
      final hiringManEmail = _hiringManEmailController.text;

      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _hiringManEmailController.text, // is this the email na gagamitin for LOGIN?? or yung company email
          password: _passwordController.text,
        );
      await FirebaseFirestore.instance.collection('recruiters').doc(userCredential.user!.uid).set({
        'companyName': companyName,
        'companyEmail': companyEmail,
        'ceoFirstname': ceoFirstname,
        'ceoLastname': ceoLastname,
        'numEmployees': numEmployees,
        'companyHeadquarter': companyHeadquarter,
        'companyIndustry': companyIndustry,
        'companyDescription': companyDescription,
        'companyWebsite': companyWebsite,
        'hiringManFirstname': hiringManFirstname,
        'hiringManLastname': hiringManLastname,
        'howHeardAbtUs': howHeardAbtUs,
        'phoneNumber': phoneNumber,
        'hiringManEmail': hiringManEmail,
      });

      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Registration successful!')),
      // );
       Navigator.of(context).push(MaterialPageRoute(builder: (context) => CongratulationPage()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all the fields correctly')),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const NavBarLoginRegister(),
          Expanded(
              child: PageView(
            controller: _pageController,
            children: [
              CompanyProfileScreen(
                nextPage: _nextPage,
                companyNameController: _companyNameController,
                companyEmailController: _companyEmailController,
                ceoFirstnameController: _ceoFirstnameController,
                ceoLastnameController: _ceoLastnameController,
                numEmployeesController: _numEmployeesController,
                companyHeadquarterController: _companyHeadquarterController,
                companyIndustryController: _companyIndustryController,
                companyDescriptionController: _companyDescriptionController,
                companyWebsiteController: _companyWebsiteController
              ),
              HiringManagerProfileScreen(
                  nextPage: _nextPage, 
                  previousPage: _previousPage,
                  hiringManFirstnameController: _hiringManFirstnameController,
                  hiringManLastnameController: _hiringManLastnameController,
                  howHeardAbtUsController: _howHeardAbtUsController,
                  phoneNumberController: _phoneNumberController
                ),
              AccountHiringManagerScreen(
                previousPage: _previousPage,
                hiringManEmailController: _hiringManEmailController,
                passwordController: _passwordController,
                confirmPasswordController: _confirmPasswordController,
                register: register,
              ),
            ],
          ))
        ],
      ),
    );
  }
}
