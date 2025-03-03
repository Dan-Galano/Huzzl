import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/user-provider.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/functions/string_formatter.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/providers/resume_provider.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/widgets/custom_textfield.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/widgets/resume_option.dart';
import 'package:huzzl_web/views/recruiters/branches_tab/managers-tab.dart';
import 'package:huzzl_web/widgets/buttons/blue/bluefilled_circlebutton.dart';
import 'package:huzzl_web/widgets/dropdown/lightblue_dropdown.dart';
import 'package:huzzl_web/widgets/textfield/lightblue_prefix.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/providers/location_provider.dart';

class ResumePageContactInfo2 extends StatefulWidget {
  final VoidCallback nextPage;
  final VoidCallback previousPage;
  final Function(Map<String, dynamic>) onSaveResumeSetup;
  final Map<String, dynamic>? currentResumeOption;
  final int noOfPages;
  final int noOfResumePages;
  const ResumePageContactInfo2({
    super.key,
    required this.nextPage,
    required this.previousPage,
    required this.onSaveResumeSetup,
    required this.currentResumeOption,
    required this.noOfPages,
    required this.noOfResumePages,
  });

  @override
  _ResumePageContactInfo2State createState() => _ResumePageContactInfo2State();
}

class _ResumePageContactInfo2State extends State<ResumePageContactInfo2> {
  var fnameController = TextEditingController();
  var lnameController = TextEditingController();
  var pnumberController = TextEditingController();
  var emailController = TextEditingController();

  String phoneNumberInputted = "";

  final _formKey = GlobalKey<FormState>();

  void _submitContactInfo() {
    if (_formKey.currentState!.validate()) {
      try {
        final resumeProvider =
            Provider.of<ResumeProvider>(context, listen: false);
        final locationProvider =
            Provider.of<LocationProvider>(context, listen: false);
        String firstName =
            fnameController.text.toLowerCaseTrimmed().toCapitalCase();
        String lastName =
            lnameController.text.toLowerCaseTrimmed().toCapitalCase();
        String phoneNumber = phoneNumberInputted.trim();
        String email = emailController.text.toLowerCaseTrimmed();
        final locationData = locationProvider.getLocationData();

        locationData.forEach((key, value) {
          print('$key: $value');
        });
        resumeProvider.updateLocation(locationData);

        resumeProvider.updateName(firstName, lastName);
        resumeProvider.updatePhoneNumber(phoneNumber);
        resumeProvider.updateEmail(email);

        print('Updated Resume Information:');
        print('First Name: $firstName');
        print('Last Name: $lastName');
        print('Phone Number: $phoneNumber');
        print('Email: $email');

        // Proceed to the next page
        widget.nextPage();
      } catch (e) {
        print('Error updating resume information: $e');
      }
    }
  }

  @override
  void initState() {
    super.initState();

    final resumeProvider = Provider.of<ResumeProvider>(context, listen: false);
    _fetchResumeDetails();
    fnameController.text = resumeProvider.fname ?? '';
    lnameController.text = resumeProvider.lname ?? '';

    String phoneNumber = resumeProvider.phoneNumber ?? '';
    if (phoneNumber.startsWith('+63')) {
      phoneNumber = phoneNumber.substring(3);
    }
    pnumberController.text = phoneNumber;

    emailController.text = resumeProvider.email ?? '';

    final locationProvider =
        Provider.of<LocationProvider>(context, listen: false);

    if (locationProvider.regions.isEmpty) {
      locationProvider.fetchRegions().then((_) {
        if (locationProvider.selectedRegion != null) {
          if (locationProvider.selectedRegion == '130000000') {
            locationProvider
                .fetchCitiesForRegion(locationProvider.selectedRegion!);
          } else {
            locationProvider
                .fetchProvincesOrCities(locationProvider.selectedRegion!);
          }
        }
      });
    }

    if (locationProvider.selectedRegion != null) {
      locationProvider.getLocationData();
    }
  }

  
  Future<void> _fetchResumeDetails() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    String userId = userProvider.loggedInUserId!;
    await context.read<ResumeProvider>().fetchAndSetResumeDetails(userId);
  }

  @override
  Widget build(BuildContext context) {
    final locationProvider = Provider.of<LocationProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 400.0),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 80.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 40),
                      Row(
                        children: [
                          Expanded(
                            child: LinearPercentIndicator(
                              animation: true,
                              animationDuration: 300,
                              animateFromLastPercent: true,
                              barRadius: Radius.circular(20),
                              lineHeight: 10,
                              percent: 1 / widget.noOfResumePages,
                              backgroundColor: Colors.orange.withOpacity(0.4),
                              progressColor: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 40),
                      Text(
                        'Contact Information',
                        style: TextStyle(
                          fontSize: 24,
                          color: Color(0xff373030),
                          fontFamily: 'Galano',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Your primary details for professional communication.',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xff373030),
                          fontFamily: 'Galano',
                          fontWeight: FontWeight.w100,
                        ),
                      ),
                      Gap(40),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    children: [
                                      Text(
                                        'First Name',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Color(0xff373030),
                                          fontFamily: 'Galano',
                                        ),
                                      ),
                                      Text(
                                        ' *',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.red,
                                          fontFamily: 'Galano',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Gap(5),
                                CustomTextFormField(
                                  controller: fnameController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'First name is required.'; // Show error message
                                    }
                                    return null; // No error if valid
                                  },
                                ),
                              ],
                            ),
                          ),
                          Gap(20),
                          Expanded(
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    children: [
                                      Text(
                                        'Last Name',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Color(0xff373030),
                                          fontFamily: 'Galano',
                                        ),
                                      ),
                                      Text(
                                        ' *',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.red,
                                          fontFamily: 'Galano',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Gap(5),
                                CustomTextFormField(
                                  controller: lnameController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Last name is required.'; // Show error message
                                    }
                                    return null; // No error if valid
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Gap(20),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            Text(
                              'Phone Number',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xff373030),
                                fontFamily: 'Galano',
                              ),
                            ),
                            Text(
                              ' *',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.red,
                                fontFamily: 'Galano',
                              ),
                            ),
                          ],
                        ),
                      ),
                      Gap(5),
                      CustomTextFormField(
                        controller: pnumberController,
                        keyboardType: TextInputType.phone,
                        prefixText: "+63",
                        prefixIcon: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                'assets/images/phflag.png',
                                width: 30,
                              ),
                              SizedBox(width: 8),
                              // Text('+63', style: TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                        validator: (value) {
                          phoneNumberInputted = "+63${value!}";
                          if (value!.isEmpty || value == null) {
                            return "Phone number is required.";
                          }
                          if (!phoneNumberInputted.isValidPhoneNumber()) {
                            return "Provide a valid Phone number.";
                          }
                          return null;
                        },
                      ),
                      Gap(20),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            Text(
                              'Email',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xff373030),
                                fontFamily: 'Galano',
                              ),
                            ),
                            Text(
                              ' *',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.red,
                                fontFamily: 'Galano',
                              ),
                            ),
                          ],
                        ),
                      ),
                      Gap(5),
                      CustomTextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty || value == null) {
                            return "Email Address is required.";
                          }
                          if (!EmailValidator.validate(value)) {
                            return "Please provide a valid email address.";
                          }
                        },
                      ),
                      SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            Text(
                              'Address',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xff373030),
                                fontFamily: 'Galano',
                              ),
                            ),
                            Text(
                              ' *',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.red,
                                fontFamily: 'Galano',
                              ),
                            ),
                          ],
                        ),
                      ),
                      Gap(15),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              validator: (value) {
                                if (value == null) {
                                  return "Required";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: 'Select Region',
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
                              value: locationProvider.selectedRegion,
                              items: locationProvider.regions
                                  .map((region) => DropdownMenuItem<String>(
                                        value: region['code'],
                                        child: Text(region['name']),
                                      ))
                                  .toList(),
                              onChanged: (regionCode) {
                                locationProvider.selectedRegion = regionCode;
                                locationProvider
                                    .fetchProvincesOrCities(regionCode!)
                                    .then((_) {
                                  // After fetching provinces or cities, set the region name
                                  locationProvider.selectedRegionName =
                                      locationProvider.regions.firstWhere(
                                          (region) =>
                                              region['code'] == regionCode,
                                          orElse: () => {})['name'];
                                  locationProvider.setLocationData({
                                    'regionCode': regionCode,
                                    'provinceCode':
                                        locationProvider.selectedProvince,
                                    'cityCode': locationProvider.selectedCity,
                                    'barangayCode':
                                        locationProvider.selectedBarangay,
                                    'otherLocation': locationProvider
                                        .otherLocationController.text
                                  });
                                });
                              },
                            ),
                          ),
                          if (locationProvider.selectedRegion !=
                              '130000000') ...[
                            Gap(20),
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                validator: (value) {
                                  if (value == null) {
                                    return "Required";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  labelText: 'Select Province',
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
                                value: locationProvider.selectedProvince,
                                items: locationProvider.provinces
                                    .map((province) => DropdownMenuItem<String>(
                                          value: province['code'],
                                          child: Text(province['name']),
                                        ))
                                    .toList(),
                                onChanged: (provinceCode) {
                                  locationProvider.selectedProvince =
                                      provinceCode;
                                  locationProvider
                                      .fetchCities(provinceCode!)
                                      .then((_) {
                                    // After fetching cities, set the province name
                                    locationProvider.selectedProvinceName =
                                        locationProvider.provinces.firstWhere(
                                            (province) =>
                                                province['code'] ==
                                                provinceCode,
                                            orElse: () => {})['name'];
                                    locationProvider.setLocationData({
                                      'regionCode':
                                          locationProvider.selectedRegion,
                                      'provinceCode': provinceCode,
                                      'cityCode': locationProvider.selectedCity,
                                      'barangayCode':
                                          locationProvider.selectedBarangay,
                                      'otherLocation': locationProvider
                                          .otherLocationController.text
                                    });
                                  });
                                },
                              ),
                            ),
                          ],
                          Gap(20),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              validator: (value) {
                                if (value == null) {
                                  return "Required";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: 'Select City/Municipality',
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
                              value: locationProvider.selectedCity,
                              items: locationProvider.cities
                                  .map((city) => DropdownMenuItem<String>(
                                        value: city['code'],
                                        child: Text(city['name']),
                                      ))
                                  .toList(),
                              onChanged: (cityCode) {
                                locationProvider.selectedCity = cityCode;
                                locationProvider
                                    .fetchBarangays(cityCode!)
                                    .then((_) {
                                  // After fetching barangays, set the city name
                                  locationProvider.selectedCityName =
                                      locationProvider.cities.firstWhere(
                                          (city) => city['code'] == cityCode,
                                          orElse: () => {})['name'];
                                  locationProvider.setLocationData({
                                    'regionCode':
                                        locationProvider.selectedRegion,
                                    'provinceCode':
                                        locationProvider.selectedProvince,
                                    'cityCode': cityCode,
                                    'barangayCode':
                                        locationProvider.selectedBarangay,
                                    'otherLocation': locationProvider
                                        .otherLocationController.text
                                  });
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      Gap(30),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              validator: (value) {
                                if (value == null) {
                                  return "Required";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: 'Select Barangay',
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
                              value: locationProvider.selectedBarangay,
                              items: locationProvider.barangays
                                  .map((barangay) => DropdownMenuItem<String>(
                                        value: barangay['code'],
                                        child: Text(barangay['name']),
                                      ))
                                  .toList(),
                              onChanged: (barangayCode) {
                                locationProvider.selectedBarangay =
                                    barangayCode;
                                locationProvider.setLocationData({
                                  'regionCode': locationProvider.selectedRegion,
                                  'provinceCode':
                                      locationProvider.selectedProvince,
                                  'cityCode': locationProvider.selectedCity,
                                  'barangayCode': barangayCode,
                                  'otherLocation': locationProvider
                                      .otherLocationController.text
                                });
                              },
                            ),
                          ),
                          Gap(20),
                          Expanded(
                            child: TextFormField(
                              controller:
                                  locationProvider.otherLocationController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Required";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: 'Building/House No., Street Name',
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
                            ),
                          ),
                        ],
                      ),
                      Gap(100),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // TextButton(
                          //   child: Text("Skip",
                          //       style: TextStyle(
                          //           fontSize: 16,
                          //           color: Colors.grey[700],
                          //           fontWeight: FontWeight.bold)),
                          //   onPressed: () {
                          //     widget.nextPage();
                          //   },
                          // ),
                          // SizedBox(
                          //   width: 20,
                          // ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: SizedBox(
                              width: 130,
                              child: BlueFilledCircleButton(
                                onPressed: _submitContactInfo,
                                text: 'Next',
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 60,
            left: 350,
            child: IconButton(
              icon: Image.asset(
                'assets/images/backbutton.png',
                width: 20,
                height: 20,
              ),
              onPressed: widget.previousPage,
            ),
          ),
        ],
      ),
    );
  }
}
