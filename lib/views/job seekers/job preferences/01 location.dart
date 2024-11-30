import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/user-provider.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/providers/location_provider.dart';
import 'package:huzzl_web/views/job%20seekers/job%20preferences/providers/resume_provider.dart';
import 'package:huzzl_web/views/job%20seekers/main_screen.dart';
import 'package:huzzl_web/widgets/buttons/blue/bluefilled_circlebutton.dart';
import 'package:huzzl_web/widgets/loading_dialog.dart';
import 'package:provider/provider.dart';

class LocationSelectorPage extends StatefulWidget {
  final VoidCallback nextPage;
  final Function(Map<String, dynamic>) onSaveLocation;
  final int noOfPages;

  const LocationSelectorPage({
    Key? key,
    required this.nextPage,
    required this.onSaveLocation,
    required this.noOfPages,
  }) : super(key: key);

  @override
  State<LocationSelectorPage> createState() => _LocationSelectorPageState();
}

class _LocationSelectorPageState extends State<LocationSelectorPage> {
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();

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

  void _submitLocationForm() {
    final resumeProvider = Provider.of<ResumeProvider>(context, listen: false);
    final locationProvider =
        Provider.of<LocationProvider>(context, listen: false);

    if (_formKey.currentState!.validate()) {
      try {
        final locationData = locationProvider.getLocationData();

        resumeProvider.updateLocation(locationData);

        locationData.forEach((key, value) {
          print('$key: $value');
        });

        widget.onSaveLocation(locationData);
        widget.nextPage();
      } catch (e) {
        print('Error updating resume information: $e');
      }
    }
  }

  void _submitPreferences() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    String? userId = userProvider.loggedInUserId;

    if (userId == null) {
      print('User not logged in!');
      return;
    }

    Map<String, dynamic> jobPreferences = {
      'selectedLocation': null,
      'selectedPayRate': null,
      'currentSelectedJobTitles': null,
      'uid': userId,
    };

    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      CollectionReference usersRef = firestore.collection('users');

      await usersRef.doc(userId).set(jobPreferences, SetOptions(merge: true));
      print('Job preferences saved successfully!');

      _showLoadingDialog(context);

      await Future.delayed(Duration(seconds: 3));

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) => JobseekerMainScreen(uid: userId)),
      );
    } catch (e) {
      print('Error saving job preferences: $e');
    }
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return const LoadingDialog(
          message: 'Loading, please wait...',
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final locationProvider = Provider.of<LocationProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 80.0, horizontal: 400.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '1/${widget.noOfPages}',
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xff373030),
                      fontFamily: 'Galano',
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                  TextButton(
                    child: Text("Skip all",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.orange,
                            fontWeight: FontWeight.bold)),
                    onPressed: _submitPreferences,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text('Where are you located?',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const Text('We use this to match you with jobs nearby',
                  style: TextStyle(fontSize: 18)),
              const SizedBox(height: 30),
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
                                  (region) => region['code'] == regionCode,
                                  orElse: () => {})['name'];
                          locationProvider.setLocationData({
                            'regionCode': regionCode,
                            'provinceCode': locationProvider.selectedProvince,
                            'cityCode': locationProvider.selectedCity,
                            'barangayCode': locationProvider.selectedBarangay,
                            'otherLocation':
                                locationProvider.otherLocationController.text
                          });
                        });
                      },
                    ),
                  ),
                  if (locationProvider.selectedRegion != '130000000') ...[
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
                          locationProvider.selectedProvince = provinceCode;
                          locationProvider.fetchCities(provinceCode!).then((_) {
                            // After fetching cities, set the province name
                            locationProvider.selectedProvinceName =
                                locationProvider.provinces.firstWhere(
                                    (province) =>
                                        province['code'] == provinceCode,
                                    orElse: () => {})['name'];
                            locationProvider.setLocationData({
                              'regionCode': locationProvider.selectedRegion,
                              'provinceCode': provinceCode,
                              'cityCode': locationProvider.selectedCity,
                              'barangayCode': locationProvider.selectedBarangay,
                              'otherLocation':
                                  locationProvider.otherLocationController.text
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
                        locationProvider.fetchBarangays(cityCode!).then((_) {
                          // After fetching barangays, set the city name
                          locationProvider.selectedCityName = locationProvider
                              .cities
                              .firstWhere((city) => city['code'] == cityCode,
                                  orElse: () => {})['name'];
                          locationProvider.setLocationData({
                            'regionCode': locationProvider.selectedRegion,
                            'provinceCode': locationProvider.selectedProvince,
                            'cityCode': cityCode,
                            'barangayCode': locationProvider.selectedBarangay,
                            'otherLocation':
                                locationProvider.otherLocationController.text
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
                        locationProvider.selectedBarangay = barangayCode;
                        locationProvider.setLocationData({
                          'regionCode': locationProvider.selectedRegion,
                          'provinceCode': locationProvider.selectedProvince,
                          'cityCode': locationProvider.selectedCity,
                          'barangayCode': barangayCode,
                          'otherLocation':
                              locationProvider.otherLocationController.text
                        });
                      },
                    ),
                  ),
                  Gap(20),
                  Expanded(
                    child: TextFormField(
                      controller: locationProvider.otherLocationController,
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
              const SizedBox(height: 100),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    child: Text(
                      "Skip",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      // Reset all fields to null or empty state in the provider
                      locationProvider.selectedRegion = null;
                      locationProvider.selectedProvince = null;
                      locationProvider.selectedCity = null;
                      locationProvider.selectedBarangay = null;
                      locationProvider.otherLocationController.clear();

                      // Clear lists
                      locationProvider.regions = [];
                      locationProvider.provinces = [];
                      locationProvider.cities = [];
                      locationProvider.barangays = [];

                      // Create an empty map for location data
                      Map<String, dynamic> locationData = {};

                      // Call the onSaveLocation callback to pass the reset data
                      widget.onSaveLocation(locationData);

                      // Navigate to the next page
                      widget.nextPage();
                    },
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      width: 130,
                      child: BlueFilledCircleButton(
                        onPressed: _submitLocationForm,
                        text: 'Next',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
